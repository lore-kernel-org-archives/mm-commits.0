From: akpm@linux-foundation.org
Subject: [merged] mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch removed from -mm tree
Date: Tue, 09 Oct 2012 11:14:10 -0700
Message-ID: <20121009181411.5FE315C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:58417 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab2JISOP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 14:14:15 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so309367lah.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 11:14:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haggaie@mellanox.com, a.p.zijlstra@chello.nl, andrea@qumranet.com, avi@redhat.com, cl@linux-foundation.org, hughd@google.com, liranl@mellanox.com, ogerlitz@mellanox.com, raindel@mellanox.com, sagig@mellanox.com, xiaoguangrong@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: wrap calls to set_pte_at_notify with invalidate_range_start and invalidate_range_end
has been removed from the -mm tree.  Its filename was
     mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Haggai Eran <haggaie@mellanox.com>
Subject: mm: wrap calls to set_pte_at_notify with invalidate_range_start and invalidate_range_end

In order to allow sleeping during invalidate_page mmu notifier calls, we
need to avoid calling when holding the PT lock.  In addition to its direct
calls, invalidate_page can also be called as a substitute for a change_pte
call, in case the notifier client hasn't implemented change_pte.

This patch drops the invalidate_page call from change_pte, and instead
wraps all calls to change_pte with invalidate_range_start and
invalidate_range_end calls.

Note that change_pte still cannot sleep after this patch, and that clients
implementing change_pte should not take action on it in case the number of
outstanding invalidate_range_start calls is larger than one, otherwise
they might miss a later invalidation.

Signed-off-by: Haggai Eran <haggaie@mellanox.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Haggai Eran <haggaie@mellanox.com>
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Liran Liss <liranl@mellanox.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/events/uprobes.c |    5 +++++
 mm/ksm.c                |   21 +++++++++++++++++++--
 mm/memory.c             |   18 ++++++++++++------
 mm/mmu_notifier.c       |    6 ------
 4 files changed, 36 insertions(+), 14 deletions(-)

diff -puN kernel/events/uprobes.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end kernel/events/uprobes.c
--- a/kernel/events/uprobes.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end
+++ a/kernel/events/uprobes.c
@@ -141,10 +141,14 @@ static int __replace_page(struct vm_area
 	spinlock_t *ptl;
 	pte_t *ptep;
 	int err;
+	/* For mmu_notifiers */
+	const unsigned long mmun_start = addr;
+	const unsigned long mmun_end   = addr + PAGE_SIZE;
 
 	/* For try_to_free_swap() and munlock_vma_page() below */
 	lock_page(page);
 
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
 	err = -EAGAIN;
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
@@ -173,6 +177,7 @@ static int __replace_page(struct vm_area
 
 	err = 0;
  unlock:
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	unlock_page(page);
 	return err;
 }
diff -puN mm/ksm.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end mm/ksm.c
--- a/mm/ksm.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end
+++ a/mm/ksm.c
@@ -709,15 +709,22 @@ static int write_protect_page(struct vm_
 	spinlock_t *ptl;
 	int swapped;
 	int err = -EFAULT;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	addr = page_address_in_vma(page, vma);
 	if (addr == -EFAULT)
 		goto out;
 
 	BUG_ON(PageTransCompound(page));
+
+	mmun_start = addr;
+	mmun_end   = addr + PAGE_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
-		goto out;
+		goto out_mn;
 
 	if (pte_write(*ptep) || pte_dirty(*ptep)) {
 		pte_t entry;
@@ -752,6 +759,8 @@ static int write_protect_page(struct vm_
 
 out_unlock:
 	pte_unmap_unlock(ptep, ptl);
+out_mn:
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 out:
 	return err;
 }
@@ -776,6 +785,8 @@ static int replace_page(struct vm_area_s
 	spinlock_t *ptl;
 	unsigned long addr;
 	int err = -EFAULT;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
 
 	addr = page_address_in_vma(page, vma);
 	if (addr == -EFAULT)
@@ -794,10 +805,14 @@ static int replace_page(struct vm_area_s
 	if (!pmd_present(*pmd))
 		goto out;
 
+	mmun_start = addr;
+	mmun_end   = addr + PAGE_SIZE;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
 	if (!pte_same(*ptep, orig_pte)) {
 		pte_unmap_unlock(ptep, ptl);
-		goto out;
+		goto out_mn;
 	}
 
 	get_page(kpage);
@@ -814,6 +829,8 @@ static int replace_page(struct vm_area_s
 
 	pte_unmap_unlock(ptep, ptl);
 	err = 0;
+out_mn:
+	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 out:
 	return err;
 }
diff -puN mm/memory.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end mm/memory.c
--- a/mm/memory.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end
+++ a/mm/memory.c
@@ -2527,6 +2527,9 @@ static int do_wp_page(struct mm_struct *
 	int ret = 0;
 	int page_mkwrite = 0;
 	struct page *dirty_page = NULL;
+	unsigned long mmun_start;	/* For mmu_notifiers */
+	unsigned long mmun_end;		/* For mmu_notifiers */
+	bool mmun_called = false;	/* For mmu_notifiers */
 
 	old_page = vm_normal_page(vma, address, orig_pte);
 	if (!old_page) {
@@ -2704,6 +2707,11 @@ gotten:
 	if (mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))
 		goto oom_free_new;
 
+	mmun_start  = address & PAGE_MASK;
+	mmun_end    = (address & PAGE_MASK) + PAGE_SIZE;
+	mmun_called = true;
+	mmu_notifier_invalidate_range_start(mm, mmun_start, mmun_end);
+
 	/*
 	 * Re-check the pte - we dropped the lock
 	 */
@@ -2766,14 +2774,12 @@ gotten:
 	} else
 		mem_cgroup_uncharge_page(new_page);
 
+	if (new_page)
+		page_cache_release(new_page);
 unlock:
 	pte_unmap_unlock(page_table, ptl);
-	if (new_page) {
-		if (new_page == old_page)
-			/* cow happened, notify before releasing old_page */
-			mmu_notifier_invalidate_page(mm, address);
-		page_cache_release(new_page);
-	}
+	if (mmun_called)
+		mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 	if (old_page) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
diff -puN mm/mmu_notifier.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~mm-wrap-calls-to-set_pte_at_notify-with-invalidate_range_start-and-invalidate_range_end
+++ a/mm/mmu_notifier.c
@@ -137,12 +137,6 @@ void __mmu_notifier_change_pte(struct mm
 	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
 		if (mn->ops->change_pte)
 			mn->ops->change_pte(mn, mm, address, pte);
-		/*
-		 * Some drivers don't have change_pte,
-		 * so we must call invalidate_page in that case.
-		 */
-		else if (mn->ops->invalidate_page)
-			mn->ops->invalidate_page(mn, mm, address);
 	}
 	srcu_read_unlock(&srcu, id);
 }
_

Patches currently in -mm which might be from haggaie@mellanox.com are

origin.patch

