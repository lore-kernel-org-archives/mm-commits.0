From: akpm@linux-foundation.org
Subject: +
 huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch added to
 -mm tree
Date: Tue, 05 Apr 2016 16:16:29 -0700
Message-ID: <5704474d.dDiu3uIlwRSkaY2V%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbcDEXQa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Apr 2016 19:16:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, quning@gmail.com, rientjes@google.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge tmpfs recovery: shmem_recovery_remap & remap_team_by_pmd
has been added to the -mm tree.  Its filename is
     huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd.patch

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
Subject: huge tmpfs recovery: shmem_recovery_remap & remap_team_by_pmd

And once we have a fully populated huge page, replace the pte mappings (by
now already pointing into this huge page, as page migration has arranged)
by a huge pmd mapping - not just in the mm which prompted this work, but
in any other mm which might benefit from it.

However, the transition from pte mappings to huge pmd mapping is a new
one, which may surprise code elsewhere - pte_offset_map() and
pte_offset_map_lock() in particular.  See the earlier discussion in "huge
tmpfs: avoid premature exposure of new pagetable", but now we are forced
to go beyond its solution.

The answer will be to put *pmd checking inside them, and examine whether a
pagetable page could ever be recycled for another purpose before the pte
lock is taken: the deposit/withdraw protocol, and mmap_sem conventions,
work nicely against that danger; but special attention will have to be
paid to MADV_DONTNEED's zap_huge_pmd() pte_free under down_read of
mmap_sem.

Avoid those complications for now: just use a rather unwelcome down_write
or down_write_trylock of mmap_sem here in shmem_recovery_remap(), to
exclude msyscalls or faults or ptrace or GUP or NUMA work or /proc access.
rmap access is already excluded by our holding i_mmap_rwsem.  Fast GUP on
x86 is made safe by the TLB flush in remap_team_by_pmd()'s
pmdp_collapse_flush(), its IPIs as usual blocked by fast GUP's
local_irq_disable().  Fast GUP on powerpc is made safe as usual by its RCU
freeing of page tables (though zap_huge_pmd()'s pte_free appears to
violate that, but if so it's an issue for anon THP too: investigate
further later).

Does remap_team_by_pmd() really need its mmu_notifier_invalidate_range
pair?  The manner of mapping changes, but nothing is actually unmapped. 
Of course, the same question can be asked of remap_team_by_ptes().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pageteam.h |    2 
 mm/huge_memory.c         |   87 +++++++++++++++++++++++++++++++++++++
 mm/shmem.c               |   76 ++++++++++++++++++++++++++++++++
 3 files changed, 165 insertions(+)

diff -puN include/linux/pageteam.h~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd include/linux/pageteam.h
--- a/include/linux/pageteam.h~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd
+++ a/include/linux/pageteam.h
@@ -313,6 +313,8 @@ void unmap_team_by_pmd(struct vm_area_st
 			unsigned long addr, pmd_t *pmd, struct page *page);
 void remap_team_by_ptes(struct vm_area_struct *vma,
 			unsigned long addr, pmd_t *pmd);
+void remap_team_by_pmd(struct vm_area_struct *vma,
+			unsigned long addr, pmd_t *pmd, struct page *page);
 #else
 static inline int map_team_by_pmd(struct vm_area_struct *vma,
 			unsigned long addr, pmd_t *pmd, struct page *page)
diff -puN mm/huge_memory.c~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd mm/huge_memory.c
--- a/mm/huge_memory.c~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd
+++ a/mm/huge_memory.c
@@ -3704,3 +3704,90 @@ raced:
 	spin_unlock(pml);
 	mmu_notifier_invalidate_range_end(mm, addr, end);
 }
+
+void remap_team_by_pmd(struct vm_area_struct *vma, unsigned long addr,
+		       pmd_t *pmd, struct page *head)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct page *page = head;
+	pgtable_t pgtable;
+	unsigned long end;
+	spinlock_t *pml;
+	spinlock_t *ptl;
+	pmd_t pmdval;
+	pte_t *pte;
+	int rss = 0;
+
+	VM_BUG_ON_PAGE(!PageTeam(head), head);
+	VM_BUG_ON_PAGE(!PageLocked(head), head);
+	VM_BUG_ON(addr & ~HPAGE_PMD_MASK);
+	end = addr + HPAGE_PMD_SIZE;
+
+	mmu_notifier_invalidate_range_start(mm, addr, end);
+	pml = pmd_lock(mm, pmd);
+	pmdval = *pmd;
+	/* I don't see how this can happen now, but be defensive */
+	if (pmd_trans_huge(pmdval) || pmd_none(pmdval))
+		goto out;
+
+	ptl = pte_lockptr(mm, pmd);
+	if (ptl != pml)
+		spin_lock(ptl);
+
+	pgtable = pmd_pgtable(pmdval);
+	pmdval = mk_pmd(head, vma->vm_page_prot);
+	pmdval = pmd_mkhuge(pmd_mkdirty(pmdval));
+
+	/* Perhaps wise to mark head as mapped before removing pte rmaps */
+	page_add_file_rmap(head);
+
+	/*
+	 * Just as remap_team_by_ptes() would prefer to fill the page table
+	 * earlier, remap_team_by_pmd() would prefer to empty it later; but
+	 * ppc64's variant of the deposit/withdraw protocol prevents that.
+	 */
+	pte = pte_offset_map(pmd, addr);
+	do {
+		if (pte_none(*pte))
+			continue;
+
+		VM_BUG_ON(!pte_present(*pte));
+		VM_BUG_ON(pte_page(*pte) != page);
+
+		pte_clear(mm, addr, pte);
+		page_remove_rmap(page, false);
+		put_page(page);
+		rss++;
+	} while (pte++, page++, addr += PAGE_SIZE, addr != end);
+
+	pte -= HPAGE_PMD_NR;
+	addr -= HPAGE_PMD_SIZE;
+
+	if (rss) {
+		pmdp_collapse_flush(vma, addr, pmd);
+		pgtable_trans_huge_deposit(mm, pmd, pgtable);
+		set_pmd_at(mm, addr, pmd, pmdval);
+		update_mmu_cache_pmd(vma, addr, pmd);
+		get_page(head);
+		page_add_team_rmap(head);
+		add_mm_counter(mm, MM_SHMEMPAGES, HPAGE_PMD_NR - rss);
+	} else {
+		/*
+		 * Hmm.  We might have caught this vma in between unmap_vmas()
+		 * and free_pgtables(), which is a surprising time to insert a
+		 * huge page.  Before our caller checked mm_users, I sometimes
+		 * saw a "bad pmd" report, and pgtable_pmd_page_dtor() BUG on
+		 * pmd_huge_pte, when killing off tests.  But checking mm_users
+		 * is not enough to protect against munmap(): so for safety,
+		 * back out if we found no ptes to replace.
+		 */
+		page_remove_rmap(head, false);
+	}
+
+	if (ptl != pml)
+		spin_unlock(ptl);
+	pte_unmap(pte);
+out:
+	spin_unlock(pml);
+	mmu_notifier_invalidate_range_end(mm, addr, end);
+}
diff -puN mm/shmem.c~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd mm/shmem.c
--- a/mm/shmem.c~huge-tmpfs-recovery-shmem_recovery_remap-remap_team_by_pmd
+++ a/mm/shmem.c
@@ -1097,6 +1097,82 @@ unlock:
 
 static void shmem_recovery_remap(struct recovery *recovery, struct page *head)
 {
+	struct mm_struct *mm = recovery->mm;
+	struct address_space *mapping = head->mapping;
+	pgoff_t pgoff = head->index;
+	struct vm_area_struct *vma;
+	unsigned long addr;
+	pmd_t *pmd;
+	bool try_other_mms = false;
+
+	/*
+	 * XXX: This use of mmap_sem is regrettable.  It is needed for one
+	 * reason only: because callers of pte_offset_map(_lock)() are not
+	 * prepared for a huge pmd to appear in place of a page table at any
+	 * instant.  That can be fixed in pte_offset_map(_lock)() and callers,
+	 * but that is a more invasive change, so just do it this way for now.
+	 */
+	down_write(&mm->mmap_sem);
+	lock_page(head);
+	if (!PageTeam(head)) {
+		unlock_page(head);
+		up_write(&mm->mmap_sem);
+		return;
+	}
+	VM_BUG_ON_PAGE(!PageChecked(head), head);
+	i_mmap_lock_write(mapping);
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		/* XXX: Use anon_vma as over-strict hint of COWed pages */
+		if (vma->anon_vma)
+			continue;
+		addr = vma_address(head, vma);
+		if (addr & (HPAGE_PMD_SIZE-1))
+			continue;
+		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
+			continue;
+		if (!atomic_read(&vma->vm_mm->mm_users))
+			continue;
+		if (vma->vm_mm != mm) {
+			try_other_mms = true;
+			continue;
+		}
+		/* Only replace existing ptes: empty pmd can fault for itself */
+		pmd = mm_find_pmd(vma->vm_mm, addr);
+		if (!pmd)
+			continue;
+		remap_team_by_pmd(vma, addr, pmd, head);
+		shr_stats(remap_faulter);
+	}
+	up_write(&mm->mmap_sem);
+	if (!try_other_mms)
+		goto out;
+	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+		if (vma->vm_mm == mm)
+			continue;
+		/* XXX: Use anon_vma as over-strict hint of COWed pages */
+		if (vma->anon_vma)
+			continue;
+		addr = vma_address(head, vma);
+		if (addr & (HPAGE_PMD_SIZE-1))
+			continue;
+		if (vma->vm_end < addr + HPAGE_PMD_SIZE)
+			continue;
+		if (!atomic_read(&vma->vm_mm->mm_users))
+			continue;
+		/* Only replace existing ptes: empty pmd can fault for itself */
+		pmd = mm_find_pmd(vma->vm_mm, addr);
+		if (!pmd)
+			continue;
+		if (down_write_trylock(&vma->vm_mm->mmap_sem)) {
+			remap_team_by_pmd(vma, addr, pmd, head);
+			shr_stats(remap_another);
+			up_write(&vma->vm_mm->mmap_sem);
+		} else
+			shr_stats(remap_untried);
+	}
+out:
+	i_mmap_unlock_write(mapping);
+	unlock_page(head);
 }
 
 static void shmem_recovery_work(struct work_struct *work)
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

