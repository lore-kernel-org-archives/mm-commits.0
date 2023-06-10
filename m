Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1F4C7EE29
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbjFJA2R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbjFJA2N (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:28:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ACDBF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:28:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 01940649E2
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:28:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C13C433EF;
        Sat, 10 Jun 2023 00:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356891;
        bh=+KLLWWtTrl9UPtOmyW4wcLL9DQmTSphp25pW+aJsFkI=;
        h=Date:To:From:Subject:From;
        b=i5RtVVfQ2s6efxRwv7RSj7kjVu82gEusPmctrEGMETlApD8TZoWT1mUUgBVD4tkDN
         rav+cAXBIoQ8M6+XZ2WGKlZhfN6rAsimqOzIvcRQ668J5sf/S5sPAR440o+v3UBPSp
         rST90FVFfto2VtmBbVieBNJqvydKKoN8u3p9a4H4=
Date:   Fri, 09 Jun 2023 17:28:10 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk, hch@lst.de,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-cache-partial-compressed-blocks-fix-3.patch removed from -mm tree
Message-Id: <20230610002811.53C13C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs: fix page indices
has been removed from the -mm tree.  Its filename was
     squashfs-cache-partial-compressed-blocks-fix-3.patch

This patch was dropped because it was folded into squashfs-cache-partial-compressed-blocks.patch

------------------------------------------------------
From: Vincent Whitchurch <vincent.whitchurch@axis.com>
Subject: squashfs: fix page indices
Date: Fri, 26 May 2023 15:25:46 +0200

The page cache functions want the page index as an argument but we're
currently passing in the byte address.

Link: https://lkml.kernel.org/r/20230526-squashfs-cache-fixup-v1-2-d54a7fa23e7b@axis.com
Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix-3
+++ a/fs/squashfs/block.c
@@ -142,7 +142,7 @@ static int squashfs_bio_read_cached(stru
 
 	if (head_to_cache) {
 		int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
-						read_start, GFP_NOIO);
+						read_start >> PAGE_SHIFT, GFP_NOIO);
 
 		if (!ret) {
 			SetPageUptodate(head_to_cache);
@@ -153,7 +153,7 @@ static int squashfs_bio_read_cached(stru
 
 	if (tail_to_cache) {
 		int ret = add_to_page_cache_lru(tail_to_cache, cache_mapping,
-						read_end - PAGE_SIZE, GFP_NOIO);
+						(read_end >> PAGE_SHIFT) - 1, GFP_NOIO);
 
 		if (!ret) {
 			SetPageUptodate(tail_to_cache);
@@ -192,7 +192,7 @@ static int squashfs_bio_read(struct supe
 
 		if (cache_mapping)
 			page = find_get_page(cache_mapping,
-					     read_start + i * PAGE_SIZE);
+					     (read_start >> PAGE_SHIFT) + i);
 		if (!page)
 			page = alloc_page(GFP_NOIO);
 
_

Patches currently in -mm which might be from vincent.whitchurch@axis.com are

squashfs-cache-partial-compressed-blocks.patch

