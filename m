Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EE6ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiILDez (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbiILDdX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A4929820
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD063B80C7E
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFDCC433D7;
        Mon, 12 Sep 2022 03:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953430;
        bh=L76EmYCN1yo9hTssXhXRef8ydAE/M0Kk2PFRLdMflJw=;
        h=Date:To:From:Subject:From;
        b=oREx68pn1YIYgwpIwa0H6AG9gY6drWxV2Likm/C59LQ/m70WLTWm36aItO71DSy3y
         DVtpwxYR+blB/ErNnWQzqRkCmfm7mtLamNr3wlNdnxS4kwteG1ZbM8rqy6JO7YOEuu
         voT+a9Xu5WOZH2Bqu5q3SG+irQSMR2FFjAj5O35U=
Date:   Sun, 11 Sep 2022 20:30:29 -0700
To:     mm-commits@vger.kernel.org, tytso@mit.edu, jack@suse.cz,
        hch@lst.de, yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] jbd2-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033030.5FFDCC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: jbd2: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     jbd2-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: jbd2: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:57 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in
journal_get_superblock(). We also switch to new bh_readahead_batch()
for the buffer array readahead path.

Link: https://lkml.kernel.org/r/20220901133505.2510834-7-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/journal.c  |   15 ++++++---------
 fs/jbd2/recovery.c |   16 ++++++++++------
 2 files changed, 16 insertions(+), 15 deletions(-)

--- a/fs/jbd2/journal.c~jbd2-replace-ll_rw_block
+++ a/fs/jbd2/journal.c
@@ -1893,19 +1893,16 @@ static int journal_get_superblock(journa
 {
 	struct buffer_head *bh;
 	journal_superblock_t *sb;
-	int err = -EIO;
+	int err;
 
 	bh = journal->j_sb_buffer;
 
 	J_ASSERT(bh != NULL);
-	if (!buffer_uptodate(bh)) {
-		ll_rw_block(REQ_OP_READ, 1, &bh);
-		wait_on_buffer(bh);
-		if (!buffer_uptodate(bh)) {
-			printk(KERN_ERR
-				"JBD2: IO error reading journal superblock\n");
-			goto out;
-		}
+	err = bh_read(bh, 0);
+	if (err < 0) {
+		printk(KERN_ERR
+			"JBD2: IO error reading journal superblock\n");
+		goto out;
 	}
 
 	if (buffer_verified(bh))
--- a/fs/jbd2/recovery.c~jbd2-replace-ll_rw_block
+++ a/fs/jbd2/recovery.c
@@ -100,7 +100,7 @@ static int do_readahead(journal_t *journ
 		if (!buffer_uptodate(bh) && !buffer_locked(bh)) {
 			bufs[nbufs++] = bh;
 			if (nbufs == MAXBUF) {
-				ll_rw_block(REQ_OP_READ, nbufs, bufs);
+				bh_readahead_batch(nbufs, bufs, 0);
 				journal_brelse_array(bufs, nbufs);
 				nbufs = 0;
 			}
@@ -109,7 +109,7 @@ static int do_readahead(journal_t *journ
 	}
 
 	if (nbufs)
-		ll_rw_block(REQ_OP_READ, nbufs, bufs);
+		bh_readahead_batch(nbufs, bufs, 0);
 	err = 0;
 
 failed:
@@ -152,9 +152,14 @@ static int jread(struct buffer_head **bh
 		return -ENOMEM;
 
 	if (!buffer_uptodate(bh)) {
-		/* If this is a brand new buffer, start readahead.
-                   Otherwise, we assume we are already reading it.  */
-		if (!buffer_req(bh))
+		/*
+		 * If this is a brand new buffer, start readahead.
+		 * Otherwise, we assume we are already reading it.
+		 */
+		bool need_readahead = !buffer_req(bh);
+
+		bh_read_nowait(bh, 0);
+		if (need_readahead)
 			do_readahead(journal, offset);
 		wait_on_buffer(bh);
 	}
@@ -687,7 +692,6 @@ static int do_one_pass(journal_t *journa
 					mark_buffer_dirty(nbh);
 					BUFFER_TRACE(nbh, "marking uptodate");
 					++info->nr_replays;
-					/* ll_rw_block(WRITE, 1, &nbh); */
 					unlock_buffer(nbh);
 					brelse(obh);
 					brelse(nbh);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


