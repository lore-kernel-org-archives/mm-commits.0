Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72AFDE7C4F4
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244779AbjJDUWw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244931AbjJDUW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6975C1736
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:37 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB5E5C433C8;
        Wed,  4 Oct 2023 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450897;
        bh=HBsLyOPe//FpRkPQbwQVCiT2dB8WkJKhi0iVvvq+3jk=;
        h=Date:To:From:Subject:From;
        b=iHk7J2aZalhcGeE8bi0zBbvQrkADGLsbcEUocrlgm6kaIftUlcQjICBQeD4XO/wlO
         iZgOidZH1WHdw2D3w70cprkSNkgPdiZt6fdI7Gr3uWrKi287cIHI72YtnUeYBlA41C
         2sjAyPQPbV1e7LYB8uvMouPyHoKeDyn7uJUMihyw=
Date:   Wed, 04 Oct 2023 13:21:35 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] ext4-call-bdev_getblk-from-sb_getblk_gfp.patch removed from -mm tree
Message-Id: <20231004202136.BB5E5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ext4: call bdev_getblk() from sb_getblk_gfp()
has been removed from the -mm tree.  Its filename was
     ext4-call-bdev_getblk-from-sb_getblk_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: ext4: call bdev_getblk() from sb_getblk_gfp()
Date: Thu, 14 Sep 2023 16:00:10 +0100

Most of the callers of sb_getblk_gfp() already assumed that they were
passing the entire GFP flags to use.  Fix up the two callers that didn't,
and remove the __GFP_NOFAIL from them since they both appear to correctly
handle failure.

Link: https://lkml.kernel.org/r/20230914150011.843330-8-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/super.c             |   10 ++++++++--
 include/linux/buffer_head.h |    6 +++---
 2 files changed, 11 insertions(+), 5 deletions(-)

--- a/fs/ext4/super.c~ext4-call-bdev_getblk-from-sb_getblk_gfp
+++ a/fs/ext4/super.c
@@ -244,13 +244,19 @@ static struct buffer_head *__ext4_sb_bre
 struct buffer_head *ext4_sb_bread(struct super_block *sb, sector_t block,
 				   blk_opf_t op_flags)
 {
-	return __ext4_sb_bread_gfp(sb, block, op_flags, __GFP_MOVABLE);
+	gfp_t gfp = mapping_gfp_constraint(sb->s_bdev->bd_inode->i_mapping,
+			~__GFP_FS) | __GFP_MOVABLE;
+
+	return __ext4_sb_bread_gfp(sb, block, op_flags, gfp);
 }
 
 struct buffer_head *ext4_sb_bread_unmovable(struct super_block *sb,
 					    sector_t block)
 {
-	return __ext4_sb_bread_gfp(sb, block, 0, 0);
+	gfp_t gfp = mapping_gfp_constraint(sb->s_bdev->bd_inode->i_mapping,
+			~__GFP_FS);
+
+	return __ext4_sb_bread_gfp(sb, block, 0, gfp);
 }
 
 void ext4_sb_breadahead_unmovable(struct super_block *sb, sector_t block)
--- a/include/linux/buffer_head.h~ext4-call-bdev_getblk-from-sb_getblk_gfp
+++ a/include/linux/buffer_head.h
@@ -368,10 +368,10 @@ static inline struct buffer_head *sb_get
 	return __getblk(sb->s_bdev, block, sb->s_blocksize);
 }
 
-static inline struct buffer_head *
-sb_getblk_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
+static inline struct buffer_head *sb_getblk_gfp(struct super_block *sb,
+		sector_t block, gfp_t gfp)
 {
-	return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, gfp);
+	return bdev_getblk(sb->s_bdev, block, sb->s_blocksize, gfp);
 }
 
 static inline struct buffer_head *
_

Patches currently in -mm which might be from willy@infradead.org are

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

