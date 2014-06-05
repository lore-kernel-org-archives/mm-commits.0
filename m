From: akpm@linux-foundation.org
Subject: [merged] plist-add-plist_requeue.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:52:05 -0700
Message-ID: <5390ca65.QOxz3xhiEUlM3uHi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbaFETwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:52:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijieut@gmail.com, tglx@linutronix.de, shli@fusionio.com, rostedt@goodmis.org, riel@redhat.com, peterz@infradead.org, paul.gortmaker@windriver.com, mhocko@suse.cz, mgorman@suse.de, hughd@google.com, hannes@cmpxchg.org, ehrhardt@linux.vnet.ibm.com, bob.liu@oracle.com, ddstreet@ieee.org

Subject: [merged] plist-add-plist_requeue.patch removed from -mm tree
To: ddstreet@ieee.org,bob.liu@oracle.com,ehrhardt@linux.vnet.ibm.com,hannes@cmpxchg.org,hughd@google.com,mgorman@suse.de,mhocko@suse.cz,paul.gortmaker@windriver.com,peterz@infradead.org,riel@redhat.com,rostedt@goodmis.org,shli@fusionio.com,tglx@linutronix.de,weijieut@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:52:05 -0700


The patch titled
     Subject: lib/plist: add plist_requeue
has been removed from the -mm tree.  Its filename was
     plist-add-plist_requeue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dan Streetman <ddstreet@ieee.org>
Subject: lib/plist: add plist_requeue

Add plist_requeue(), which moves the specified plist_node after all other
same-priority plist_nodes in the list.  This is essentially an optimized
plist_del() followed by plist_add().

This is needed by swap, which (with the next patch in this set) uses a
plist of available swap devices.  When a swap device (either a swap
partition or swap file) are added to the system with swapon(), the device
is added to a plist, ordered by the swap device's priority.  When swap
needs to allocate a page from one of the swap devices, it takes the page
from the first swap device on the plist, which is the highest priority
swap device.  The swap device is left in the plist until all its pages are
used, and then removed from the plist when it becomes full.

However, as described in man 2 swapon, swap must allocate pages from swap
devices with the same priority in round-robin order; to do this, on each
swap page allocation, swap uses a page from the first swap device in the
plist, and then calls plist_requeue() to move that swap device entry to
after any other same-priority swap devices.  The next swap page allocation
will again use a page from the first swap device in the plist and requeue
it, and so on, resulting in round-robin usage of equal-priority swap
devices.

Also add plist_test_requeue() test function, for use by plist_test() to
test plist_requeue() function.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Shaohua Li <shli@fusionio.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Cc: Weijie Yang <weijieut@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bob Liu <bob.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/plist.h |    2 +
 lib/plist.c           |   52 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff -puN include/linux/plist.h~plist-add-plist_requeue include/linux/plist.h
--- a/include/linux/plist.h~plist-add-plist_requeue
+++ a/include/linux/plist.h
@@ -141,6 +141,8 @@ static inline void plist_node_init(struc
 extern void plist_add(struct plist_node *node, struct plist_head *head);
 extern void plist_del(struct plist_node *node, struct plist_head *head);
 
+extern void plist_requeue(struct plist_node *node, struct plist_head *head);
+
 /**
  * plist_for_each - iterate over the plist
  * @pos:	the type * to use as a loop counter
diff -puN lib/plist.c~plist-add-plist_requeue lib/plist.c
--- a/lib/plist.c~plist-add-plist_requeue
+++ a/lib/plist.c
@@ -134,6 +134,46 @@ void plist_del(struct plist_node *node,
 	plist_check_head(head);
 }
 
+/**
+ * plist_requeue - Requeue @node at end of same-prio entries.
+ *
+ * This is essentially an optimized plist_del() followed by
+ * plist_add().  It moves an entry already in the plist to
+ * after any other same-priority entries.
+ *
+ * @node:	&struct plist_node pointer - entry to be moved
+ * @head:	&struct plist_head pointer - list head
+ */
+void plist_requeue(struct plist_node *node, struct plist_head *head)
+{
+	struct plist_node *iter;
+	struct list_head *node_next = &head->node_list;
+
+	plist_check_head(head);
+	BUG_ON(plist_head_empty(head));
+	BUG_ON(plist_node_empty(node));
+
+	if (node == plist_last(head))
+		return;
+
+	iter = plist_next(node);
+
+	if (node->prio != iter->prio)
+		return;
+
+	plist_del(node, head);
+
+	plist_for_each_continue(iter, head) {
+		if (node->prio != iter->prio) {
+			node_next = &iter->node_list;
+			break;
+		}
+	}
+	list_add_tail(&node->node_list, node_next);
+
+	plist_check_head(head);
+}
+
 #ifdef CONFIG_DEBUG_PI_LIST
 #include <linux/sched.h>
 #include <linux/module.h>
@@ -170,6 +210,14 @@ static void __init plist_test_check(int
 	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
 }
 
+static void __init plist_test_requeue(struct plist_node *node)
+{
+	plist_requeue(node, &test_head);
+
+	if (node != plist_last(&test_head))
+		BUG_ON(node->prio == plist_next(node)->prio);
+}
+
 static int  __init plist_test(void)
 {
 	int nr_expect = 0, i, loop;
@@ -193,6 +241,10 @@ static int  __init plist_test(void)
 			nr_expect--;
 		}
 		plist_test_check(nr_expect);
+		if (!plist_node_empty(test_node + i)) {
+			plist_test_requeue(test_node + i);
+			plist_test_check(nr_expect);
+		}
 	}
 
 	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
_

Patches currently in -mm which might be from ddstreet@ieee.org are

origin.patch
linux-next.patch

