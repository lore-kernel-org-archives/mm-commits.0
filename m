From: akpm@linux-foundation.org
Subject: + mm-mmu_notifier_unregister-fix-null-pointer-deref.patch added to -mm tree
Date: Mon, 04 Feb 2013 14:11:47 -0800
Message-ID: <20130204221147.CA2BA31C19C@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:62333 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3BDWLt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 17:11:49 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so757810vcd.5
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 14:11:48 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: holt@sgi.com, aarcange@redhat.com, avi@redhat.com, haggaie@mellanox.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mtosatti@redhat.com, sagig@mellanox.co.il, xiaoguangrong@linux.vnet.ibm.com


The patch titled
     Subject: mm: mmu_notifier_unregister(): fix NULL pointer deref
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier_unregister-fix-null-pointer-deref.patch

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
Subject: mm: mmu_notifier_unregister(): fix NULL pointer deref

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

Tested with this patch applied.  My test case which was failing
approximately every 300th iteration passed 25,000 tests.

Signed-off-by: Robin Holt <holt@sgi.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.co.il>
Cc: Haggai Eran <haggaie@mellanox.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier_unregister-fix-null-pointer-deref mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier_unregister-fix-null-pointer-deref
+++ a/mm/mmu_notifier.c
@@ -55,7 +55,6 @@ void __mmu_notifier_release(struct mm_st
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
-	srcu_read_unlock(&srcu, id);
 
 	spin_lock(&mm->mmu_notifier_mm->lock);
 	while (unlikely(!hlist_empty(&mm->mmu_notifier_mm->list))) {
@@ -72,6 +71,8 @@ void __mmu_notifier_release(struct mm_st
 	}
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
+	srcu_read_unlock(&srcu, id);
+
 	/*
 	 * synchronize_srcu here prevents mmu_notifier_release to
 	 * return to exit_mmap (which would proceed freeing all pages
@@ -292,16 +293,24 @@ void __mmu_notifier_mm_destroy(struct mm
  */
 void mmu_notifier_unregister(struct mmu_notifier *mn, struct mm_struct *mm)
 {
+	int id;
+
 	BUG_ON(atomic_read(&mm->mm_count) <= 0);
 
+	if (hlist_unhashed(&mn->hlist))
+		goto released;
+
+	/*
+	 * SRCU here will force exit_mmap to wait ->release to finish
+	 * before freeing the pages.
+	 */
+	id = srcu_read_lock(&srcu);
+
+	spin_lock(&mm->mmu_notifier_mm->lock);
 	if (!hlist_unhashed(&mn->hlist)) {
-		/*
-		 * SRCU here will force exit_mmap to wait ->release to finish
-		 * before freeing the pages.
-		 */
-		int id;
+		hlist_del_rcu(&mn->hlist);
+		spin_unlock(&mm->mmu_notifier_mm->lock);
 
-		id = srcu_read_lock(&srcu);
 		/*
 		 * exit_mmap will block in mmu_notifier_release to
 		 * guarantee ->release is called before freeing the
@@ -309,16 +318,16 @@ void mmu_notifier_unregister(struct mmu_
 		 */
 		if (mn->ops->release)
 			mn->ops->release(mn, mm);
-		srcu_read_unlock(&srcu, id);
 
-		spin_lock(&mm->mmu_notifier_mm->lock);
-		hlist_del_rcu(&mn->hlist);
+	} else
 		spin_unlock(&mm->mmu_notifier_mm->lock);
-	}
 
+	srcu_read_unlock(&srcu, id);
+
+released:
 	/*
 	 * Wait any running method to finish, of course including
-	 * ->release if it was run by mmu_notifier_relase instead of us.
+	 * ->release if it was run by __mmu_notifier_release instead of us.
 	 */
 	synchronize_srcu(&srcu);
 
_

Patches currently in -mm which might be from holt@sgi.com are

mm-mmu_notifier_unregister-fix-null-pointer-deref.patch
mm-mmu_notifier_unregister-fix-null-pointer-deref-fix.patch

