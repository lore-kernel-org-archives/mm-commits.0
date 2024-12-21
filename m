Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EFB13A244
	for <mm-commits@vger.kernel.org>; Sat, 21 Dec 2024 04:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734754059; cv=none; b=qNzJ21kpTTiAiyVnd5DjVFzEWwQ0KRUPUBpIdZlLXh/Kctirr2fDgJI8IYVCdNare6/ClPNfHQ8U6/3+oIV4sjwDXmBEUlZS8+ffi3ksRCoPV/RzRqZQSG653TRRTyHz6qy3R/q8Ql3XpSlLCgVVsBaS6RcEFWSsCqsYB8eJiXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734754059; c=relaxed/simple;
	bh=rJrZWNvQME4zqwI1++GajHBUZwA6PBinCVpS7b+0CT8=;
	h=Date:To:From:Subject:Message-Id; b=Xg/8c6A94EYeSFGwJMIK99E6piNqs2lhSmxccWN/dSx6ZO6QzveliUNhALT8SQf67H7c3L1Xkl86W2SBA5q1wdDRPEruKEldiTcHaoRObp1QACfsFysH1a2tea2G823ezVBzl1RaV3wlLz9tz7jkvt9aHlQdEmr/H8c+PJ2QvQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AsS3ZExY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AsS3ZExY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5C5C4CECE;
	Sat, 21 Dec 2024 04:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1734754059;
	bh=rJrZWNvQME4zqwI1++GajHBUZwA6PBinCVpS7b+0CT8=;
	h=Date:To:From:Subject:From;
	b=AsS3ZExYd4wx82cZCzXD3vvkPZ9b8QtSwuGTLT9Y6tlH6dYZSkXlKAOWHImw7eiMs
	 5+WT/DPvE/Rxoy7nUQ7YDdYmR8iDqFAVpqYUuIoU+1RPie2hA4r/JJCR2aPulj0y0B
	 JCI97rdEOpDOxKn79ZffenLxI3UkVdJxWQ0q8hz0=
Date: Fri, 20 Dec 2024 20:07:38 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch added to mm-nonmm-unstable branch
Message-Id: <20241221040739.5B5C5C4CECE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: convert squashfs_readpage_block() to take a folio
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
@@ -72,7 +72,7 @@ void squashfs_copy_cache(struct page *,
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
ocfs2-handle-a-symlink-read-error-correctly.patch
ocfs2-convert-ocfs2_page_mkwrite-to-use-a-folio.patch
ocfs2-pass-mmap_folio-around-instead-of-mmap_page.patch
ocfs2-convert-ocfs2_read_inline_data-to-take-a-folio.patch
ocfs2-use-a-folio-in-ocfs2_fast_symlink_read_folio.patch
ocfs2-remove-ocfs2_start_walk_page_trans-prototype.patch
iov_iter-remove-setting-of-page-index.patch
squashfs-use-a-folio-throughout-squashfs_read_folio.patch
squashfs-pass-a-folio-to-squashfs_readpage_fragment.patch
squashfs-convert-squashfs_readpage_block-to-take-a-folio.patch
squashfs-convert-squashfs_copy_cache-to-take-a-folio.patch
squashfs-convert-squashfs_fill_page-to-take-a-folio.patch

