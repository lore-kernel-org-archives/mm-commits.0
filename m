Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAA441A81
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026196; cv=none; b=d4xWis4dp7IJYf/iKPHTvhSUS23iG0DP4kSFEJAyiEH3+iE6fAqXdUI/8+6CdPAd1w+VTRV30Aeeef4kTK/W4XJs4HX1d7whKGeuieFEyBODtPwPzKpPrsMif4ddXLJoXDnJOGRhkKBY8PloaEByPDf249f9wg7yw4HA2HFUcsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026196; c=relaxed/simple;
	bh=zpazCacX8dc9j6561LpskWBQ/fR9DmTB7MaSTvCvs48=;
	h=Date:To:From:Subject:Message-Id; b=nTnXFTbyKQEu3aZsATDqeieihDu2gc8BQ6VWjplyNheYMMnSANwOGe1AOP4kIiW82rs9kji+I3nFAX4V0baEiOerpAkO4g7jEYLYBFJ/6lHi4G7aG0Q+eOB4eZbjYhSovoh1jvnO6iJCviWkJmlOkzTBn9qpjiKX55SdUSB9BOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wk5bOlAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wk5bOlAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE1FC433F1;
	Thu, 15 Feb 2024 19:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026196;
	bh=zpazCacX8dc9j6561LpskWBQ/fR9DmTB7MaSTvCvs48=;
	h=Date:To:From:Subject:From;
	b=wk5bOlAfF0LIwnrp0ab97P6UVeNu0H6NFNfVQhM5vLX1VmOlQx8fHWK0HUP3M1KFg
	 WyYlt8YlJNFWTneEJfY7NC3kw58aorV0iCX46KJNzyYLRoe3ovOekIpMdJxe9tQpUh
	 +ZwF28zYDuJ5O1HmPQqZn0eBLOjAE+xdhTznCyfA=
Date: Thu, 15 Feb 2024 11:43:15 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-__always_inline-to-improve-fork-perf.patch added to mm-unstable branch
Message-Id: <20240215194316.3AE1FC433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: __always_inline to improve fork() perf
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-__always_inline-to-improve-fork-perf.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-__always_inline-to-improve-fork-perf.patch

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
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: arm64/mm: __always_inline to improve fork() perf
Date: Thu, 15 Feb 2024 10:32:04 +0000

As set_ptes() and wrprotect_ptes() become a bit more complex, the compiler
may choose not to inline them.  But this is critical for fork()
performance.  So mark the functions, along with contpte_try_unfold() which
is called by them, as __always_inline.  This is worth ~1% on the fork()
microbenchmark with order-0 folios (the common case).

Link: https://lkml.kernel.org/r/20240215103205.2607016-18-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-__always_inline-to-improve-fork-perf
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1206,8 +1206,8 @@ extern int contpte_ptep_set_access_flags
 				unsigned long addr, pte_t *ptep,
 				pte_t entry, int dirty);
 
-static inline void contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte)
+static __always_inline void contpte_try_unfold(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep, pte_t pte)
 {
 	if (unlikely(pte_valid_cont(pte)))
 		__contpte_try_unfold(mm, addr, ptep, pte);
@@ -1278,7 +1278,7 @@ static inline void set_pte(pte_t *ptep,
 }
 
 #define set_ptes set_ptes
-static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+static __always_inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	pte = pte_mknoncont(pte);
@@ -1360,8 +1360,8 @@ static inline int ptep_clear_flush_young
 }
 
 #define wrprotect_ptes wrprotect_ptes
-static inline void wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr)
+static __always_inline void wrprotect_ptes(struct mm_struct *mm,
+				unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1)) {
 		/*
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

tools-mm-add-thpmaps-script-to-dump-thp-usage-info.patch
arm64-mm-make-set_ptes-robust-when-oas-cross-48-bit-boundary.patch
mm-clarify-the-spec-for-set_ptes.patch
mm-thp-batch-collapse-pmd-with-set_ptes.patch
mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch
arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch
mm-tidy-up-pte_next_pfn-definition.patch
arm64-mm-convert-read_onceptep-to-ptep_getptep.patch
arm64-mm-convert-set_pte_at-to-set_ptes-1.patch
arm64-mm-convert-ptep_clear-to-ptep_get_and_clear.patch
arm64-mm-new-ptep-layer-to-manage-contig-bit.patch
arm64-mm-split-__flush_tlb_range-to-elide-trailing-dsb.patch
arm64-mm-wire-up-pte_cont-for-user-mappings.patch
arm64-mm-implement-new-wrprotect_ptes-batch-api.patch
arm64-mm-implement-new-clear_full_ptes-batch-apis.patch
mm-add-pte_batch_hint-to-reduce-scanning-in-folio_pte_batch.patch
arm64-mm-implement-pte_batch_hint.patch
arm64-mm-__always_inline-to-improve-fork-perf.patch
arm64-mm-automatically-fold-contpte-mappings.patch

