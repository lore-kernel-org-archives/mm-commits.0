Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D30E7C4F3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244662AbjJDUWr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244902AbjJDUW1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4B01728
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BD9DC433C7;
        Wed,  4 Oct 2023 20:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450888;
        bh=gaHHqdCxSIqTpaBZeIx0ym1WdO2XCsYDtmxldrJqLhk=;
        h=Date:To:From:Subject:From;
        b=hF6jRAm+K5SbYW7zaCd0GUFsWkB4nEMkVxQQTBhVsnxKEuTGPE4FJFgsevnUFnKf4
         oejupJ/XbdUead3Qox0dbWQJoAZOQQRMHYJtPqysluI6Fm8uoCo25STtg7tjzw1Qxr
         E9C0E0qWpPJ/y4voi70eVJXphvIAV8MKwW0gP6ig=
Date:   Wed, 04 Oct 2023 13:21:26 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch removed from -mm tree
Message-Id: <20231004202128.3BD9DC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: use bdev_getblk() to avoid memory reclaim in readahead path
has been removed from the -mm tree.  Its filename was
     ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ext4: use bdev_getblk() to avoid memory reclaim in readahead path
Date: Thu, 14 Sep 2023 16:00:06 +0100

sb_getblk_gfp adds __GFP_NOFAIL, which is unnecessary for readahead; we're
quite comfortable with the possibility that we may not get a bh back. 
Switch to bdev_getblk() which does not include __GFP_NOFAIL.

Link: https://lkml.kernel.org/r/20230914150011.843330-4-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Hui Zhu <teawater@antgroup.com>
Closes: https://lore.kernel.org/linux-fsdevel/20230811035705.3296-1-teawaterz@linux.alibaba.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/super.c~ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path
+++ a/fs/ext4/super.c
@@ -255,7 +255,8 @@ struct buffer_head *ext4_sb_bread_unmova
 
 void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
 {
-	struct buffer_head *bh = sb_getblk_gfp(sb, block, 0);
+	struct buffer_head *bh = bdev_getblk(sb->s_bdev, block,
+			sb->s_blocksize, GFP_NOWAIT);
 
 	if (likely(bh)) {
 		if (trylock_buffer(bh))
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

