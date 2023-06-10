Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4399DC7EE25
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbjFJA2R (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFJA2O (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE992D46
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 211F26486A
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7807DC433D2;
        Sat, 10 Jun 2023 00:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356892;
        bh=0d6ol0c04aIO/+rcenFrvzXYSarreA4z4+wvJcTLCrQ=;
        h=Date:To:From:Subject:From;
        b=Wo7yLtjEDImp242WanW4FNx8XLuYSDHzqdW57k6CN96wC5O9jdzjSrlSSxnDlWD0E
         mRbvadFBxmkzpfTg8bTMOepNL3JGSiGNUL82Z+eFb2J2R7ypi/OSknGCTuv5mJVzDc
         gPYvlZH8tJdNWV+GXnfPzztXDJ/dn/9dMll6OZhA=
Date:   Fri, 09 Jun 2023 17:28:11 -0700
To:     mm-commits@vger.kernel.org, vincent.whitchurch@axis.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-cache-partial-compressed-blocks-fix-3-fix.patch removed from -mm tree
Message-Id: <20230610002812.7807DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs-cache-partial-compressed-blocks-fix-3-fix
has been removed from the -mm tree.  Its filename was
     squashfs-cache-partial-compressed-blocks-fix-3-fix.patch

This patch was dropped because it was folded into squashfs-cache-partial-compressed-blocks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-cache-partial-compressed-blocks-fix-3-fix
Date: Fri May 26 10:55:48 AM PDT 2023

fix layout, per hch

Cc: Christoph Hellwig <hch@lst.de>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix-3-fix
+++ a/fs/squashfs/block.c
@@ -142,7 +142,8 @@ static int squashfs_bio_read_cached(stru
 
 	if (head_to_cache) {
 		int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
-						read_start >> PAGE_SHIFT, GFP_NOIO);
+						read_start >> PAGE_SHIFT,
+						GFP_NOIO);
 
 		if (!ret) {
 			SetPageUptodate(head_to_cache);
@@ -153,7 +154,8 @@ static int squashfs_bio_read_cached(stru
 
 	if (tail_to_cache) {
 		int ret = add_to_page_cache_lru(tail_to_cache, cache_mapping,
-						(read_end >> PAGE_SHIFT) - 1, GFP_NOIO);
+						(read_end >> PAGE_SHIFT) - 1,
+						GFP_NOIO);
 
 		if (!ret) {
 			SetPageUptodate(tail_to_cache);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
squashfs-cache-partial-compressed-blocks.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

