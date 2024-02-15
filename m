Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FA713A252
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026158; cv=none; b=j/VVT2K4YaI5x4+qnj0jrTASIvPx+kIcS4MEJSM+hzw2yRjnwKykE2QS1OLuLg2RqVEPtkY/KycfySYcx51ryF4fwnTW7FP3RBlZmad1UZwbpTh79QXtCQCSOyPOMCOck+Pt+e7zcKkS+lAt2KexFjy0k1QX2ISre+x6x0tAw+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026158; c=relaxed/simple;
	bh=XSkXNobpKZm7GhDnb80/LBZLiCHzUdtWUXVWcLZ2k4Q=;
	h=Date:To:From:Subject:Message-Id; b=cL2bhEHNEle3JGJuSs3RYme2YyStJeBlPPchXDPfgZAJkpqa/u/4HA8fQXD1c3tqhmtXLb/HlDqcYTGeST3LSiBHLtU8OMX/zTFqlU2Kt5pCRt1O4eIqVBUwfPsAnpgWQg/eiMvU7+NWPBlJUMivT6vPM5a63itXd34xCdr2xMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gUpgnFPU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gUpgnFPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59855C433F1;
	Thu, 15 Feb 2024 19:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026158;
	bh=XSkXNobpKZm7GhDnb80/LBZLiCHzUdtWUXVWcLZ2k4Q=;
	h=Date:To:From:Subject:From;
	b=gUpgnFPUnje4aYZpZDGTSUjcZ22ZMKccurloKdI/139QsrHlkAuDfj2BYV/Md94PA
	 6XUodYPp8NQ4qGtpWGNw5JQiuLlywcFkn2W0hEscsf6h2gxhYDu0cT2rkKBHvyX/1D
	 GX+jtFhEOFS2uoZqdOaEYsPYVdv5+ykaXKehfWds=
Date: Thu, 15 Feb 2024 11:42:37 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch added to mm-unstable branch
Message-Id: <20240215194238.59855C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: convert pte_next_pfn() to pte_advance_pfn()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn.patch

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
Subject: arm64/mm: convert pte_next_pfn() to pte_advance_pfn()
Date: Thu, 15 Feb 2024 10:31:51 +0000

Core-mm needs to be able to advance the pfn by an arbitrary amount, so
override the new pte_advance_pfn() API to do so.

Link: https://lkml.kernel.org/r/20240215103205.2607016-5-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Borislav Petkov (AMD) <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
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

 arch/arm64/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-convert-pte_next_pfn-to-pte_advance_pfn
+++ a/arch/arm64/include/asm/pgtable.h
@@ -351,10 +351,10 @@ static inline pgprot_t pte_pgprot(pte_t
 	return __pgprot(pte_val(pfn_pte(pfn, __pgprot(0))) ^ pte_val(pte));
 }
 
-#define pte_next_pfn pte_next_pfn
-static inline pte_t pte_next_pfn(pte_t pte)
+#define pte_advance_pfn pte_advance_pfn
+static inline pte_t pte_advance_pfn(pte_t pte, unsigned long nr)
 {
-	return pfn_pte(pte_pfn(pte) + 1, pte_pgprot(pte));
+	return pfn_pte(pte_pfn(pte) + nr, pte_pgprot(pte));
 }
 
 static inline void set_ptes(struct mm_struct *mm,
@@ -370,7 +370,7 @@ static inline void set_ptes(struct mm_st
 		if (--nr == 0)
 			break;
 		ptep++;
-		pte = pte_next_pfn(pte);
+		pte = pte_advance_pfn(pte, 1);
 	}
 }
 #define set_ptes set_ptes
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

