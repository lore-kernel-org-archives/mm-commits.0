Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A35C7EE24
	for <mm-commits@archiver.kernel.org>; Tue, 30 May 2023 19:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjE3Tqk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 30 May 2023 15:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjE3Tqk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2023 15:46:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E98F9
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 12:46:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 623A1611E0
        for <mm-commits@vger.kernel.org>; Tue, 30 May 2023 19:46:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7455C433EF;
        Tue, 30 May 2023 19:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685475997;
        bh=tffpa2OYaFssIbXgH/Bx76HWNsqiEW3lgcFD9Hgc2o8=;
        h=Date:To:From:Subject:From;
        b=kRI9BT7nmrwYNZcDqJtQEDvSr/qq/HbAKkcXhxsM2N690cdQRH18BYgE5wu3wmLtU
         tp0xeSXrkY6yEBvT4UcFaIOM8NSPVO18KIZyXTYJhZMjDShvQOULDrPDX8IOpk7+lW
         oHEESfuFBEgyEySjCtnq6dpfOVw3RpAMb32GU6LY=
Date:   Tue, 30 May 2023 12:46:37 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk, hch@lst.de,
        vincent.whitchurch@axis.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-cache-partial-compressed-blocks-fix-3.patch added to mm-nonmm-unstable branch
Message-Id: <20230530194637.B7455C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs: fix page indices
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-cache-partial-compressed-blocks-fix-3.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-cache-partial-compressed-blocks-fix-3.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
squashfs-cache-partial-compressed-blocks-fix-2.patch
squashfs-cache-partial-compressed-blocks-fix-3.patch

