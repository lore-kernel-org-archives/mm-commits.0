Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCC91C5F1F
	for <mm-commits@vger.kernel.org>; Tue, 18 Mar 2025 05:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742274615; cv=none; b=k+OHzjYN40cj0xgKDSkGYr8Y1Ql62+wR69f8xd/cbC++3k9CDgoUNtS+os8F2s06QaVW9LOBFnCdTGLllbtPBpU6iV6tEvPSnvEzgDmRXUzLFNApagkkpanBP3rH5fl30C4zcggbq+2EnZdz1tzu7iM59pxk1cQ6RBm3JYUku1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742274615; c=relaxed/simple;
	bh=pDkF3+6fj1Th+FjOUjwN/omNbJbiiHs9qw5mUbCPRZI=;
	h=Date:To:From:Subject:Message-Id; b=SGLFIHUoHhltvZSBuRwRM/a8BWVGsVudU856mOjYzpw4XTvDXcaAV2QWlLlOh5bXqe6ulUBWeNUraqyA4BfUfoLBRbB23tinXtd7h9h9oIiHnyIT2N+se3x1xb+eaGHUkAuabJE/mYb/qyBbwtQniYjR7ZCJPO8pQqKMqjuvc4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NOujhhrf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NOujhhrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BF5C4CEDD;
	Tue, 18 Mar 2025 05:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742274615;
	bh=pDkF3+6fj1Th+FjOUjwN/omNbJbiiHs9qw5mUbCPRZI=;
	h=Date:To:From:Subject:From;
	b=NOujhhrfdZX0+cCMVD+nkSEo7TxGsknQ0aRtumc9If8mt33CcOLTlQMLVpbzm/jTQ
	 1iFepWBwLY91WPV64NeZ9dZArZjiS2r7nDd4WZ0Y8R9a7F1U4gEweoCE0zwuCugPHT
	 2S505cyjXN83stdusbrXXksymx7S+GBdgbNy+pV0=
Date: Mon, 17 Mar 2025 22:10:15 -0700
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch removed from -mm tree
Message-Id: <20250318051015.A6BF5C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hugetlb: convert hugetlb_vma_maps_page() to hugetlb_vma_maps_pfn()
has been removed from the -mm tree.  Its filename was
     hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hugetlb: convert hugetlb_vma_maps_page() to hugetlb_vma_maps_pfn()
Date: Wed, 26 Feb 2025 16:31:29 +0000

pte_page() is more expensive than pte_pfn() (often it's defined as
pfn_to_page(pte_pfn())), so it makes sense to do the conversion to pfn
once (by calling folio_pfn()) rather than convert the pfn to a page each
time.

While this is a very small advantage, the main motivation is removing a
reference to folio->page.

Link: https://lkml.kernel.org/r/20250226163131.3795869-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn
+++ a/fs/hugetlbfs/inode.c
@@ -338,8 +338,8 @@ static void hugetlb_delete_from_page_cac
  * mutex for the page in the mapping.  So, we can not race with page being
  * faulted into the vma.
  */
-static bool hugetlb_vma_maps_page(struct vm_area_struct *vma,
-				unsigned long addr, struct page *page)
+static bool hugetlb_vma_maps_pfn(struct vm_area_struct *vma,
+				unsigned long addr, unsigned long pfn)
 {
 	pte_t *ptep, pte;
 
@@ -351,7 +351,7 @@ static bool hugetlb_vma_maps_page(struct
 	if (huge_pte_none(pte) || !pte_present(pte))
 		return false;
 
-	if (pte_page(pte) == page)
+	if (pte_pfn(pte) == pfn)
 		return true;
 
 	return false;
@@ -396,7 +396,7 @@ static void hugetlb_unmap_file_folio(str
 {
 	struct rb_root_cached *root = &mapping->i_mmap;
 	struct hugetlb_vma_lock *vma_lock;
-	struct page *page = &folio->page;
+	unsigned long pfn = folio_pfn(folio);
 	struct vm_area_struct *vma;
 	unsigned long v_start;
 	unsigned long v_end;
@@ -412,7 +412,7 @@ retry:
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
 
-		if (!hugetlb_vma_maps_page(vma, v_start, page))
+		if (!hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			continue;
 
 		if (!hugetlb_vma_trylock_write(vma)) {
@@ -462,7 +462,7 @@ retry:
 		 */
 		v_start = vma_offset_start(vma, start);
 		v_end = vma_offset_end(vma, end);
-		if (hugetlb_vma_maps_page(vma, v_start, page))
+		if (hugetlb_vma_maps_pfn(vma, v_start, pfn))
 			unmap_hugepage_range(vma, v_start, v_end, NULL,
 					     ZAP_FLAG_DROP_MARKER);
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-separate-folio_split_memcg_refs-from-split_page_memcg.patch
mm-simplify-split_page_memcg.patch
mm-remove-references-to-folio-in-split_page_memcg.patch
mm-simplify-folio_memcg_charged.patch
mm-remove-references-to-folio-in-__memcg_kmem_uncharge_page.patch

