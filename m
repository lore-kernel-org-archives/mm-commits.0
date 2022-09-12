Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19A4AECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiILDe7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiILDdj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E077E29C99
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43FAEB80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC2FC433C1;
        Mon, 12 Sep 2022 03:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953435;
        bh=gctFFxVWG9IGzFUGjTr4vbdoO05yRT9LwQYhMUQGNdY=;
        h=Date:To:From:Subject:From;
        b=ynQ53vx1yMwYvnX4Mrmkk4UkPWuMWB4G5Tg1ncSqdF6Vu5/aduGkg1r5EfFm+HdgV
         HQ/2apQoaUHG3f7cmwF8t2riVixudM8W6a2s3KDQXULuMesqKq+2fm3/yWu0c4abW8
         4jutEr7ERe2W+p+iAb9dCKzVx5o/xVTEut3Vbrp0=
Date:   Sun, 11 Sep 2022 20:30:34 -0700
To:     mm-commits@vger.kernel.org, hch@lst.de, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] udf-replace-ll_rw_block.patch removed from -mm tree
Message-Id: <20220912033034.EFC2FC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: udf: replace ll_rw_block()
has been removed from the -mm tree.  Its filename was
     udf-replace-ll_rw_block.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: udf: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:35:01 +0800

ll_rw_block() is not safe for the sync read path because it cannot
guarantee that submitting read IO if the buffer has been locked. We
could get false positive EIO after wait_on_buffer() if the buffer has
been locked by others. So stop using ll_rw_block(). We also switch to
new bh_readahead_batch() helper for the buffer array readahead path.

Link: https://lkml.kernel.org/r/20220901133505.2510834-11-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/dir.c       |    2 +-
 fs/udf/directory.c |    2 +-
 fs/udf/inode.c     |    8 +-------
 3 files changed, 3 insertions(+), 9 deletions(-)

--- a/fs/udf/dir.c~udf-replace-ll_rw_block
+++ a/fs/udf/dir.c
@@ -130,7 +130,7 @@ static int udf_readdir(struct file *file
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
--- a/fs/udf/directory.c~udf-replace-ll_rw_block
+++ a/fs/udf/directory.c
@@ -89,7 +89,7 @@ struct fileIdentDesc *udf_fileident_read
 					brelse(tmp);
 			}
 			if (num) {
-				ll_rw_block(REQ_OP_READ | REQ_RAHEAD, num, bha);
+				bh_readahead_batch(num, bha, REQ_RAHEAD);
 				for (i = 0; i < num; i++)
 					brelse(bha[i]);
 			}
--- a/fs/udf/inode.c~udf-replace-ll_rw_block
+++ a/fs/udf/inode.c
@@ -1211,13 +1211,7 @@ struct buffer_head *udf_bread(struct ino
 	if (!bh)
 		return NULL;
 
-	if (buffer_uptodate(bh))
-		return bh;
-
-	ll_rw_block(REQ_OP_READ, 1, &bh);
-
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
+	if (bh_read(bh, 0) >= 0)
 		return bh;
 
 	brelse(bh);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


