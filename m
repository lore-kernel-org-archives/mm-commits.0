Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5F2F134A0
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s6+UQRNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C759C433CB;
	Fri, 29 Dec 2023 19:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879965;
	bh=/nXSZImutHwk8eKLwv8f9u9+eVY40LU7sukRpmDCLgM=;
	h=Date:To:From:Subject:From;
	b=s6+UQRNkd8LmJK1sjAxpw+pvBbIXFnw1P0MgG9tcmmerfoW8D7FMdvlz5v/OpkjuM
	 Z/5kFvLtBBj70lOnumxfeBpuELVFgyMvfo99a0ZvTK6rY5HmNvb7szyvN7CMnHu7K2
	 tAoVUbtfA2Rkwf0y1UPKS0qpM/8qlmh8sHapyaXg=
Date: Fri, 29 Dec 2023 11:59:25 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-calculate-block-number-inside-folio_init_buffers.patch removed from -mm tree
Message-Id: <20231229195925.8C759C433CB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: calculate block number inside folio_init_buffers()
has been removed from the -mm tree.  Its filename was
     buffer-calculate-block-number-inside-folio_init_buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: calculate block number inside folio_init_buffers()
Date: Thu, 9 Nov 2023 21:06:03 +0000

The calculation of block from index doesn't work for devices with a block
size larger than PAGE_SIZE as we end up shifting by a negative number. 
Instead, calculate the number of the first block from the folio's position
in the block device.  We no longer need to pass sizebits to
grow_dev_folio().

Link: https://lkml.kernel.org/r/20231109210608.2252323-3-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~buffer-calculate-block-number-inside-folio_init_buffers
+++ a/fs/buffer.c
@@ -995,11 +995,12 @@ static sector_t blkdev_max_block(struct
  * Initialise the state of a blockdev folio's buffers.
  */ 
 static sector_t folio_init_buffers(struct folio *folio,
-		struct block_device *bdev, sector_t block, int size)
+		struct block_device *bdev, unsigned size)
 {
 	struct buffer_head *head = folio_buffers(folio);
 	struct buffer_head *bh = head;
 	bool uptodate = folio_test_uptodate(folio);
+	sector_t block = div_u64(folio_pos(folio), size);
 	sector_t end_block = blkdev_max_block(bdev, size);
 
 	do {
@@ -1032,7 +1033,7 @@ static sector_t folio_init_buffers(struc
  * we succeeded, or the caller should retry.
  */
 static bool grow_dev_folio(struct block_device *bdev, sector_t block,
-		pgoff_t index, unsigned size, int sizebits, gfp_t gfp)
+		pgoff_t index, unsigned size, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct folio *folio;
@@ -1047,8 +1048,7 @@ static bool grow_dev_folio(struct block_
 	bh = folio_buffers(folio);
 	if (bh) {
 		if (bh->b_size == size) {
-			end_block = folio_init_buffers(folio, bdev,
-					(sector_t)index << sizebits, size);
+			end_block = folio_init_buffers(folio, bdev, size);
 			goto unlock;
 		}
 
@@ -1069,8 +1069,7 @@ static bool grow_dev_folio(struct block_
 	 */
 	spin_lock(&inode->i_mapping->private_lock);
 	link_dev_buffers(folio, bh);
-	end_block = folio_init_buffers(folio, bdev,
-			(sector_t)index << sizebits, size);
+	end_block = folio_init_buffers(folio, bdev, size);
 	spin_unlock(&inode->i_mapping->private_lock);
 unlock:
 	folio_unlock(folio);
@@ -1105,7 +1104,7 @@ static bool grow_buffers(struct block_de
 	}
 
 	/* Create a folio with the proper size buffers */
-	return grow_dev_folio(bdev, block, index, size, sizebits, gfp);
+	return grow_dev_folio(bdev, block, index, size, gfp);
 }
 
 static struct buffer_head *
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

