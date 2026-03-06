Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95E2314B8F;
	Fri,  6 Mar 2026 01:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772759948; cv=none; b=gMGA9E+VrbFe4pdxs5mT3x0eYF/JeV6RqfZuYdSLNhUTj05S3w9zQEzuLEsBHBObdasgSP/ugrl9LlK8kCEdNtDRc3c4JJqdE+Q0qBs/2JEC9Ohi3788OL6szsuRt9ff+a5zaW9Qh22258RVXAW3Nr6GiduF/ClvUB2jpKkqzWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772759948; c=relaxed/simple;
	bh=YqBF38cmNK/9MVBLp+TYA6nIrdV8FmaVsAGE2Wbuhkg=;
	h=Date:To:From:Subject:Message-Id; b=b1LHw87c7iPROe7omhwAZaqQf+OoJ558BKPJ2DK7QzDI9pRgu2DuO4ikiAx42jbeX/GPydpKzBahDhXnBPUCnYqCuQ70sGFvmrKVE/2YECNV6mKuiwxDWF/daudC33QnvACLigi/eGr+sejKnQzMno2WrMrTCBtZ2KoE1Fy+6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sKGaqcIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sKGaqcIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67CE4C116C6;
	Fri,  6 Mar 2026 01:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772759947;
	bh=YqBF38cmNK/9MVBLp+TYA6nIrdV8FmaVsAGE2Wbuhkg=;
	h=Date:To:From:Subject:From;
	b=sKGaqcIRO5MfmIx4CDHj6kxYs7B40J9Z9auGvvPQlQA7FUHeRFm58Zf+o5vdJMb4k
	 XBbBtbtkc6ZNs1DpZBEgTK+o8uWeXY/kB2GeClOWZHddfKdKushq0wJ+9X1hv33y+s
	 s0qRc3hsGF8u/fVhq5N5xj+pxgPuQuIVR65CJK8A=
Date: Thu, 05 Mar 2026 17:19:06 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,leitao@debian.org,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,catalin.marinas@arm.com,apopple@nvidia.com,pjaroszynski@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch added to mm-hotfixes-unstable branch
Message-Id: <20260306011907.67CE4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Subject: arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
Date: Thu, 05 Mar 2026 15:26:29 -0800

contpte_ptep_set_access_flags() compared the gathered ptep_get() value
against the requested entry to detect no-ops.  ptep_get() ORs AF/dirty
from all sub-PTEs in the CONT block, so a dirty sibling can make the
target appear already-dirty.  When the gathered value matches entry, the
function returns 0 even though the target sub-PTE still has PTE_RDONLY set
in hardware.

For a CPU with FEAT_HAFDBS this gathered view is fine, since hardware may
set AF/dirty on any sub-PTE and CPU TLB behavior is effectively gathered
across the CONT range.  But page-table walkers that evaluate each
descriptor individually (e.g.  a CPU without DBM support, or an SMMU
without HTTU, or with HA/HD disabled in CD.TCR) can keep faulting on the
unchanged target sub-PTE, causing an infinite fault loop.

Gathering can therefore cause false no-ops when only a sibling has been
updated:
 - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
 - read faults:  target still lacks PTE_AF

Fix by checking each sub-PTE against the requested AF/dirty/write state
(the same bits consumed by __ptep_set_access_flags()), using raw per-PTE
values rather than the gathered ptep_get() view, before returning no-op. 
Keep using the raw target PTE for the write-bit unfold decision.

Per Arm ARM (DDI 0487) D8.7.1 ("The Contiguous bit"), any sub-PTE in a
CONT range may become the effective cached translation and software must
maintain consistent attributes across the range.

Link: https://lkml.kernel.org/r/20260305-contpte-fault-loop-v2-1-0216f0026d7f@nvidia.com
Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: James Houghton <jthoughton@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Breno Leitao <leitao@debian.org>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   53 +++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 4 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults
+++ a/arch/arm64/mm/contpte.c
@@ -599,6 +599,27 @@ void contpte_clear_young_dirty_ptes(stru
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
+static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
+{
+	pte_t *cont_ptep = contpte_align_down(ptep);
+	/*
+	 * PFNs differ per sub-PTE. Match only bits consumed by
+	 * __ptep_set_access_flags(): AF, DIRTY and write permission.
+	 */
+	const pteval_t cmp_mask = PTE_RDONLY | PTE_AF | PTE_WRITE | PTE_DIRTY;
+	pteval_t entry_cmp = pte_val(entry) & cmp_mask;
+	int i;
+
+	for (i = 0; i < CONT_PTES; i++) {
+		pteval_t pte_cmp = pte_val(__ptep_get(cont_ptep + i)) & cmp_mask;
+
+		if (pte_cmp != entry_cmp)
+			return false;
+	}
+
+	return true;
+}
+
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
 					unsigned long addr, pte_t *ptep,
 					pte_t entry, int dirty)
@@ -608,14 +629,38 @@ int contpte_ptep_set_access_flags(struct
 	int i;
 
 	/*
-	 * Gather the access/dirty bits for the contiguous range. If nothing has
-	 * changed, its a noop.
+	 * Check whether all sub-PTEs in the CONT block already match the
+	 * requested access flags/write permission, using raw per-PTE values
+	 * rather than the gathered ptep_get() view.
+	 *
+	 * __ptep_set_access_flags() can update AF, dirty and write
+	 * permission, but only to make the mapping more permissive.
+	 *
+	 * ptep_get() gathers AF/dirty state across the whole CONT block,
+	 * which is correct for a CPU with FEAT_HAFDBS. But page-table
+	 * walkers that evaluate each descriptor individually (e.g. a CPU
+	 * without DBM support, or an SMMU without HTTU, or with HA/HD
+	 * disabled in CD.TCR) can keep faulting on the target sub-PTE if
+	 * only a sibling has been updated. Gathering can therefore cause
+	 * false no-ops when only a sibling has been updated:
+	 *  - write faults: target still has PTE_RDONLY (needs PTE_RDONLY cleared)
+	 *  - read faults:  target still lacks PTE_AF
+	 *
+	 * Per Arm ARM (DDI 0487) D8.7.1, any sub-PTE in a CONT range may
+	 * become the effective cached translation, so all entries must have
+	 * consistent attributes. Check the full CONT block before returning
+	 * no-op, and when any sub-PTE mismatches, proceed to update the whole
+	 * range.
 	 */
-	orig_pte = pte_mknoncont(ptep_get(ptep));
-	if (pte_val(orig_pte) == pte_val(entry))
+	if (contpte_all_subptes_match_access_flags(ptep, entry))
 		return 0;
 
 	/*
+	 * Use raw target pte (not gathered) for write-bit unfold decision.
+	 */
+	orig_pte = pte_mknoncont(__ptep_get(ptep));
+
+	/*
 	 * We can fix up access/dirty bits without having to unfold the contig
 	 * range. But if the write bit is changing, we must unfold.
 	 */
_

Patches currently in -mm which might be from pjaroszynski@nvidia.com are

arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch

