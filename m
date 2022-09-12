Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D605C6FA8A
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiILDem (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiILDdO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:33:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A496E26541
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42D4A61178
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7BFC433D6;
        Mon, 12 Sep 2022 03:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953424;
        bh=GUxneq2NqCjy5lzqZdTNXLDp4toQQO/UnaIbpAm0WFk=;
        h=Date:To:From:Subject:From;
        b=v5SWOr9SZsG+PL35oiYD7TeOEs4y8+NV6i4iDtDThNVFzBF9Q3nRPXR2VsJy6EeX/
         t4ocFAnWe8+8LBcMfFL8NKf45yCEH2u2m7ITvTpOUHtjCZ/xF1D9wklZclTHr2NifU
         9HzYGaQnHXNFYKBs7h3pN4LQPBEdARW8aeDQn5w0=
Date:   Sun, 11 Sep 2022 20:30:23 -0700
To:     mm-commits@vger.kernel.org, yukuai3@huawei.com,
        viro@zeniv.linux.org.uk, tytso@mit.edu, rpeterso@redhat.com,
        ocfs2-devel@oss.oracle.com, mark@fasheh.com, jack@suse.cz,
        hch@lst.de, dushistov@mail.ru, chengzhihao1@huawei.com,
        axboe@kernel.dk, almaz.alexandrovich@paragon-software.com,
        agruenba@redhat.com, yi.zhang@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fs-buffer-remove-__breadahead_gfp.patch removed from -mm tree
Message-Id: <20220912033024.9C7BFC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fs/buffer: remove __breadahead_gfp()
has been removed from the -mm tree.  Its filename was
     fs-buffer-remove-__breadahead_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Bob Peterson <rpeterso@redhat.com>
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


