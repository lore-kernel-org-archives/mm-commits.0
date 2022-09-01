Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A568EECAAD3
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiIATGn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbiIATGj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBBE6DF85
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A0F461D9A
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE650C433C1;
        Thu,  1 Sep 2022 19:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059197;
        bh=yX+oFWWrp8NxiCEpUdi9Zb+D0yKghYnnjmWIhDyD2uY=;
        h=Date:To:From:Subject:From;
        b=GNuVmtH+v6erA4dYsbtG2F9WHq+zbVlUtZ7xa51pBiv4B2keB0jXvgCunYnOJZUhh
         9kDvbzGCt57ynHG/yWbBTuLcQltkqvqlpgESt100/OpkFeHrKFoqHR1iPvhUQLrvWJ
         5kAO7yQDZmerX+/Ucb1v+izjgfIkF4zk/hnAUi44=
Date:   Thu, 01 Sep 2022 12:06:36 -0700
To:     mm-commits@vger.kernel.org, jack@suse.cz, yi.zhang@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-replace-ll_rw_block.patch added to mm-unstable branch
Message-Id: <20220901190637.BE650C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: replace ll_rw_block()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-replace-ll_rw_block.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-replace-ll_rw_block.patch

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
Subject: fs/buffer: replace ll_rw_block()
Date: Thu, 1 Sep 2022 21:34:54 +0800

ll_rw_block() is not safe for the sync IO path because it skip buffers
which has been locked by others, it could lead to false positive EIO
when submitting read IO. So stop using ll_rw_block(), switch to use new
helpers which could guarantee buffer locked and submit IO if needed.

Link: https://lkml.kernel.org/r/20220901133505.2510834-4-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/fs/buffer.c~fs-buffer-replace-ll_rw_block
+++ a/fs/buffer.c
@@ -562,7 +562,7 @@ void write_boundary_block(struct block_d
 	struct buffer_head *bh = __find_get_block(bdev, bblock + 1, blocksize);
 	if (bh) {
 		if (buffer_dirty(bh))
-			ll_rw_block(REQ_OP_WRITE, 1, &bh);
+			write_dirty_buffer(bh, 0);
 		put_bh(bh);
 	}
 }
@@ -1342,7 +1342,7 @@ void __breadahead(struct block_device *b
 {
 	struct buffer_head *bh = __getblk(bdev, block, size);
 	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
+		bh_readahead(bh, REQ_RAHEAD);
 		brelse(bh);
 	}
 }
@@ -2022,7 +2022,7 @@ int __block_write_begin_int(struct folio
 		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
 		    !buffer_unwritten(bh) &&
 		     (block_start < from || block_end > to)) {
-			ll_rw_block(REQ_OP_READ, 1, &bh);
+			bh_read_nowait(bh, 0);
 			*wait_bh++=bh;
 		}
 	}
@@ -2582,11 +2582,9 @@ int block_truncate_page(struct address_s
 		set_buffer_uptodate(bh);
 
 	if (!buffer_uptodate(bh) && !buffer_delay(bh) && !buffer_unwritten(bh)) {
-		err = -EIO;
-		ll_rw_block(REQ_OP_READ, 1, &bh);
-		wait_on_buffer(bh);
+		err = bh_read(bh, 0);
 		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
+		if (err < 0)
 			goto unlock;
 	}
 
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

