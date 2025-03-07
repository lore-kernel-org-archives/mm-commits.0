Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5660B2F5B
	for <mm-commits@vger.kernel.org>; Fri,  7 Mar 2025 00:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741305699; cv=none; b=YzMTmf+RlDDO1eJaLn3NdUMk4QeIfghyyth+u9ORv77CzGovl36nz2MEfaCBXMCvyoktWSKmVQ3wTDvYWzY5m92wqZ7Z3dHhyDeeAKF+FsJ3U4dhYo/K/S9fJ7j8nqwxdRnvKQUm4gdJk1AOhVjQFbYyJd/WUl8MzshP5gVlSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741305699; c=relaxed/simple;
	bh=KEzHL+v7wlh9JiWJqVJZ84KqTjJbC3XIBlGiThm7jBE=;
	h=Date:To:From:Subject:Message-Id; b=fk9VGsf9Fk6YAQbxMTPmjq0CVjox04makoxujaLkK+8FIkoXKBkKlH4Gk4Z9QcJgRPcv5eiRqzIkIjd33c8dODaoqdO6jRCnnLxLfzFa92NzIAUNcDjy/CCu+KIUpkyJNfBBom+xukQfPDihF86KlVn41Id7ZtFnJWHAf2Pv+XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XsEBF4pq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XsEBF4pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE51C4CEE5;
	Fri,  7 Mar 2025 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741305698;
	bh=KEzHL+v7wlh9JiWJqVJZ84KqTjJbC3XIBlGiThm7jBE=;
	h=Date:To:From:Subject:From;
	b=XsEBF4pqsPFaHfv6ixppi5yffXAMPkyJwY2VBIhGNX5No3S72ZdmnFmITZ46WtJoF
	 lGDUitUYhOkWAVJS2UW9tdO2N1Gb161J7Gb2rrhTCaHj4hO9Q+orR9QKeJsL+VqFx9
	 0INCncrwQHt4t+mw4C2yn6KVWtg9zBG8zpOoXd5w=
Date: Thu, 06 Mar 2025 16:01:38 -0800
To: mm-commits@vger.kernel.org,muchun.song@linux.dev,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch added to mm-unstable branch
Message-Id: <20250307000138.AEE51C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: hugetlb: convert adjust_range_hwpoison() to take a folio
has been added to the -mm mm-unstable branch.  Its filename is
     hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/hugetlb-convert-adjust_range_hwpoison-to-take-a-folio.patch

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
Subject: hugetlb: convert adjust_range_hwpoison() to take a folio
Date: Wed, 26 Feb 2025 16:31:30 +0000

Remove a use of folio->page by passing the folio into
adjust_range_hwpoison().  We need to convert to a page eventually, but
that can happen inside adjust_range_hwpoison().

Link: https://lkml.kernel.org/r/20250226163131.3795869-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlb-convert-adjust_range_hwpoison-to-take-a-folio
+++ a/fs/hugetlbfs/inode.c
@@ -193,19 +193,21 @@ hugetlb_get_unmapped_area(struct file *f
 }
 
 /*
- * Someone wants to read @bytes from a HWPOISON hugetlb @page from @offset.
+ * Someone wants to read @bytes from a HWPOISON hugetlb @folio from @offset.
  * Returns the maximum number of bytes one can read without touching the 1st raw
- * HWPOISON subpage.
+ * HWPOISON page.
  *
  * The implementation borrows the iteration logic from copy_page_to_iter*.
  */
-static size_t adjust_range_hwpoison(struct page *page, size_t offset, size_t bytes)
+static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
+		size_t bytes)
 {
+	struct page *page;
 	size_t n = 0;
 	size_t res = 0;
 
-	/* First subpage to start the loop. */
-	page = nth_page(page, offset / PAGE_SIZE);
+	/* First page to start the loop. */
+	page = folio_page(folio, offset / PAGE_SIZE);
 	offset %= PAGE_SIZE;
 	while (1) {
 		if (is_raw_hwpoison_page_in_hugepage(page))
@@ -278,10 +280,10 @@ static ssize_t hugetlbfs_read_iter(struc
 			else {
 				/*
 				 * Adjust how many bytes safe to read without
-				 * touching the 1st raw HWPOISON subpage after
+				 * touching the 1st raw HWPOISON page after
 				 * offset.
 				 */
-				want = adjust_range_hwpoison(&folio->page, offset, nr);
+				want = adjust_range_hwpoison(folio, offset, nr);
 				if (want == 0) {
 					folio_put(folio);
 					retval = -EIO;
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

