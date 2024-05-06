Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DA12207A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 00:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957059; cv=none; b=cy4z2vEoP9FRwu8P8X4pjdoEhZlShVF1cv598qKy9eHXv1mgk2VDniD5mW+hZSbbQhlUja8jm3jV2KAcpSeDjH2qJT1npsiloS3PdnN7fHknELHgsoKo2dODFgOE0zH/qRf5rJZuWuWicqSc/ida/e74mbFKCEzoaIQR/MsVg3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957059; c=relaxed/simple;
	bh=mHHxUE5FE8jMD3BFCgJeSvBt+8xiBALLozVIJvERj4s=;
	h=Date:To:From:Subject:Message-Id; b=Iy7d8IsgENeS6Kzpi5GAkpGu7kHzLyUAMSIKgUzd6p+4w1Q+6V9m3YL7QAnQuAlevwM7Zp8wzjOz3WNsYgTCyoARMmBaxy1Miby5wt7IEHxC1sWgT6R6hjXEs6W5cjRC/ffwLE6tIdbuiomdqhgo1veF4YWKIsNKd3vz5Z+W4Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JFXe0DGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JFXe0DGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1E3C113CC;
	Mon,  6 May 2024 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957059;
	bh=mHHxUE5FE8jMD3BFCgJeSvBt+8xiBALLozVIJvERj4s=;
	h=Date:To:From:Subject:From;
	b=JFXe0DGQS/vA2mpIrI3MgbvpUzioR9RXwAILkUsn0lxPKsDNiH9sZZqhkI7bNqcmh
	 KPwE7amX+ejrmP+awnogZRCZhmRztT85XqmoeKYddkRy9W85K2gYiw8LhkW6NOVU/7
	 HOaS8/l1xh9MQLG2HeWsaLpPq7iM7iBGmwJblp6k=
Date: Sun, 05 May 2024 17:57:38 -0700
To: mm-commits@vger.kernel.org,rdunlap@infradead.org,p.raghav@samsung.com,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch removed from -mm tree
Message-Id: <20240506005739.0E1E3C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: buffer: fix __bread and __bread_gfp kernel-doc
has been removed from the -mm tree.  Its filename was
     buffer-fix-__bread-and-__bread_gfp-kernel-doc.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: buffer: fix __bread and __bread_gfp kernel-doc
Date: Tue, 16 Apr 2024 04:17:48 +0100

The extra indentation confused the kernel-doc parser, so remove it.  Fix
some other wording while I'm here, and advise the user they need to call
brelse() on this buffer.

__bread_gfp() isn't used directly by filesystems, but the other wrappers
for it don't have documentation, so document it accordingly.

Link: https://lkml.kernel.org/r/20240416031754.4076917-5-willy@infradead.org
Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   33 +++++++++++++++++++++------------
 include/linux/buffer_head.h |   22 +++++++++++++---------
 2 files changed, 34 insertions(+), 21 deletions(-)

--- a/fs/buffer.c~buffer-fix-__bread-and-__bread_gfp-kernel-doc
+++ a/fs/buffer.c
@@ -1453,20 +1453,29 @@ void __breadahead(struct block_device *b
 EXPORT_SYMBOL(__breadahead);
 
 /**
- *  __bread_gfp() - reads a specified block and returns the bh
- *  @bdev: the block_device to read from
- *  @block: number of block
- *  @size: size (in bytes) to read
- *  @gfp: page allocation flag
+ * __bread_gfp() - Read a block.
+ * @bdev: The block device to read from.
+ * @block: Block number in units of block size.
+ * @size: The block size of this device in bytes.
+ * @gfp: Not page allocation flags; see below.
  *
- *  Reads a specified block, and returns buffer head that contains it.
- *  The page cache can be allocated from non-movable area
- *  not to prevent page migration if you set gfp to zero.
- *  It returns NULL if the block was unreadable.
+ * You are not expected to call this function.  You should use one of
+ * sb_bread(), sb_bread_unmovable() or __bread().
+ *
+ * Read a specified block, and return the buffer head that refers to it.
+ * If @gfp is 0, the memory will be allocated using the block device's
+ * default GFP flags.  If @gfp is __GFP_MOVABLE, the memory may be
+ * allocated from a movable area.  Do not pass in a complete set of
+ * GFP flags.
+ *
+ * The returned buffer head has its refcount increased.  The caller should
+ * call brelse() when it has finished with the buffer.
+ *
+ * Context: May sleep waiting for I/O.
+ * Return: NULL if the block was unreadable.
  */
-struct buffer_head *
-__bread_gfp(struct block_device *bdev, sector_t block,
-		   unsigned size, gfp_t gfp)
+struct buffer_head *__bread_gfp(struct block_device *bdev, sector_t block,
+		unsigned size, gfp_t gfp)
 {
 	struct buffer_head *bh;
 
--- a/include/linux/buffer_head.h~buffer-fix-__bread-and-__bread_gfp-kernel-doc
+++ a/include/linux/buffer_head.h
@@ -437,17 +437,21 @@ static inline void bh_readahead_batch(in
 }
 
 /**
- *  __bread() - reads a specified block and returns the bh
- *  @bdev: the block_device to read from
- *  @block: number of block
- *  @size: size (in bytes) to read
+ * __bread() - Read a block.
+ * @bdev: The block device to read from.
+ * @block: Block number in units of block size.
+ * @size: The block size of this device in bytes.
  *
- *  Reads a specified block, and returns buffer head that contains it.
- *  The page cache is allocated from movable area so that it can be migrated.
- *  It returns NULL if the block was unreadable.
+ * Read a specified block, and return the buffer head that refers
+ * to it.  The memory is allocated from the movable area so that it can
+ * be migrated.  The returned buffer head has its refcount increased.
+ * The caller should call brelse() when it has finished with the buffer.
+ *
+ * Context: May sleep waiting for I/O.
+ * Return: NULL if the block was unreadable.
  */
-static inline struct buffer_head *
-__bread(struct block_device *bdev, sector_t block, unsigned size)
+static inline struct buffer_head *__bread(struct block_device *bdev,
+		sector_t block, unsigned size)
 {
 	return __bread_gfp(bdev, block, size, __GFP_MOVABLE);
 }
_

Patches currently in -mm which might be from willy@infradead.org are

squashfs-convert-squashfs_symlink_read_folio-to-use-folio-apis.patch
squashfs-remove-calls-to-set-the-folio-error-flag.patch
nilfs2-remove-calls-to-folio_set_error-and-folio_clear_error.patch

