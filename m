From: akpm@linux-foundation.org
Subject: + thp-kvm-mmu-transparent-hugepage-support-fix.patch added to -mm tree
Date: Mon, 10 Jan 2011 14:42:23 -0800
Message-ID: <201101102242.p0AMgO8q015725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57716 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752888Ab1AJWnF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 17:43:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, jirislaby@gmail.com


The patch titled
     thp: fix for KVM THP support
has been added to the -mm tree.  Its filename is
     thp-kvm-mmu-transparent-hugepage-support-fix.patch

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
Subject: thp: fix for KVM THP support
From: Andrea Arcangeli <aarcange@redhat.com>

There were several bugs: dirty_bitmap ignored (migration shutoff
largepages), has_wrprotect_page(directory_level) ignored, refcount taken
on tail page and refcount released on pfn head page post-adjustment (now
it's being transferred during the adjustment, that's where KSM over THP
tripped inside split_huge_page, the rest I found it by code review).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Tested-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c         |   97 +++++++++++++++++++++++++----------
 arch/x86/kvm/paging_tmpl.h |   10 ++-
 2 files changed, 79 insertions(+), 28 deletions(-)

diff -puN arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support-fix arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support-fix
+++ a/arch/x86/kvm/mmu.c
@@ -554,14 +554,18 @@ static int host_mapping_level(struct kvm
 	return ret;
 }
 
-static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+static bool mapping_level_dirty_bitmap(struct kvm_vcpu *vcpu, gfn_t large_gfn)
 {
 	struct kvm_memory_slot *slot;
-	int host_level, level, max_level;
-
 	slot = gfn_to_memslot(vcpu->kvm, large_gfn);
 	if (slot && slot->dirty_bitmap)
-		return PT_PAGE_TABLE_LEVEL;
+		return true;
+	return false;
+}
+
+static int mapping_level(struct kvm_vcpu *vcpu, gfn_t large_gfn)
+{
+	int host_level, level, max_level;
 
 	host_level = host_mapping_level(vcpu->kvm, large_gfn);
 
@@ -2281,15 +2285,45 @@ static int kvm_handle_bad_page(struct kv
 	return 1;
 }
 
-static void transparent_hugepage_adjust(gfn_t *gfn, pfn_t *pfn, int * level)
+static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
+					gfn_t *gfnp, pfn_t *pfnp, int *levelp)
 {
-	/* check if it's a transparent hugepage */
-	if (!is_error_pfn(*pfn) && !kvm_is_mmio_pfn(*pfn) &&
-	    *level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompound(pfn_to_page(*pfn))) {
-		*level = PT_DIRECTORY_LEVEL;
-		*gfn = *gfn & ~(KVM_PAGES_PER_HPAGE(*level) - 1);
-		*pfn = *pfn & ~(KVM_PAGES_PER_HPAGE(*level) - 1);
+	pfn_t pfn = *pfnp;
+	gfn_t gfn = *gfnp;
+	int level = *levelp;
+
+	/*
+	 * Check if it's a transparent hugepage. If this would be an
+	 * hugetlbfs page, level wouldn't be set to
+	 * PT_PAGE_TABLE_LEVEL and there would be no adjustment done
+	 * here.
+	 */
+	if (!is_error_pfn(pfn) && !kvm_is_mmio_pfn(pfn) &&
+	    level == PT_PAGE_TABLE_LEVEL &&
+	    PageTransCompound(pfn_to_page(pfn)) &&
+	    !has_wrprotected_page(vcpu->kvm, gfn, PT_DIRECTORY_LEVEL)) {
+		unsigned long mask;
+		/*
+		 * mmu_notifier_retry was successful and we hold the
+		 * mmu_lock here, so the pmd can't become splitting
+		 * from under us, and in turn
+		 * __split_huge_page_refcount() can't run from under
+		 * us and we can safely transfer the refcount from
+		 * PG_tail to PG_head as we switch the pfn to tail to
+		 * head.
+		 */
+		*levelp = level = PT_DIRECTORY_LEVEL;
+		mask = KVM_PAGES_PER_HPAGE(level) - 1;
+		VM_BUG_ON((gfn & mask) != (pfn & mask));
+		if (pfn & mask) {
+			gfn &= ~mask;
+			*gfnp = gfn;
+			kvm_release_pfn_clean(pfn);
+			pfn &= ~mask;
+			if (!get_page_unless_zero(pfn_to_page(pfn)))
+				BUG();
+			*pfnp = pfn;
+		}
 	}
 }
 
@@ -2301,27 +2335,31 @@ static int nonpaging_map(struct kvm_vcpu
 {
 	int r;
 	int level;
+	int force_pt_level;
 	pfn_t pfn;
 	unsigned long mmu_seq;
 	bool map_writable;
 
-	level = mapping_level(vcpu, gfn);
-
-	/*
-	 * This path builds a PAE pagetable - so we can map 2mb pages at
-	 * maximum. Therefore check if the level is larger than that.
-	 */
-	if (level > PT_DIRECTORY_LEVEL)
-		level = PT_DIRECTORY_LEVEL;
+	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
+	if (likely(!force_pt_level)) {
+		level = mapping_level(vcpu, gfn);
+		/*
+		 * This path builds a PAE pagetable - so we can map
+		 * 2mb pages at maximum. Therefore check if the level
+		 * is larger than that.
+		 */
+		if (level > PT_DIRECTORY_LEVEL)
+			level = PT_DIRECTORY_LEVEL;
 
-	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+	} else
+		level = PT_PAGE_TABLE_LEVEL;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, gfn, v, &pfn, write, &map_writable))
 		return 0;
-	transparent_hugepage_adjust(&gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2331,6 +2369,8 @@ static int nonpaging_map(struct kvm_vcpu
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
 			 prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2668,6 +2708,7 @@ static int tdp_page_fault(struct kvm_vcp
 	pfn_t pfn;
 	int r;
 	int level;
+	int force_pt_level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
@@ -2680,16 +2721,18 @@ static int tdp_page_fault(struct kvm_vcp
 	if (r)
 		return r;
 
-	level = mapping_level(vcpu, gfn);
-
-	gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+	force_pt_level = mapping_level_dirty_bitmap(vcpu, gfn);
+	if (likely(!force_pt_level)) {
+		level = mapping_level(vcpu, gfn);
+		gfn &= ~(KVM_PAGES_PER_HPAGE(level) - 1);
+	} else
+		level = PT_PAGE_TABLE_LEVEL;
 
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
 	smp_rmb();
 
 	if (try_async_pf(vcpu, prefault, gfn, gpa, &pfn, write, &map_writable))
 		return 0;
-	transparent_hugepage_adjust(&gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2698,6 +2741,8 @@ static int tdp_page_fault(struct kvm_vcp
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable,
 			 level, gfn, pfn, prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff -puN arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support-fix arch/x86/kvm/paging_tmpl.h
--- a/arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support-fix
+++ a/arch/x86/kvm/paging_tmpl.h
@@ -550,6 +550,7 @@ static int FNAME(page_fault)(struct kvm_
 	int r;
 	pfn_t pfn;
 	int level = PT_PAGE_TABLE_LEVEL;
+	int force_pt_level;
 	unsigned long mmu_seq;
 	bool map_writable;
 
@@ -577,7 +578,11 @@ static int FNAME(page_fault)(struct kvm_
 		return 0;
 	}
 
-	if (walker.level >= PT_DIRECTORY_LEVEL) {
+	if (walker.level >= PT_DIRECTORY_LEVEL)
+		force_pt_level = mapping_level_dirty_bitmap(vcpu, walker.gfn);
+	else
+		force_pt_level = 1;
+	if (!force_pt_level) {
 		level = min(walker.level, mapping_level(vcpu, walker.gfn));
 		walker.gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE(level) - 1);
 	}
@@ -588,7 +593,6 @@ static int FNAME(page_fault)(struct kvm_
 	if (try_async_pf(vcpu, prefault, walker.gfn, addr, &pfn, write_fault,
 			 &map_writable))
 		return 0;
-	transparent_hugepage_adjust(&walker.gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -600,6 +604,8 @@ static int FNAME(page_fault)(struct kvm_
 
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
+	if (!force_pt_level)
+		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn, map_writable, prefault);
 	(void)sptep;
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
thp-config_transparent_hugepage-fix.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-pte-alloc-trans-splitting-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-kvm-mmu-transparent-hugepage-support-fix.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
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
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode-fix.patch
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
thp-compound_trans_order-fix.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

