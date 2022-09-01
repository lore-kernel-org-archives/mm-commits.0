Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BE9ECAAD1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiIATGm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiIATGj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FA06DAE0
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90E49B828CE
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB83C433C1;
        Thu,  1 Sep 2022 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059195;
        bh=1MwGuXs6uiffGwjYl37+g6WJwDV4gO5vbszLZazpsss=;
        h=Date:To:From:Subject:From;
        b=PBN12qozlFJI8R6ccZp/jkYOKHr6i2/TFk24lLm0qpRcNysfKChi57pBYUMi5O5N5
         CkuIGc3Hty8PLhFTlj/xK7GN5myrfBi1pdTPfjob6ZqPwzCgYg3seNg8SsZhxRQ++y
         BagO2oMBrOu/hJjr32ZqkyIJDWzV8QJGHYVQm228=
Date:   Thu, 01 Sep 2022 12:06:34 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-add-some-new-buffer-read-helpers.patch added to mm-unstable branch
Message-Id: <20220901190635.4AB83C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: add some new buffer read helpers
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-add-some-new-buffer-read-helpers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-add-some-new-buffer-read-helpers.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

fs-buffer-remove-__breadahead_gfp.patch
fs-buffer-add-some-new-buffer-read-helpers.patch
fs-buffer-replace-ll_rw_block.patch
gfs2-replace-ll_rw_block.patch
isofs-replace-ll_rw_block.patch
jbd2-replace-ll_rw_block.patch
ntfs3-replace-ll_rw_block.patch
ocfs2-replace-ll_rw_block.patch
reiserfs-replace-ll_rw_block.patch
udf-replace-ll_rw_block.patch
ufs-replace-ll_rw_block.patch
fs-buffer-remove-ll_rw_block-helper.patch
ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch
fs-buffer-remove-bh_submit_read-helper.patch

