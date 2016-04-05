From: akpm@linux-foundation.org
Subject: + huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
 added to -mm tree
Date: Tue, 05 Apr 2016 16:16:13 -0700
Message-ID: <5704473d.1MS8DpN+xyO/JK7u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbcDEXQP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs: mem_cgroup move charge on shmem huge pages
has been added to the -mm tree.  Its filename is
     huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge tmpfs: mem_cgroup move charge on shmem huge pages

Early on, for simplicity, we disabled moving huge tmpfs pages from one
memcg to another (nowadays only required when moving a task into a memcg
having move_charge_at_immigrate exceptionally set).  We're about to add a
couple of memcg stats for huge tmpfs, and will need to confront how to
handle moving those stats, so better enable moving the pages now.

Although they're discovered by the pmd's get_mctgt_type_thp(), they have
to be considered page by page, in what's usually the pte scan: because
although the common case is for each member of the team to be owned by the
same memcg, nowhere is that enforced - perhaps one day we shall need to
enforce such a limitation, but not so far.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |  103 +++++++++++++++++++++++++---------------------
 1 file changed, 58 insertions(+), 45 deletions(-)

diff -puN mm/memcontrol.c~huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages mm/memcontrol.c
--- a/mm/memcontrol.c~huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages
+++ a/mm/memcontrol.c
@@ -4329,6 +4329,7 @@ static int mem_cgroup_do_precharge(unsig
  *   2(MC_TARGET_SWAP): if the swap entry corresponding to this pte is a
  *     target for charge migration. if @target is not NULL, the entry is stored
  *     in target->ent.
+ *   3(MC_TARGET_TEAM): if pmd entry is not an anon THP: check it page by page
  *
  * Called with pte lock held.
  */
@@ -4341,6 +4342,7 @@ enum mc_target_type {
 	MC_TARGET_NONE = 0,
 	MC_TARGET_PAGE,
 	MC_TARGET_SWAP,
+	MC_TARGET_TEAM,
 };
 
 static struct page *mc_handle_present_pte(struct vm_area_struct *vma,
@@ -4562,19 +4564,22 @@ static enum mc_target_type get_mctgt_typ
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
- * We don't consider swapping or file mapped pages because THP does not
- * support them for now.
  * Caller should make sure that pmd_trans_huge(pmd) is true.
  */
-static enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t pmd, union mc_target *target)
+static enum mc_target_type get_mctgt_type_thp(pmd_t pmd,
+		union mc_target *target, unsigned long *pfn)
 {
-	struct page *page = NULL;
+	struct page *page;
 	enum mc_target_type ret = MC_TARGET_NONE;
 
 	page = pmd_page(pmd);
-	/* Don't attempt to move huge tmpfs pages yet: can be enabled later */
-	if (!(mc.flags & MOVE_ANON) || !PageAnon(page))
+	if (!PageAnon(page)) {
+		if (!(mc.flags & MOVE_FILE))
+			return ret;
+		*pfn = page_to_pfn(page);
+		return MC_TARGET_TEAM;
+	}
+	if (!(mc.flags & MOVE_ANON))
 		return ret;
 	if (page->mem_cgroup == mc.from) {
 		ret = MC_TARGET_PAGE;
@@ -4586,8 +4591,8 @@ static enum mc_target_type get_mctgt_typ
 	return ret;
 }
 #else
-static inline enum mc_target_type get_mctgt_type_thp(struct vm_area_struct *vma,
-		unsigned long addr, pmd_t pmd, union mc_target *target)
+static inline enum mc_target_type get_mctgt_type_thp(pmd_t pmd,
+		union mc_target *target, unsigned long *pfn)
 {
 	return MC_TARGET_NONE;
 }
@@ -4598,24 +4603,33 @@ static int mem_cgroup_count_precharge_pt
 					struct mm_walk *walk)
 {
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
+	enum mc_target_type target_type;
+	unsigned long uninitialized_var(pfn);
+	pte_t ptent;
+	pte_t *pte = NULL;
 	spinlock_t *ptl;
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		if (get_mctgt_type_thp(vma, addr, *pmd, NULL) == MC_TARGET_PAGE)
+		target_type = get_mctgt_type_thp(*pmd, NULL, &pfn);
+		if (target_type == MC_TARGET_PAGE)
 			mc.precharge += HPAGE_PMD_NR;
-		spin_unlock(ptl);
-		return 0;
+		if (target_type != MC_TARGET_TEAM)
+			goto unlock;
+	} else {
+		if (pmd_trans_unstable(pmd))
+			return 0;
+		pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; pte++, addr += PAGE_SIZE)
-		if (get_mctgt_type(vma, addr, *pte, NULL))
+	for (; addr != end; addr += PAGE_SIZE) {
+		ptent = pte ? *(pte++) : pfn_pte(pfn++, vma->vm_page_prot);
+		if (get_mctgt_type(vma, addr, ptent, NULL))
 			mc.precharge++;	/* increment precharge temporarily */
-	pte_unmap_unlock(pte - 1, ptl);
+	}
+	if (pte)
+		pte_unmap(pte - 1);
+unlock:
+	spin_unlock(ptl);
 	cond_resched();
 
 	return 0;
@@ -4784,22 +4798,21 @@ static int mem_cgroup_move_charge_pte_ra
 {
 	int ret = 0;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *pte;
+	unsigned long uninitialized_var(pfn);
+	pte_t ptent;
+	pte_t *pte = NULL;
 	spinlock_t *ptl;
 	enum mc_target_type target_type;
 	union mc_target target;
 	struct page *page;
-
+retry:
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		if (mc.precharge < HPAGE_PMD_NR) {
-			spin_unlock(ptl);
-			return 0;
-		}
-		target_type = get_mctgt_type_thp(vma, addr, *pmd, &target);
+		target_type = get_mctgt_type_thp(*pmd, &target, &pfn);
 		if (target_type == MC_TARGET_PAGE) {
 			page = target.page;
-			if (!isolate_lru_page(page)) {
+			if (mc.precharge >= HPAGE_PMD_NR &&
+			    !isolate_lru_page(page)) {
 				if (!mem_cgroup_move_account(page, true,
 							     mc.from, mc.to)) {
 					mc.precharge -= HPAGE_PMD_NR;
@@ -4808,22 +4821,19 @@ static int mem_cgroup_move_charge_pte_ra
 				putback_lru_page(page);
 			}
 			put_page(page);
+			addr = end;
 		}
-		spin_unlock(ptl);
-		return 0;
+		if (target_type != MC_TARGET_TEAM)
+			goto unlock;
+		/* addr is not aligned when retrying after precharge ran out */
+		pfn += (addr & (HPAGE_PMD_SIZE-1)) >> PAGE_SHIFT;
+	} else {
+		if (pmd_trans_unstable(pmd))
+			return 0;
+		pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	}
-
-	if (pmd_trans_unstable(pmd))
-		return 0;
-retry:
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	for (; addr != end; addr += PAGE_SIZE) {
-		pte_t ptent = *(pte++);
-		swp_entry_t ent;
-
-		if (!mc.precharge)
-			break;
-
+	for (; addr != end && mc.precharge; addr += PAGE_SIZE) {
+		ptent = pte ? *(pte++) : pfn_pte(pfn++, vma->vm_page_prot);
 		switch (get_mctgt_type(vma, addr, ptent, &target)) {
 		case MC_TARGET_PAGE:
 			page = target.page;
@@ -4848,8 +4858,8 @@ put:			/* get_mctgt_type() gets the page
 			put_page(page);
 			break;
 		case MC_TARGET_SWAP:
-			ent = target.ent;
-			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
+			if (!mem_cgroup_move_swap_account(target.ent,
+							  mc.from, mc.to)) {
 				mc.precharge--;
 				/* we fixup refcnts and charges later. */
 				mc.moved_swap++;
@@ -4859,7 +4869,10 @@ put:			/* get_mctgt_type() gets the page
 			break;
 		}
 	}
-	pte_unmap_unlock(pte - 1, ptl);
+	if (pte)
+		pte_unmap(pte - 1);
+unlock:
+	spin_unlock(ptl);
 	cond_resched();
 
 	if (addr != end) {
_

Patches currently in -mm which might be from hughd@google.com are

mm-update_lru_size-warn-and-reset-bad-lru_size.patch
mm-update_lru_size-do-the-__mod_zone_page_state.patch
mm-use-__setpageswapbacked-and-dont-clearpageswapbacked.patch
tmpfs-preliminary-minor-tidyups.patch
mm-proc-sys-vm-stat_refresh-to-force-vmstat-update.patch
huge-mm-move_huge_pmd-does-not-need-new_vma.patch
huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch
huge-pagecache-mmap_sem-is-unlocked-when-truncation-splits-pmd.patch
arch-fix-has_transparent_hugepage.patch
huge-tmpfs-prepare-counts-in-meminfo-vmstat-and-sysrq-m.patch
huge-tmpfs-include-shmem-freeholes-in-available-memory.patch
huge-tmpfs-huge=n-mount-option-and-proc-sys-vm-shmem_huge.patch
huge-tmpfs-try-to-allocate-huge-pages-split-into-a-team.patch
huge-tmpfs-avoid-team-pages-in-a-few-places.patch
huge-tmpfs-shrinker-to-migrate-and-free-underused-holes.patch
huge-tmpfs-get_unmapped_area-align-fault-supply-huge-page.patch
huge-tmpfs-try_to_unmap_one-use-page_check_address_transhuge.patch
huge-tmpfs-avoid-premature-exposure-of-new-pagetable.patch
huge-tmpfs-map-shmem-by-huge-page-pmd-or-by-page-team-ptes.patch
huge-tmpfs-disband-split-huge-pmds-on-race-or-memory-failure.patch
huge-tmpfs-extend-get_user_pages_fast-to-shmem-pmd.patch
huge-tmpfs-use-unevictable-lru-with-variable-hpage_nr_pages.patch
huge-tmpfs-fix-mlocked-meminfo-track-huge-unhuge-mlocks.patch
huge-tmpfs-fix-mapped-meminfo-track-huge-unhuge-mappings.patch
huge-tmpfs-mem_cgroup-move-charge-on-shmem-huge-pages.patch
huge-tmpfs-proc-pid-smaps-show-shmemhugepages.patch
huge-tmpfs-recovery-framework-for-reconstituting-huge-pages.patch
huge-tmpfs-recovery-shmem_recovery_populate-to-fill-huge-page.patch
huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
huge-tmpfs-recovery-shmem_recovery_swapin-to-read-from-swap.patch
huge-tmpfs-recovery-tweak-shmem_getpage_gfp-to-fill-team.patch
huge-tmpfs-recovery-debugfs-stats-to-complete-this-phase.patch
huge-tmpfs-recovery-page-migration-call-back-into-shmem.patch
huge-tmpfs-shmem_huge_gfpmask-and-shmem_recovery_gfpmask.patch

