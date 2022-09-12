Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2EDECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiILDe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiILDd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0642982B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5293A611AD
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C27C433D7;
        Mon, 12 Sep 2022 03:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953432;
        bh=2bgLZHmv2QHEG1/0nGdUjFPIfKW3Jd17APhBPr4NXvI=;
        h=Date:To:From:Subject:From;
        b=pVQVzGzovx1Xfd2Bj0Q5DwyP0XSgUgGgosYQtcQdlAcuUM//s6cfOnZmhnTF194ub
         +kePnSiKRkikElMo6Wo+7SDFLJPA2NXNDivT7YGM+LXCmV027VbfN2NF3GnuMea1Zh
         +SYg7xZDGEa9UvcV7XuZzglAlcYssSioVa1JYxJc=
Date:   Sun, 11 Sep 2022 20:30:32 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ocfs2-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033032.A8C27C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ocfs2: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     ocfs2-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: ocfs2: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:59 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block() in ocfs2.

Link: https://lkml.kernel.org/r/20220901133505.2510834-9-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c  |    2 +-
 fs/ocfs2/super.c |    4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/aops.c~ocfs2-replace-ll_rw_block
+++ a/fs/ocfs2/aops.c
@@ -636,7 +636,7 @@ int ocfs2_map_page_blocks(struct page *p
 			   !buffer_new(bh) &&
 			   ocfs2_should_read_blk(inode, page, block_start) &&
 			   (block_start < from || block_end > to)) {
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
 		}
 
--- a/fs/ocfs2/super.c~ocfs2-replace-ll_rw_block
+++ a/fs/ocfs2/super.c
@@ -1764,9 +1764,7 @@ static int ocfs2_get_sector(struct super
 	if (!buffer_dirty(*bh))
 		clear_buffer_uptodate(*bh);
 	unlock_buffer(*bh);
-	ll_rw_block(REQ_OP_READ, 1, bh);
-	wait_on_buffer(*bh);
-	if (!buffer_uptodate(*bh)) {
+	if (bh_read(*bh, 0) < 0) {
 		mlog_errno(-EIO);
 		brelse(*bh);
 		*bh = NULL;
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


