From: akpm@linux-foundation.org
Subject: + mmu-notifiers-add-list_del_init_rcu-update.patch added to -mm tree
Date: Sat, 26 Jul 2008 12:37:45 -0700
Message-ID: <200807261937.m6QJbjr1016037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41412 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751706AbYGZTiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 15:38:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@qumranet.com, paulmck@us.ibm.com


The patch titled
     move hlist_del_init_rcu from list.h to rculist.h
has been added to the -mm tree.  Its filename is
     mmu-notifiers-add-list_del_init_rcu-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mmu-notifiers-add-list_del_init_rcu-update.patch
mmu-notifiers-add-mm_take_all_locks-operation.patch
mmu-notifier-core.patch

