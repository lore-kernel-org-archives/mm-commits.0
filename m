Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6653441A81
	for <mm-commits@vger.kernel.org>; Thu, 15 Feb 2024 19:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708026194; cv=none; b=lV/vbupdoACP9sxbf/DmpdkyfgYK2dAUnCJCapIbxIo9Vvj9nth1XktHaOZGVWg13IF6JNp382vyk3tRup+3y9yXMnoIDQQMEiuq1RenA3ShMLDjsv6fwWK8lxV1FUlz13UakG4JDF981EFhK4bvoNj6IiA6zx916fdLThmg2Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708026194; c=relaxed/simple;
	bh=SXGceVMTs48oP+XBIoPGpuzUBuzEXJJB4Wq2S9rhYMA=;
	h=Date:To:From:Subject:Message-Id; b=ZW2L+ixy6S9A6EfLgvTr6yBA9RPCws/ONK3QwnUZGSHh3PclEEotteA4c7cefD24Z8GX8PY8INbs8UF5epJzsoz5ybxXs2H2xX1pkf7Z/ezu21RCAXoQicDJczZdJus2QHQ3Qlb9+5uhVT6IKvODewjsJABC9CIEvv+MU0LwArI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aCErY/ag; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aCErY/ag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DEF7C433F1;
	Thu, 15 Feb 2024 19:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708026194;
	bh=SXGceVMTs48oP+XBIoPGpuzUBuzEXJJB4Wq2S9rhYMA=;
	h=Date:To:From:Subject:From;
	b=aCErY/agT2umZqUDNJyK/Vliv0K0Vttk36HDwPwEP5kVFgFw6Tj5uuq1LaNAsKh2h
	 halCP4MzeYEXYgL164rLUQowmNpa0Kh+ZlJMwtr4JW0Wppnau1uPIpAC8ASiiDLH5G
	 peT51yiFVWpfQ5yS72nl2g+QfL2OJvOFP9Mu4noo=
Date: Thu, 15 Feb 2024 11:43:13 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,will@kernel.org,wangkefeng.wang@huawei.com,tglx@linutronix.de,shy828301@gmail.com,ryabinin.a.a@gmail.com,mingo@redhat.com,maz@kernel.org,mark.rutland@arm.com,jhubbard@nvidia.com,james.morse@arm.com,hpa@zytor.com,david@redhat.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,ardb@kernel.org,apopple@nvidia.com,21cnbao@gmail.com,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-implement-pte_batch_hint.patch added to mm-unstable branch
Message-Id: <20240215194314.2DEF7C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64/mm: implement pte_batch_hint()
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-implement-pte_batch_hint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-implement-pte_batch_hint.patch

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
Subject: arm64/mm: implement pte_batch_hint()
Date: Thu, 15 Feb 2024 10:32:03 +0000

When core code iterates over a range of ptes and calls ptep_get() for each
of them, if the range happens to cover contpte mappings, the number of pte
reads becomes amplified by a factor of the number of PTEs in a contpte
block.  This is because for each call to ptep_get(), the implementation
must read all of the ptes in the contpte block to which it belongs to
gather the access and dirty bits.

This causes a hotspot for fork(), as well as operations that unmap memory
such as munmap(), exit and madvise(MADV_DONTNEED).  Fortunately we can fix
this by implementing pte_batch_hint() which allows their iterators to skip
getting the contpte tail ptes when gathering the batch of ptes to operate
on.  This results in the number of PTE reads returning to 1 per pte.

Link: https://lkml.kernel.org/r/20240215103205.2607016-17-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Tested-by: John Hubbard <jhubbard@nvidia.com>
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
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/include/asm/pgtable.h |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/arm64/include/asm/pgtable.h~arm64-mm-implement-pte_batch_hint
+++ a/arch/arm64/include/asm/pgtable.h
@@ -1213,6 +1213,15 @@ static inline void contpte_try_unfold(st
 		__contpte_try_unfold(mm, addr, ptep, pte);
 }
 
+#define pte_batch_hint pte_batch_hint
+static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+{
+	if (!pte_valid_cont(pte))
+		return 1;
+
+	return CONT_PTES - (((unsigned long)ptep >> 3) & (CONT_PTES - 1));
+}
+
 /*
  * The below functions constitute the public API that arm64 presents to the
  * core-mm to manipulate PTE entries within their page tables (or at least this
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

