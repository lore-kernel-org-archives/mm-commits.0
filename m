Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FEA13A274
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026160; cv=none; b=geclhTpcgHzWyKO5xVxC6YDuxfgG6LUOiHk6R0HSsFKvFSPfixUO7iE2/u2XZAc1KrS0wY8jcVc4pBPsSM340CXKgu6LtH6q8PyniIBebv8CjVifts+BGC9xWQyTL3lIHWzbwhwStTtHsq6P5wMn5JK0ylCJMMIi/I/k0E4cbvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026160; c=relaxed/simple;
	bh=2HSlYTsMigwgDfjMvoAtDohnWY4F4DxEBDesE9mo/+w=;
	h=Date:To:From:Subject:Message-Id; b=WdFeqxZfQyusiLcUF3/ZoFF3tbCBATt4EslgiMDeybjhxC54fgxQb0H7/2RyzZAbbpOuSp4LiarfQXW3v0vE6gy9oiGpwcmYY6mj20ehrpHOBP9hCZucZ7ErKi+lUArSl7u5bFV+xkQtCrw5xkFVsTLDaZ5USd+bTTERpvMbX0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gb8snl45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gb8snl45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB25C43394;
	Thu, 15 Feb 2024 19:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026160;
	bh=2HSlYTsMigwgDfjMvoAtDohnWY4F4DxEBDesE9mo/+w=;
	h=Date:To:From:Subject:From;
	b=gb8snl45uIcZXMV8ULFMrniqGexKFkl4ZBB8pPhbcCH0tioah1naCp9+uBhT65/m6
	 TU+1lwj2BTA8//2ufUIeOxdmaTkVTTLQbH5ydnvxYtLbvhFgUiqGlQVLiyrBgy/1p5
	 u6t3U2ynJjGGMcWSF0Lt7fj2F0FrCTPV7dNskdLY=
Date: Thu, 15 Feb 2024 11:42:39 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch added to mm-unstable branch
Message-Id: <20240215194240.5BB25C43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: x86/mm: convert pte_next_pfn() to pte_advance_pfn()
has been added to the -mm mm-unstable branch.  Its filename is
     x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/x86-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

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
Subject: x86/mm: convert pte_next_pfn() to pte_advance_pfn()
Date: Thu, 15 Feb 2024 10:31:52 +0000

Core-mm needs to be able to advance the pfn by an arbitrary amount, so
override the new pte_advance_pfn() API to do so.

Link: https://lkml.kernel.org/r/20240215103205.2607016-6-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Morse <james.morse@arm.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/include/asm/pgtable.h~x86-mm-convert-pte_next_pfn-to-pte_advance_pfn
+++ a/arch/x86/include/asm/pgtable.h
@@ -955,13 +955,13 @@ static inline int pte_same(pte_t a, pte_
 	return a.pte == b.pte;
 }
 
-static inline pte_t pte_next_pfn(pte_t pte)
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
 	if (__pte_needs_invert(pte_val(pte)))
-		return __pte(pte_val(pte) - (1UL << PFN_PTE_SHIFT));
-	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+		return __pte(pte_val(pte) - (nr << PFN_PTE_SHIFT));
+	return __pte(pte_val(pte) + (nr << PFN_PTE_SHIFT));
 }
-#define pte_next_pfn	pte_next_pfn
+#define pte_advance_pfn	pte_advance_pfn
 
 static inline int pte_present(pte_t a)
 {
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

