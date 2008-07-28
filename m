From: akpm@linux-foundation.org
Subject: - mmu-notifiers-add-list_del_init_rcu-update.patch removed from -mm tree
Date: Mon, 28 Jul 2008 15:44:50 -0700
Message-ID: <200807282244.m6SMioEd032159@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49360 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752015AbYG1Wpp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jul 2008 18:45:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@qumranet.com, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     move hlist_del_init_rcu from list.h to rculist.h
has been removed from the -mm tree.  Its filename was
     mmu-notifiers-add-list_del_init_rcu-update.patch

This patch was dropped because it was folded into mmu-notifiers-add-list_del_init_rcu.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: move hlist_del_init_rcu from list.h to rculist.h
From: Andrea Arcangeli <andrea@qumranet.com>

This moves the _rcu method in the right file.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list.h    |   28 ----------------------------
 include/linux/rculist.h |   28 ++++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 28 deletions(-)

diff -puN include/linux/list.h~mmu-notifiers-add-list_del_init_rcu-update include/linux/list.h
--- a/include/linux/list.h~mmu-notifiers-add-list_del_init_rcu-update
+++ a/include/linux/list.h
@@ -519,34 +519,6 @@ static inline void hlist_del_init(struct
 	}
 }
 
-/**
- * hlist_del_init_rcu - deletes entry from hash list with re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on the node return true after this. It is
- * useful for RCU based read lockfree traversal if the writer side
- * must know if the list entry is still hashed or already unhashed.
- *
- * In particular, it means that we can not poison the forward pointers
- * that may still be used for walking the hash list and we can only
- * zero the pprev pointer so list_unhashed() will return true after
- * this.
- *
- * The caller must take whatever precautions are necessary (such as
- * holding appropriate locks) to avoid racing with another
- * list-mutation primitive, such as hlist_add_head_rcu() or
- * hlist_del_rcu(), running on this same list.  However, it is
- * perfectly legal to run concurrently with the _rcu list-traversal
- * primitives, such as hlist_for_each_entry_rcu().
- */
-static inline void hlist_del_init_rcu(struct hlist_node *n)
-{
-	if (!hlist_unhashed(n)) {
-		__hlist_del(n);
-		n->pprev = NULL;
-	}
-}
-
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
diff -puN include/linux/rculist.h~mmu-notifiers-add-list_del_init_rcu-update include/linux/rculist.h
--- a/include/linux/rculist.h~mmu-notifiers-add-list_del_init_rcu-update
+++ a/include/linux/rculist.h
@@ -98,6 +98,34 @@ static inline void list_del_rcu(struct l
 }
 
 /**
+ * hlist_del_init_rcu - deletes entry from hash list with re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: list_unhashed() on the node return true after this. It is
+ * useful for RCU based read lockfree traversal if the writer side
+ * must know if the list entry is still hashed or already unhashed.
+ *
+ * In particular, it means that we can not poison the forward pointers
+ * that may still be used for walking the hash list and we can only
+ * zero the pprev pointer so list_unhashed() will return true after
+ * this.
+ *
+ * The caller must take whatever precautions are necessary (such as
+ * holding appropriate locks) to avoid racing with another
+ * list-mutation primitive, such as hlist_add_head_rcu() or
+ * hlist_del_rcu(), running on this same list.  However, it is
+ * perfectly legal to run concurrently with the _rcu list-traversal
+ * primitives, such as hlist_for_each_entry_rcu().
+ */
+static inline void hlist_del_init_rcu(struct hlist_node *n)
+{
+	if (!hlist_unhashed(n)) {
+		__hlist_del(n);
+		n->pprev = NULL;
+	}
+}
+
+/**
  * list_replace_rcu - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
_

Patches currently in -mm which might be from andrea@qumranet.com are

origin.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-list_del_init_rcu-update.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch
linux-next.patch
mmu-notifiers-add-mm_take_all_locks-operation-fix.patch

