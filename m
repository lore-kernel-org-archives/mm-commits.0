Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27EFCEEAA53
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241560AbjINQGq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241579AbjINQGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A521FD6
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97CDC433AD;
        Thu, 14 Sep 2023 16:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707597;
        bh=3YWGRr9RkNIPtWgfOEbFgF363Wv4o3l3tyWy5qY0eO8=;
        h=Date:To:From:Subject:From;
        b=j1YO4FzMJU1LJA2bKL8poU2uLS+LY3t8GUg6IheYpcZqz4p5QThhbXG/TKLkCHVGB
         yJYMhamQ64d3Uii08ZM3fXU8ithP/SF3vbzOdwzsPCM5s+I5xG6953HpuSGIYfhAnY
         ZzGvuaKstCDv1EyDPD40lhTJB255hakH6ACPibgY=
Date:   Thu, 14 Sep 2023 09:06:36 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch added to mm-unstable branch
Message-Id: <20230914160637.A97CDC433AD@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: use bdev_getblk() to avoid memory reclaim in readahead path
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path.patch

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
Subject: buffer: use bdev_getblk() to avoid memory reclaim in readahead path
Date: Thu, 14 Sep 2023 16:00:07 +0100

__getblk() adds __GFP_NOFAIL, which is unnecessary for readahead; we're
quite comfortable with the possibility that we may not get a bh back. 
Switch to bdev_getblk() which does not include __GFP_NOFAIL.

Link: https://lkml.kernel.org/r/20230914150011.843330-5-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/buffer.c~buffer-use-bdev_getblk-to-avoid-memory-reclaim-in-readahead-path
+++ a/fs/buffer.c
@@ -1464,7 +1464,9 @@ EXPORT_SYMBOL(__getblk_gfp);
  */
 void __breadahead(struct block_device *bdev, sector_t block, unsigned size)
 {
-	struct buffer_head *bh = __getblk(bdev, block, size);
+	struct buffer_head *bh = bdev_getblk(bdev, block, size,
+			GFP_NOWAIT | __GFP_MOVABLE);
+
 	if (likely(bh)) {
 		bh_readahead(bh, REQ_RAHEAD);
 		brelse(bh);
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

