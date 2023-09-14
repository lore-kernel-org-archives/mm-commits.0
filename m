Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B901EEAA52
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241611AbjINQGp (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbjINQGk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBF41FC0
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:36 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4A5C433C8;
        Thu, 14 Sep 2023 16:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707595;
        bh=oH/T1/OjIkz8FuOYZVk2WQnD4XslrsL+amB30Rgkwp0=;
        h=Date:To:From:Subject:From;
        b=FfyBq+LiXSog4YpgnacpAsYSIaVlOQ0kSq0mrGGcXE2fH54Gbf9LkbrIEm8fypdFj
         t9L+9Mdizdx1s6PTZzIcFntNtT2Rq8gx05c8JTf8BFhrNzV1MQhKa3+YHVXN66mSkX
         wX76UeZOy1qNm4y5if7MnuG8zJPr7zl0sT3aeDXc=
Date:   Thu, 14 Sep 2023 09:06:35 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch added to mm-unstable branch
Message-Id: <20230914160635.BA4A5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: use bdev_getblk() to avoid memory reclaim in readahead path
has been added to the -mm mm-unstable branch.  Its filename is
     ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

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

mm-convert-dax-lock-unlock-page-to-lock-unlock-folio.patch
buffer-pass-gfp-flags-to-folio_alloc_buffers.patch
buffer-hoist-gfp-flags-from-grow_dev_page-to-__getblk_gfp.patch
ext4-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch
buffer-convert-getblk_unmovable-and-__getblk-to-use-bdev_getblk.patch
buffer-convert-sb_getblk-to-call-__getblk.patch
ext4-call-bdev_getblk-from-sb_getblk_gfp.patch
buffer-remove-__getblk_gfp.patch

