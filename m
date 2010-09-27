From: akpm@linux-foundation.org
Subject: + lib-list_sort-test-improve-errors-handling.patch added to -mm tree
Date: Mon, 27 Sep 2010 12:05:22 -0700
Message-ID: <201009271905.o8RJ5Mgh010716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760038Ab0I0TFf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 15:05:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Artem.Bityutskiy@nokia.com, don.mullis@gmail.com


The patch titled
     lib/list_sort: test: improve errors handling
has been added to the -mm tree.  Its filename is
     lib-list_sort-test-improve-errors-handling.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lib/list_sort: test: improve errors handling
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>

The 'lib_sort()' test does not free memory if it fails, and it makes the
kernel panic if it cannot allocate memory.  This patch fixes the problem.

This patch also changes several small things:
 o use 'list_add()' helper instead of adding manually
 o introduce temporary 'el1' variable to avoid ugly and unreadalbe
   "if" statement
 o make 'head' to be stack variable instead of 'kmalloc()'ed, which
   simplifies code a bit

Overall, this patch is of clean-up type.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: Don Mullis <don.mullis@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/list_sort.c |   65 ++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff -puN lib/list_sort.c~lib-list_sort-test-improve-errors-handling lib/list_sort.c
--- a/lib/list_sort.c~lib-list_sort-test-improve-errors-handling
+++ a/lib/list_sort.c
@@ -165,56 +165,67 @@ static int cmp(void *priv, struct list_h
 
 static int __init list_sort_test(void)
 {
-	int i, count;
-	struct list_head *head = kmalloc(sizeof(*head), GFP_KERNEL);
-	struct list_head *cur;
+	int i, count = 1, err = -EINVAL;
+	struct debug_el *el;
+	struct list_head *cur, *tmp;
+	LIST_HEAD(head);
 
 	printk(KERN_DEBUG "testing list_sort()\n");
 
-	cur = head;
 	for (i = 0; i < TEST_LIST_LEN; i++) {
-		struct debug_el *el = kmalloc(sizeof(*el), GFP_KERNEL);
-		BUG_ON(!el);
+		el = kmalloc(sizeof(*el), GFP_KERNEL);
+		if (!el) {
+			printk(KERN_ERR "cancel list_sort() testing - cannot "
+					"allocate memory\n");
+			goto exit;
+		}
 		 /* force some equivalencies */
 		el->value = random32() % (TEST_LIST_LEN/3);
 		el->serial = i;
-
-		el->list.prev = cur;
-		cur->next = &el->list;
-		cur = cur->next;
+		list_add_tail(&el->list, &head);
 	}
-	head->prev = cur;
 
-	list_sort(NULL, head, cmp);
+	list_sort(NULL, &head, cmp);
+
+	for (cur = head.next; cur->next != &head; cur = cur->next) {
+		struct debug_el *el1;
+		int cmp_result;
 
-	count = 1;
-	for (cur = head->next; cur->next != head; cur = cur->next) {
-		struct debug_el *el = container_of(cur, struct debug_el, list);
-		int cmp_result = cmp(NULL, cur, cur->next);
 		if (cur->next->prev != cur) {
 			printk(KERN_ERR "list_sort() returned "
 					"a corrupted list!\n");
-			return 1;
-		} else if (cmp_result > 0) {
+			goto exit;
+		}
+
+		cmp_result = cmp(NULL, cur, cur->next);
+		if (cmp_result > 0) {
 			printk(KERN_ERR "list_sort() failed to sort!\n");
-			return 1;
-		} else if (cmp_result == 0 &&
-				el->serial >= container_of(cur->next,
-					struct debug_el, list)->serial) {
+			goto exit;
+		}
+
+		el = container_of(cur, struct debug_el, list);
+		el1 = container_of(cur->next, struct debug_el, list);
+		if (cmp_result == 0 && el->serial >= el1->serial) {
 			printk(KERN_ERR "list_sort() failed to preserve order "
 					"of equivalent elements!\n");
-			return 1;
+			goto exit;
 		}
-		kfree(cur->prev);
 		count++;
 	}
-	kfree(cur);
+
 	if (count != TEST_LIST_LEN) {
 		printk(KERN_ERR "list_sort() returned list of "
 				"different length!\n");
-		return 1;
+		goto exit;
+	}
+
+	err = 0;
+exit:
+	list_for_each_safe(cur, tmp, &head) {
+		list_del(cur);
+		kfree(container_of(cur, struct debug_el, list));
 	}
-	return 0;
+	return err;
 }
 module_init(list_sort_test);
 #endif /* CONFIG_TEST_LIST_SORT */
_

Patches currently in -mm which might be from Artem.Bityutskiy@nokia.com are

linux-next.patch
jffs2-use-cond_resched-instead-of-yield.patch
lib-list_sort-do-not-pass-bad-pointers-to-cmp-callback.patch
lib-kconfigdebug-add-list_sort-debugging-switch.patch
lib-list_sort-test-use-more-reasonable-printk-levels.patch
lib-list_sort-test-use-generic-random32.patch
lib-list_sort-test-improve-errors-handling.patch
lib-list_sort-test-unify-test-messages.patch
lib-list_sort-test-check-element-addresses.patch

