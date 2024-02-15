Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1EAC13A274
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026163; cv=none; b=HBGXV82SCCzw/Vnc8E9mxskW8REfSSSrwM7H3aJmNATS4VvJ53PLZwQ64DtY1j044gY07iFdkAUptFYlFLEdgSjl1A8/RrxRRwy3qJJ1hVeGmuQakuuXAk+jkum95HelG1wbofyn86Av2dYIfo6Irgh4pxlSPa5P5PIDkxJ4I+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026163; c=relaxed/simple;
	bh=WbIHjFLJo7fjC22tcyuq0TGyq7SeXqou0ra2zmdzdus=;
	h=Date:To:From:Subject:Message-Id; b=tfkeAJvpT4yO2impPc3VVdJWrXUL4hXnO1k7HZF6i58neIcq23+gIda2cH9hPxXt+3D/XO4pCfgAB2PifC98yFmAdnaOe6/J/2qC1X0VZIUOYM8cUAYlnY07cXXmK70Yq8NUd7A86G6GceMBf6xHJR2haN8ykVLOhSGNrnHucl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LXHJfI9C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LXHJfI9C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3C8C43390;
	Thu, 15 Feb 2024 19:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026162;
	bh=WbIHjFLJo7fjC22tcyuq0TGyq7SeXqou0ra2zmdzdus=;
	h=Date:To:From:Subject:From;
	b=LXHJfI9CzR3N4FPRBTC8N3pZ7XRjib5N8ZfRIt/mY/B5sqaFKHvsjM+c7SQaPoCGU
	 L6xTMVwsGYm4SmrnYd++Oq5bZM4aca5V/OcX4i4gMJnd9N3hBXC72ncR5Bs5HSCAcy
	 /187A/lUFUTPUBuAvH2//38hjS6mCWqWjenW59to=
Date: Thu, 15 Feb 2024 11:42:41 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-tidy-up-pte_next_pfn-definition.patch added to mm-unstable branch
Message-Id: <20240215194242.4D3C8C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: tidy up pte_next_pfn() definition
has been added to the -mm mm-unstable branch.  Its filename is
     mm-tidy-up-pte_next_pfn-definition.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-tidy-up-pte_next_pfn-definition.patch

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
Subject: mm: tidy up pte_next_pfn() definition
Date: Thu, 15 Feb 2024 10:31:53 +0000

Now that the all architecture overrides of pte_next_pfn() have been
replaced with pte_advance_pfn(), we can simplify the definition of the
generic pte_next_pfn() macro so that it is unconditionally defined.

Link: https://lkml.kernel.org/r/20240215103205.2607016-7-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
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

 include/linux/pgtable.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/pgtable.h~mm-tidy-up-pte_next_pfn-definition
+++ a/include/linux/pgtable.h
@@ -212,7 +212,6 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
-#ifndef pte_next_pfn
 #ifndef pte_advance_pfn
 static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
@@ -221,7 +220,6 @@ static inline pte_t pte_advance_pfn(pte_
 #endif
 
 #define pte_next_pfn(pte) pte_advance_pfn(pte, 1)
-#endif
 
 #ifndef set_ptes
 /**
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

