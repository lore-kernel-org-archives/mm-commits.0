From: akpm@linux-foundation.org
Subject: [merged] mm-mmu_notifier-allocate-mmu_notifier-in-advance.patch removed from -mm tree
Date: Mon, 29 Oct 2012 12:50:15 -0700
Message-ID: <20121029195015.6DA66100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:53197 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2J2TuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Oct 2012 15:50:17 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so682958ghb.1
        for <mm-commits@vger.kernel.org>; Mon, 29 Oct 2012 12:50:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, aarcange@redhat.com, andrea@betterlinux.com, avi@redhat.com, haggaie@mellanox.com, hughd@google.com, liwanp@linux.vnet.ibm.com, mtosatti@redhat.com, sagig@mellanox.co.il, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifier: allocate mmu_notifier in advance
has been removed from the -mm tree.  Its filename was
     mm-mmu_notifier-allocate-mmu_notifier-in-advance.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/mmu_notifier: allocate mmu_notifier in advance

While allocating mmu_notifier with parameter GFP_KERNEL, swap would start
to work in case of tight available memory.  Eventually, that would lead to
a deadlock while the swap deamon swaps anonymous pages.  It was caused by
commit e0f3c3f78da29b ("mm/mmu_notifier: init notifier if necessary").

: [49048.262912] =================================
: [49048.262913] [ INFO: inconsistent lock state ]
: [49048.262916] 3.7.0-rc1+ #518 Not tainted
: [49048.262918] ---------------------------------
: [49048.262919] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
: [49048.262922] kswapd0/35 [HC0[0]:SC0[0]:HE1:SE1] takes:
: [49048.262924]  (&mapping->i_mmap_mutex){+.+.?.}, at: [<ffffffff81192fbc>] page_referenced+0x9c/0x2e0
: [49048.262933] {RECLAIM_FS-ON-W} state was registered at:
: [49048.262935]   [<ffffffff810ed5d6>] mark_held_locks+0x86/0x150
: [49048.262938]   [<ffffffff810edce7>] lockdep_trace_alloc+0x67/0xc0
: [49048.262942]   [<ffffffff811a9323>] kmem_cache_alloc_trace+0x33/0x230
: [49048.262945]   [<ffffffff811a1a27>] do_mmu_notifier_register+0x87/0x180
: [49048.262948]   [<ffffffff811a1b53>] mmu_notifier_register+0x13/0x20
: [49048.262951]   [<ffffffff81006738>] kvm_dev_ioctl+0x428/0x510
: [49048.262955]   [<ffffffff811c7ce8>] do_vfs_ioctl+0x98/0x570
: [49048.262959]   [<ffffffff811c8251>] sys_ioctl+0x91/0xb0
: [49048.262962]   [<ffffffff815df302>] system_call_fastpath+0x16/0x1b
: [49048.262966] irq event stamp: 825
: [49048.262968] hardirqs last  enabled at (825): [<ffffffff815d6fa0>] _raw_spin_unlock_irq+0x30/0x60
: [49048.262971] hardirqs last disabled at (824): [<ffffffff815d6659>] _raw_spin_lock_irq+0x19/0x80
: [49048.262975] softirqs last  enabled at (0): [<ffffffff81082170>] copy_process+0x630/0x17c0
: [49048.262979] softirqs last disabled at (0): [<          (null)>]           (null)
: ...

Simply back out the above commit, which was a small performance
optimization.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Reported-by: Andrea Righi <andrea@betterlinux.com>
Tested-by: Andrea Righi <andrea@betterlinux.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Sagi Grimberg <sagig@mellanox.co.il>
Cc: Haggai Eran <haggaie@mellanox.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN mm/mmu_notifier.c~mm-mmu_notifier-allocate-mmu_notifier-in-advance mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-mmu_notifier-allocate-mmu_notifier-in-advance
+++ a/mm/mmu_notifier.c
@@ -196,28 +196,28 @@ static int do_mmu_notifier_register(stru
 	BUG_ON(atomic_read(&mm->mm_users) <= 0);
 
 	/*
-	* Verify that mmu_notifier_init() already run and the global srcu is
-	* initialized.
-	*/
+	 * Verify that mmu_notifier_init() already run and the global srcu is
+	 * initialized.
+	 */
 	BUG_ON(!srcu.per_cpu_ref);
 
+	ret = -ENOMEM;
+	mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm), GFP_KERNEL);
+	if (unlikely(!mmu_notifier_mm))
+		goto out;
+
 	if (take_mmap_sem)
 		down_write(&mm->mmap_sem);
 	ret = mm_take_all_locks(mm);
 	if (unlikely(ret))
-		goto out;
+		goto out_clean;
 
 	if (!mm_has_notifiers(mm)) {
-		mmu_notifier_mm = kmalloc(sizeof(struct mmu_notifier_mm),
-					GFP_KERNEL);
-		if (unlikely(!mmu_notifier_mm)) {
-			ret = -ENOMEM;
-			goto out_of_mem;
-		}
 		INIT_HLIST_HEAD(&mmu_notifier_mm->list);
 		spin_lock_init(&mmu_notifier_mm->lock);
 
 		mm->mmu_notifier_mm = mmu_notifier_mm;
+		mmu_notifier_mm = NULL;
 	}
 	atomic_inc(&mm->mm_count);
 
@@ -233,12 +233,12 @@ static int do_mmu_notifier_register(stru
 	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
-out_of_mem:
 	mm_drop_all_locks(mm);
-out:
+out_clean:
 	if (take_mmap_sem)
 		up_write(&mm->mmap_sem);
