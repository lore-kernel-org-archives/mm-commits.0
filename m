From: akpm@linux-foundation.org
Subject: + thp-mmu_notifier_test_young.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:58:01 -0800
Message-ID: <201012152358.oBFNw1w9013670@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755903Ab0LOX6P (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:58:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com


The patch titled
     thp: mmu_notifier_test_young
has been added to the -mm tree.  Its filename is
     thp-mmu_notifier_test_young.patch

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
Subject: thp: mmu_notifier_test_young
From: Andrea Arcangeli <aarcange@redhat.com>

For GRU and EPT, we need gup-fast to set referenced bit too (this is why
it's correct to return 0 when shadow_access_mask is zero, it requires
gup-fast to set the referenced bit).  qemu-kvm access already sets the
young bit in the pte if it isn't zero-copy, if it's zero copy or a shadow
paging EPT minor fault we relay on gup-fast to signal the page is in
use...

We also need to check the young bits on the secondary pagetables for NPT
and not nested shadow mmu as the data may never get accessed again by the
primary pte.

Without this closer accuracy, we'd have to remove the heuristic that
avoids collapsing hugepages in hugepage virtual regions that have not even
a single subpage in use.

->test_young is full backwards compatible with GRU and other usages that
don't have young bits in pagetables set by the hardware and that should
nuke the secondary mmu mappings when ->clear_flush_young runs just like
EPT does.

Removing the heuristic that checks the young bit in
khugepaged/collapse_huge_page completely isn't so bad either probably but
I thought it was worth it and this makes it reliable.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/kvm_host.h |    1 
 arch/x86/kvm/mmu.c              |   34 ++++++++++++++++++++++++++++++
 arch/x86/mm/gup.c               |    3 ++
 include/linux/mmu_notifier.h    |   26 ++++++++++++++++++++++
 mm/huge_memory.c                |    6 +++--
 mm/mmu_notifier.c               |   20 +++++++++++++++++
 virt/kvm/kvm_main.c             |   17 +++++++++++++++
 7 files changed, 105 insertions(+), 2 deletions(-)

diff -puN arch/x86/include/asm/kvm_host.h~thp-mmu_notifier_test_young arch/x86/include/asm/kvm_host.h
--- a/arch/x86/include/asm/kvm_host.h~thp-mmu_notifier_test_young
+++ a/arch/x86/include/asm/kvm_host.h
@@ -805,6 +805,7 @@ asmlinkage void kvm_handle_fault_on_rebo
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
 int kvm_age_hva(struct kvm *kvm, unsigned long hva);
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int cpuid_maxphyaddr(struct kvm_vcpu *vcpu);
 int kvm_cpu_has_interrupt(struct kvm_vcpu *vcpu);
diff -puN arch/x86/kvm/mmu.c~thp-mmu_notifier_test_young arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~thp-mmu_notifier_test_young
+++ a/arch/x86/kvm/mmu.c
@@ -945,6 +945,35 @@ static int kvm_age_rmapp(struct kvm *kvm
 	return young;
 }
 
+static int kvm_test_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
+			      unsigned long data)
+{
+	u64 *spte;
+	int young = 0;
+
+	/*
+	 * If there's no access bit in the secondary pte set by the
+	 * hardware it's up to gup-fast/gup to set the access bit in
+	 * the primary pte or in the page structure.
+	 */
+	if (!shadow_accessed_mask)
+		goto out;
+
+	spte = rmap_next(kvm, rmapp, NULL);
+	while (spte) {
+		u64 _spte = *spte;
+		BUG_ON(!(_spte & PT_PRESENT_MASK));
+		young = _spte & PT_ACCESSED_MASK;
+		if (young) {
+			young = 1;
+			break;
+		}
+		spte = rmap_next(kvm, rmapp, spte);
+	}
+out:
+	return young;
+}
+
 #define RMAP_RECYCLE_THRESHOLD 1000
 
 static void rmap_recycle(struct kvm_vcpu *vcpu, u64 *spte, gfn_t gfn)
@@ -965,6 +994,11 @@ int kvm_age_hva(struct kvm *kvm, unsigne
 	return kvm_handle_hva(kvm, hva, 0, kvm_age_rmapp);
 }
 
+int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
+{
+	return kvm_handle_hva(kvm, hva, 0, kvm_test_age_rmapp);
+}
+
 #ifdef MMU_DEBUG
 static int is_empty_shadow_page(u64 *spt)
 {
diff -puN arch/x86/mm/gup.c~thp-mmu_notifier_test_young arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~thp-mmu_notifier_test_young
+++ a/arch/x86/mm/gup.c
@@ -8,6 +8,7 @@
 #include <linux/mm.h>
 #include <linux/vmstat.h>
 #include <linux/highmem.h>
+#include <linux/swap.h>
 
 #include <asm/pgtable.h>
 
@@ -89,6 +90,7 @@ static noinline int gup_pte_range(pmd_t 
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
 		page = pte_page(pte);
 		get_page(page);
+		SetPageReferenced(page);
 		pages[*nr] = page;
 		(*nr)++;
 
@@ -103,6 +105,7 @@ static inline void get_head_page_multipl
 	VM_BUG_ON(page != compound_head(page));
 	VM_BUG_ON(page_count(page) == 0);
 	atomic_add(nr, &page->_count);
+	SetPageReferenced(page);
 }
 
 static inline void get_huge_page_tail(struct page *page)
diff -puN include/linux/mmu_notifier.h~thp-mmu_notifier_test_young include/linux/mmu_notifier.h
--- a/include/linux/mmu_notifier.h~thp-mmu_notifier_test_young
+++ a/include/linux/mmu_notifier.h
@@ -62,6 +62,16 @@ struct mmu_notifier_ops {
 				 unsigned long address);
 
 	/*
+	 * test_young is called to check the young/accessed bitflag in
+	 * the secondary pte. This is used to know if the page is
+	 * frequently used without actually clearing the flag or tearing
+	 * down the secondary mapping on the page.
+	 */
+	int (*test_young)(struct mmu_notifier *mn,
+			  struct mm_struct *mm,
+			  unsigned long address);
+
+	/*
 	 * change_pte is called in cases that pte mapping to page is changed:
 	 * for example, when ksm remaps pte to point to a new shared page.
 	 */
@@ -163,6 +173,8 @@ extern void __mmu_notifier_mm_destroy(st
 extern void __mmu_notifier_release(struct mm_struct *mm);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long address);
+extern int __mmu_notifier_test_young(struct mm_struct *mm,
+				     unsigned long address);
 extern void __mmu_notifier_change_pte(struct mm_struct *mm,
 				      unsigned long address, pte_t pte);
 extern void __mmu_notifier_invalidate_page(struct mm_struct *mm,
@@ -186,6 +198,14 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline int mmu_notifier_test_young(struct mm_struct *mm,
+					  unsigned long address)
+{
+	if (mm_has_notifiers(mm))
+		return __mmu_notifier_test_young(mm, address);
+	return 0;
+}
+
 static inline void mmu_notifier_change_pte(struct mm_struct *mm,
 					   unsigned long address, pte_t pte)
 {
@@ -313,6 +333,12 @@ static inline int mmu_notifier_clear_flu
 	return 0;
 }
 
+static inline int mmu_notifier_test_young(struct mm_struct *mm,
+					  unsigned long address)
+{
+	return 0;
+}
+
 static inline void mmu_notifier_change_pte(struct mm_struct *mm,
 					   unsigned long address, pte_t pte)
 {
diff -puN mm/huge_memory.c~thp-mmu_notifier_test_young mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mmu_notifier_test_young
+++ a/mm/huge_memory.c
@@ -1632,7 +1632,8 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON(PageLRU(page));
 
 		/* If there is no mapped pte young don't collapse the page */
-		if (pte_young(pteval))
+		if (pte_young(pteval) || PageReferenced(page) ||
+		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
 	if (unlikely(!referenced))
@@ -1892,7 +1893,8 @@ static int khugepaged_scan_pmd(struct mm
 		/* cannot use mapcount: can't collapse if there's a gup pin */
 		if (page_count(page) != 1)
 			goto out_unmap;
-		if (pte_young(pteval))
+		if (pte_young(pteval) || PageReferenced(page) ||
+		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
 	if (referenced)
diff -puN mm/mmu_notifier.c~thp-mmu_notifier_test_young mm/mmu_notifier.c
--- a/mm/mmu_notifier.c~thp-mmu_notifier_test_young
+++ a/mm/mmu_notifier.c
@@ -100,6 +100,26 @@ int __mmu_notifier_clear_flush_young(str
 	return young;
 }
 
+int __mmu_notifier_test_young(struct mm_struct *mm,
+			      unsigned long address)
+{
+	struct mmu_notifier *mn;
+	struct hlist_node *n;
+	int young = 0;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
+		if (mn->ops->test_young) {
+			young = mn->ops->test_young(mn, mm, address);
+			if (young)
+				break;
+		}
+	}
+	rcu_read_unlock();
+
+	return young;
+}
+
 void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
 			       pte_t pte)
 {
diff -puN virt/kvm/kvm_main.c~thp-mmu_notifier_test_young virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~thp-mmu_notifier_test_young
+++ a/virt/kvm/kvm_main.c
@@ -346,6 +346,22 @@ static int kvm_mmu_notifier_clear_flush_
 	return young;
 }
 
+static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
+				       struct mm_struct *mm,
+				       unsigned long address)
+{
+	struct kvm *kvm = mmu_notifier_to_kvm(mn);
+	int young, idx;
+
+	idx = srcu_read_lock(&kvm->srcu);
+	spin_lock(&kvm->mmu_lock);
+	young = kvm_test_age_hva(kvm, address);
+	spin_unlock(&kvm->mmu_lock);
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	return young;
+}
+
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
@@ -362,6 +378,7 @@ static const struct mmu_notifier_ops kvm
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
 	.clear_flush_young	= kvm_mmu_notifier_clear_flush_young,
+	.test_young		= kvm_mmu_notifier_test_young,
 	.change_pte		= kvm_mmu_notifier_change_pte,
 	.release		= kvm_mmu_notifier_release,
 };
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

