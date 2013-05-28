From: akpm@linux-foundation.org
Subject: [merged]
 mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:36:41 -0700
Message-ID: <51a50749.A35nstAuAKlyzu11%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab3E1Tgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, holt@sgi.com, xiaoguangrong@linux.vnet.ibm.com

Subject: [merged] mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch removed from -mm tree
To: xiaoguangrong@linux.vnet.ibm.com,holt@sgi.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:41 -0700


The patch titled
     Subject: mm: mmu_notifier: re-fix freed page still mapped in secondary MMU
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: mm: mmu_notifier: re-fix freed page still mapped in secondary MMU

commit 751efd8610d3 ("mmu_notifier_unregister NULL Pointer deref and
multiple ->release()") breaks the fix 3ad3d901bb ("mm: mmu_notifier: fix
freed page still mapped in secondary MMU").

Since hlist_for_each_entry_rcu() is changed now, we can not revert that
patch directly, so this patch reverts the commit and simply fix the bug
spotted by that patch

This bug spotted by commit 751efd8610d3 is:
======
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
======

This can be fixed by using hlist_del_init_rcu instead of hlist_del_rcu.

The another issue spotted in the commit is "multiple ->release()
callouts", we needn't care it too much because it is really rare (e.g, can
not happen on kvm since mmu-notify is unregistered after exit_mmap()) and
the later call of multiple ->release should be fast since all the pages
have already been released by the first call.  Anyway, this issue should
be fixed in a separate patch.

-stable suggestions:
Any version has commit 751efd8610d3 need to be backported. I find the oldest
version has this commit is 3.0-stable.

[akpm@linux-foundation.org: tweak comments]
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Tested-by: Robin Holt <holt@sgi.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   79 +++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 40 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-re-fix-freed-page-still-mapped-in-secondary-mmu
+++ a/mm/mmu_notifier.c
@@ -40,48 +40,44 @@ void __mmu_notifier_release(struct mm_st
 	int id;
 
 	/*
-	 * srcu_read_lock() here will block synchronize_srcu() in
-	 * mmu_notifier_unregister() until all registered
-	 * ->release() callouts this function makes have
-	 * returned.
+	 * SRCU here will block mmu_notifier_unregister until
+	 * ->release returns.
 	 */
 	id = srcu_read_lock(&srcu);
+	hlist_for_each_entry_rcu(mn, &mm->mmu_notifier_mm->list, hlist)
+		/*
+		 * If ->release runs before mmu_notifier_unregister it must be
+		 * handled, as it's the only way for the driver to flush all
+		 * existing sptes and stop the driver from establishing any more
+		 * sptes before all the pages in the mm are freed.
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+	srcu_read_unlock(&srcu, id);
+
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
 		mn = hlist_entry(mm->mmu_notifier_mm->list.first,
 				 struct mmu_notifier,
 				 hlist);
-
 		/*
-		 * Unlink.  This will prevent mmu_notifier_unregister()
-		 * from also making the ->release() callout.
+		 * We arrived before mmu_notifier_unregister so
+		 * mmu_notifier_unregister will do nothing other than to wait
+		 * for ->release to finish and for mmu_notifier_unregister to
+		 * return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
-		/*
-		 * Clear sptes. (see 'release' description in mmu_notifier.h)
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-
-		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	/*
-	 * All callouts to ->release() which we have done are complete.
-	 * Allow synchronize_srcu() in mmu_notifier_unregister() to complete
-	 */
-	srcu_read_unlock(&srcu, id);
-
-	/*
-	 * mmu_notifier_unregister() may have unlinked a notifier and may
-	 * still be calling out to it.	Additionally, other notifiers
-	 * may have been active via vmtruncate() et. al. Block here
-	 * to ensure that all notifier callouts for this mm have been
-	 * completed and the sptes are really cleaned up before returning
-	 * to exit_mmap().
+	 * synchronize_srcu here prevents mmu_notifier_release from returning to
+	 * exit_mmap (which would proceed with freeing all pages in the mm)
+	 * until the ->release method returns, if it was invoked by
+	 * mmu_notifier_unregister.
+	 *
+	 * The mmu_notifier_mm can't go away from under us because one mm_count
+	 * is held by exit_mmap.
 	 */
 	synchronize_srcu(&srcu);
 }
@@ -292,31 +288,34 @@ void mmu_notifier_unregister(struct mmu_
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
+		/*
+		 * SRCU here will force exit_mmap to wait for ->release to
+		 * finish before freeing the pages.
+		 */
 		int id;
 
+		id = srcu_read_lock(&srcu);
 		/*
-		 * Ensure we synchronize up with __mmu_notifier_release().
+		 * exit_mmap will block in mmu_notifier_release to guarantee
+		 * that ->release is called before freeing the pages.
 		 */
-		id = srcu_read_lock(&srcu);
-
-		hlist_del_rcu(&mn->hlist);
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
+		srcu_read_unlock(&srcu, id);
 
+		spin_lock(&mm->mmu_notifier_mm->lock);
 		/*
-		 * Allow __mmu_notifier_release() to complete.
+		 * Can not use list_del_rcu() since __mmu_notifier_release
+		 * can delete it before we hold the lock.
 		 */
-		srcu_read_unlock(&srcu, id);
-	} else
+		hlist_del_init_rcu(&mn->hlist);
 		spin_unlock(&mm->mmu_notifier_mm->lock);
+	}
 
 	/*
-	 * Wait for any running method to finish, including ->release() if it
-	 * was run by __mmu_notifier_release() instead of us.
+	 * Wait for any running method to finish, of course including
+	 * ->release if it was run by mmu_notifier_relase instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
_

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
clear_refs-sanitize-accepted-commands-declaration.patch
clear_refs-introduce-private-struct-for-mm_walk.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits.patch
pagemap-introduce-pagemap_entry_t-without-pmshift-bits-v4.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking.patch
mm-soft-dirty-bits-for-user-memory-changes-tracking-call-mmu-notifiers-when-write-protecting-ptes.patch
pagemap-prepare-to-reuse-constant-bits-with-page-shift.patch

