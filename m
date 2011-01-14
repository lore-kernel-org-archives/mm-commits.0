From: akpm@linux-foundation.org
Subject: [merged] thp-kvm-mmu-transparent-hugepage-support.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:11 -0800
Message-ID: <201101142250.p0EMo1nX005357@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34407 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab1ANWuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, avi@redhat.com, mtosatti@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: kvm mmu transparent hugepage support
has been removed from the -mm tree.  Its filename was
     thp-kvm-mmu-transparent-hugepage-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: kvm mmu transparent hugepage support
From: Andrea Arcangeli <aarcange@redhat.com>

This should work for both hugetlbfs and transparent hugepages.

[akpm@linux-foundation.org: bring forward PageTransCompound() addition for bisectability]
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/mmu.c         |   91 ++++++++++++++++++++++++++++-------
 arch/x86/kvm/paging_tmpl.h |    9 +++
 include/linux/page-flags.h |   12 ++++
 virt/kvm/kvm_main.c        |   32 +++++++++++-
 4 files changed, 125 insertions(+), 19 deletions(-)

diff -puN arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support arch/x86/kvm/mmu.c
--- a/arch/x86/kvm/mmu.c~thp-kvm-mmu-transparent-hugepage-support
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
 
@@ -2281,6 +2285,48 @@ static int kvm_handle_bad_page(struct kv
 	return 1;
 }
 
+static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
+					gfn_t *gfnp, pfn_t *pfnp, int *levelp)
+{
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
+	}
+}
+
 static bool try_async_pf(struct kvm_vcpu *vcpu, bool prefault, gfn_t gfn,
 			 gva_t gva, pfn_t *pfn, bool write, bool *writable);
 
@@ -2289,20 +2335,25 @@ static int nonpaging_map(struct kvm_vcpu
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
@@ -2318,6 +2369,8 @@ static int nonpaging_map(struct kvm_vcpu
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, v, write, map_writable, level, gfn, pfn,
 			 prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
@@ -2655,6 +2708,7 @@ static int tdp_page_fault(struct kvm_vcp
 	pfn_t pfn;
 	int r;
 	int level;
+	int force_pt_level;
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	unsigned long mmu_seq;
 	int write = error_code & PFERR_WRITE_MASK;
@@ -2667,9 +2721,12 @@ static int tdp_page_fault(struct kvm_vcp
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
@@ -2684,6 +2741,8 @@ static int tdp_page_fault(struct kvm_vcp
 	if (mmu_notifier_retry(vcpu, mmu_seq))
 		goto out_unlock;
 	kvm_mmu_free_some_pages(vcpu);
+	if (likely(!force_pt_level))
+		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
 	r = __direct_map(vcpu, gpa, write, map_writable,
 			 level, gfn, pfn, prefault);
 	spin_unlock(&vcpu->kvm->mmu_lock);
diff -puN arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support arch/x86/kvm/paging_tmpl.h
--- a/arch/x86/kvm/paging_tmpl.h~thp-kvm-mmu-transparent-hugepage-support
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
@@ -599,6 +604,8 @@ static int FNAME(page_fault)(struct kvm_
 
 	trace_kvm_mmu_audit(vcpu, AUDIT_PRE_PAGE_FAULT);
 	kvm_mmu_free_some_pages(vcpu);
+	if (!force_pt_level)
+		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
 	sptep = FNAME(fetch)(vcpu, addr, &walker, user_fault, write_fault,
 			     level, &write_pt, pfn, map_writable, prefault);
 	(void)sptep;
diff -puN include/linux/page-flags.h~thp-kvm-mmu-transparent-hugepage-support include/linux/page-flags.h
--- a/include/linux/page-flags.h~thp-kvm-mmu-transparent-hugepage-support
+++ a/include/linux/page-flags.h
@@ -409,6 +409,18 @@ static inline void ClearPageCompound(str
 
 #endif /* !PAGEFLAGS_EXTENDED */
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static inline int PageTransCompound(struct page *page)
+{
+	return PageCompound(page);
+}
+#else
+static inline int PageTransCompound(struct page *page)
+{
+	return 0;
+}
+#endif
+
 #ifdef CONFIG_MMU
 #define __PG_MLOCKED		(1 << PG_mlocked)
 #else
diff -puN virt/kvm/kvm_main.c~thp-kvm-mmu-transparent-hugepage-support virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c~thp-kvm-mmu-transparent-hugepage-support
+++ a/virt/kvm/kvm_main.c
@@ -104,8 +104,36 @@ static pfn_t fault_pfn;
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

origin.patch
thp-add-pagetranscompound.patch

