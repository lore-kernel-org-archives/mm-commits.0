Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F416842AAB
	for <mm-commits@vger.kernel.org>; Sat,  4 Jan 2025 02:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735958199; cv=none; b=Jj9g9gWsIRbqvcTZxLmOc5SuQHU3qJvr4f0H6xpFdyPA7/l30rk912WYeLhpwKTFNnV7rMs5bcViekEhtJD7zwFd3NVjDHqh9YupiEWdsn5vtX4dApKOxo2zh67Pnv9brBZ9OCN0dlQy3Eo2tGCaPH2HeD3ozm7SJ9w8q/dIrvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735958199; c=relaxed/simple;
	bh=I1KUCjqWVJfHvFInIUIooVvQlt/pvOrPCPMEcDbHDPg=;
	h=Date:To:From:Subject:Message-Id; b=tefcc53OqKATzNgaLoOblHw9u0usRYT9TIvtc1SnOnCGDRL+Myj903aBjtivgy0CWR8k8R7Hh4AAGcxrRPWhFyler+4qBlMTFhDQuJaZwOvdh5O5KzydQLqFdUtOBfnMm2nbh/1BVvmrlS7eDJOdgqvaLsnAEEk5rVIgyz63NoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FVT3vNgv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FVT3vNgv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A75C4CED6;
	Sat,  4 Jan 2025 02:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1735958198;
	bh=I1KUCjqWVJfHvFInIUIooVvQlt/pvOrPCPMEcDbHDPg=;
	h=Date:To:From:Subject:From;
	b=FVT3vNgvckjqbt8nWd2kjXsZA1N3aPZHrlFQqJaH+zahLGuAbZ5wuyM9SxFPr3fYs
	 sOk6L/RHPVHlm6alZ7fG9C7fZaTJ/XGPZ0qEJXKeynMsxRPOlyQFgUaH50YiH7PaPK
	 vNjZuGGDKAnNcmLeQ3C7brJgcP7mPn1nNqZdHx6g=
Date: Fri, 03 Jan 2025 18:36:38 -0800
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,willy@infradead.org,will@kernel.org,tglx@linutronix.de,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,mingo@elte.hu,luto@kernel.org,linus.walleij@linaro.org,dave.hansen@linux.intel.com,catalin.marinas@arm.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + parisc-mm-ensure-pagetable_pmd_tor-are-called.patch added to mm-unstable branch
Message-Id: <20250104023638.81A75C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: parisc: mm: ensure pagetable_pmd_[cd]tor are called
has been added to the -mm mm-unstable branch.  Its filename is
     parisc-mm-ensure-pagetable_pmd_tor-are-called.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/parisc-mm-ensure-pagetable_pmd_tor-are-called.patch

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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: parisc: mm: ensure pagetable_pmd_[cd]tor are called
Date: Fri, 3 Jan 2025 18:44:11 +0000

The implementation of pmd_{alloc_one,free} on parisc requires a non-zero
allocation order, but is completely standard aside from that.  Let's reuse
the generic implementation of pmd_alloc_one().  Explicit zeroing is not
needed as GFP_PGTABLE_KERNEL includes __GFP_ZERO.  The generic pmd_free()
can handle higher allocation orders so we don't need to define our own.

These changes ensure that pagetable_pmd_[cd]tor are called, improving the
accounting of page table pages.

Link: https://lkml.kernel.org/r/20250103184415.2744423-3-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/pgalloc.h |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/arch/parisc/include/asm/pgalloc.h~parisc-mm-ensure-pagetable_pmd_tor-are-called
+++ a/arch/parisc/include/asm/pgalloc.h
@@ -11,7 +11,6 @@
 #include <asm/cache.h>
 
 #define __HAVE_ARCH_PMD_ALLOC_ONE
-#define __HAVE_ARCH_PMD_FREE
 #define __HAVE_ARCH_PGD_FREE
 #include <asm-generic/pgalloc.h>
 
@@ -46,17 +45,19 @@ static inline void pud_populate(struct m
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	pmd_t *pmd;
+	struct ptdesc *ptdesc;
+	gfp_t gfp = GFP_PGTABLE_USER;
 
-	pmd = (pmd_t *)__get_free_pages(GFP_PGTABLE_KERNEL, PMD_TABLE_ORDER);
-	if (likely(pmd))
-		memset ((void *)pmd, 0, PAGE_SIZE << PMD_TABLE_ORDER);
-	return pmd;
-}
-
-static inline void pmd_free(struct mm_struct *mm, pmd_t *pmd)
-{
-	free_pages((unsigned long)pmd, PMD_TABLE_ORDER);
+	if (mm == &init_mm)
+		gfp = GFP_PGTABLE_KERNEL;
+	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
+	if (!ptdesc)
+		return NULL;
+	if (!pagetable_pmd_ctor(ptdesc)) {
+		pagetable_free(ptdesc);
+		return NULL;
+	}
+	return ptdesc_address(ptdesc);
 }
 #endif
 
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

selftests-mm-fix-condition-in-uffd_move_test_common.patch
selftests-mm-fix-wmaybe-uninitialized-warnings.patch
selftests-mm-fix-strncpy-length.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests.patch
selftests-mm-fix-warray-bounds-warnings-in-pkey_sighandler_tests-fix.patch
selftests-mm-build-with-o2.patch
selftests-mm-remove-unused-pkey-helpers.patch
selftests-mm-define-types-using-typedef-in-pkey-helpersh.patch
selftests-mm-ensure-pkey-h-define-inline-functions-only.patch
selftests-mm-remove-empty-pkey-helper-definition.patch
selftests-mm-ensure-non-global-pkey-symbols-are-marked-static.patch
selftests-mm-use-sys_pkey-helpers-consistently.patch
selftests-mm-use-sys_pkey-helpers-consistently-fix.patch
selftests-mm-rename-pkey-register-macro.patch
selftests-mm-skip-pkey_sighandler_tests-if-support-is-missing.patch
selftests-mm-remove-x-permission-from-sigaltstack-mapping.patch
riscv-mm-skip-pgtable-level-check-in-pudp4d_alloc_one.patch
asm-generic-pgalloc-provide-generic-p4d_alloc_onefree.patch
mm-move-common-part-of-pagetable__ctor-to-helper.patch
parisc-mm-ensure-pagetable_pmd_tor-are-called.patch
m68k-mm-add-calls-to-pagetable_pmd_tor.patch
arm-mm-rename-pgd-helpers.patch
asm-generic-pgalloc-provide-generic-__pgd_allocfree.patch
mm-introduce-ctor-dtor-at-pgd-level.patch

