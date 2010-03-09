From: akpm@linux-foundation.org
Subject: [merged] lib-more-scalable-list_sort.patch removed from -mm tree
Date: Tue, 09 Mar 2010 11:07:28 -0800
Message-ID: <201003091907.o29J7SPA031335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756039Ab0CITWn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Mar 2010 14:22:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: don.mullis@gmail.com, airlied@redhat.com, andi@firstfloor.org, david@fromorbit.com, dedekind@infradead.org, mm-commits@vger.kernel.org


The patch titled
     lib: more scalable list_sort()
has been removed from the -mm tree.  Its filename was
     lib-more-scalable-list_sort.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib: more scalable list_sort()
From: Don Mullis <don.mullis@gmail.com>

XFS and UBIFS can pass long lists to list_sort(); this alternative
implementation scales better, reaching ~3x performance gain when list
length exceeds the L2 cache size.

Stand-alone program timings were run on a Core 2 duo L1=32KB L2=4MB,
gcc-4.4, with flags extracted from an Ubuntu kernel build.  Object size is
581 bytes compared to 455 for Mark J.  Roberts' code.

Worst case for either implementation is a list length just over a power of
two, and to roughly the same degree, so here are timing results for a
range of 2^N+1 lengths.  List elements were 16 bytes each including malloc
overhead; initial order was random.

                      time (msec)
                      Tatham-Roberts
                      |       generic-Mullis-v2
loop_count  length    |       |    ratio
4000000       2     206     294    1.427
2000000       3     176     227    1.289
1000000       5     199     172    0.864
 500000       9     235     178    0.757
 250000      17     243     182    0.748
 125000      33     261     196    0.750
  62500      65     277     209    0.754
  31250     129     292     219    0.75
  15625     257     317     235    0.741
   7812     513     340     252    0.741
   3906    1025     362     267    0.737
   1953    2049     388     283    0.729  ~ L1 size
    976    4097     556     323    0.580
    488    8193     678     361    0.532
    244   16385     773     395    0.510
    122   32769     844     418    0.495
     61   65537     917     454    0.495
     30  131073    1128     543    0.481
     15  262145    2355     869    0.369  ~ L2 size
      7  524289    5597    1714    0.306
      3 1048577    6218    2022    0.325

Mark's code does not actually implement the usual or generic mergesort,
but rather a variant from Simon Tatham described here:

    http://www.chiark.greenend.org.uk/~sgtatham/algorithms/listsort.html

Simon's algorithm performs O(log N) passes over the entire input list,
doing merges of sublists that double in size on each pass.  The generic
algorithm instead merges pairs of equal length lists as early as possible,
in recursive order.  For either algorithm, the elements that extend the
list beyond power-of-two length are a special case, handled as nearly as
possible as a "rounding-up" to a full POT.

Some intuition for the locality of reference implications of merge order
may be gotten by watching this animation:

    http://www.sorting-algorithms.com/merge-sort

Simon's algorithm requires only O(1) extra space rather than the generic
algorithm's O(log N), but in my non-recursive implementation the actual
O(log N) data is merely a vector of ~20 pointers, which I've put on the
stack.

Long-running list_sort() calls: If the list passed in may be long, or the
client's cmp() callback function is slow, the client's cmp() may
periodically invoke cond_resched() to voluntarily yield the CPU.  All
inner loops of list_sort() call back to cmp().

Stability of the sort: distinct elements that compare equal emerge from
the sort in the same order as with Mark's code, for simple test cases.  A
boot-time test is provided to verify this and other correctness
requirements.

A kernel that uses drm.ko appears to run normally with this change; I have
no suitable hardware to similarly test the use by UBIFS.

[akpm@linux-foundation.org: style tweaks, fix comment, make list_sort_test __init]
Signed-off-by: Don Mullis <don.mullis@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Artem Bityutskiy <dedekind@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |  252 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 183 insertions(+), 69 deletions(-)

diff -puN lib/list_sort.c~lib-more-scalable-list_sort lib/list_sort.c
--- a/lib/list_sort.c~lib-more-scalable-list_sort
+++ a/lib/list_sort.c
@@ -4,99 +4,213 @@
 #include <linux/slab.h>
 #include <linux/list.h>
 
+#define MAX_LIST_LENGTH_BITS 20
+
+/*
+ * Returns a list organized in an intermediate format suited
+ * to chaining of merge() calls: null-terminated, no reserved or
+ * sentinel head node, "prev" links not maintained.
+ */
+static struct list_head *merge(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head head, *tail = &head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a?:b;
+	return head.next;
+}
+
+/*
+ * Combine final list merge with restoration of standard doubly-linked
+ * list structure.  This approach duplicates code from merge(), but
+ * runs faster than the tidier alternatives of either a separate final
+ * prev-link restoration pass, or maintaining the prev links
+ * throughout.
+ */
+static void merge_and_restore_back_links(void *priv,
+				int (*cmp)(void *priv, struct list_head *a,
+					struct list_head *b),
+				struct list_head *head,
+				struct list_head *a, struct list_head *b)
+{
+	struct list_head *tail = head;
+
+	while (a && b) {
+		/* if equal, take 'a' -- important for sort stability */
+		if ((*cmp)(priv, a, b) <= 0) {
+			tail->next = a;
+			a->prev = tail;
+			a = a->next;
+		} else {
+			tail->next = b;
+			b->prev = tail;
+			b = b->next;
+		}
+		tail = tail->next;
+	}
+	tail->next = a ? : b;
+
+	do {
+		/*
+		 * In worst cases this loop may run many iterations.
+		 * Continue callbacks to the client even though no
+		 * element comparison is needed, so the client's cmp()
+		 * routine can invoke cond_resched() periodically.
+		 */
+		(*cmp)(priv, tail, tail);
+
+		tail->next->prev = tail;
+		tail = tail->next;
+	} while (tail->next);
+
+	tail->next = head;
+	head->prev = tail;
+}
+
 /**
  * list_sort - sort a list.
  * @priv: private data, passed to @cmp
  * @head: the list to sort
  * @cmp: the elements comparison function
  *
- * This function has been implemented by Mark J Roberts <mjr@znex.org>. It
- * implements "merge sort" which has O(nlog(n)) complexity. The list is sorted
- * in ascending order.
+ * This function implements "merge sort" which has O(nlog(n)) complexity.
+ * The list is sorted in ascending order.
  *
  * The comparison function @cmp is supposed to return a negative value if @a is
  * less than @b, and a positive value if @a is greater than @b. If @a and @b
  * are equivalent, then it does not matter what this function returns.
  */
 void list_sort(void *priv, struct list_head *head,
-	       int (*cmp)(void *priv, struct list_head *a,
-			  struct list_head *b))
+		int (*cmp)(void *priv, struct list_head *a,
+			struct list_head *b))
 {
-	struct list_head *p, *q, *e, *list, *tail, *oldhead;
-	int insize, nmerges, psize, qsize, i;
+	struct list_head *part[MAX_LIST_LENGTH_BITS+1]; /* sorted partial lists
+						-- last slot is a sentinel */
+	int lev;  /* index into part[] */
+	int max_lev = 0;
+	struct list_head *list;
 
 	if (list_empty(head))
 		return;
 
+	memset(part, 0, sizeof(part));
+
+	head->prev->next = NULL;
 	list = head->next;
-	list_del(head);
-	insize = 1;
-	for (;;) {
-		p = oldhead = list;
-		list = tail = NULL;
-		nmerges = 0;
-
-		while (p) {
-			nmerges++;
-			q = p;
-			psize = 0;
-			for (i = 0; i < insize; i++) {
-				psize++;
-				q = q->next == oldhead ? NULL : q->next;
-				if (!q)
-					break;
-			}
 
-			qsize = insize;
-			while (psize > 0 || (qsize > 0 && q)) {
-				if (!psize) {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				} else if (!qsize || !q) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else if (cmp(priv, p, q) <= 0) {
-					e = p;
-					p = p->next;
-					psize--;
-					if (p == oldhead)
-						p = NULL;
-				} else {
-					e = q;
-					q = q->next;
-					qsize--;
-					if (q == oldhead)
-						q = NULL;
-				}
-				if (tail)
-					tail->next = e;
-				else
-					list = e;
-				e->prev = tail;
-				tail = e;
+	while (list) {
+		struct list_head *cur = list;
+		list = list->next;
+		cur->next = NULL;
+
+		for (lev = 0; part[lev]; lev++) {
+			cur = merge(priv, cmp, part[lev], cur);
+			part[lev] = NULL;
+		}
+		if (lev > max_lev) {
+			if (unlikely(lev >= ARRAY_SIZE(part)-1)) {
+				printk_once(KERN_DEBUG "list passed to"
+					" list_sort() too long for"
+					" efficiency\n");
+				lev--;
 			}
-			p = q;
+			max_lev = lev;
 		}
+		part[lev] = cur;
+	}
 
-		tail->next = list;
-		list->prev = tail;
+	for (lev = 0; lev < max_lev; lev++)
+		if (part[lev])
+			list = merge(priv, cmp, part[lev], list);
 
-		if (nmerges <= 1)
-			break;
+	merge_and_restore_back_links(priv, cmp, head, part[max_lev], list);
+}
+EXPORT_SYMBOL(list_sort);
 
-		insize *= 2;
-	}
+#ifdef DEBUG_LIST_SORT
+struct debug_el {
+	struct list_head l_h;
+	int value;
+	unsigned serial;
+};
 
-	head->next = list;
-	head->prev = list->prev;
-	list->prev->next = head;
-	list->prev = head;
+static int cmp(void *priv, struct list_head *a, struct list_head *b)
+{
+	return container_of(a, struct debug_el, l_h)->value
+	     - container_of(b, struct debug_el, l_h)->value;
 }
 
-EXPORT_SYMBOL(list_sort);
+/*
+ * The pattern of set bits in the list length determines which cases
+ * are hit in list_sort().
+ */
+#define LIST_SORT_TEST_LENGTH (512+128+2) /* not including head */
+
+static int __init list_sort_test(void)
+{
+	int i, r = 1, count;
+	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
+	struct list_head *cur;
+
+	printk(KERN_WARNING "testing list_sort()\n");
+
+	cur = head;
+	for (i = 0; i < LIST_SORT_TEST_LENGTH; i++) {
+		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
+		BUG_ON(!el);
+		 /* force some equivalencies */
+		el->value = (r = (r * 725861) % 6599) % (LIST_SORT_TEST_LENGTH/3);
+		el->serial = i;
+
+		el->l_h.prev = cur;
+		cur->next = &el->l_h;
+		cur = cur->next;
+	}
+	head->prev = cur;
+
+	list_sort(NULL, head, cmp);
+
+	count = 1;
+	for (cur = head->next; cur->next != head; cur = cur->next) {
+		struct debug_el *el = container_of(cur, struct debug_el, l_h);
+		int cmp_result = cmp(NULL, cur, cur->next);
+		if (cur->next->prev != cur) {
+			printk(KERN_EMERG "list_sort() returned "
+						"a corrupted list!\n");
+			return 1;
+		} else if (cmp_result > 0) {
+			printk(KERN_EMERG "list_sort() failed to sort!\n");
+			return 1;
+		} else if (cmp_result == 0 &&
+				el->serial >= container_of(cur->next,
+					struct debug_el, l_h)->serial) {
+			printk(KERN_EMERG "list_sort() failed to preserve order"
+						 " of equivalent elements!\n");
+			return 1;
+		}
+		kfree(cur->prev);
+		count++;
+	}
+	kfree(cur);
+	if (count != LIST_SORT_TEST_LENGTH) {
+		printk(KERN_EMERG "list_sort() returned list of"
+						"different length!\n");
+		return 1;
+	}
+	return 0;
+}
+module_init(list_sort_test);
+#endif
_

Patches currently in -mm which might be from don.mullis@gmail.com are


