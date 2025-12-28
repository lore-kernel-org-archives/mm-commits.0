Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCCE26FD93
	for <mm-commits@vger.kernel.org>; Sun, 28 Dec 2025 20:03:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766952181; cv=none; b=f6yPqdvqWEPg4FXHBcm/D/8iKdFO2/UKZzB8QUGPInN5Qwp1+cGQ4uUC9PlMJcXijH/i8cmnTyeZnHIsBvw6lISODxd/lt9erCN19TfzD7OSTyXRETYDaW8ivq56cmPeB+DYBo3Nq5dZDQWNn2CkPYuh4b6LV4V71tlbs6GcvZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766952181; c=relaxed/simple;
	bh=jchhXSukMg/tBAq649WFhScupnLZBG7iLKsBTinP0SA=;
	h=Date:To:From:Subject:Message-Id; b=klNE9tmkrQ38Ow17/N2uFFLQvucc+1PPz6N4VINMmH6M5zQDc2usdlHqrXuJyklZoImaYr9nd4PTudjsy90pAzWWxX8v3ajaJSWS2QI/4tYuubS1s3fjwotuDLICUqjb36NhZk51OTzKvOisjVOYu1Np+YpOySkAqYUay9fPi1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=fmNdIH1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fmNdIH1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6CAC4CEFB;
	Sun, 28 Dec 2025 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766952181;
	bh=jchhXSukMg/tBAq649WFhScupnLZBG7iLKsBTinP0SA=;
	h=Date:To:From:Subject:From;
	b=fmNdIH1sQ83zVBu56J2UkpM21lBcprZE/m5Dud3xzndCsdURb7gLDAtyU6cICzJys
	 SUHpLnH84W/YKwP6/sTvt34lewXpw1I1pr//IRw5xWWxdGIYYq/7EROcj17zkLl/C3
	 XbiFT172fbbpd53ajCdJcY7IRzsBjE57ftd4QH04=
Date: Sun, 28 Dec 2025 12:03:00 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch added to mm-new branch
Message-Id: <20251228200301.7E6CAC4CEFB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: factor out the address and ptep alignment into a new helper
has been added to the -mm mm-new branch.  Its filename is
     arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64: mm: factor out the address and ptep alignment into a new helper
Date: Fri, 26 Dec 2025 14:07:56 +0800

Factor out the contpte block's address and ptep alignment into a new
helper, and will be reused in the following patch.

No functional changes.

Link: https://lkml.kernel.org/r/70499ea05beb23fe386b3d4423249a817cec17d4.1766631066.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/contpte.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/arch/arm64/mm/contpte.c~arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper
+++ a/arch/arm64/mm/contpte.c
@@ -26,6 +26,26 @@ static inline pte_t *contpte_align_down(
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
+static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
+					     unsigned long *end, pte_t *ptep,
+					     unsigned int nr)
+{
+	/*
+	 * Note: caller must ensure these nr PTEs are consecutive (present)
+	 * PTEs that map consecutive pages of the same large folio within a
+	 * single VMA and a single page table.
+	 */
+	if (pte_cont(__ptep_get(ptep + nr - 1)))
+		*end = ALIGN(*end, CONT_PTE_SIZE);
+
+	if (pte_cont(__ptep_get(ptep))) {
+		*start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
+		ptep = contpte_align_down(ptep);
+	}
+
+	return ptep;
+}
+
 static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
 {
@@ -569,14 +589,7 @@ void contpte_clear_young_dirty_ptes(stru
 	unsigned long start = addr;
 	unsigned long end = start + nr * PAGE_SIZE;
 
-	if (pte_cont(__ptep_get(ptep + nr - 1)))
-		end = ALIGN(end, CONT_PTE_SIZE);
-
-	if (pte_cont(__ptep_get(ptep))) {
-		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
-		ptep = contpte_align_down(ptep);
-	}
-
+	ptep = contpte_align_addr_ptep(&start, &end, ptep, nr);
 	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-rmap-support-batched-checks-of-the-references-for-large-folios.patch
arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch
arm64-mm-support-batch-clearing-of-the-young-flag-for-large-folios.patch
arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes.patch
mm-rmap-support-batched-unmapping-for-file-large-folios.patch

