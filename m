Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C95A2145348
	for <mm-commits@vger.kernel.org>; Tue, 23 Dec 2025 18:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766514335; cv=none; b=SSor+zYljLV32ci362PAeaJeiz3BgkU2kqwtFuzDdRUQukeVy086hJ8PkNqlOwvOyV61eR1mqP9sKasyznI8uJq48HtXpiv8qSOR/fqmkMbapk8+eJ35FawMr641cln+J6eYHa1apOw/3S+WZh6GUYOgGMNstZw/n0ZlLMW5lLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766514335; c=relaxed/simple;
	bh=m+FLaDmqs56A5PdK8DjkzXzu6uldq/n0DIX0YjNHWm4=;
	h=Date:To:From:Subject:Message-Id; b=S1ksmqLnttZ/cNQx1XLBczOOkt7NpwnatH/40upOkj5kpDhHfUBizH1+MtSEKfD7bkEIv4TJwnagQ5c3gpWe22bBpf4CkZrXTLrIp02bknufHHuMu8Hjb6oLhDO8Ye+7IwEgpGjtgqN7rwVk28n2rVzZ36P0lDHJzFIrgJEoP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gljx/Q7Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gljx/Q7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785C8C113D0;
	Tue, 23 Dec 2025 18:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766514335;
	bh=m+FLaDmqs56A5PdK8DjkzXzu6uldq/n0DIX0YjNHWm4=;
	h=Date:To:From:Subject:From;
	b=gljx/Q7Y8+RtYGke6TJeGERd5i+K/hdhvWVGCaky+/opIS378ehmVA30eL1W76vYv
	 NzO/o/KeuolnIU88744Ti1/7sKmkVYdNVuVjgUQo5JSGojnq0ztrEUNz19nuOGk4fQ
	 MvH/50et+cyZqwWaDLYJceNv82RXzdU91hblS3B4=
Date: Tue, 23 Dec 2025 10:25:34 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch added to mm-new branch
Message-Id: <20251223182535.785C8C113D0@smtp.kernel.org>
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
Date: Tue, 23 Dec 2025 13:48:36 +0800

Factor out the contpte block's address and ptep alignment into a new
helper, and will be reused in the following patch.

No functional changes.

Link: https://lkml.kernel.org/r/47e29030347c23ffce238ff5ed752da01a8cc7cb.1766455378.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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
Cc: Ryan Roberts <ryan.roberts@arm.com>
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

