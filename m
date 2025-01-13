Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791F325761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742249; cv=none; b=oEKVjtlvc2dDHiO7g0eLJcgfe4xx7ahy7qJIS1GaQE2C3JeJBl1BvzuSTZpqZrEHlRNJJrnMwFR6VVVvMIYjWrcVLs3bWIuU/3XLG7n8nHa2J8wdfhRChLBzK5LfIkRMSeGUlnDkK0CNoWJ96sECi6IklJbUDNsOfk2V4sDQi0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742249; c=relaxed/simple;
	bh=d8M4XAkHIxhjI1sN9y9CJYM8HT9K+7OOnUucCclODBM=;
	h=Date:To:From:Subject:Message-Id; b=OmKna24gexhR1IVVYFVrS09UL41IJkYcHzrxTcMsaBZFCPSHSp18YEXY8um7i5QyybSami1glc8lPp+0JlA7RzT0ZuqC5iaAmdSAUQlhFP78q6jp60BI1lQpbZBrYwS7KXlNirWZeOytmz8qBU5S9+q46o9IQJO8WtLqYOv0Bd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0qBZfWYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0qBZfWYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E497C4CEE2;
	Mon, 13 Jan 2025 04:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742249;
	bh=d8M4XAkHIxhjI1sN9y9CJYM8HT9K+7OOnUucCclODBM=;
	h=Date:To:From:Subject:From;
	b=0qBZfWYngswY7NFcLXgD0Uv7+HCSyO6bsLLn9wcQE54aQLVHi4hDdcvyJVWizmcxI
	 FZFBWtNNPy7Xzu0IgmJfoMoy7nVTjBQk+4vkQJGXTsxC4LPMYMo20tuGetKr/xWSCS
	 RTDaKnyJ/FzYYetbp/hDpH134FU8oS4hBlEJIpWc=
Date: Sun, 12 Jan 2025 20:24:08 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch removed from -mm tree
Message-Id: <20250113042409.4E497C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: convert squashfs_readpage_block() to take a folio
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: squashfs: convert squashfs_readpage_block() to take a folio
Date: Fri, 20 Dec 2024 22:46:26 +0000

Remove a few accesses to page->mapping.

Link: https://lkml.kernel.org/r/20241220224634.723899-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |    2 +-
 fs/squashfs/file_cache.c  |    6 +++---
 fs/squashfs/file_direct.c |   11 +++++------
 fs/squashfs/squashfs.h    |    2 +-
 4 files changed, 10 insertions(+), 11 deletions(-)

--- a/fs/squashfs/file.c~squashfs-convert-squashfs_readpage_block-to-take-a-folio
+++ a/fs/squashfs/file.c
@@ -472,7 +472,7 @@ static int squashfs_read_folio(struct fi
 		if (res == 0)
 			res = squashfs_readpage_sparse(&folio->page, expected);
 		else
-			res = squashfs_readpage_block(&folio->page, block, res, expected);
+			res = squashfs_readpage_block(folio, block, res, expected);
 	} else
 		res = squashfs_readpage_fragment(folio, expected);
 
--- a/fs/squashfs/file_cache.c~squashfs-convert-squashfs_readpage_block-to-take-a-folio
+++ a/fs/squashfs/file_cache.c
@@ -18,9 +18,9 @@
 #include "squashfs.h"
 
 /* Read separately compressed datablock and memcopy into page cache */
-int squashfs_readpage_block(struct page *page, u64 block, int bsize, int expected)
+int squashfs_readpage_block(struct folio *folio, u64 block, int bsize, int expected)
 {
-	struct inode *i = page->mapping->host;
+	struct inode *i = folio->mapping->host;
 	struct squashfs_cache_entry *buffer = squashfs_get_datablock(i->i_sb,
 		block, bsize);
 	int res = buffer->error;
@@ -29,7 +29,7 @@ int squashfs_readpage_block(struct page
 		ERROR("Unable to read page, block %llx, size %x\n", block,
 			bsize);
 	else
-		squashfs_copy_cache(page, buffer, expected, 0);
+		squashfs_copy_cache(&folio->page, buffer, expected, 0);
 
 	squashfs_cache_put(buffer);
 	return res;
--- a/fs/squashfs/file_direct.c~squashfs-convert-squashfs_readpage_block-to-take-a-folio
+++ a/fs/squashfs/file_direct.c
@@ -19,12 +19,11 @@
 #include "page_actor.h"
 
 /* Read separately compressed datablock directly into page cache */
-int squashfs_readpage_block(struct page *target_page, u64 block, int bsize,
-	int expected)
-
+int squashfs_readpage_block(struct folio *folio, u64 block, int bsize,
+		int expected)
 {
-	struct folio *folio = page_folio(target_page);
-	struct inode *inode = target_page->mapping->host;
+	struct page *target_page = &folio->page;
+	struct inode *inode = folio->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
@@ -48,7 +47,7 @@ int squashfs_readpage_block(struct page
 	/* Try to grab all the pages covered by the Squashfs block */
 	for (i = 0, index = start_index; index <= end_index; index++) {
 		page[i] = (index == folio->index) ? target_page :
-			grab_cache_page_nowait(target_page->mapping, index);
+			grab_cache_page_nowait(folio->mapping, index);
 
 		if (page[i] == NULL)
 			continue;
--- a/fs/squashfs/squashfs.h~squashfs-convert-squashfs_readpage_block-to-take-a-folio
+++ a/fs/squashfs/squashfs.h
@@ -78,7 +78,7 @@ void squashfs_copy_cache(struct page *,
 				int);
 
 /* file_xxx.c */
-extern int squashfs_readpage_block(struct page *, u64, int, int);
+int squashfs_readpage_block(struct folio *, u64 block, int bsize, int expected);
 
 /* id.c */
 extern int squashfs_get_id(struct super_block *, unsigned int, unsigned int *);
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

