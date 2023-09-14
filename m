Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A837EEAA55
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241578AbjINQGw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241630AbjINQGu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA2E1FD0
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB05C433CB;
        Thu, 14 Sep 2023 16:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707603;
        bh=r8iYqhVg2nTkeqo0GVC7Uao852pXF7bhYIGORvpyjtM=;
        h=Date:To:From:Subject:From;
        b=bV7CfOJeSLtnSrnMHjYSmSFYtZvNndZulAvjlqGqCxiwYPmP7HvCm8uuAUvQpfl0v
         XKYk4ZmstTSLWz2kCqGVg9juFsQuIZDZ4sj0PE5l4EGU6YUryaBtYQL7mkLBLeZRn6
         YIw4mQtkLXXMLJsOE4d+APY652Zo1ObVxOuIJXd4=
Date:   Thu, 14 Sep 2023 09:06:42 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-call-bdev_getblk-from-sb_getblk_gfp.patch added to mm-unstable branch
Message-Id: <20230914160642.EDB05C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: call bdev_getblk() from sb_getblk_gfp()
has been added to the -mm mm-unstable branch.  Its filename is
     ext4-call-bdev_getblk-from-sb_getblk_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-call-bdev_getblk-from-sb_getblk_gfp.patch

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
@@ -365,10 +365,10 @@ static inline struct buffer_head *sb_get
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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

