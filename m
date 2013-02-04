From: akpm@linux-foundation.org
Subject: + mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch added to -mm tree
Date: Mon, 04 Feb 2013 14:14:41 -0800
Message-ID: <20130204221442.0E8005A40F3@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:42802 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3BDWOn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 17:14:43 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so758046vch.4
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 14:14:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, aarcange@redhat.com, avi@redhat.com, haggaie@mellanox.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mtosatti@redhat.com, sagig@mellanox.co.il, stable@vger.kernel.org, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts
has been added to the -mm tree.  Its filename is
     mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Robin Holt <holt@sgi.com>
Subject: mmu_notifier_unregister NULL Pointer deref and multiple ->release() callouts

There is a race condition between mmu_notifier_unregister() and
__mmu_notifier_release().

Assume two tasks, one calling mmu_notifier_unregister() as a result of a
filp_close() ->flush() callout (task A), and the other calling
mmu_notifier_release() from an mmput() (task B).

                A                               B
t1                                              srcu_read_lock()
t2              if (!hlist_unhashed())
t3                                              srcu_read_unlock()
t4              srcu_read_lock()
t5                                              hlist_del_init_rcu()
t6                                              synchronize_srcu()
t7              srcu_read_unlock()
t8              hlist_del_rcu()  <--- NULL pointer deref.

Additionally, the list traversal in __mmu_notifier_release() is not
protected by the by the mmu_notifier_mm->hlist_lock which can result in
callouts to the ->release() notifier from both mmu_notifier_unregister()
and __mmu_notifier_release().

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Sagi Grimberg <sagig@mellanox.co.il>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: stable-kernel <stable@vger.kernel.org> # 3.[0-6].y 21a9273
Cc: stable-kernel <stable@vger.kernel.org> # 3.[0-6].y 7040030
Cc: stable-kernel <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   82 ++++++++++++++++++++++----------------------
 1 file changed, 42 insertions(+), 40 deletions(-)

diff -puN mm/mmu_notifier.c~mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts
+++ a/mm/mmu_notifier.c
@@ -37,49 +37,51 @@ static struct srcu_struct srcu;
 void __mmu_notifier_release(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
-	struct hlist_node *n;
 	int id;
 
 	/*
-	 * SRCU here will block mmu_notifier_unregister until
-	 * ->release returns.
+	 * srcu_read_lock() here will block synchronize_srcu() in
+	 * mmu_notifier_unregister() until all registered
+	 * ->release() callouts this function makes have
+	 * returned.
 	 */
 	id = srcu_read_lock(&srcu);
-	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist)
-		/*
-		 * if ->release runs before mmu_notifier_unregister it
-		 * must be handled as it's the only way for the driver
-		 * to flush all existing sptes and stop the driver
-		 * from establishing any more sptes before all the
-		 * pages in the mm are freed.
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-	srcu_read_unlock(&srcu, id);
-
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
 		mn = hlist_entry(mm->mmu_notifier_mm->list.first,
 				 struct mmu_notifier,
 				 hlist);
+
 		/*
-		 * We arrived before mmu_notifier_unregister so
-		 * mmu_notifier_unregister will do nothing other than
-		 * to wait ->release to finish and
-		 * mmu_notifier_unregister to return.
+		 * Unlink.  This will prevent mmu_notifier_unregister()
+		 * from also making the ->release() callout.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
+		spin_unlock(&mm->mmu_notifier_mm->lock);
+
+		/*
+		 * Clear sptes. (see 'release' description in mmu_notifier.h)
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+
+		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * synchronize_srcu here prevents mmu_notifier_release to
-	 * return to exit_mmap (which would proceed freeing all pages
-	 * in the mm) until the ->release method returns, if it was
-	 * invoked by mmu_notifier_unregister.
-	 *
-	 * The mmu_notifier_mm can't go away from under us because one
-	 * mm_count is hold by exit_mmap.
+	 * All callouts to ->release() which we have done are complete.
+	 * Allow synchronize_srcu() in mmu_notifier_unregister() to complete
+	 */
+	srcu_read_unlock(&srcu, id);
+
+	/*
+	 * mmu_notifier_unregister() may have unlinked a notifier and may
+	 * still be calling out to it.	Additionally, other notifiers
+	 * may have been active via vmtruncate() et. al. Block here
+	 * to ensure that all notifier callouts for this mm have been
+	 * completed and the sptes are really cleaned up before returning
+	 * to exit_mmap().
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -294,31 +296,31 @@ void mmu_notifier_unregister(struct mmu_
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
+	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
-		/*
-		 * SRCU here will force exit_mmap to wait ->release to finish
-		 * before freeing the pages.
-		 */
 		int id;
 
-		id = srcu_read_lock(&srcu);
 		/*
-		 * exit_mmap will block in mmu_notifier_release to
-		 * guarantee ->release is called before freeing the
-		 * pages.
+		 * Ensure we synchronize up with __mmu_notifier_release().
 		 */
+		id = srcu_read_lock(&srcu);
+
+		hlist_del_rcu(&mn->hlist);
+		spin_unlock(&mm->mmu_notifier_mm->lock);
+
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
-		srcu_read_unlock(&srcu, id);
 
-		spin_lock(&mm->mmu_notifier_mm->lock);
-		hlist_del_rcu(&mn->hlist);
+		/*
+		 * Allow __mmu_notifier_release() to complete.
+		 */
+		srcu_read_unlock(&srcu, id);
+	} else
 		spin_unlock(&mm->mmu_notifier_mm->lock);
-	}
 
 	/*
-	 * Wait any running method to finish, of course including
-	 * ->release if it was run by mmu_notifier_relase instead of us.
+	 * Wait for any running method to finish, including ->release() if it
+	 * was run by __mmu_notifier_release() instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
_

Patches currently in -mm which might be from holt@sgi.com are

mmu_notifier_unregister-null-pointer-deref-and-multiple-release-callouts.patch

