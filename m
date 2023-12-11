Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149C2BE64
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FheqQlHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF80EC433C8;
	Mon, 11 Dec 2023 01:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257854;
	bh=XwWqeER8pjzxRneCg+o6lC4cBEO7zQM8pMDcKE3rpqM=;
	h=Date:To:From:Subject:From;
	b=FheqQlHIZ3l7T0Oe2gIzfYrVyiFikJkc/4v6OQwxmC8pvfbdmsYGqEv4SDdLjY1ed
	 6FsVV/WC3JhXQPER6+VoCfjnppVi9k2jLi3LjpCRlo7spY1wp402GAbHiCCVlKNNV9
	 ZAUdmdyr3oq7pa9hV1SMjvnBYour2rXlMArAEb+M=
Date: Sun, 10 Dec 2023 17:24:14 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_empty_dir-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012414.CF80EC433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_empty_dir() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_empty_dir-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_empty_dir() to use a folio
Date: Mon, 27 Nov 2023 23:30:33 +0900

Remove three calls to compound_head() by using the folio API.

Link: https://lkml.kernel.org/r/20231127143036.2425-15-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_empty_dir-to-use-a-folio
+++ a/fs/nilfs2/dir.c
@@ -203,17 +203,6 @@ fail:
 	return ERR_PTR(-EIO);
 }
 
-static void *nilfs_get_page(struct inode *dir, unsigned long n,
-		struct page **pagep)
-{
-	struct folio *folio;
-	void *kaddr = nilfs_get_folio(dir, n, &folio);
-
-	if (!IS_ERR(kaddr))
-		*pagep = &folio->page;
-	return kaddr;
-}
-
 /*
  * NOTE! unlike strncmp, nilfs_match returns 1 for success, 0 for failure.
  *
@@ -611,14 +600,14 @@ fail:
  */
 int nilfs_empty_dir(struct inode *inode)
 {
-	struct page *page = NULL;
+	struct folio *folio = NULL;
 	char *kaddr;
 	unsigned long i, npages = dir_pages(inode);
 
 	for (i = 0; i < npages; i++) {
 		struct nilfs_dir_entry *de;
 
-		kaddr = nilfs_get_page(inode, i, &page);
+		kaddr = nilfs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
 			continue;
 
@@ -647,12 +636,12 @@ int nilfs_empty_dir(struct inode *inode)
 			}
 			de = nilfs_next_entry(de);
 		}
-		unmap_and_put_page(page, kaddr);
+		folio_release_kmap(folio, kaddr);
 	}
 	return 1;
 
 not_empty:
-	unmap_and_put_page(page, kaddr);
+	folio_release_kmap(folio, kaddr);
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

