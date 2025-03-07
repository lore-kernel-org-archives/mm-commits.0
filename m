Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86A7383
	for <mm-commits@vger.kernel.org>; Fri,  7 Mar 2025 00:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305698; cv=none; b=nSQWY34+Cl4qQ023qy2SvdsZEFNNW1gBp5b2TREIbrjOK4lzf5DQFv5etmotOjqsGfXOmlzz/A6n2aYjslPyAXZVaUVSCCZ93WEy640GebwFsmxU+Bk1mvNqkthsFTBo1NHgKPa9jBHZkOdcwlL3Hfa3Ddz1G7/51PMMeGVv66A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305698; c=relaxed/simple;
	bh=OKNJw2QYjKFCC90mAeVSw3zoyHm5XZvjONXgKstbR9k=;
	h=Date:To:From:Subject:Message-Id; b=J7GBevVMAHHJVFusaXf783MzuPdXkpdVswP7K/VoS+p0s7RdcbJaz0ZOTaH12v9j1FlHRajFeu2jycaVwkpLKeXtJbXoAvr9Z/Qq5JHdTG+5PyLJqa+kYlrXaBRU3b/CKdT4FvtjHjtF+yMvh7WPuAWZnOKy6fZGav7N1eINf0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CwM01LdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CwM01LdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B9C4CEE0;
	Fri,  7 Mar 2025 00:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741305697;
	bh=OKNJw2QYjKFCC90mAeVSw3zoyHm5XZvjONXgKstbR9k=;
	h=Date:To:From:Subject:From;
	b=CwM01LdIcrdnFlYnv2p3UZllBd4xa2t9rpLFDpzFQ3OzJCIhzeg47yGs9G9z00Qt5
	 7Vc0AzUmvTF7EMfLuYTvW4+5d1rVTN2mhhazHPA30Y+OjaGNsqtR1uUugPi2m+rV0y
	 tge7NTuNn9NzPC3btPCfp2DGOK/TOxiTOdt7IGb0=
Date: Thu, 06 Mar 2025 16:01:36 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch added to mm-unstable branch
Message-Id: <20250307000137.811B9C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: convert hugetlb_vma_maps_page() to hugetlb_vma_maps_pfn()
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch

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

dax-remove-access-to-page-index.patch
dax-use-folios-more-widely-within-dax.patch
fs-convert-block_commit_write-to-take-a-folio.patch
fs-remove-page_file_mapping.patch
fs-remove-folio_file_mapping.patch
mm-assert-the-folio-is-locked-in-folio_start_writeback.patch
hugetlb-convert-hugetlb_vma_maps_page-to-hugetlb_vma_maps_pfn.patch
hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch
ocfs2-use-memcpy_to_folio-in-ocfs2_symlink_get_block.patch
ocfs2-remove-reference-to-bh-b_page.patch

