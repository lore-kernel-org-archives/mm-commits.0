From: akpm@linux-foundation.org
Subject: [merged] fs-direct-ioc-calcuate-fs_count-correctly-in-get_more_blocks.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:50 -0800
Message-ID: <20120113203650.A960E1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:63424 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:51 -0500
Received: by mail-yw0-f74.google.com with SMTP id j52so102213yhj.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:51 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: boyu.mt@taobao.com, hch@lst.de, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()
has been removed from the -mm tree.  Its filename was
     fs-direct-ioc-calcuate-fs_count-correctly-in-get_more_blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Tao Ma <boyu.mt@taobao.com>
Subject: fs/direct-io.c: calculate fs_count correctly in get_more_blocks()

In get_more_blocks(), we use dio_count to calcuate fs_count and do some
tricky things to increase fs_count if dio_count isn't aligned.  But
actually it still has some corner cases that can't be coverd.  See the
following example:

	dio_write foo -s 1024 -w 4096

(direct write 4096 bytes at offset 1024).  The same goes if the offset
isn't aligned to fs_blocksize.

In this case, the old calculation counts fs_count to be 1, but actually we
will write into 2 different blocks (if fs_blocksize=4096).  The old code
just works, since it will call get_block twice (and may have to allocate
and create extents twice for filesystems like ext4).  So we'd better call
get_block just once with the proper fs_count.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/direct-io.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN fs/direct-io.c~fs-direct-ioc-calcuate-fs_count-correctly-in-get_more_blocks fs/direct-io.c
--- a/fs/direct-io.c~fs-direct-ioc-calcuate-fs_count-correctly-in-get_more_blocks
+++ a/fs/direct-io.c
@@ -580,9 +580,8 @@ static int get_more_blocks(struct dio *d
 {
 	int ret;
 	sector_t fs_startblk;	/* Into file, in filesystem-sized blocks */
+	sector_t fs_endblk;	/* Into file, in filesystem-sized blocks */
 	unsigned long fs_count;	/* Number of filesystem-sized blocks */
-	unsigned long dio_count;/* Number of dio_block-sized blocks */
-	unsigned long blkmask;
 	int create;
 
 	/*
@@ -593,11 +592,9 @@ static int get_more_blocks(struct dio *d
 	if (ret == 0) {
 		BUG_ON(sdio->block_in_file >= sdio->final_block_in_request);
 		fs_startblk = sdio->block_in_file >> sdio->blkfactor;
-		dio_count = sdio->final_block_in_request - sdio->block_in_file;
-		fs_count = dio_count >> sdio->blkfactor;
-		blkmask = (1 << sdio->blkfactor) - 1;
-		if (dio_count & blkmask)	
-			fs_count++;
+		fs_endblk = (sdio->final_block_in_request - 1) >>
+					sdio->blkfactor;
+		fs_count = fs_endblk - fs_startblk + 1;
 
 		map_bh->b_state = 0;
 		map_bh->b_size = fs_count << dio->inode->i_blkbits;
_

Patches currently in -mm which might be from boyu.mt@taobao.com are

origin.patch

