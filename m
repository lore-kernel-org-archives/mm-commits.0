Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B98DC54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiILDfv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiILDdt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E67C2A259
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C48B7B80C74
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F952C433D6;
        Mon, 12 Sep 2022 03:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953439;
        bh=C3jltn02aNrgJ1LQIQbmzLo6SzitjrpEx3mpmf09YqA=;
        h=Date:To:From:Subject:From;
        b=rDoPo0pEPJxzIorRpYpRuxDKFzczHDakn1taj5wyNvBW84nfhblmQK+GLlKb6JX9x
         iguzYr1x0YHoiJCn0BIgfKB31w7oBRCBDEHtUQw1x+0nI9XXAvgLNVcFulZKlV1mCP
         n0tT7Ep3pRa9FStozRa+TxtttJjmQlBVqtgZVDrA=
Date:   Sun, 11 Sep 2022 20:30:38 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, hch@lst.de,
        yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-remove-bh_submit_read-helper.patch removed from -mm tree
Message-Id: <20220912033039.7F952C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: remove bh_submit_read() helper
has been removed from the -mm tree.  Its filename was
     fs-buffer-remove-bh_submit_read-helper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhang Yi <yi.zhang@huawei.com>
Subject: fs/buffer: remove bh_submit_read() helper
Date: Thu, 1 Sep 2022 21:35:05 +0800

bh_submit_read() has no user anymore, just remove it.

Link: https://lkml.kernel.org/r/20220901133505.2510834-15-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   25 -------------------------
 include/linux/buffer_head.h |    1 -
 2 files changed, 26 deletions(-)

--- a/fs/buffer.c~fs-buffer-remove-bh_submit_read-helper
+++ a/fs/buffer.c
@@ -3025,31 +3025,6 @@ void __bh_read_batch(int nr, struct buff
 }
 EXPORT_SYMBOL(__bh_read_batch);
 
-/**
- * bh_submit_read - Submit a locked buffer for reading
- * @bh: struct buffer_head
- *
- * Returns zero on success and -EIO on error.
- */
-int bh_submit_read(struct buffer_head *bh)
-{
-	BUG_ON(!buffer_locked(bh));
-
-	if (buffer_uptodate(bh)) {
-		unlock_buffer(bh);
-		return 0;
-	}
-
-	get_bh(bh);
-	bh->b_end_io = end_buffer_read_sync;
-	submit_bh(REQ_OP_READ, bh);
-	wait_on_buffer(bh);
-	if (buffer_uptodate(bh))
-		return 0;
-	return -EIO;
-}
-EXPORT_SYMBOL(bh_submit_read);
-
 void __init buffer_init(void)
 {
 	unsigned long nrpages;
--- a/include/linux/buffer_head.h~fs-buffer-remove-bh_submit_read-helper
+++ a/include/linux/buffer_head.h
@@ -230,7 +230,6 @@ int submit_bh(blk_opf_t, struct buffer_h
 void write_boundary_block(struct block_device *bdev,
 			sector_t bblock, unsigned blocksize);
 int bh_uptodate_or_lock(struct buffer_head *bh);
-int bh_submit_read(struct buffer_head *bh);
 int __bh_read(struct buffer_head *bh, blk_opf_t op_flags, bool wait);
 void __bh_read_batch(int nr, struct buffer_head *bhs[],
 		     blk_opf_t op_flags, bool force_lock);
_

Patches currently in -mm which might be from yi.zhang@huawei.com are


