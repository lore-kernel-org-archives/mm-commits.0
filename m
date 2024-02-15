Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DA113A252
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026156; cv=none; b=R7XoeB9wyOyAPMw/V+azwkdGwi+8CZ+dxsr0HcBQGGILzh/WLmK3Aq3+V6hyp3ZQeExz+YDW4K98qRCcaLNLIoc1KmHMw4JQ9rjqRwBKEXIyrKUDFQW0imi0eIe8jF+aHvNrL3EiWLFFXPegDQcXUZyDG5J4LVBxapUidhaogrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026156; c=relaxed/simple;
	bh=NZBwHAmRAjp6JfEuUwgt6J/Ttyr8pXgsj0vDfAFPZlY=;
	h=Date:To:From:Subject:Message-Id; b=ZNcrn5AxVSjZLUXZtJY8xmEg7tX3bilsLGIAZK8xtaqKun6KCpg5eJZprHqtt/8rvk0GKIzCyo/KLSItpWWMG8QEqz303xpFFWDv2rrKTskKIOsErnleT9cHXiFFSb9OkPhm2Pg/1cdg4tFalvYesU1CrcxF1AHKdV2nlSSnBt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ws2NOC1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ws2NOC1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50655C433F1;
	Thu, 15 Feb 2024 19:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026156;
	bh=NZBwHAmRAjp6JfEuUwgt6J/Ttyr8pXgsj0vDfAFPZlY=;
	h=Date:To:From:Subject:From;
	b=Ws2NOC1VXC8ZgPN3l46w61tAI6utTNsg8Uc9nASvD+MLPmzO6o2DFM5SYsHbHNeID
	 jyYjFojuwbkVexfyLrj3bRRsdYGD82MD4l3BmvwXcGqRoESM5/XH8DnWPRouYNQov+
	 7Lu8wwVtW2CdbQ8s+ZV6noQrBSBM24Qq/CbD3Rwg=
Date: Thu, 15 Feb 2024 11:42:35 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch added to mm-unstable branch
Message-Id: <20240215194236.50655C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: introduce pte_advance_pfn() and use for pte_next_pfn()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn.patch

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
Subject: mm: introduce pte_advance_pfn() and use for pte_next_pfn()
Date: Thu, 15 Feb 2024 10:31:50 +0000

The goal is to be able to advance a PTE by an arbitrary number of PFNs. 
So introduce a new API that takes a nr param.  Define the default
implementation here and allow for architectures to override. 
pte_next_pfn() becomes a wrapper around pte_advance_pfn().

Follow up commits will convert each overriding architecture's
pte_next_pfn() to pte_advance_pfn().

Link: https://lkml.kernel.org/r/20240215103205.2607016-4-ryan.roberts@arm.com
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

 include/linux/pgtable.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/include/linux/pgtable.h~mm-introduce-pte_advance_pfn-and-use-for-pte_next_pfn
+++ a/include/linux/pgtable.h
@@ -212,14 +212,17 @@ static inline int pmd_dirty(pmd_t pmd)
 #define arch_flush_lazy_mmu_mode()	do {} while (0)
 #endif
 
-
 #ifndef pte_next_pfn
-static inline pte_t pte_next_pfn(pte_t pte)
+#ifndef pte_advance_pfn
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
-	return __pte(pte_val(pte) + (1UL << PFN_PTE_SHIFT));
+	return __pte(pte_val(pte) + (nr << PFN_PTE_SHIFT));
 }
 #endif
 
+#define pte_next_pfn(pte) pte_advance_pfn(pte, 1)
+#endif
+
 #ifndef set_ptes
 /**
  * set_ptes - Map consecutive pages to a contiguous range of addresses.
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

