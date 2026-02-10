Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C0F35898
	for <mm-commits@vger.kernel.org>; Tue, 10 Feb 2026 01:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770688427; cv=none; b=TmQdgnHf0PoeeU9/5pDkqNIbfDBs21Le5u+91PTVGyRi/nydqK8qhX8eO5lodckKYSBnIDM8c/XSwAoklulHto2KHHd5x3QT20zT2/aJU38KO0icE09gNL43BxQFsBRQl8C4quJ/DkaSDyoruI1eeVW8BYjPsZjDo5v5lY1H/Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770688427; c=relaxed/simple;
	bh=78KQNh5vzdDSLW9Oxio2B5shyJNaCrTn7j6fsXQHV4s=;
	h=Date:To:From:Subject:Message-Id; b=gezxjKvizaODDqVHzehYjz65DHkUykc7QfFCiP6rIE/Y/GDTzzCQXh8Re0E6Xe53oS2Foonctzew7Bk+7kKdgWRz5+438PMuBUaIjR0GKzIKuV4r1Swn0dD5DxVp093810byNyKGn3iudVqz9/MLXbudtgf6Xl/oe/YhT4sHnek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FFE3HxFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FFE3HxFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2AEC116C6;
	Tue, 10 Feb 2026 01:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770688427;
	bh=78KQNh5vzdDSLW9Oxio2B5shyJNaCrTn7j6fsXQHV4s=;
	h=Date:To:From:Subject:From;
	b=FFE3HxFiRTFovvbdqOmmrxrvbDo0C/1P2nCJ0mTzd92hC1u5IlcQr7ECkpF4V3uGu
	 zTQoymAA2Icyf9/rNhs3pjqG11dB9A1hxz1zWjsH63Mtb8ArI/SB7Bts3i7Z0TBAox
	 PfCjZhU4I/pSYrZH886EHWdVgt0HvCoT1J1mePBI=
Date: Mon, 09 Feb 2026 17:53:47 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch added to mm-unstable branch
Message-Id: <20260210015347.8F2AEC116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: factor out the address and ptep alignment into a new helper
has been added to the -mm mm-unstable branch.  Its filename is
     arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch

This patch will later appear in the mm-unstable branch at
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: arm64: mm: factor out the address and ptep alignment into a new helper
Date: Mon, 9 Feb 2026 22:07:25 +0800

Factor out the contpte block's address and ptep alignment into a new
helper, and will be reused in the following patch.

No functional changes.

Link: https://lkml.kernel.org/r/8076d12cb244b2d9e91119b44dc6d5e4ad9c00af.1770645603.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
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

