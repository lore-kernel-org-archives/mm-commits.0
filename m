From: akpm@linux-foundation.org
Subject: + memcg-cleanup-preparation-for-page-table-walk.patch added to
 -mm tree
Date: Thu, 22 Jan 2015 15:31:24 -0800
Message-ID: <54c1884c.wzUGP8W+Deyg0qs/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbbAVXbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Jan 2015 18:31:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, aarcange@redhat.com, benh@kernel.crashing.org, dave.hansen@intel.com, gorcunov@openvz.org, kirill.shutemov@linux.intel.com, xemul@parallels.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: cleanup preparation for page table walk
has been added to the -mm tree.  Its filename is
     memcg-cleanup-preparation-for-page-table-walk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/memcg-cleanup-preparation-for-page-table-walk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/memcg-cleanup-preparation-for-page-table-walk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: memcg: cleanup preparation for page table walk

pagewalk.c can handle vma in itself, so we don't have to pass vma via
walk->private.  And both of mem_cgroup_count_precharge() and
mem_cgroup_move_charge() do for each vma loop themselves, but now it's
done in pagewalk.c, so let's clean up them.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   49 +++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-preparation-for-page-table-walk mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-preparation-for-page-table-walk
+++ a/mm/memcontrol.c
@@ -4868,7 +4868,7 @@ static int mem_cgroup_count_precharge_pt
 					unsigned long addr, unsigned long end,
 					struct mm_walk *walk)
 {
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 
@@ -4894,20 +4894,13 @@ static int mem_cgroup_count_precharge_pt
 static unsigned long mem_cgroup_count_precharge(struct mm_struct *mm)
 {
 	unsigned long precharge;
-	struct vm_area_struct *vma;
 
+	struct mm_walk mem_cgroup_count_precharge_walk = {
+		.pmd_entry = mem_cgroup_count_precharge_pte_range,
+		.mm = mm,
+	};
 	down_read(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		struct mm_walk mem_cgroup_count_precharge_walk = {
-			.pmd_entry = mem_cgroup_count_precharge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		walk_page_range(vma->vm_start, vma->vm_end,
-					&mem_cgroup_count_precharge_walk);
-	}
+	walk_page_range(0, ~0UL, &mem_cgroup_count_precharge_walk);
 	up_read(&mm->mmap_sem);
 
 	precharge = mc.precharge;
@@ -5040,7 +5033,7 @@ static int mem_cgroup_move_charge_pte_ra
 				struct mm_walk *walk)
 {
 	int ret = 0;
-	struct vm_area_struct *vma = walk->private;
+	struct vm_area_struct *vma = walk->vma;
 	pte_t *pte;
 	spinlock_t *ptl;
 	enum mc_target_type target_type;
@@ -5136,7 +5129,10 @@ put:			/* get_mctgt_type() gets the page
 
 static void mem_cgroup_move_charge(struct mm_struct *mm)
 {
-	struct vm_area_struct *vma;
+	struct mm_walk mem_cgroup_move_charge_walk = {
+		.pmd_entry = mem_cgroup_move_charge_pte_range,
+		.mm = mm,
+	};
 
 	lru_add_drain_all();
 	/*
@@ -5159,24 +5155,11 @@ retry:
 		cond_resched();
 		goto retry;
 	}
-	for (vma = mm->mmap; vma; vma = vma->vm_next) {
-		int ret;
-		struct mm_walk mem_cgroup_move_charge_walk = {
-			.pmd_entry = mem_cgroup_move_charge_pte_range,
-			.mm = mm,
-			.private = vma,
-		};
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		ret = walk_page_range(vma->vm_start, vma->vm_end,
-						&mem_cgroup_move_charge_walk);
-		if (ret)
-			/*
-			 * means we have consumed all precharges and failed in
-			 * doing additional charge. Just abandon here.
-			 */
-			break;
-	}
+	/*
+	 * When we have consumed all precharges and failed in doing
+	 * additional charge, the page walk just aborts.
+	 */
+	walk_page_range(0, ~0UL, &mem_cgroup_move_charge_walk);
 	up_read(&mm->mmap_sem);
 	atomic_dec(&mc.from->moving_account);
 }
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
mm-add-kpf_zero_page-flag-for-proc-kpageflags.patch
mm-hugetlb-reduce-arch-dependent-code-around-follow_huge_.patch
mm-hugetlb-pmd_huge-returns-true-for-non-present-hugepage.patch
mm-hugetlb-take-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-fix-getting-refcount-0-page-in-hugetlb_fault.patch
mm-hugetlb-add-migration-hwpoisoned-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-add-migration-entry-check-in-__unmap_hugepage_range.patch
mm-hugetlb-fix-suboptimal-migration-hwpoisoned-entry-check.patch
mm-hugetlb-cleanup-and-rename-is_hugetlb_entry_migrationhwpoisoned.patch
mm-pagewalk-remove-pgd_entry-and-pud_entry.patch
revert-mm-pagewalk-call-pte_hole-for-vm_pfnmap-during-walk_page_range.patch
pagewalk-improve-vma-handling.patch
pagewalk-add-walk_page_vma.patch
smaps-remove-mem_size_stats-vma-and-use-walk_page_vma.patch
clear_refs-remove-clear_refs_private-vma-and-introduce-clear_refs_test_walk.patch
pagemap-use-walk-vma-instead-of-calling-find_vma.patch
numa_maps-fix-typo-in-gather_hugetbl_stats.patch
numa_maps-remove-numa_maps-vma.patch
memcg-cleanup-preparation-for-page-table-walk.patch
arch-powerpc-mm-subpage-protc-use-walk-vma-and-walk_page_vma.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-proc-pid-clear_refs-avoid-split_huge_page.patch
mincore-apply-page-table-walker-on-do_mincore.patch
do_shared_fault-check-that-mmap_sem-is-held.patch

