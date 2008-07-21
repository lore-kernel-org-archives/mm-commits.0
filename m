From: akpm@linux-foundation.org
Subject: + split-lru-munlock-rework.patch added to -mm tree
Date: Sun, 20 Jul 2008 22:20:59 -0700
Message-ID: <200807210520.m6L5KxwH018936@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43131 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932222AbYGUFWH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Jul 2008 01:22:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, Lee.Schermerhorn@hp.com, hugh@veritas.com, lizf@cn.fujitsu.com, riel@redhat.com


The patch titled
     splitlru: split LRU: munlock rework
has been added to the -mm tree.  Its filename is
     split-lru-munlock-rework.patch

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
Subject: splitlru: split LRU: munlock rework
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

current munlock processing use to pagewalk.
its cause two problems.
  - build error on nommu machine
  - runtime error on HIGHPTE machine.

This patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |  152 +++++++++++----------------------------------------
 1 file changed, 35 insertions(+), 117 deletions(-)

diff -puN mm/mlock.c~split-lru-munlock-rework mm/mlock.c
--- a/mm/mlock.c~split-lru-munlock-rework
+++ a/mm/mlock.c
@@ -120,18 +120,33 @@ static void munlock_vma_page(struct page
  * vma->vm_mm->mmap_sem must be held for write.
  */
 static int __mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
+				   unsigned long start, unsigned long end,
+				   int mlock)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long addr = start;
 	struct page *pages[16]; /* 16 gives a reasonable batch */
-	int write = !!(vma->vm_flags & VM_WRITE);
 	int nr_pages = (end - start) / PAGE_SIZE;
 	int ret;
+	int gup_flags = 0;
+
+	VM_BUG_ON(start & ~PAGE_MASK);
+	VM_BUG_ON(end   & ~PAGE_MASK);
+	VM_BUG_ON(start < vma->vm_start);
+	VM_BUG_ON(end   > vma->vm_end);
+	VM_BUG_ON((!rwsem_is_locked(&mm->mmap_sem)) &&
+		  (atomic_read(&mm->mm_users) != 0));
+
+	/*
+	 * mlock:   don't page populate if page has PROT_NONE permission.
+	 * munlock: the pages always do munlock althrough
+	 *          its has PROT_NONE permission.
+	 */
+	if (!mlock)
+		gup_flags |= GUP_FLAGS_IGNORE_VMA_PERMISSIONS;
 
-	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);
-	VM_BUG_ON(start < vma->vm_start || end > vma->vm_end);
-	VM_BUG_ON(!rwsem_is_locked(&vma->vm_mm->mmap_sem));
+	if (vma->vm_flags & VM_WRITE)
+		gup_flags |= GUP_FLAGS_WRITE;
 
 	lru_add_drain_all();	/* push cached pages to LRU */
 
@@ -146,9 +161,9 @@ static int __mlock_vma_pages_range(struc
 		 * disable migration of this page.  However, page may
 		 * still be truncated out from under us.
 		 */
-		ret = get_user_pages(current, mm, addr,
+		ret = __get_user_pages(current, mm, addr,
 				min_t(int, nr_pages, ARRAY_SIZE(pages)),
-				write, 0, pages, NULL);
+				gup_flags, pages, NULL);
 		/*
 		 * This can happen for, e.g., VM_NONLINEAR regions before
 		 * a page has been allocated and mapped at a given offset,
@@ -178,8 +193,12 @@ static int __mlock_vma_pages_range(struc
 			 * by the elevated reference, we need only check for
 			 * page truncation (file-cache only).
 			 */
-			if (page->mapping)
-				mlock_vma_page(page);
+			if (page->mapping) {
+				if (mlock)
+					mlock_vma_page(page);
+				else
+					munlock_vma_page(page);
+			}
 			unlock_page(page);
 			put_page(page);		/* ref from get_user_pages() */
 
@@ -197,120 +216,19 @@ static int __mlock_vma_pages_range(struc
 	return 0;	/* count entire vma as locked_vm */
 }
 
-/*
- * private structure for munlock page table walk
- */
-struct munlock_page_walk {
-	struct vm_area_struct *vma;
-	pmd_t                 *pmd; /* for migration_entry_wait() */
-};
-
-/*
- * munlock normal pages for present ptes
- */
-static int __munlock_pte_handler(pte_t *ptep, unsigned long addr,
-				   unsigned long end, struct mm_walk *walk)
-{
-	struct munlock_page_walk *mpw = walk->private;
-	swp_entry_t entry;
-	struct page *page;
-	pte_t pte;
-
-retry:
-	pte = *ptep;
-	/*
-	 * If it's a swap pte, we might be racing with page migration.
-	 */
-	if (unlikely(!pte_present(pte))) {
-		if (!is_swap_pte(pte))
-			goto out;
-		entry = pte_to_swp_entry(pte);
-		if (is_migration_entry(entry)) {
-			migration_entry_wait(mpw->vma->vm_mm, mpw->pmd, addr);
-			goto retry;
-		}
-		goto out;
-	}
-
-	page = vm_normal_page(mpw->vma, addr, pte);
-	if (!page)
-		goto out;
-
-	lock_page(page);
-	if (!page->mapping) {
-		unlock_page(page);
-		goto retry;
-	}
-	munlock_vma_page(page);
-	unlock_page(page);
-
-out:
-	return 0;
-}
-
-/*
- * Save pmd for pte handler for waiting on migration entries
- */
-static int __munlock_pmd_handler(pmd_t *pmd, unsigned long addr,
-				 unsigned long end, struct mm_walk *walk)
-{
-	struct munlock_page_walk *mpw = walk->private;
-
-	mpw->pmd = pmd;
-	return 0;
-}
-
-
-/*
- * munlock a range of pages in the vma using standard page table walk.
- *
- * vma->vm_mm->mmap_sem must be held for write.
- */
-static void __munlock_vma_pages_range(struct vm_area_struct *vma,
-			      unsigned long start, unsigned long end)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	struct munlock_page_walk mpw = {
-		.vma = vma,
-	};
-	struct mm_walk munlock_page_walk = {
-		.pmd_entry = __munlock_pmd_handler,
-		.pte_entry = __munlock_pte_handler,
-		.private = &mpw,
-		.mm = mm,
-	};
-
-	VM_BUG_ON(start & ~PAGE_MASK || end & ~PAGE_MASK);
-	VM_BUG_ON((!rwsem_is_locked(&mm->mmap_sem)) &&
-		  (atomic_read(&mm->mm_users) != 0));
-	VM_BUG_ON(start < vma->vm_start);
-	VM_BUG_ON(end > vma->vm_end);
-
-	lru_add_drain_all();	/* push cached pages to LRU */
-	walk_page_range(start, end, &munlock_page_walk);
-	lru_add_drain_all();	/* to update stats */
-}
-
 #else /* CONFIG_UNEVICTABLE_LRU */
 
 /*
  * Just make pages present if VM_LOCKED.  No-op if unlocking.
  */
 static int __mlock_vma_pages_range(struct vm_area_struct *vma,
-			unsigned long start, unsigned long end)
+				   unsigned long start, unsigned long end,
+				   int mlock)
 {
-	if (vma->vm_flags & VM_LOCKED)
+	if (mlock && (vma->vm_flags & VM_LOCKED))
 		make_pages_present(start, end);
 	return 0;
 }
-
-/*
- * munlock a range of pages in the vma -- no-op.
- */
-static void __munlock_vma_pages_range(struct vm_area_struct *vma,
-			      unsigned long start, unsigned long end)
-{
-}
 #endif /* CONFIG_UNEVICTABLE_LRU */
 
 /*
@@ -333,7 +251,7 @@ int mlock_vma_pages_range(struct vm_area
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 		downgrade_write(&mm->mmap_sem);
-		nr_pages = __mlock_vma_pages_range(vma, start, end);
+		nr_pages = __mlock_vma_pages_range(vma, start, end, 1);
 
 		up_read(&mm->mmap_sem);
 		/* vma can change or disappear */
@@ -368,7 +286,7 @@ void munlock_vma_pages_range(struct vm_a
 			   unsigned long start, unsigned long end)
 {
 	vma->vm_flags &= ~VM_LOCKED;
-	__munlock_vma_pages_range(vma, start, end);
+	__mlock_vma_pages_range(vma, start, end, 0);
 }
 
 /*
@@ -445,7 +363,7 @@ success:
 		 */
 		downgrade_write(&mm->mmap_sem);
 
-		ret = __mlock_vma_pages_range(vma, start, end);
+		ret = __mlock_vma_pages_range(vma, start, end, 1);
 		if (ret > 0) {
 			mm->locked_vm -= ret;
 			ret = 0;
@@ -471,7 +389,7 @@ success:
 		 * while.  Should we downgrade the semaphore for both lock
 		 * AND unlock ?
 		 */
-		__munlock_vma_pages_range(vma, start, end);
+		__mlock_vma_pages_range(vma, start, end, 0);
 	}
 
 out:
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

adapt-drivers-base-topologyc-to-new-sysfs-api.patch
ahci-use-correct-type-for-cpu-flags.patch
page-allocator-inlnie-some-__alloc_pages-wrappers.patch
page-allocator-inlnie-some-__alloc_pages-wrappers-fix.patch
mm-hugetlbc-fix-duplicate-variable.patch
page-flags-record-page-flag-overlays-explicitly.patch
slub-record-page-flag-overlays-explicitly.patch
slob-record-page-flag-overlays-explicitly.patch
mm-create-sys-kernel-mm-fix.patch
mm-make-config_migration-available-w-o-config_numa-fix.patch
pm-schedule-sysrq-poweroff-on-boot-cpu-fix.patch
call_usermodehelper-increase-reliability.patch
cgroup-list_for_each-cleanup-v2.patch
cgroup-anotate-two-variables-with-__read_mostly.patch
devcgroup-code-cleanup-fix-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
per-task-delay-accounting-update-document-and-getdelaysc-for-memory-reclaim.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix.patch
full-conversion-to-early_initcall-interface-remove-old-interface-fix-fix-fix.patch
relay-add-buffer-only-channels-useful-for-early-logging-fix.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
vmscan-use-an-indexed-array-for-lru-variables.patch
swap-use-an-array-for-the-lru-pagevecs.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-collect-lru-meminfo-statistics-from-correct-offset.patch
vmscan-split-lru-lists-into-anon-file-sets-prevent-incorrect-oom-under-split_lru.patch
vmscan-split-lru-lists-into-anon-file-sets-split_lru-fix-pagevec_move_tail-doesnt-treat-unevictable-page.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-bdi_cap_swap_backed.patch
vmscan-second-chance-replacement-for-anonymous-pages.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
unevictable-lru-infrastructure.patch
unevictable-lru-infrastructure-fix.patch
unevictable-lru-infrastructure-remove-redundant-page-mapping-check.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
unevictable-lru-infrastructure-kill-unnecessary-lock_page-in-vmscanc.patch
unevictable-lru-infrastructure-revert-migration-change-of-unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
unevictable-lru-page-statistics-fix-printk-in-show_free_areas.patch
unevictable-lru-page-statistics-units-fix.patch
shm_locked-pages-are-unevictable.patch
shm_locked-pages-are-unevictable-revert-shm-change-of-shm_locked-pages-are-unevictable-patch.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mlock-mlocked-pages-are-unevictable-fix-fix.patch
mlock-mlocked-pages-are-unevictable-fix-3.patch
mlock-mlocked-pages-are-unevictable-fix-fix-munlock-page-table-walk-now-requires-mm.patch
mlock-mlocked-pages-are-unevictable-restore-patch-failure-hunk-of-mlock-mlocked-pages-are-unevictablepatch.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-cleanup.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
introduce-__get_user_pages.patch
split-lru-munlock-rework.patch
revert-to-unevictable-lru-infrastructure-kconfig-fixpatch.patch
vmstat-mlocked-pages-statistics.patch
vmstat-mlocked-pages-statistics-fix-incorrect-mlocked-field-of-proc-meminfo.patch
vmstat-mlocked-pages-statistics-fix.patch
swap-cull-unevictable-pages-in-fault-path-fix.patch
vmstat-unevictable-and-mlocked-pages-vm-events.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch
vmscan-unevictable-lru-scan-sysctl.patch
vmscan-unevictable-lru-scan-sysctl-nommu-fix.patch
vmscan-unevictable-lru-scan-sysctl-add-sys_device-parameter.patch
vmscam-kill-unused-lru-functions.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
make-mm-memoryc-print_bad_pte-static.patch
mm-swapfilec-make-code-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch

