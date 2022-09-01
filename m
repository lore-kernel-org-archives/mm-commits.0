Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD0DECAAD1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Sep 2022 19:06:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbiIATGh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 1 Sep 2022 15:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiIATGg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Sep 2022 15:06:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47936D565
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 12:06:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FE3B825DC
        for <mm-commits@vger.kernel.org>; Thu,  1 Sep 2022 19:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40C1C433D6;
        Thu,  1 Sep 2022 19:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662059193;
        bh=jLsR0gVffekc5zyoaOCJ8zt6mbwl9WlIOG+HoD7ddyE=;
        h=Date:To:From:Subject:From;
        b=H7nEkIdrnJ5gmwfJgeTuyhxi2ZUTwxF4xon1fRq40GAlfKXB/Qtla2gKSJsRM44+E
         lrCNRmbQM5Q8V+w8KlGAhl8tZXCwx20v7TcWFh1mMsmNv6zdEJYzXi8g0l1uLdmChu
         BcAwR/qkYmQeQhEh9xOVPncqvZRRe/LF1sn3/LPM=
Date:   Thu, 01 Sep 2022 12:06:32 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        viro@zeniv.linux.org.uk, tytso@mit.edu, rpeterso@redhat.com,
        ocfs2-devel@oss.oracle.com, mark@fasheh.com, jack@suse.cz,
        hch@infradead.org, dushistov@mail.ru, chengzhihao1@huawei.com,
        axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
        agruenba@redhat.com, yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-buffer-remove-__breadahead_gfp.patch added to mm-unstable branch
Message-Id: <20220901190632.E40C1C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/buffer: remove __breadahead_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     fs-buffer-remove-__breadahead_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-buffer-remove-__breadahead_gfp.patch

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
Subject: fs/buffer: remove __breadahead_gfp()
Date: Thu, 1 Sep 2022 21:34:52 +0800

Patch series "fs/buffer: remove ll_rw_block()", v2.

ll_rw_block() will skip locked buffer before submitting IO, it assumes
that locked buffer means it is under IO.  This assumption is not always
true because we cannot guarantee every buffer lock path would submit IO. 
After commit 88dbcbb3a484 ("blkdev: avoid migration stalls for blkdev
pages"), buffer_migrate_folio_norefs() becomes one exceptional case, and
there may be others.  So ll_rw_block() is not safe on the sync read path,
we could get false positive EIO return value when filesystem reading
metadata.  It seems that it could be only used on the readahead path.

Unfortunately, many filesystem misuse the ll_rw_block() on the sync read
path.  This patch set just remove ll_rw_block() and add new friendly
helpers, which could prevent false positive EIO on the read metadata path.
Thanks for the suggestion from Jan, the original discussion is at [1].

 patch 1: remove unused helpers in fs/buffer.c
 patch 2: add new bh_read_[*] helpers
 patch 3-11: remove all ll_rw_block() calls in filesystems
 patch 12-14: do some leftover cleanups.

[1]. https://lore.kernel.org/linux-mm/20220825080146.2021641-1-chengzhihao1@huawei.com/


This patch (of 14):

No one use __breadahead_gfp() and sb_breadahead_unmovable() any more,
remove them.

Link: https://lkml.kernel.org/r/20220901133505.2510834-1-yi.zhang@huawei.com
Link: https://lkml.kernel.org/r/20220901133505.2510834-2-yi.zhang@huawei.com
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Heming Zhao <ocfs2-devel@oss.oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   11 -----------
 include/linux/buffer_head.h |    8 --------
 2 files changed, 19 deletions(-)

--- a/fs/buffer.c~fs-buffer-remove-__breadahead_gfp
+++ a/fs/buffer.c
@@ -1348,17 +1348,6 @@ void __breadahead(struct block_device *b
 }
 EXPORT_SYMBOL(__breadahead);
 
-void __breadahead_gfp(struct block_device *bdev, sector_t block, unsigned size,
-		      gfp_t gfp)
-{
-	struct buffer_head *bh = __getblk_gfp(bdev, block, size, gfp);
-	if (likely(bh)) {
-		ll_rw_block(REQ_OP_READ | REQ_RAHEAD, 1, &bh);
-		brelse(bh);
-	}
-}
-EXPORT_SYMBOL(__breadahead_gfp);
-
 /**
  *  __bread_gfp() - reads a specified block and returns the bh
  *  @bdev: the block_device to read from
--- a/include/linux/buffer_head.h~fs-buffer-remove-__breadahead_gfp
+++ a/include/linux/buffer_head.h
@@ -214,8 +214,6 @@ struct buffer_head *__getblk_gfp(struct
 void __brelse(struct buffer_head *);
 void __bforget(struct buffer_head *);
 void __breadahead(struct block_device *, sector_t block, unsigned int size);
-void __breadahead_gfp(struct block_device *, sector_t block, unsigned int size,
-		  gfp_t gfp);
 struct buffer_head *__bread_gfp(struct block_device *,
 				sector_t block, unsigned size, gfp_t gfp);
 void invalidate_bh_lrus(void);
@@ -340,12 +338,6 @@ sb_breadahead(struct super_block *sb, se
 	__breadahead(sb->s_bdev, block, sb->s_blocksize);
 }
 
-static inline void
-sb_breadahead_unmovable(struct super_block *sb, sector_t block)
-{
-	__breadahead_gfp(sb->s_bdev, block, sb->s_blocksize, 0);
-}
-
 static inline struct buffer_head *
 sb_getblk(struct super_block *sb, sector_t block)
 {
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

