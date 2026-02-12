Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0702DB7A6
	for <mm-commits@vger.kernel.org>; Thu, 12 Feb 2026 23:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770939860; cv=none; b=khmrQ4rXB6LNNQjkI3aIi9nnq0V88N6WCpfs9jucnWlrY076uzBv31AFbfxbmLdeqBmueXdTCEaaYof4aRS6r2/LTgq5KKoTOUXGD5wh2nRkO1867XTaSvbiXT60r3vVxuL6+5nvB2kdzugivoz1uKo5unNTfxIldyRWpzcbRiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770939860; c=relaxed/simple;
	bh=CqnInK114P9Fn85LVHbas/CCHV0SZO12XPTp2iuFxoo=;
	h=Date:To:From:Subject:Message-Id; b=QLiipFNrPlaDCo5uH1delQ4D+voyNORssPkIUeEmYchFMzBsryF+BTwWfBhhwNYffZzd7nqY86DhzEUJc47UaYzPbo5Pxza1vJIe/DRz3OmLHwosOfCzYDr/1jIdqk2uRj51TTXJDvlTHkVSAutEhprfCRUTJS8DbMOuPzRHEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tewxo8el; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tewxo8el"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689C8C4CEF7;
	Thu, 12 Feb 2026 23:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770939860;
	bh=CqnInK114P9Fn85LVHbas/CCHV0SZO12XPTp2iuFxoo=;
	h=Date:To:From:Subject:From;
	b=tewxo8elTDRQlJTnQ0axfaTeuQMMDHuwMBsU23Bzo99McMucObnDzxA1ajTmMnt8J
	 EaN9WoBiYD2pL1DbJkBpxaQcn5aGTek4gyo09oDglUvgygoEH76RFaWYNrBNPbQzGy
	 F2TvVb+RX+OY19yOX0k6VOhLG6DC6isga4mTsicw=
Date: Thu, 12 Feb 2026 15:44:19 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,will@kernel.org,vbabka@suse.cz,surenb@google.com,ryan.roberts@arm.com,rppt@kernel.org,riel@surriel.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jannh@google.com,harry.yoo@oracle.com,david@kernel.org,catalin.marinas@arm.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch removed from -mm tree
Message-Id: <20260212234420.689C8C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: factor out the address and ptep alignment into a new helper
has been removed from the -mm tree.  Its filename was
     arm64-mm-factor-out-the-address-and-ptep-alignment-into-a-new-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


