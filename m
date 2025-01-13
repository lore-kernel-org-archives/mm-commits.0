Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600DF25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742247; cv=none; b=Hgsauedco6yOG0ZeXnZ1xUt//DAP3tpgOjE9cIoqMgQDUK7a3/nW9lDnTQkZxaL4QTj7Jl/OitUWt0vkmJsD8LU6epn7KlWTmMF3F+7QuD7/EOEMfuV+Ue4HYRnQWHE0u3JfrU0VQ4h9VdJfSuxLIJvjPJSYQzbV7rZVXTp2JFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742247; c=relaxed/simple;
	bh=Ab+/6cYTsZXkd1FdkuTzH6sevd26vdq6AQK6u7aEcnU=;
	h=Date:To:From:Subject:Message-Id; b=PQPycu+y25P2w0EsAmirR341pndJVdAyiNdkwtpsjCjd2OMGKL9dpPuNVO583tOaa96cxaamcCJwNlruLCriKc/p8SQUQMdyEJTVwMxdftDvNCXr+E7C0cnAV4apbc3VqPcVRSRjGLJyfOkQYCOMQpxsEJhjmFpuP4M4s2ZS+wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ob1ivIQF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ob1ivIQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F06FC4CED6;
	Mon, 13 Jan 2025 04:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742247;
	bh=Ab+/6cYTsZXkd1FdkuTzH6sevd26vdq6AQK6u7aEcnU=;
	h=Date:To:From:Subject:From;
	b=ob1ivIQFzxIeshZFhZZ0gfYVnsr/V4nI33Puc/ZXraZbzaIe237eGOtJd1WKpYS75
	 WezSRDlHy9xLJw8zcMvOL+ZIexHvLmt7JenCwt8PXAYFYyp5noWzDz5SGqIvI5kYVS
	 FZu66229I7KTWFQagYZlvm3/WMBAR815NfqSmTdY=
Date: Sun, 12 Jan 2025 20:24:06 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-use-a-folio-throughout-squashfs_read_folio.patch removed from -mm tree
Message-Id: <20250113042407.2F06FC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: use a folio throughout squashfs_read_folio()
has been removed from the -mm tree.  Its filename was
     squashfs-use-a-folio-throughout-squashfs_read_folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: use a folio throughout squashfs_read_folio()
Date: Fri, 20 Dec 2024 22:46:24 +0000

Use modern folio APIs where they exist and convert back to struct
page for the internal functions.

Link: https://lkml.kernel.org/r/20241220224634.723899-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

--- a/fs/squashfs/file.c~squashfs-use-a-folio-throughout-squashfs_read_folio
+++ a/fs/squashfs/file.c
@@ -445,21 +445,19 @@ static int squashfs_readpage_sparse(stru
 
 static int squashfs_read_folio(struct file *file, struct folio *folio)
 {
-	struct page *page = &folio->page;
-	struct inode *inode = page->mapping->host;
+	struct inode *inode = folio->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int index = page->index >> (msblk->block_log - PAGE_SHIFT);
+	int index = folio->index >> (msblk->block_log - PAGE_SHIFT);
 	int file_end = i_size_read(inode) >> msblk->block_log;
 	int expected = index == file_end ?
 			(i_size_read(inode) & (msblk->block_size - 1)) :
 			 msblk->block_size;
 	int res = 0;
-	void *pageaddr;
 
 	TRACE("Entered squashfs_readpage, page index %lx, start block %llx\n",
-				page->index, squashfs_i(inode)->start);
+				folio->index, squashfs_i(inode)->start);
 
-	if (page->index >= ((i_size_read(inode) + PAGE_SIZE - 1) >>
+	if (folio->index >= ((i_size_read(inode) + PAGE_SIZE - 1) >>
 					PAGE_SHIFT))
 		goto out;
 
@@ -472,23 +470,18 @@ static int squashfs_read_folio(struct fi
 			goto out;
 
 		if (res == 0)
-			res = squashfs_readpage_sparse(page, expected);
+			res = squashfs_readpage_sparse(&folio->page, expected);
 		else
-			res = squashfs_readpage_block(page, block, res, expected);
+			res = squashfs_readpage_block(&folio->page, block, res, expected);
 	} else
-		res = squashfs_readpage_fragment(page, expected);
+		res = squashfs_readpage_fragment(&folio->page, expected);
 
 	if (!res)
 		return 0;
 
 out:
-	pageaddr = kmap_atomic(page);
-	memset(pageaddr, 0, PAGE_SIZE);
-	kunmap_atomic(pageaddr);
-	flush_dcache_page(page);
-	if (res == 0)
-		SetPageUptodate(page);
-	unlock_page(page);
+	folio_zero_segment(folio, 0, folio_size(folio));
+	folio_end_read(folio, res == 0);
 
 	return res;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-page_alloc-cache-page_zone-result-in-free_unref_page.patch
mm-make-alloc_pages_mpol-static.patch
mm-page_alloc-export-free_frozen_pages-instead-of-free_unref_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-post_alloc_hook.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-prep_new_page.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-get_page_from_freelist.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_cpuset_fallback.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_may_oom.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_compact.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_direct_reclaim.patch
mm-page_alloc-move-set_page_refcounted-to-callers-of-__alloc_pages_slowpath.patch
mm-page_alloc-move-set_page_refcounted-to-end-of-__alloc_pages.patch
mm-page_alloc-add-__alloc_frozen_pages.patch
mm-mempolicy-add-alloc_frozen_pages.patch
slab-allocate-frozen-pages.patch
mm-remove-pagetranstail.patch

