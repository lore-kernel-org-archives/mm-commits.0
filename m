Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A313AD1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ATpKUbFK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDE4C433C8;
	Fri, 29 Dec 2023 20:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703880026;
	bh=PyHZS/WJqlUXnYgyGKsV9ZTQFKXUmYDUM6T9bUfgxEo=;
	h=Date:To:From:Subject:From;
	b=ATpKUbFKx7dYBC2OlaEbgUlMejmu989Hvklu2thsJEczgxBxh+Zp4j8sxNMm2PPaq
	 cCxpBU5xnIvZoMGdWJxlg+TcYHbDXos0ofyOyySXFwgk2VppSfUyP0C0YO5DGYLaX1
	 jPjDwZC2GT84X7wqyo5uJr9I2bevZ2/PjK36qTSU=
Date: Fri, 29 Dec 2023 12:00:25 -0800
To: mm-commits@vger.kernel.org,hch@lst.de,axboe@kernel.dk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hfs-really-remove-hfs_writepage.patch removed from -mm tree
Message-Id: <20231229200026.0FDE4C433C8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: hfs: really remove hfs_writepage
has been removed from the -mm tree.  Its filename was
     hfs-really-remove-hfs_writepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: hfs: really remove hfs_writepage
Date: Fri, 15 Dec 2023 20:02:38 +0000

The earlier commit to remove hfs_writepage only removed it from one of the
aops.  Remove it from the btree_aops as well.

Link: https://lkml.kernel.org/r/20231215200245.748418-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/inode.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/fs/hfs/inode.c~hfs-really-remove-hfs_writepage
+++ a/fs/hfs/inode.c
@@ -29,11 +29,6 @@ static const struct inode_operations hfs
 
 #define HFS_VALID_MODE_BITS  (S_IFREG | S_IFDIR | S_IRWXUGO)
 
-static int hfs_writepage(struct page *page, struct writeback_control *wbc)
-{
-	return block_write_full_page(page, hfs_get_block, wbc);
-}
-
 static int hfs_read_folio(struct file *file, struct folio *folio)
 {
 	return block_read_full_folio(folio, hfs_get_block);
@@ -162,9 +157,10 @@ const struct address_space_operations hf
 	.dirty_folio	= block_dirty_folio,
 	.invalidate_folio = block_invalidate_folio,
 	.read_folio	= hfs_read_folio,
-	.writepage	= hfs_writepage,
+	.writepages	= hfs_writepages,
 	.write_begin	= hfs_write_begin,
 	.write_end	= generic_write_end,
+	.migrate_folio	= buffer_migrate_folio,
 	.bmap		= hfs_bmap,
 	.release_folio	= hfs_release_folio,
 };
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

