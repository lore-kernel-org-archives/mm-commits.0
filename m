Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30EFC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiILDe5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiILDd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4FA2982C
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79382611B0
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB024C433C1;
        Mon, 12 Sep 2022 03:30:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953433;
        bh=ijj51unhgLV+SyTssodhhkfttfXMIOQ0RikuEq0YA6M=;
        h=Date:To:From:Subject:From;
        b=hxudfMquaKoy3ud7n10W7v/8+o9J27ZfqEaCiDhpAJotMOOqIxv6vP0vZLiH0LTUc
         xsIYkk6TTNLHvmfas3mRYS1uTTvKh/7s50vVSc3EFKSTa7UjquEVX1CPDyCCQOK3Tz
         tbTl4ByHcFlc1AFA25JX7u3BBgwO44pR9OK4f0FE=
Date:   Sun, 11 Sep 2022 20:30:33 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] reiserfs-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033033.CB024C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: reiserfs: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     reiserfs-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: reiserfs: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:35:00 +0800

ll_rw_block() is not safe for the sync read/write path because it cannot
guarantee that submitting read/write IO if the buffer has been locked.
We could get false positive EIO after wait_on_buffer() in read path if
the buffer has been locked by others. So stop using ll_rw_block() in
reiserfs. We also switch to new bh_readahead_batch() helper for the
buffer array readahead path.

Link: https://lkml.kernel.org/r/20220901133505.2510834-10-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/journal.c |   11 ++++++-----
 fs/reiserfs/stree.c   |    4 ++--
 fs/reiserfs/super.c   |    4 +---
 3 files changed, 9 insertions(+), 10 deletions(-)

--- a/fs/reiserfs/journal.c~reiserfs-replace-ll_rw_block
+++ a/fs/reiserfs/journal.c
@@ -868,7 +868,7 @@ loop_next:
 		 */
 		if (buffer_dirty(bh) && unlikely(bh->b_page->mapping == NULL)) {
 			spin_unlock(lock);
-			ll_rw_block(REQ_OP_WRITE, 1, &bh);
+			write_dirty_buffer(bh, 0);
 			spin_lock(lock);
 		}
 		put_bh(bh);
@@ -1054,7 +1054,7 @@ static int flush_commit_list(struct supe
 		if (tbh) {
 			if (buffer_dirty(tbh)) {
 		            depth = reiserfs_write_unlock_nested(s);
-			    ll_rw_block(REQ_OP_WRITE, 1, &tbh);
+			    write_dirty_buffer(tbh, 0);
 			    reiserfs_write_lock_nested(s, depth);
 			}
 			put_bh(tbh) ;
@@ -2240,7 +2240,7 @@ abort_replay:
 		}
 	}
 	/* read in the log blocks, memcpy to the corresponding real block */
-	ll_rw_block(REQ_OP_READ, get_desc_trans_len(desc), log_blocks);
+	bh_read_batch(get_desc_trans_len(desc), log_blocks);
 	for (i = 0; i < get_desc_trans_len(desc); i++) {
 
 		wait_on_buffer(log_blocks[i]);
@@ -2342,10 +2342,11 @@ static struct buffer_head *reiserfs_brea
 		} else
 			bhlist[j++] = bh;
 	}
-	ll_rw_block(REQ_OP_READ, j, bhlist);
+	bh = bhlist[0];
+	bh_read_nowait(bh, 0);
+	bh_readahead_batch(j - 1, &bhlist[1], 0);
 	for (i = 1; i < j; i++)
 		brelse(bhlist[i]);
-	bh = bhlist[0];
 	wait_on_buffer(bh);
 	if (buffer_uptodate(bh))
 		return bh;
--- a/fs/reiserfs/stree.c~reiserfs-replace-ll_rw_block
+++ a/fs/reiserfs/stree.c
@@ -579,7 +579,7 @@ static int search_by_key_reada(struct su
 		if (!buffer_uptodate(bh[j])) {
 			if (depth == -1)
 				depth = reiserfs_write_unlock_nested(s);
-			ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, bh + j);
+			bh_readahead(bh[j], REQ_RAHEAD);
 		}
 		brelse(bh[j]);
 	}
@@ -685,7 +685,7 @@ int search_by_key(struct super_block *sb
 			if (!buffer_uptodate(bh) && depth == -1)
 				depth = reiserfs_write_unlock_nested(sb);
 
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			wait_on_buffer(bh);
 
 			if (depth != -1)
--- a/fs/reiserfs/super.c~reiserfs-replace-ll_rw_block
+++ a/fs/reiserfs/super.c
@@ -1702,9 +1702,7 @@ static int read_super_block(struct super
 /* after journal replay, reread all bitmap and super blocks */
 static int reread_meta_blocks(struct super_block *s)
 {
-	ll_rw_block(REQ_OP_READ, 1, &SB_BUFFER_WITH_SB(s));
-	wait_on_buffer(SB_BUFFER_WITH_SB(s));
-	if (!buffer_uptodate(SB_BUFFER_WITH_SB(s))) {
+	if (bh_read(SB_BUFFER_WITH_SB(s), 0) < 0) {
 		reiserfs_warning(s, "reiserfs-2504", "error reading the super");
 		return 1;
 	}
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


