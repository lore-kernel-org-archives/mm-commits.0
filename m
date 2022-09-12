Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B336ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiILDep (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiILDdP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB4C29810
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 254D0B80C70
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC853C433C1;
        Mon, 12 Sep 2022 03:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953425;
        bh=JDR0n4dX0lxDVpcQeN917w5Hqb5aXTV6tiSDF+2PZIE=;
        h=Date:To:From:Subject:From;
        b=Y/zvnbdpEQYm3NjKhZmmrGlaqzW10r2ZUwYRj+DJjTYbLFLQ5/I7PSWKnAUM372R8
         WveTSKg/rQGmw8U4b3Qa14DoW3jENVtK7zd08qkIXgPogvu4C4Oth2LrXUgu5XOgRZ
         7QNuwfGCPTHbxfG+XhHygceaOG+xMgx8FQtBxqvI=
Date:   Sun, 11 Sep 2022 20:30:25 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-add-some-new-buffer-read-helpers.patch removed from -mm tree
Message-Id: <20220912033025.BC853C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: add some new buffer read helpers
has been removed from the -mm tree.  Its filename was
     fs-buffer-add-some-new-buffer-read-helpers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: add some new buffer read helpers
Date: Thu, 1 Sep 2022 21:34:53 +0800

Current ll_rw_block() helper is fragile because it assumes that locked
buffer means it's under IO which is submitted by some other who holds
the lock, it skip buffer if it failed to get the lock, so it's only
safe on the readahead path. Unfortunately, now that most filesystems
still use this helper mistakenly on the sync metadata read path. There
is no guarantee that the one who holds the buffer lock always submit IO
(e.g. buffer_migrate_folio_norefs() after commit 88dbcbb3a484 ("blkdev:
avoid migration stalls for blkdev pages"), it could lead to false
positive -EIO when submitting reading IO.

This patch add some friendly buffer read helpers to prepare replacing
ll_rw_block() and similar calls. We can only call bh_readahead_[]
helpers for the readahead paths.

Link: https://lkml.kernel.org/r/20220901133505.2510834-3-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   65 ++++++++++++++++++++++++++++++++++
 include/linux/buffer_head.h |   38 +++++++++++++++++++
 2 files changed, 103 insertions(+)

--- a/fs/buffer.c~fs-buffer-add-some-new-buffer-read-helpers
+++ a/fs/buffer.c
@@ -3018,6 +3018,71 @@ int bh_uptodate_or_lock(struct buffer_he
 EXPORT_SYMBOL(bh_uptodate_or_lock);
 
 /**
+ * __bh_read - Submit read for a locked buffer
+ * @bh: struct buffer_head
+ * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
+ * @wait: wait until reading finish
+ *
+ * Returns zero on success or don't wait, and -EIO on error.
+ */
+int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait)
+{
+	int ret = 0;
+
+	BUG_ON(!buffer_locked(bh));
+
+	get_bh(bh);
+	bh->b_end_io = end_buffer_read_sync;
+	submit_bh(REQ_OP_READ | op_flags, bh);
+	if (wait) {
+		wait_on_buffer(bh);
+		if (!buffer_uptodate(bh))
+			ret = -EIO;
+	}
+	return ret;
+}
+EXPORT_SYMBOL(__bh_read);
+
+/**
+ * __bh_read_batch - Submit read for a batch of unlocked buffers
+ * @nr: entry number of the buffer batch
+ * @bhs: a batch of struct buffer_head
+ * @op_flags: appending REQ_OP_* flags besides REQ_OP_READ
+ * @force_lock: force to get a lock on the buffer if set, otherwise drops any
+ *              buffer that cannot lock.
+ *
+ * Returns zero on success or don't wait, and -EIO on error.
+ */
+void __bh_read_batch(int nr, struct buffer_head *bhs[],
+		     blk_opf_t op_flags, bool force_lock)
+{
+	int i;
+
+	for (i = 0; i < nr; i++) {
+		struct buffer_head *bh = bhs[i];
+
+		if (buffer_uptodate(bh))
+			continue;
+
+		if (force_lock)
+			lock_buffer(bh);
+		else
+			if (!trylock_buffer(bh))
+				continue;
+
+		if (buffer_uptodate(bh)) {
+			unlock_buffer(bh);
+			continue;
+		}
+
+		bh->b_end_io = end_buffer_read_sync;
+		get_bh(bh);
+		submit_bh(REQ_OP_READ | op_flags, bh);
+	}
+}
+EXPORT_SYMBOL(__bh_read_batch);
+
+/**
  * bh_submit_read - Submit a locked buffer for reading
  * @bh: struct buffer_head
  *
--- a/include/linux/buffer_head.h~fs-buffer-add-some-new-buffer-read-helpers
+++ a/include/linux/buffer_head.h
@@ -232,6 +232,9 @@ void write_boundary_block(struct block_d
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
 int bh_submit_read(struct buffer_head *bh);
+int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
+void __bh_read_batch(int nr, struct buffer_head *bhs[],
+		     blk_opf_t op_flags, bool force_lock);
 
 extern int buffer_heads_over_limit;
 
@@ -399,6 +402,41 @@ static inline struct buffer_head *__getb
 	return __getblk_gfp(bdev, block, size, __GFP_MOVABLE);
 }
 
+static inline void bh_readahead(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (!buffer_uptodate(bh) && trylock_buffer(bh)) {
+		if (!buffer_uptodate(bh))
+			__bh_read(bh, op_flags, false);
+		else
+			unlock_buffer(bh);
+	}
+}
+
+static inline void bh_read_nowait(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (!bh_uptodate_or_lock(bh))
+		__bh_read(bh, op_flags, false);
+}
+
+/* Returns 1 if buffer uptodated, 0 on success, and -EIO on error. */
+static inline int bh_read(struct buffer_head *bh, blk_opf_t op_flags)
+{
+	if (bh_uptodate_or_lock(bh))
+		return 1;
+	return __bh_read(bh, op_flags, true);
+}
+
+static inline void bh_read_batch(int nr, struct buffer_head *bhs[])
+{
+	__bh_read_batch(nr, bhs, 0, true);
+}
+
+static inline void bh_readahead_batch(int nr, struct buffer_head *bhs[],
+				      blk_opf_t op_flags)
+{
+	__bh_read_batch(nr, bhs, op_flags, false);
+}
+
 /**
  *  __bread() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


