From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu.patch added to -mm tree
Date: Fri, 13 Jul 2012 14:51:24 -0700
Message-ID: <20120713215125.25F915C0063@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:37495 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2GMVv2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jul 2012 17:51:28 -0400
Received: by wgbdt11 with SMTP id dt11so205628wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jul 2012 14:51:26 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, aarcange@redhat.com, avi@redhat.com, mtosatti@redhat.com, paul.gortmaker@windriver.com, stable@vger.kernel.org


The patch titled
     Subject: mm: mmu_notifier: fix freed page still mapped in secondary MMU
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: mm: mmu_notifier: fix freed page still mapped in secondary MMU

mmu_notifier_release() is called when the process is exiting.  It will
delete all the mmu notifiers.  But at this time the page belonging to the
process is still present in page tables and is present on the LRU list, so
this race will happen:

      CPU 0                 CPU 1
mmu_notifier_release:    try_to_unmap:
   hlist_del_init_rcu(&mn->hlist);
                            ptep_clear_flush_notify:
                                  mmu nofifler not found
                            free page  !!!!!!
                            /*
                             * At the point, the page has been
                             * freed, but it is still mapped in
                             * the secondary MMU.
                             */

  mn->ops->release(mn, mm);

Then the box is not stable and sometimes we can get this bug:

[  738.075923] BUG: Bad page state in process migrate-perf  pfn:03bec
[  738.075931] page:ffffea00000efb00 count:0 mapcount:0 mapping:          (null) index:0x8076
[  738.075936] page flags: 0x20000000000014(referenced|dirty)

The same issue is present in mmu_notifier_unregister().

We can call ->release before deleting the notifier to ensure the page has
been unmapped from the secondary MMU before it is freed.

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   45 ++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu
+++ a/mm/mmu_notifier.c
@@ -33,6 +33,24 @@
 void __mmu_notifier_release(struct mm_struct *mm)
 {
 	struct mmu_notifier *mn;
+	struct hlist_node *n;
+
+	/*
+	 * RCU here will block mmu_notifier_unregister until
+	 * ->release returns.
+	 */
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist)
+		/*
+		 * if ->release runs before mmu_notifier_unregister it
+		 * must be handled as it's the only way for the driver
+		 * to flush all existing sptes and stop the driver
+		 * from establishing any more sptes before all the
+		 * pages in the mm are freed.
+		 */
+		if (mn->ops->release)
+			mn->ops->release(mn, mm);
+	rcu_read_unlock();
 
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
@@ -46,23 +64,6 @@ void __mmu_notifier_release(struct mm_st
 		 * mmu_notifier_unregister to return.
 		 */
 		hlist_del_init_rcu(&mn->hlist);
-		/*
-		 * RCU here will block mmu_notifier_unregister until
-		 * ->release returns.
-		 */
-		rcu_read_lock();
-		spin_unlock(&mm->mmu_notifier_mm->lock);
-		/*
-		 * if ->release runs before mmu_notifier_unregister it
-		 * must be handled as it's the only way for the driver
-		 * to flush all existing sptes and stop the driver
-		 * from establishing any more sptes before all the
-		 * pages in the mm are freed.
-		 */
-		if (mn->ops->release)
-			mn->ops->release(mn, mm);
-		rcu_read_unlock();
-		spin_lock(&mm->mmu_notifier_mm->lock);
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
@@ -284,16 +285,13 @@ void mmu_notifier_unregister(struct mmu_
 {
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
-	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
-		hlist_del_rcu(&mn->hlist);
-
 		/*
 		 * RCU here will force exit_mmap to wait ->release to finish
 		 * before freeing the pages.
 		 */
 		rcu_read_lock();
-		spin_unlock(&mm->mmu_notifier_mm->lock);
+
 		/*
 		 * exit_mmap will block in mmu_notifier_release to
 		 * guarantee ->release is called before freeing the
@@ -302,8 +300,11 @@ void mmu_notifier_unregister(struct mmu_
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
 		rcu_read_unlock();
-	} else
+
+		spin_lock(&mm->mmu_notifier_mm->lock);
+		hlist_del_rcu(&mn->hlist);
 		spin_unlock(&mm->mmu_notifier_mm->lock);
+	}
 
 	/*
 	 * Wait any running method to finish, of course including
_
Subject: Subject: mm: mmu_notifier: fix freed page still mapped in secondary MMU

Patches currently in -mm which might be from xiaoguangrong@linux.vnet.ibm.com are

linux-next.patch
mm-mmu_notifier-fix-freed-page-still-mapped-in-secondary-mmu.patch

