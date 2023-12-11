Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47476BE64
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mfOSzbaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141EDC433C9;
	Mon, 11 Dec 2023 01:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257852;
	bh=4NpFwCE6vO1txVVB6PXz7G1/snRkLLonW2ahaLbQGt8=;
	h=Date:To:From:Subject:From;
	b=mfOSzbaC5Y+LTwty+bnzC4dC2+U9SuELBz0uBuY/sl/dEt1WgCf//J37u+vTVDjJc
	 EFXPktrPxHJEcjMW+ZDLxZGqJ0mSg9beqUTnJ9mJ90zu8AnN4ATzvo6adovS2d6aeE
	 W/CXSUfTYRxH66RsXLUclXUSepFCeMXoTSDGeakw=
Date: Sun, 10 Dec 2023 17:24:11 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_find_entry-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012412.141EDC433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_find_entry to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_find_entry-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_find_entry to use a folio
Date: Mon, 27 Nov 2023 23:30:30 +0900

Use the new folio APIs to remove calls to compound_head().

[konishi.ryusuke: resolved a conflict due to style warning correction]
Link: https://lkml.kernel.org/r/20231127143036.2425-12-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_find_entry-to-use-a-folio
+++ a/fs/nilfs2/dir.c
@@ -339,7 +339,7 @@ nilfs_find_entry(struct inode *dir, cons
 	unsigned int reclen = NILFS_DIR_REC_LEN(namelen);
 	unsigned long start, n;
 	unsigned long npages = dir_pages(dir);
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	struct nilfs_inode_info *ei = NILFS_I(dir);
 	struct nilfs_dir_entry *de;
 
@@ -354,7 +354,7 @@ nilfs_find_entry(struct inode *dir, cons
 		start = 0;
 	n = start;
 	do {
-		char *kaddr = nilfs_get_page(dir, n, &page);
+		char *kaddr = nilfs_get_folio(dir, n, &folio);
 
 		if (!IS_ERR(kaddr)) {
 			de = (struct nilfs_dir_entry *)kaddr;
@@ -363,18 +363,18 @@ nilfs_find_entry(struct inode *dir, cons
 				if (de->rec_len == 0) {
 					nilfs_error(dir->i_sb,
 						"zero-length directory entry");
-					unmap_and_put_page(page, kaddr);
+					folio_release_kmap(folio, kaddr);
 					goto out;
 				}
 				if (nilfs_match(namelen, name, de))
 					goto found;
 				de = nilfs_next_entry(de);
 			}
-			unmap_and_put_page(page, kaddr);
+			folio_release_kmap(folio, kaddr);
 		}
 		if (++n >= npages)
 			n = 0;
-		/* next page is past the blocks we've got */
+		/* next folio is past the blocks we've got */
 		if (unlikely(n > (dir->i_blocks >> (PAGE_SHIFT - 9)))) {
 			nilfs_error(dir->i_sb,
 			       "dir %lu size %lld exceeds block count %llu",
@@ -387,7 +387,7 @@ out:
 	return NULL;
 
 found:
-	*res_page = page;
+	*res_page = &folio->page;
 	ei->i_dir_start_lookup = n;
 	return de;
 }
_

Patches currently in -mm which might be from willy@infradead.org are

buffer-return-bool-from-grow_dev_folio.patch
buffer-calculate-block-number-inside-folio_init_buffers.patch
buffer-fix-grow_buffers-for-block-size-page_size.patch
buffer-cast-block-to-loff_t-before-shifting-it.patch
buffer-fix-various-functions-for-block-size-page_size.patch
buffer-handle-large-folios-in-__block_write_begin_int.patch
buffer-fix-more-functions-for-block-size-page_size.patch

