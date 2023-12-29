Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1CC134A1
	for <mm-commits@vger.kernel.org>; Fri, 29 Dec 2023 19:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="fIpmokhN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5ADC433C7;
	Fri, 29 Dec 2023 19:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1703879964;
	bh=8zNG9l88hsFdCQ0ixWxThdPf/kP5V4vp4cHGKrVxNlA=;
	h=Date:To:From:Subject:From;
	b=fIpmokhNp3zI2Wd3VgSKeKy5tu19qRC4Sb6x48zvF3XbTDyoCfQircl/FD8ZzIKBs
	 Oqy5FA3wSIyQ26CL3MM3kTH5nzOq+MOXwHZQ3LUYZxEaaZINpQqPnHMHFnoXe8g/TR
	 LlMDY1wf3ZmmYdKZUxmyqwH1RpJAj8vd2+wzUc7E=
Date: Fri, 29 Dec 2023 11:59:23 -0800
To: mm-commits@vger.kernel.org,p.raghav@samsung.com,mcgrof@kernel.org,konishi.ryusuke@gmail.com,hare@suse.de,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-return-bool-from-grow_dev_folio.patch removed from -mm tree
Message-Id: <20231229195924.4B5ADC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: return bool from grow_dev_folio()
has been removed from the -mm tree.  Its filename was
     buffer-return-bool-from-grow_dev_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: return bool from grow_dev_folio()
Date: Thu, 9 Nov 2023 21:06:02 +0000

Patch series "More buffer_head cleanups", v2.

The first patch is a left-over from last cycle.  The rest fix "obvious"
block size > PAGE_SIZE problems.  I haven't tested with a large block size
setup (but I have done an ext4 xfstests run).


This patch (of 7):

Rename grow_dev_page() to grow_dev_folio() and make it return a bool. 
Document what that bool means; it's more subtle than it first appears. 
Also rename the 'failed' label to 'unlock' beacuse it's not exactly
'failed'.  It just hasn't succeeded.

Link: https://lkml.kernel.org/r/20231109210608.2252323-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/fs/buffer.c~buffer-return-bool-from-grow_dev_folio
+++ a/fs/buffer.c
@@ -1024,40 +1024,43 @@ static sector_t folio_init_buffers(struc
 }
 
 /*
- * Create the page-cache page that contains the requested block.
+ * Create the page-cache folio that contains the requested block.
  *
  * This is used purely for blockdev mappings.
+ *
+ * Returns false if we have a 'permanent' failure.  Returns true if
+ * we succeeded, or the caller should retry.
  */
-static int
-grow_dev_page(struct block_device *bdev, sector_t block,
-	      pgoff_t index, int size, int sizebits, gfp_t gfp)
+static bool grow_dev_folio(struct block_device *bdev, sector_t block,
+		pgoff_t index, unsigned size, int sizebits, gfp_t gfp)
 {
 	struct inode *inode = bdev->bd_inode;
 	struct folio *folio;
 	struct buffer_head *bh;
-	sector_t end_block;
-	int ret = 0;
+	sector_t end_block = 0;
 
 	folio = __filemap_get_folio(inode->i_mapping, index,
 			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
 	if (IS_ERR(folio))
-		return PTR_ERR(folio);
+		return false;
 
 	bh = folio_buffers(folio);
 	if (bh) {
 		if (bh->b_size == size) {
 			end_block = folio_init_buffers(folio, bdev,
 					(sector_t)index << sizebits, size);
-			goto done;
+			goto unlock;
 		}
+
+		/* Caller should retry if this call fails */
+		end_block = ~0ULL;
 		if (!try_to_free_buffers(folio))
-			goto failed;
+			goto unlock;
 	}
 
-	ret = -ENOMEM;
 	bh = folio_alloc_buffers(folio, size, gfp | __GFP_ACCOUNT);
 	if (!bh)
-		goto failed;
+		goto unlock;
 
 	/*
 	 * Link the folio to the buffers and initialise them.  Take the
@@ -1069,20 +1072,19 @@ grow_dev_page(struct block_device *bdev,
 	end_block = folio_init_buffers(folio, bdev,
 			(sector_t)index << sizebits, size);
 	spin_unlock(&inode->i_mapping->private_lock);
-done:
-	ret = (block < end_block) ? 1 : -ENXIO;
-failed:
+unlock:
 	folio_unlock(folio);
 	folio_put(folio);
-	return ret;
+	return block < end_block;
 }
 
 /*
- * Create buffers for the specified block device block's page.  If
- * that page was dirty, the buffers are set dirty also.
+ * Create buffers for the specified block device block's folio.  If
+ * that folio was dirty, the buffers are set dirty also.  Returns false
+ * if we've hit a permanent error.
  */
-static int
-grow_buffers(struct block_device *bdev, sector_t block, int size, gfp_t gfp)
+static bool grow_buffers(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp)
 {
 	pgoff_t index;
 	int sizebits;
@@ -1099,11 +1101,11 @@ grow_buffers(struct block_device *bdev,
 			"device %pg\n",
 			__func__, (unsigned long long)block,
 			bdev);
-		return -EIO;
+		return false;
 	}
 
-	/* Create a page with the proper size buffers.. */
-	return grow_dev_page(bdev, block, index, size, sizebits, gfp);
+	/* Create a folio with the proper size buffers */
+	return grow_dev_folio(bdev, block, index, size, sizebits, gfp);
 }
 
 static struct buffer_head *
@@ -1124,14 +1126,12 @@ __getblk_slow(struct block_device *bdev,
 
 	for (;;) {
 		struct buffer_head *bh;
-		int ret;
 
 		bh = __find_get_block(bdev, block, size);
 		if (bh)
 			return bh;
 
-		ret = grow_buffers(bdev, block, size, gfp);
-		if (ret < 0)
+		if (!grow_buffers(bdev, block, size, gfp))
 			return NULL;
 	}
 }
_

Patches currently in -mm which might be from willy@infradead.org are

mm-remove-inc-dec-lruvec-page-state-functions.patch
slub-use-alloc_pages_node-in-alloc_slab_page.patch
slub-use-folio-apis-in-free_large_kmalloc.patch
slub-use-a-folio-in-__kmalloc_large_node.patch
mm-khugepaged-use-a-folio-more-in-collapse_file.patch
mm-memcontrol-remove-__mod_lruvec_page_state.patch

