Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC238C77B7A
	for <mm-commits@archiver.kernel.org>; Fri, 26 May 2023 17:56:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjEZR4a (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 26 May 2023 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236289AbjEZR43 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 26 May 2023 13:56:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3B1E7
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 10:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27052651F9
        for <mm-commits@vger.kernel.org>; Fri, 26 May 2023 17:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E62C433D2;
        Fri, 26 May 2023 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1685123787;
        bh=4HDAjUTTWdEKX8qEQyxkj0jvlg+rhUXSfp/herE9ODY=;
        h=Date:To:From:Subject:From;
        b=0TrPgFucv4/aHlcYwc1nMcaAPGe1KXQqCBcABv4R9ICpMiEU8Q1taljMpe1dcUSYy
         QqGASl149JAqhK/rhEUKgx5eBp+Kiywl9EuZK9jAQ3Wnp3fTKMIddn1fKlibrD8tMj
         i8y3VhPOP/elfhsZExe2Cpniz0NTBufUXooNvMxc=
Date:   Fri, 26 May 2023 10:56:26 -0700
To:     mm-commits@vger.kernel.org, vincent.whitchurch@axis.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-cache-partial-compressed-blocks-fix-3-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230526175627.71E62C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: squashfs-cache-partial-compressed-blocks-fix-3-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-cache-partial-compressed-blocks-fix-3-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-cache-partial-compressed-blocks-fix-3-fix.patch

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

mm-compaction-optimize-compact_memory-to-comply-with-the-admin-guide-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-mlock-rename-mlock_future_check-to-mlock_future_ok.patch
fork-optimize-memcg_charge_kernel_stack-a-bit-fix.patch
squashfs-cache-partial-compressed-blocks-fix.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch

