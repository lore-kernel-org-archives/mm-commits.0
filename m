Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7760ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiILDfl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiILDdk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBF429CAB
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D76B16119C
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCD3C433C1;
        Mon, 12 Sep 2022 03:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953437;
        bh=gRaafgZdkGRwpFJwemU7qYJj+DugpOcXKrYStKaf01A=;
        h=Date:To:From:Subject:From;
        b=dX1V0YQNvY7pSmjJ+pIj9RK7WN3r5YD15+62VAgLJ2DNXhIfFjQGEcHmMCnbRDGeu
         Q7J8zL97VfYZj2kjW6wtTJumGn/59Mt9sNpT6mopnedmw9D9J/y+3oOttqbtkEqwat
         cdpdUu+KXd9fgx3FiY+P08Ua1Zpr99Wo/4BtldqA=
Date:   Sun, 11 Sep 2022 20:30:36 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-remove-ll_rw_block-helper.patch removed from -mm tree
Message-Id: <20220912033037.3BCD3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: remove ll_rw_block() helper
has been removed from the -mm tree.  Its filename was
     fs-buffer-remove-ll_rw_block-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: remove ll_rw_block() helper
Date: Thu, 1 Sep 2022 21:35:03 +0800

Now that all ll_rw_block() users has been replaced to new safe helpers,
we just remove it here.

Link: https://lkml.kernel.org/r/20220901133505.2510834-13-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   63 ++--------------------------------
 include/linux/buffer_head.h |    1 
 2 files changed, 4 insertions(+), 60 deletions(-)

--- a/fs/buffer.c~fs-buffer-remove-ll_rw_block-helper
+++ a/fs/buffer.c
@@ -152,7 +152,7 @@ static void __end_buffer_read_notouch(st
 
 /*
  * Default synchronous end-of-IO handler..  Just mark it up-to-date and
- * unlock the buffer. This is what ll_rw_block uses too.
+ * unlock the buffer.
  */
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate)
 {
@@ -491,8 +491,8 @@ int inode_has_buffers(struct inode *inod
  * all already-submitted IO to complete, but does not queue any new
  * writes to the disk.
  *
- * To do O_SYNC writes, just queue the buffer writes with ll_rw_block as
- * you dirty the buffers, and then use osync_inode_buffers to wait for
+ * To do O_SYNC writes, just queue the buffer writes with write_dirty_buffer
+ * as you dirty the buffers, and then use osync_inode_buffers to wait for
  * completion.  Any other dirty buffers which are not yet queued for
  * write will not be flushed to disk by the osync.
  */
@@ -1806,7 +1806,7 @@ done:
 		/*
 		 * The page was marked dirty, but the buffers were
 		 * clean.  Someone wrote them back by hand with
-		 * ll_rw_block/submit_bh.  A rare case.
+		 * write_dirty_buffer/submit_bh.  A rare case.
 		 */
 		end_page_writeback(page);
 
@@ -2713,61 +2713,6 @@ int submit_bh(blk_opf_t opf, struct buff
 }
 EXPORT_SYMBOL(submit_bh);
 
-/**
- * ll_rw_block: low-level access to block devices (DEPRECATED)
- * @opf: block layer request operation and flags.
- * @nr: number of &struct buffer_heads in the array
- * @bhs: array of pointers to &struct buffer_head
- *
- * ll_rw_block() takes an array of pointers to &struct buffer_heads, and
- * requests an I/O operation on them, either a %REQ_OP_READ or a %REQ_OP_WRITE.
- * @opf contains flags modifying the detailed I/O behavior, most notably
- * %REQ_RAHEAD.
- *
- * This function drops any buffer that it cannot get a lock on (with the
- * BH_Lock state bit), any buffer that appears to be clean when doing a write
- * request, and any buffer that appears to be up-to-date when doing read
- * request.  Further it marks as clean buffers that are processed for
- * writing (the buffer cache won't assume that they are actually clean
- * until the buffer gets unlocked).
- *
- * ll_rw_block sets b_end_io to simple completion handler that marks
- * the buffer up-to-date (if appropriate), unlocks the buffer and wakes
- * any waiters. 
- *
- * All of the buffers must be for the same device, and must also be a
- * multiple of the current approved size for the device.
- */
-void ll_rw_block(const blk_opf_t opf, int nr, struct buffer_head *bhs[])
-{
-	const enum req_op op = opf & REQ_OP_MASK;
-	int i;
-
-	for (i = 0; i < nr; i++) {
-		struct buffer_head *bh = bhs[i];
-
-		if (!trylock_buffer(bh))
-			continue;
-		if (op == REQ_OP_WRITE) {
-			if (test_clear_buffer_dirty(bh)) {
-				bh->b_end_io = end_buffer_write_sync;
-				get_bh(bh);
-				submit_bh(opf, bh);
-				continue;
-			}
-		} else {
-			if (!buffer_uptodate(bh)) {
-				bh->b_end_io = end_buffer_read_sync;
-				get_bh(bh);
-				submit_bh(opf, bh);
-				continue;
-			}
-		}
-		unlock_buffer(bh);
-	}
-}
-EXPORT_SYMBOL(ll_rw_block);
-
 void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags)
 {
 	lock_buffer(bh);
--- a/include/linux/buffer_head.h~fs-buffer-remove-ll_rw_block-helper
+++ a/include/linux/buffer_head.h
@@ -223,7 +223,6 @@ struct buffer_head *alloc_buffer_head(gf
 void free_buffer_head(struct buffer_head * bh);
 void unlock_buffer(struct buffer_head *bh);
 void __lock_buffer(struct buffer_head *bh);
-void ll_rw_block(blk_opf_t, int, struct buffer_head * bh[]);
 int sync_dirty_buffer(struct buffer_head *bh);
 int __sync_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
 void write_dirty_buffer(struct buffer_head *bh, blk_opf_t op_flags);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


