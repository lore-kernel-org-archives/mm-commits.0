Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A73ECAAA1
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiILDft (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiILDds (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A402A24F
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB6AEB80C80
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D29C433D7;
        Mon, 12 Sep 2022 03:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953438;
        bh=RD2fg5Zg6qdwYDAIt2jYx8W9seAsJ+pat2RmJR9npn8=;
        h=Date:To:From:Subject:From;
        b=byRJXc8ihW3vtAjYeoZhiCeMgNb5KFZiX0KwsR83QDYnDJmYvOGLbLVOu8yKqGi0U
         wh3zRJLeFRant63CZsf0K6tDiobBblRSgZ0WZxD4Zs31SdC7w1MdglEBgUiN56vIQG
         ajWZHk0mJ3dCg5v9yNT7nPhWlu4at2vodODkPBNU=
Date:   Sun, 11 Sep 2022 20:30:37 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch removed from -mm tree
Message-Id: <20220912033038.59D29C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext2: replace bh_submit_read() helper with bh_read()
has been removed from the -mm tree.  Its filename was
     ext2-replace-bh_submit_read-helper-with-bh_read_locked.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: ext2: replace bh_submit_read() helper with bh_read()
Date: Thu, 1 Sep 2022 21:35:04 +0800

bh_submit_read() and the uptodate check logic in bh_uptodate_or_lock()
has been integrated in bh_read() helper, so switch to use it directly.

Link: https://lkml.kernel.org/r/20220901133505.2510834-14-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext2/balloc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/ext2/balloc.c~ext2-replace-bh_submit_read-helper-with-bh_read_locked
+++ a/fs/ext2/balloc.c
@@ -126,6 +126,7 @@ read_block_bitmap(struct super_block *sb
 	struct ext2_group_desc * desc;
 	struct buffer_head * bh = NULL;
 	ext2_fsblk_t bitmap_blk;
+	int ret;
 
 	desc = ext2_get_group_desc(sb, block_group, NULL);
 	if (!desc)
@@ -139,10 +140,10 @@ read_block_bitmap(struct super_block *sb
 			    block_group, le32_to_cpu(desc->bg_block_bitmap));
 		return NULL;
 	}
-	if (likely(bh_uptodate_or_lock(bh)))
+	ret = bh_read(bh, 0);
+	if (ret > 0)
 		return bh;
-
-	if (bh_submit_read(bh) < 0) {
+	if (ret < 0) {
 		brelse(bh);
 		ext2_error(sb, __func__,
 			    "Cannot read block bitmap - "
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


