Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60F92C7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjFJA2N (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232076AbjFJA2M (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:28:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E871734
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:28:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4193649D0
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:28:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 159B5C433D2;
        Sat, 10 Jun 2023 00:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356890;
        bh=8Hme9lMKcrsWsFYCzB3T3dRX2ktrVbON47J5PLC/Kcc=;
        h=Date:To:From:Subject:From;
        b=vJwujQ2tAbUiMqTn9uQxFx1K9fK0uHXZukDaAfocisuUjfhj+jN1I3zLe+rWHab0f
         M3Qkku4+LteD1qA0Lfd/EzbSUo1ZzS+RYdFcP81lrjWiqB4DJ7sNGlCvoUgSAs6u5P
         Hydr8lSnihgy++pn6c2uQbncoQKEJiHYp9wV1YP4=
Date:   Fri, 09 Jun 2023 17:28:09 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk, hch@lst.de,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-cache-partial-compressed-blocks-fix-2.patch removed from -mm tree
Message-Id: <20230610002810.159B5C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix page update race
has been removed from the -mm tree.  Its filename was
     squashfs-cache-partial-compressed-blocks-fix-2.patch

This patch was dropped because it was folded into squashfs-cache-partial-compressed-blocks.patch

------------------------------------------------------
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: fix page update race
Date: Fri, 26 May 2023 15:25:45 +0200

We only put the page into the cache after we've read it, so the
PageUptodate() check should not be necessary.  In fact, it's actively
harmful since the check could fail (since we used find_get_page() and not
find_lock_page()) and we could end up submitting a page for I/O after it
has been read and while it's actively being used, which could lead to
corruption depending on what the block driver does with it.

Link: https://lkml.kernel.org/r/20230526-squashfs-cache-fixup-v1-1-d54a7fa23e7b@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix-2
+++ a/fs/squashfs/block.c
@@ -92,7 +92,7 @@ static int squashfs_bio_read_cached(stru
 	bio_for_each_segment_all(bv, fullbio, iter_all) {
 		struct page *page = bv->bv_page;
 
-		if (page->mapping == cache_mapping && PageUptodate(page)) {
+		if (page->mapping == cache_mapping) {
 			idx++;
 			continue;
 		}
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

squashfs-cache-partial-compressed-blocks.patch
squashfs-cache-partial-compressed-blocks-fix-3.patch

