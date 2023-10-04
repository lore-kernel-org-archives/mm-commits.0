Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84529E7C4F5
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:22:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244756AbjJDUWv (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244924AbjJDUW2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1691734
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:21:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEC6C433C8;
        Wed,  4 Oct 2023 20:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450894;
        bh=i3oWQjYqNeS/RrBOlzjgNi2/Aq7UgMZueABkYZWylzg=;
        h=Date:To:From:Subject:From;
        b=eJAeTvdblbR33aPyW+rVb4t1x1scymAeP/DKR7It7JJpV9oEyXXbd+2mqhjFCjCVS
         pfram6W/84JwINmEl/2zgQn4OWG5Yco6EwQhxN/nQQHJL1zqxAHoinbS6K1qHLKNMf
         YIA4+GFL9EhjncuRAKeX7YV+NbJYIs19jd56uNrk=
Date:   Wed, 04 Oct 2023 13:21:33 -0700
To:     mm-commits@vger.kernel.org, teawater@antgroup.com,
        willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] buffer-convert-sb_getblk-to-call-__getblk.patch removed from -mm tree
Message-Id: <20231004202134.9FEC6C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: buffer: convert sb_getblk() to call __getblk()
has been removed from the -mm tree.  Its filename was
     buffer-convert-sb_getblk-to-call-__getblk.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -362,13 +362,12 @@ static inline struct buffer_head *__getb
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

mm-make-lock_folio_maybe_drop_mmap-vma-lock-aware.patch
mm-call-wp_page_copy-under-the-vma-lock.patch
mm-handle-shared-faults-under-the-vma-lock.patch
mm-handle-cow-faults-under-the-vma-lock.patch
mm-handle-read-faults-under-the-vma-lock.patch
mm-handle-write-faults-to-ro-pages-under-the-vma-lock.patch

