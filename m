From: akpm@linux-foundation.org
Subject: + thp-kvm-mmu-transparent-hugepage-support.patch added to -mm tree
Date: Wed, 15 Dec 2010 19:32:07 -0800
Message-ID: <201012160334.oBG3YocS022107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48180 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751401Ab0LPDfC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 22:35:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, avi@redhat.com, mtosatti@redhat.com


The patch titled
     thp: kvm mmu transparent hugepage support
has been added to the -mm tree.  Its filename is
     thp-kvm-mmu-transparent-hugepage-support.patch

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
Subject: thp: kvm mmu transparent hugepage support
From: Andrea Arcangeli <aarcange@redhat.com>

This should work for both hugetlbfs and transparent hugepages.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c         |   14 ++++++++++++++
 arch/x86/kvm/paging_tmpl.h |    1 +
 virt/kvm/kvm_main.c        |   32 ++++++++++++++++++++++++++++++--
 3 files changed, 45 insertions(+), 2 deletions(-)

diff -puN arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support
+++ a/arch/x86/kvm/mmu.c
@@ -2286,6 +2286,18 @@ static int kvm_handle_bad_page(struct kv
 	return 1;
 }
 
+static void transparent_hugepage_adjust(gfn_t *gfn, pfn_t *pfn, int * level)
+{
+	/* check if it's a transparent hugepage */
+	if (!is_error_pfn(*pfn) && !kvm_is_mmio_pfn(*pfn) &&
+	    *level == PT_PAGE_TABLE_LEVEL &&
+	    PageTransCompound(pfn_to_page(*pfn))) {
+		*level = PT_DIRECTORY_LEVEL;
+		*gfn = *gfn & ~(KVM_PAGES_PER_HPAGE(*level) - 1);
+		*pfn = *pfn & ~(KVM_PAGES_PER_HPAGE(*level) - 1);
+	}
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool no_apf, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
 
@@ -2314,6 +2326,7 @@ static int nonpaging_map(struct kvm_vcpu
 
 	if (try_async_pf(vcpu, no_apf, gfn, v, &pfn, write, &map_writable))
 		return 0;
+	transparent_hugepage_adjust(&gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
@@ -2676,6 +2689,7 @@ static int tdp_page_fault(struct kvm_vcp
 
 	if (try_async_pf(vcpu, no_apf, gfn, gpa, &pfn, write, &map_writable))
 		return 0;
+	transparent_hugepage_adjust(&gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
diff -puN arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support arch/x86/kvm/paging_tmpl.h
--- a/arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support
+++ a/arch/x86/kvm/paging_tmpl.h
@@ -575,6 +575,7 @@ static int FNAME(page_fault)(struct kvm_
 	if (try_async_pf(vcpu, no_apf, walker.gfn, addr, &pfn, write_fault,
 			 &map_writable))
 		return 0;
+	transparent_hugepage_adjust(&walker.gfn, &pfn, &level);
 
 	/* mmio */
 	if (is_error_pfn(pfn))
diff -puN virt/kvm/kvm_main.c~thp-kvm-mmu-transparent-hugepage-support virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~thp-kvm-mmu-transparent-hugepage-support
+++ a/virt/kvm/kvm_main.c
@@ -103,8 +103,36 @@ static pfn_t fault_pfn;
 inline int kvm_is_mmio_pfn(pfn_t pfn)
 {
 	if (pfn_valid(pfn)) {
-		struct page *page = compound_head(pfn_to_page(pfn));
-		return PageReserved(page);
+		struct page *head;
+		struct page *tail = pfn_to_page(pfn);
+		head = compound_head(tail);
+		if (head != tail) {
+			smp_rmb();
+			/*
+			 * head may be a dangling pointer.
+			 * __split_huge_page_refcount clears PageTail
+			 * before overwriting first_page, so if
+			 * PageTail is still there it means the head
+			 * pointer isn't dangling.
+			 */
+			if (PageTail(tail)) {
+				/*
+				 * the "head" is not a dangling
+				 * pointer but the hugepage may have
+				 * been splitted from under us (and we
+				 * may not hold a reference count on
+				 * the head page so it can be reused
+				 * before we run PageReferenced), so
+				 * we've to recheck PageTail before
+				 * returning what we just read.
+				 */
+				int reserved = PageReserved(head);
+				smp_rmb();
+				if (PageTail(tail))
+					return reserved;
+			}
+		}
+		return PageReserved(tail);
 	}
 
 	return true;
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
thp-kvm-mmu-transparent-hugepage-support.patch
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

