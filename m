From: akpm@linux-foundation.org
Subject: + mmu-notifiers-add-list_del_init_rcu.patch added to -mm tree
Date: Wed, 02 Jul 2008 12:24:12 -0700
Message-ID: <200807021924.m62JODF4032063@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36503 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756168AbYGBTZe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 15:25:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@qumranet.com, a.p.zijlstra@chello.nl, aliguori@us.ibm.com, avi@qumranet.com, chrisw@redhat.com, clameter@sgi.com, dada1@cosmosbay.com, holt@sgi.com, hugh@veritas.com, izike@qumranet.com, kanojsarcar@yahoo.com, marcelo@kvack.org, mingo@elte.hu, npiggin@suse.de, paulmck@us.ibm.com, rdreier@cisco.com, riel@redhat.com, rusty@rustcorp.com.au, steiner@sgi.com, swise@opengridcomputing.com, torvalds@linux-foundation.org


The patch titled
     mmu-notifiers: add list_del_init_rcu()
has been added to the -mm tree.  Its filename is
     mmu-notifiers-add-list_del_init_rcu.patch

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
Subject: mmu-notifiers: add list_del_init_rcu()
From: Andrea Arcangeli <andrea@qumranet.com>

Introduce list_del_init_rcu() and document it.

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
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

 include/linux/list.h |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff -puN include/linux/list.h~mmu-notifiers-add-list_del_init_rcu include/linux/list.h
--- a/include/linux/list.h~mmu-notifiers-add-list_del_init_rcu
+++ a/include/linux/list.h
@@ -523,6 +523,34 @@ static inline void hlist_del_init(struct
 	}
 }
 
+/**
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
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
_

Patches currently in -mm which might be from andrea@qumranet.com are

linux-next.patch
mmu-notifiers-add-list_del_init_rcu.patch
mm_take_all_locks.patch
mmu-notifier-core.patch

