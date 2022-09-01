Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BEEECAAD1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbiIATGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233456AbiIATGr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222D46F552
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1CA061D96
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F3C433C1;
        Thu,  1 Sep 2022 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059204;
        bh=jgogvp0DDnJP9Fn6QUxLw4BshDHNVPDKeGJMONG5SSc=;
        h=Date:To:From:Subject:From;
        b=FvwdeOYDi3SJkq8PWOyx7lqhkCquyB4wKOSV6LOOoqPE4hBoRbTN+VByMeC4B1tFc
         z3ahcjkeeYgcyqzB49ojxI391S6X6jLHxe5LM5Fmg+BkeEGq+LzIzAHIE4Q8izUOJ4
         kGHjsfjCOySYidK4wVEeA18VX9WrYeKU8lEgQfuw=
Date:   Thu, 01 Sep 2022 12:06:43 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + jbd2-replace-ll_rw_block.patch added to mm-unstable branch
Message-Id: <20220901190644.016F3C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: jbd2: replace ll_rw_block()
has been added to the -mm mm-unstable branch.  Its filename is
     jbd2-replace-ll_rw_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/jbd2-replace-ll_rw_block.patch

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

