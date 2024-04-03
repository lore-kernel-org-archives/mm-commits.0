Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2370B139D
	for <mm-commits@vger.kernel.org>; Wed,  3 Apr 2024 22:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712183681; cv=none; b=C/gQGBuSgFRhjIM8UI8Y2da+REyZsop2OYwqXzSiS6MG+ud0XOw/5aPyHINOBn93u2/Gv+G39N2eSasM+xGIFZytji/5nQTWScq/0efpLIkUiHbcLHCSuw5Dy5o8V9YEOZA1KADNcY8nhZsUC7KFshr7p26pt3tErU+lsPFrwhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712183681; c=relaxed/simple;
	bh=R7qtK3giSErr9+0LNyfXWFyzbwBnWURFAuzPbVjA6N4=;
	h=Date:To:From:Subject:Message-Id; b=Dh0rM2M2OsXS58vCFvKBjqufR/dMk+/BuvtIQw3tKmva75Se2KSK84uyNPdiVMbKqdNWOVyzpvcnKISS2vxKE6+wjuwPPXULLKX2T4kfE1xbOM5gY6PK/pRFhqKpbzzbc850kFY1LABr2ML67qkypsVjonNCuRhvaD0clb/99Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bn6I1agF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bn6I1agF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9687FC433F1;
	Wed,  3 Apr 2024 22:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712183680;
	bh=R7qtK3giSErr9+0LNyfXWFyzbwBnWURFAuzPbVjA6N4=;
	h=Date:To:From:Subject:From;
	b=bn6I1agFGM3QVRtZ9CgzPtHHx8x8bQG6Se1SQjsLMdlM84hdScXnR2I4yQKRO4zzW
	 MdpIUQV44MLoXxlUZLIvl9bjcfwH0RXbJnmotW7dpP3d5yErUmyxfIN6kA0PDtoAzl
	 8iF+MsLWnM7vc+5mc/umDD3JXxBnzNJPcE/GEDSc=
Date: Wed, 03 Apr 2024 15:34:39 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,jhubbard@nvidia.com,jgg@nvidia.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch added to mm-unstable branch
Message-Id: <20240403223440.9687FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/treewide: rename CONFIG_HAVE_FAST_GUP to CONFIG_HAVE_GUP_FAST
has been added to the -mm mm-unstable branch.  Its filename is
     mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/treewide: rename CONFIG_HAVE_FAST_GUP to CONFIG_HAVE_GUP_FAST
Date: Tue, 2 Apr 2024 14:55:15 +0200

Nowadays, we call it "GUP-fast", the external interface includes functions
like "get_user_pages_fast()", and we renamed all internal functions to
reflect that as well.

Let's make the config option reflect that.

Link: https://lkml.kernel.org/r/20240402125516.223131-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport (IBM) <rppt@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/Kconfig       |    2 +-
 arch/arm64/Kconfig     |    2 +-
 arch/loongarch/Kconfig |    2 +-
 arch/mips/Kconfig      |    2 +-
 arch/powerpc/Kconfig   |    2 +-
 arch/riscv/Kconfig     |    2 +-
 arch/s390/Kconfig      |    2 +-
 arch/sh/Kconfig        |    2 +-
 arch/x86/Kconfig       |    2 +-
 include/linux/rmap.h   |    8 ++++----
 kernel/events/core.c   |    4 ++--
 mm/Kconfig             |    2 +-
 mm/gup.c               |   10 +++++-----
 mm/internal.h          |    2 +-
 14 files changed, 22 insertions(+), 22 deletions(-)

--- a/arch/arm64/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/arm64/Kconfig
@@ -205,7 +205,7 @@ config ARM64
 	select HAVE_SAMPLE_FTRACE_DIRECT
 	select HAVE_SAMPLE_FTRACE_DIRECT_MULTI
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_ERROR_INJECTION
--- a/arch/arm/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/arm/Kconfig
@@ -99,7 +99,7 @@ config ARM
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS if HAVE_DYNAMIC_FTRACE
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if (CPU_V6 || CPU_V6K || CPU_V7) && MMU
 	select HAVE_EXIT_THREAD
-	select HAVE_FAST_GUP if ARM_LPAE
+	select HAVE_GUP_FAST if ARM_LPAE
 	select HAVE_FTRACE_MCOUNT_RECORD if !XIP_KERNEL
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_FUNCTION_GRAPH_TRACER
--- a/arch/loongarch/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/loongarch/Kconfig
@@ -119,7 +119,7 @@ config LOONGARCH
 	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS if !ARCH_STRICT_ALIGN
 	select HAVE_EXIT_THREAD
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_FUNCTION_ERROR_INJECTION
--- a/arch/mips/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/mips/Kconfig
@@ -68,7 +68,7 @@ config MIPS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_EBPF_JIT if !CPU_MICROMIPS
 	select HAVE_EXIT_THREAD
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
--- a/arch/powerpc/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/powerpc/Kconfig
@@ -236,7 +236,7 @@ config PPC
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS	if ARCH_USING_PATCHABLE_FUNCTION_ENTRY || MPROFILE_KERNEL || PPC32
 	select HAVE_EBPF_JIT
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_FUNCTION_DESCRIPTORS	if PPC64_ELF_ABI_V1
--- a/arch/riscv/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/riscv/Kconfig
@@ -132,7 +132,7 @@ config RISCV
 	select HAVE_FUNCTION_GRAPH_RETVAL if HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER if !XIP_KERNEL && !PREEMPTION
 	select HAVE_EBPF_JIT if MMU
-	select HAVE_FAST_GUP if MMU
+	select HAVE_GUP_FAST if MMU
 	select HAVE_FUNCTION_ARG_ACCESS_API
 	select HAVE_FUNCTION_ERROR_INJECTION
 	select HAVE_GCC_PLUGINS
--- a/arch/s390/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/s390/Kconfig
@@ -174,7 +174,7 @@ config S390
 	select HAVE_DYNAMIC_FTRACE_WITH_REGS
 	select HAVE_EBPF_JIT if HAVE_MARCH_Z196_FEATURES
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FENTRY
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_ARG_ACCESS_API
--- a/arch/sh/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/sh/Kconfig
@@ -38,7 +38,7 @@ config SUPERH
 	select HAVE_DEBUG_BUGVERBOSE
 	select HAVE_DEBUG_KMEMLEAK
 	select HAVE_DYNAMIC_FTRACE
-	select HAVE_FAST_GUP if MMU
+	select HAVE_GUP_FAST if MMU
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
--- a/arch/x86/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/arch/x86/Kconfig
@@ -221,7 +221,7 @@ config X86
 	select HAVE_EFFICIENT_UNALIGNED_ACCESS
 	select HAVE_EISA
 	select HAVE_EXIT_THREAD
-	select HAVE_FAST_GUP
+	select HAVE_GUP_FAST
 	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_GRAPH_RETVAL	if HAVE_FUNCTION_GRAPH_TRACER
--- a/include/linux/rmap.h~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/include/linux/rmap.h
@@ -284,7 +284,7 @@ static inline int hugetlb_try_share_anon
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(&folio->page), folio);
 
 	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb();
 
 	if (unlikely(folio_maybe_dma_pinned(folio)))
@@ -295,7 +295,7 @@ static inline int hugetlb_try_share_anon
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
@@ -541,7 +541,7 @@ static __always_inline int __folio_try_s
 	 */
 
 	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb();
 
 	if (unlikely(folio_maybe_dma_pinned(folio)))
@@ -552,7 +552,7 @@ static __always_inline int __folio_try_s
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
--- a/kernel/events/core.c~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/kernel/events/core.c
@@ -7539,7 +7539,7 @@ static u64 perf_get_pgtable_size(struct
 {
 	u64 size = 0;
 
-#ifdef CONFIG_HAVE_FAST_GUP
+#ifdef CONFIG_HAVE_GUP_FAST
 	pgd_t *pgdp, pgd;
 	p4d_t *p4dp, p4d;
 	pud_t *pudp, pud;
@@ -7587,7 +7587,7 @@ again:
 	if (pte_present(pte))
 		size = pte_leaf_size(pte);
 	pte_unmap(ptep);
-#endif /* CONFIG_HAVE_FAST_GUP */
+#endif /* CONFIG_HAVE_GUP_FAST */
 
 	return size;
 }
--- a/mm/gup.c~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/mm/gup.c
@@ -501,7 +501,7 @@ static inline void mm_set_has_pinned_fla
 
 #ifdef CONFIG_MMU
 
-#if defined(CONFIG_ARCH_HAS_HUGEPD) || defined(CONFIG_HAVE_FAST_GUP)
+#if defined(CONFIG_ARCH_HAS_HUGEPD) || defined(CONFIG_HAVE_GUP_FAST)
 static int record_subpages(struct page *page, unsigned long sz,
 			   unsigned long addr, unsigned long end,
 			   struct page **pages)
@@ -515,7 +515,7 @@ static int record_subpages(struct page *
 
 	return nr;
 }
-#endif	/* CONFIG_ARCH_HAS_HUGEPD || CONFIG_HAVE_FAST_GUP */
+#endif	/* CONFIG_ARCH_HAS_HUGEPD || CONFIG_HAVE_GUP_FAST */
 
 #ifdef CONFIG_ARCH_HAS_HUGEPD
 static unsigned long hugepte_addr_end(unsigned long addr, unsigned long end,
@@ -2782,7 +2782,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
  *
  * This code is based heavily on the PowerPC implementation by Nick Piggin.
  */
-#ifdef CONFIG_HAVE_FAST_GUP
+#ifdef CONFIG_HAVE_GUP_FAST
 
 /*
  * Used in the GUP-fast path to determine whether GUP is permitted to work on
@@ -3361,7 +3361,7 @@ static inline void gup_fast_pgd_range(un
 		unsigned int flags, struct page **pages, int *nr)
 {
 }
-#endif /* CONFIG_HAVE_FAST_GUP */
+#endif /* CONFIG_HAVE_GUP_FAST */
 
 #ifndef gup_fast_permitted
 /*
@@ -3381,7 +3381,7 @@ static unsigned long gup_fast(unsigned l
 	int nr_pinned = 0;
 	unsigned seq;
 
-	if (!IS_ENABLED(CONFIG_HAVE_FAST_GUP) ||
+	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
 	    !gup_fast_permitted(start, end))
 		return 0;
 
--- a/mm/internal.h~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/mm/internal.h
@@ -1249,7 +1249,7 @@ static inline bool gup_must_unshare(stru
 	}
 
 	/* Paired with a memory barrier in folio_try_share_anon_rmap_*(). */
-	if (IS_ENABLED(CONFIG_HAVE_FAST_GUP))
+	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_rmb();
 
 	/*
--- a/mm/Kconfig~mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast
+++ a/mm/Kconfig
@@ -473,7 +473,7 @@ config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMA
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
-config HAVE_FAST_GUP
+config HAVE_GUP_FAST
 	depends on MMU
 	bool
 
_

Patches currently in -mm which might be from david@redhat.com are

mm-secretmem-fix-gup-fast-succeeding-on-secretmem-folios.patch
x86-mm-pat-fix-vm_pat-handling-in-cow-mappings.patch
mm-madvise-make-madv_populate_readwrite-handle-vm_fault_retry-properly.patch
mm-madvise-dont-perform-madvise-vma-walk-for-madv_populate_readwrite.patch
mm-userfaultfd-dont-place-zeropages-when-zeropages-are-disallowed.patch
s390-mm-re-enable-the-shared-zeropage-for-pv-and-skeys-kvm-guests.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared.patch
mm-convert-folio_estimated_sharers-to-folio_likely_mapped_shared-fix.patch
selftests-memfd_secret-add-vmsplice-test.patch
mm-merge-folio_is_secretmem-and-folio_fast_pin_allowed-into-gup_fast_folio_allowed.patch
mm-optimize-config_per_vma_lock-member-placement-in-vm_area_struct.patch
mm-remove-prot-parameter-from-move_pte.patch
mm-gup-consistently-name-gup-fast-functions.patch
mm-treewide-rename-config_have_fast_gup-to-config_have_gup_fast.patch
mm-use-gup-fast-instead-fast-gup-in-remaining-comments.patch

