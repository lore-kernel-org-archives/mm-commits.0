Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2FE134A0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zbxIVWdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64317C433C7;
	Fri, 29 Dec 2023 19:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879969;
	bh=aQQq7D2rdHmHCZw9bGbPb/oIxbIDh3zAetFX5J7QSqo=;
	h=Date:To:From:Subject:From;
	b=zbxIVWdfGhkint05zAFEdx6f6BTYGD2k1pyd5YPVXDIJ8uJX60eZw/jKNPtSg6CrU
	 xblcivBtYdjbRpiw5J1wzN5iJ3eNBRZ2n8tzWzekAndv2Ra17CSgkB368SokNyB5i0
	 nOPPZ7KBzKj8IYscIhymOBjcUD0L6sstTJxyhuog=
Date: Fri, 29 Dec 2023 11:59:28 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-fix-various-functions-for-block-size-page_size.patch removed from -mm tree
Message-Id: <20231229195929.64317C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: fix various functions for block size > PAGE_SIZE
has been removed from the -mm tree.  Its filename was
     buffer-fix-various-functions-for-block-size-page_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: fix various functions for block size > PAGE_SIZE
Date: Thu, 9 Nov 2023 21:06:06 +0000

If i_blkbits is larger than PAGE_SHIFT, we shift by a negative number,
which is undefined.  It is safe to shift the block left as a block device
must be smaller than MAX_LFS_FILESIZE, which is guaranteed to fit in
loff_t.

Link: https://lkml.kernel.org/r/20231109210608.2252323-6-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/buffer.c~buffer-fix-various-functions-for-block-size-page_size
+++ a/fs/buffer.c
@@ -199,7 +199,7 @@ __find_get_block_slow(struct block_devic
 	int all_mapped = 1;
 	static DEFINE_RATELIMIT_STATE(last_warned, HZ, 1);
 
-	index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	index = ((loff_t)block << bd_inode->i_blkbits) / PAGE_SIZE;
 	folio = __filemap_get_folio(bd_mapping, index, FGP_ACCESSED, 0);
 	if (IS_ERR(folio))
 		goto out;
@@ -1693,13 +1693,13 @@ void clean_bdev_aliases(struct block_dev
 	struct inode *bd_inode = bdev->bd_inode;
 	struct address_space *bd_mapping = bd_inode->i_mapping;
 	struct folio_batch fbatch;
-	pgoff_t index = block >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	pgoff_t index = ((loff_t)block << bd_inode->i_blkbits) / PAGE_SIZE;
 	pgoff_t end;
 	int i, count;
 	struct buffer_head *bh;
 	struct buffer_head *head;
 
-	end = (block + len - 1) >> (PAGE_SHIFT - bd_inode->i_blkbits);
+	end = ((loff_t)(block + len - 1) << bd_inode->i_blkbits) / PAGE_SIZE;
 	folio_batch_init(&fbatch);
 	while (filemap_get_folios(bd_mapping, &index, end, &fbatch)) {
 		count = folio_batch_count(&fbatch);
@@ -2660,8 +2660,8 @@ int block_truncate_page(struct address_s
 		return 0;
 
 	length = blocksize - length;
-	iblock = (sector_t)index << (PAGE_SHIFT - inode->i_blkbits);
-	
+	iblock = ((loff_t)index * PAGE_SIZE) >> inode->i_blkbits;
+
 	folio = filemap_grab_folio(mapping, index);
 	if (IS_ERR(folio))
 		return PTR_ERR(folio);
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

