Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B618CEEAA52
	for <mm-commits@archiver.kernel.org>; Thu, 14 Sep 2023 16:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241582AbjINQGv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 14 Sep 2023 12:06:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbjINQGp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 14 Sep 2023 12:06:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2A01BE1
        for <mm-commits@vger.kernel.org>; Thu, 14 Sep 2023 09:06:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ECEC433C8;
        Thu, 14 Sep 2023 16:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694707601;
        bh=WHpK7iIs7PIftgL8GDnfX0suIZ96GbWE5laHRxrlD7s=;
        h=Date:To:From:Subject:From;
        b=gXEo8+uBA8QWZeEtUGcgskBflPHTxpn8eA8rmMjOFKDflAj6TXlO1G9mqyKzlZkLz
         c2MzwVWvzOS2nDyjExYnuCJ4JPmAZzaIqziwIft83s5XcEi8RrAiLAtIeK5GRHa4zn
         6way6aBnyHbgK0aVeWByErdZCaBaUWGNlnScaKLI=
Date:   Thu, 14 Sep 2023 09:06:40 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + buffer-convert-sb_getblk-to-call-__getblk.patch added to mm-unstable branch
Message-Id: <20230914160641.40ECEC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: buffer: convert sb_getblk() to call __getblk()
has been added to the -mm mm-unstable branch.  Its filename is
     buffer-convert-sb_getblk-to-call-__getblk.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/buffer-convert-sb_getblk-to-call-__getblk.patch

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
Subject: buffer: convert sb_getblk() to call __getblk()
Date: Thu, 14 Sep 2023 16:00:09 +0100

Now that __getblk() is in the right place in the file, it is trivial to
call it from sb_getblk().

Link: https://lkml.kernel.org/r/20230914150011.843330-7-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hui Zhu <teawater@antgroup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/buffer_head.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/include/linux/buffer_head.h~buffer-convert-sb_getblk-to-call-__getblk
+++ a/include/linux/buffer_head.h
@@ -359,13 +359,12 @@ static inline struct buffer_head *__getb
 	return bdev_getblk(bdev, block, size, gfp);
 }
 
-static inline struct buffer_head *
-sb_getblk(struct super_block *sb, sector_t block)
+static inline struct buffer_head *sb_getblk(struct super_block *sb,
+		sector_t block)
 {
-	return __getblk_gfp(sb->s_bdev, block, sb->s_blocksize, __GFP_MOVABLE);
+	return __getblk(sb->s_bdev, block, sb->s_blocksize);
 }
 
-
 static inline struct buffer_head *
 sb_getblk_gfp(struct super_block *sb, sector_t block, gfp_t gfp)
 {
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

