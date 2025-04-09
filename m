Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3F613D8B1
	for <mm-commits@vger.kernel.org>; Wed,  9 Apr 2025 01:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744160858; cv=none; b=Llox7hx6f3jXds/G+pkDf1TiRFb+SwY89h4ONwjidLRLGLXp0eYHvIYU8pxwXTauilpKL+vPoS4EGtsRp1joh6vqTwkLn/Hyrui5WmzqjN6n0GNMZcWW99RxOd2NqbT4Gg0MrRv90L6bnGDaqEdgfnRj752J9Xy8L/7/nirZZe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744160858; c=relaxed/simple;
	bh=U4FBnva1q6yOsmaRvpbflxJwimfILEepShGHHXtqq3A=;
	h=Date:To:From:Subject:Message-Id; b=kitdw5iK3W3I+aGhhXtofnNJZY9H58vvwarPNxNeEtBlGybhAQxJ9OCzvqlnseBpERYXSG2pM8yEeURrmo2GLCOavkhWLtQiAB0vLQIkFZ1GEPjSLw65zth4dWsngODl2x8zMOlS80JYsVKutNeIvfidIKFA2XHixmoV8ciA14I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hHrO2k1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hHrO2k1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EB7C4CEE5;
	Wed,  9 Apr 2025 01:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744160858;
	bh=U4FBnva1q6yOsmaRvpbflxJwimfILEepShGHHXtqq3A=;
	h=Date:To:From:Subject:From;
	b=hHrO2k1k9rEzzoyCHNpjvhg5oKnEZbHQwhXMeGL7ARxeF5HcTmGTwSCZsjsNyFXLl
	 lFX+qdbijuz60/8hZn8K+olsPmlKSkm3u0M2V6I3KDvt96HdkrL8lM6nxRq51t7W+p
	 VbiEef2wmJRIpAsvX9azSv9vF9qdhqWJvg3HtJT0=
Date: Tue, 08 Apr 2025 18:07:37 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,yang@os.amperecomputing.com,x86@kernel.org,willy@infradead.org,will@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterz@infradead.org,paul.walmsley@sifive.com,palmer@dabbelt.com,mpe@ellerman.id.au,mark.rutland@arm.com,maddy@linux.ibm.com,linus.walleij@linaro.org,geert@linux-m68k.org,davem@davemloft.net,dave.hansen@linux.intel.com,catalin.marinas@arm.com,aou@eecs.berkeley.edu,andreas@gaisler.com,kevin.brodsky@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch added to mm-new branch
Message-Id: <20250409010738.48EB7C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: sparc64: mm: call ctor/dtor for kernel PTEs
has been added to the -mm mm-new branch.  Its filename is
     sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch

This patch will later appear in the mm-new branch at
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
Subject: sparc64: mm: call ctor/dtor for kernel PTEs
Date: Tue, 8 Apr 2025 10:52:16 +0100

The generic implementation of pte_{alloc_one,free}_kernel now calls the
[cd]tor, without initialising the ptlock needlessly as
pagetable_pte_ctor() skips it for init_mm.

Align sparc64 with the generic implementation by ensuring
pagetable_pte_[cd]tor() are called for kernel PTEs.  As a result the
kernel and user alloc/free functions have the same implementation, and
since pgtable_t is defined as pte_t *, we can have both call a common
helper.

Link: https://lkml.kernel.org/r/20250408095222.860601-7-kevin.brodsky@arm.com
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Andreas Larsson <andreas@gaisler.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Waleij <linus.walleij@linaro.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: <x86@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/mm/init_64.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/arch/sparc/mm/init_64.c~sparc64-mm-call-ctor-dtor-for-kernel-ptes
+++ a/arch/sparc/mm/init_64.c
@@ -2878,18 +2878,7 @@ void __flush_tlb_all(void)
 			     : : "r" (pstate));
 }
 
-pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
-{
-	struct page *page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	pte_t *pte = NULL;
-
-	if (page)
-		pte = (pte_t *) page_address(page);
-
-	return pte;
-}
-
-pgtable_t pte_alloc_one(struct mm_struct *mm)
+static pte_t *__pte_alloc_one(struct mm_struct *mm)
 {
 	struct ptdesc *ptdesc = pagetable_alloc(GFP_KERNEL | __GFP_ZERO, 0);
 
@@ -2902,9 +2891,14 @@ pgtable_t pte_alloc_one(struct mm_struct
 	return ptdesc_address(ptdesc);
 }
 
-void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+pte_t *pte_alloc_one_kernel(struct mm_struct *mm)
 {
-	free_page((unsigned long)pte);
+	return __pte_alloc_one(mm);
+}
+
+pgtable_t pte_alloc_one(struct mm_struct *mm)
+{
+	return __pte_alloc_one(mm);
 }
 
 static void __pte_free(pgtable_t pte)
@@ -2915,6 +2909,11 @@ static void __pte_free(pgtable_t pte)
 	pagetable_free(ptdesc);
 }
 
+void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
+{
+	__pte_free(pte);
+}
+
 void pte_free(struct mm_struct *mm, pgtable_t pte)
 {
 	__pte_free(pte);
_

Patches currently in -mm which might be from kevin.brodsky@arm.com are

mm-pass-mm-down-to-pagetable_ptepmd_ctor.patch
x86-pgtable-always-use-pte_free_kernel.patch
mm-call-ctor-dtor-for-kernel-ptes.patch
m68k-mm-call-ctor-dtor-for-kernel-ptes.patch
powerpc-mm-call-ctor-dtor-for-kernel-ptes.patch
sparc64-mm-call-ctor-dtor-for-kernel-ptes.patch
mm-skip-ptlock_init-for-kernel-pmds.patch
arm64-mm-use-enum-to-identify-pgtable-level-instead-of-_shift.patch
arm64-mm-always-call-pte-pmd-ctor-in-__create_pgd_mapping.patch
riscv-mm-clarify-ctor-mm-argument-in-alloc_ptepmd_late.patch
arm64-mm-call-pud-p4d-ctor-in-__create_pgd_mapping.patch
riscv-mm-call-pud-p4d-ctor-in-special-kernel-pgtable-alloc.patch

