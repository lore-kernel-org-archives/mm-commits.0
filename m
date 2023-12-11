Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483F2BE64
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qu0OxiMn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CB2C433C9;
	Mon, 11 Dec 2023 01:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257851;
	bh=VvRtmhfLUipCsMLXfmUgF46D/PWRRoJmTyGw6JOIHqE=;
	h=Date:To:From:Subject:From;
	b=qu0OxiMnmvEafK5OF3GIv3B9hjbrFt9XregiS9dSZdzRjYUm6mfY8YrAjpWNug7vw
	 dGmFUTbK4R1UzL8CJtmhqOfUsAmkFMqvs/onKLwyOJm6MQzs6musShJiDyOOsYTOQQ
	 Uw1W7H3HujAvLzudpJCU3HUBCGdaFIWb0au6esQc=
Date: Sun, 10 Dec 2023 17:24:10 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_readdir-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012411.15CB2C433C9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_readdir to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_readdir-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_readdir to use a folio
Date: Mon, 27 Nov 2023 23:30:29 +0900

Use the new folio APIs to remove calls to compound_head().

Link: https://lkml.kernel.org/r/20231127143036.2425-11-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_readdir-to-use-a-folio
+++ a/fs/nilfs2/dir.c
@@ -284,9 +284,9 @@ static int nilfs_readdir(struct file *fi
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
 		struct nilfs_dir_entry *de;
-		struct page *page;
+		struct folio *folio;
 
-		kaddr = nilfs_get_page(inode, n, &page);
+		kaddr = nilfs_get_folio(inode, n, &folio);
 		if (IS_ERR(kaddr)) {
 			nilfs_error(sb, "bad page in #%lu", inode->i_ino);
 			ctx->pos += PAGE_SIZE - offset;
@@ -298,7 +298,7 @@ static int nilfs_readdir(struct file *fi
 		for ( ; (char *)de <= limit; de = nilfs_next_entry(de)) {
 			if (de->rec_len == 0) {
 				nilfs_error(sb, "zero-length directory entry");
-				unmap_and_put_page(page, kaddr);
+				folio_release_kmap(folio, kaddr);
 				return -EIO;
 			}
 			if (de->inode) {
@@ -311,13 +311,13 @@ static int nilfs_readdir(struct file *fi
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
-					unmap_and_put_page(page, kaddr);
+					folio_release_kmap(folio, kaddr);
 					return 0;
 				}
 			}
 			ctx->pos += nilfs_rec_len_from_disk(de->rec_len);
 		}
-		unmap_and_put_page(page, kaddr);
+		folio_release_kmap(folio, kaddr);
 	}
 	return 0;
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

