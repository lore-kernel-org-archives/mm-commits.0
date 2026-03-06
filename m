Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3F436923F;
	Fri,  6 Mar 2026 17:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772816563; cv=none; b=egM0SUcNKbUbtErxNMEnt8lL3jA5JpTMR3c8I7TAnmZ1u+hB2IvPSOY0ULCQbIYikfpKmTSodZN5tzJssjUeL36mgQi/eTDM4Sf3NclTM46hfXu1kzm09D9eJzkzLdG8gJDn9JluqRjTSFAmBFly6CanzalOPRIeqSNnUBjQ990=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772816563; c=relaxed/simple;
	bh=J6IzFKD6GzJ1sKo0/UCXXuBIkAgin/TdtGtxv07nNU8=;
	h=Date:To:From:Subject:Message-Id; b=KbTsyzHjtV0EJT/z+ckJmWyk4witIsnFnMxXwBXIBJwqweytTxysrJ51X3V4wj7PXEA39JM9K3Q0U6AA7pah20JMvpXHobZ8s31O5/mDNthkY0OKIWm1Jk0sF5jM0oRBxmYxXC0Q5YyLdvgYt/vIOVE34lNmbLiJDE4oImvySG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=wHtN9gec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="wHtN9gec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38420C4CEF7;
	Fri,  6 Mar 2026 17:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772816563;
	bh=J6IzFKD6GzJ1sKo0/UCXXuBIkAgin/TdtGtxv07nNU8=;
	h=Date:To:From:Subject:From;
	b=wHtN9gecCa929VB50jGkIvs3udEw4K5Ufci+JwJnGV/RHB6pwwT3lQpPHp8cJcPVm
	 0+CemrqQD0N4SjrbMXrTNn7cpSfakUwlzj0ZkuPAsykA+04x6OBFH5d4o2xORFderz
	 sv7ML+LbNWZFZCnqQzAYoiis4CNIbYipO9W3FxgE=
Date: Fri, 06 Mar 2026 09:02:42 -0800
To: mm-commits@vger.kernel.org,ziy@nvidia.com,will@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,leitao@debian.org,jthoughton@google.com,jhubbard@nvidia.com,jgg@nvidia.com,catalin.marinas@arm.com,balbirs@nvidia.com,apopple@nvidia.com,pjaroszynski@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch removed from -mm tree
Message-Id: <20260306170243.38420C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: contpte: fix set_access_flags() no-op check for SMMU/ATS faults
has been removed from the -mm tree.  Its filename was
     arm64-contpte-fix-set_access_flags-no-op-check-for-smmu-ats-faults.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


