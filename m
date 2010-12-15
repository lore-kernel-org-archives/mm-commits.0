From: akpm@linux-foundation.org
Subject: + thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:49 -0800
Message-ID: <201012152357.oBFNvnvL013644@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52659 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755885Ab0LOX6B (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: allocate memory in khugepaged outside of mmap_sem write mode
has been added to the -mm tree.  Its filename is
     thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: allocate memory in khugepaged outside of mmap_sem write mode
From: Andrea Arcangeli <aarcange@redhat.com>

This tries to be more friendly to filesystem in userland, with userland
backends that allocate memory in the I/O paths and that could deadlock if
khugepaged holds the mmap_sem write mode of the userland backend while
allocating memory.  Memory allocation may wait for writeback I/O
completion from the daemon that may be blocked in the mmap_sem read mode
if a page fault happens and the daemon wasn't using mlock for the memory
required for the I/O submission and completion.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   50 +++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 19 deletions(-)

diff -puN mm/huge_memory.c~thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode mm/huge_memory.c
--- a/mm/huge_memory.c~thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode
+++ a/mm/huge_memory.c
@@ -1680,9 +1680,34 @@ static void collapse_huge_page(struct mm
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 #ifndef CONFIG_NUMA
 	VM_BUG_ON(!*hpage);
+	new_page = *hpage;
 #else
 	VM_BUG_ON(*hpage);
+	/*
+	 * Allocate the page while the vma is still valid and under
+	 * the mmap_sem read mode so there is no memory allocation
+	 * later when we take the mmap_sem in write mode. This is more
+	 * friendly behavior (OTOH it may actually hide bugs) to
+	 * filesystems in userland with daemons allocating memory in
+	 * the userland I/O paths.  Allocating memory with the
+	 * mmap_sem in read mode is good idea also to allow greater
+	 * scalability.
+	 */
+	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
+	if (unlikely(!new_page)) {
+		up_read(&mm->mmap_sem);
+		*hpage = ERR_PTR(-ENOMEM);
+		return;
+	}
 #endif
+	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL))) {
+		up_read(&mm->mmap_sem);
+		put_page(new_page);
+		return;
+	}
+
+	/* after allocating the hugepage upgrade to mmap_sem write mode */
+	up_read(&mm->mmap_sem);
 
 	/*
 	 * Prevent all access to pagetables with the exception of
@@ -1720,18 +1745,6 @@ static void collapse_huge_page(struct mm
 	if (!pmd_present(*pmd) || pmd_trans_huge(*pmd))
 		goto out;
 
-#ifndef CONFIG_NUMA
-	new_page = *hpage;
-#else
-	new_page = alloc_hugepage_vma(khugepaged_defrag(), vma, address);
-	if (unlikely(!new_page)) {
-		*hpage = ERR_PTR(-ENOMEM);
-		goto out;
-	}
-#endif
-	if (unlikely(mem_cgroup_newpage_charge(new_page, mm, GFP_KERNEL)))
-		goto out_put_page;
-
 	anon_vma_lock(vma->anon_vma);
 
 	pte = pte_offset_map(pmd, address);
@@ -1759,7 +1772,7 @@ static void collapse_huge_page(struct mm
 		spin_unlock(&mm->page_table_lock);
 		anon_vma_unlock(vma->anon_vma);
 		mem_cgroup_uncharge_page(new_page);
-		goto out_put_page;
+		goto out;
 	}
 
 	/*
@@ -1798,15 +1811,15 @@ static void collapse_huge_page(struct mm
 	*hpage = NULL;
 #endif
 	khugepaged_pages_collapsed++;
-out:
+out_up_write:
 	up_write(&mm->mmap_sem);
 	return;
 
-out_put_page:
+out:
 #ifdef CONFIG_NUMA
 	put_page(new_page);
 #endif
-	goto out;
+	goto out_up_write;
 }
 
 static int khugepaged_scan_pmd(struct mm_struct *mm,
@@ -1865,10 +1878,9 @@ static int khugepaged_scan_pmd(struct mm
 		ret = 1;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
-	if (ret) {
-		up_read(&mm->mmap_sem);
+	if (ret)
+		/* collapse_huge_page will return with the mmap_sem released */
 		collapse_huge_page(mm, address, hpage);
-	}
 out:
 	return ret;
 }
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

