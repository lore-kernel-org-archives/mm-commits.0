Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2ADBE64
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XLNNam56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6E1C433C7;
	Mon, 11 Dec 2023 01:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257855;
	bh=y0fE7T7441lpFz1G1c6LUzSgCoCV3StcTV1AXqfjbq4=;
	h=Date:To:From:Subject:From;
	b=XLNNam56dx6tu1wGWu532VMD6YWBHnGUzVu7InVg/GmqID+I4pFQAiC/3FtSwxPoW
	 riXgOyolZTOmp8YFttHC0kwGXroWNZz8ZtSr4Lo2Bn0W7AoTYgSlBus75+1hJXaiiP
	 4jK1jw24jHjYzLUZhAJBqkAJpsPCJnIjUx9p+qwY=
Date: Sun, 10 Dec 2023 17:24:15 -0800
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-convert-nilfs_make_empty-to-use-a-folio.patch removed from -mm tree
Message-Id: <20231211012415.CA6E1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: convert nilfs_make_empty() to use a folio
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-nilfs_make_empty-to-use-a-folio.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: nilfs2: convert nilfs_make_empty() to use a folio
Date: Mon, 27 Nov 2023 23:30:34 +0900

Remove two calls to compound_head() and switch from kmap_atomic to
kmap_local.

Link: https://lkml.kernel.org/r/20231127143036.2425-16-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-convert-nilfs_make_empty-to-use-a-folio
+++ a/fs/nilfs2/dir.c
@@ -559,21 +559,21 @@ out:
 int nilfs_make_empty(struct inode *inode, struct inode *parent)
 {
 	struct address_space *mapping = inode->i_mapping;
-	struct page *page = grab_cache_page(mapping, 0);
+	struct folio *folio = filemap_grab_folio(mapping, 0);
 	unsigned int chunk_size = nilfs_chunk_size(inode);
 	struct nilfs_dir_entry *de;
 	int err;
 	void *kaddr;
 
-	if (!page)
-		return -ENOMEM;
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
 
-	err = nilfs_prepare_chunk(page, 0, chunk_size);
+	err = nilfs_prepare_chunk(&folio->page, 0, chunk_size);
 	if (unlikely(err)) {
-		unlock_page(page);
+		folio_unlock(folio);
 		goto fail;
 	}
-	kaddr = kmap_atomic(page);
+	kaddr = kmap_local_folio(folio, 0);
 	memset(kaddr, 0, chunk_size);
 	de = (struct nilfs_dir_entry *)kaddr;
 	de->name_len = 1;
@@ -588,10 +588,10 @@ int nilfs_make_empty(struct inode *inode
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
 	nilfs_set_de_type(de, inode);
-	kunmap_atomic(kaddr);
-	nilfs_commit_chunk(page, mapping, 0, chunk_size);
+	kunmap_local(kaddr);
+	nilfs_commit_chunk(&folio->page, mapping, 0, chunk_size);
 fail:
-	put_page(page);
+	folio_put(folio);
 	return err;
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

