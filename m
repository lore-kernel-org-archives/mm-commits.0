From: akpm@linux-foundation.org
Subject: - mmu-notifiers-add-list_del_init_rcu.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:40 -0700
Message-ID: <200807292029.m6TKTe9J019719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbYG2UbV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:31:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andrea@qumranet.com, a.p.zijlstra@chello.nl, aliguori@us.ibm.com, avi@qumranet.com, chrisw@redhat.com, cl@linux-foundation.org, dada1@cosmosbay.com, holt@sgi.com, hugh@veritas.com, iz


The patch titled
     mmu-notifiers: add list_del_init_rcu()
has been removed from the -mm tree.  Its filename was
     mmu-notifiers-add-list_del_init_rcu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmu-notifiers: add list_del_init_rcu()
From: Andrea Arcangeli <andrea@qumranet.com>

Introduce list_del_init_rcu() and document it.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Robin Holt <holt@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kanoj Sarcar <kanojsarcar@yahoo.com>
Cc: Roland Dreier <rdreier@cisco.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Avi Kivity <avi@qumranet.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Marcelo Tosatti <marcelo@kvack.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Izik Eidus <izike@qumranet.com>
Cc: Anthony Liguori <aliguori@us.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rculist.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN include/linux/rculist.h~mmu-notifiers-add-list_del_init_rcu include/linux/rculist.h
--- a/include/linux/rculist.h~mmu-notifiers-add-list_del_init_rcu
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

linux-next.patch

