Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B810FC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Jun 2022 17:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243474AbiFCRwT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346017AbiFCRul (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Jun 2022 13:50:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8AF556754
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 10:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC5BF60F1B
        for <mm-commits@vger.kernel.org>; Fri,  3 Jun 2022 17:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39793C385B8;
        Fri,  3 Jun 2022 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654278416;
        bh=hmJ2fupLNNI0t5PkH+wJ/J0wlSfA3Q5BkecMsOeLz/U=;
        h=Date:To:From:Subject:From;
        b=MbCDozuMLwLiC6i+lMMg96L9G6Yow37i6bLy7Cxr/v6pKzji69cUsJei4Y1mu2nP1
         ql2otdgbLmXQBnfcPT6PcPIdeSzLdYtnMTQHsb9UIy9wLUhkw2p2yXeYcGVf8nsy5w
         ox1GZx9d/vKjxM3f0y8/Qz8gHgPe+ryzhaujhERA=
Date:   Fri, 03 Jun 2022 10:46:55 -0700
To:     mm-commits@vger.kernel.org, phillip@squashfs.org.uk,
        hsinyi@chromium.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] squashfs-implement-readahead-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20220603174656.39793C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs-implement-readahead-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     squashfs-implement-readahead-checkpatch-fixes.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-implement-readahead-checkpatch-fixes
Date: Wed Jun  1 01:59:05 PM PDT 2022

ERROR: need consistent spacing around '&' (ctx:WxO)
#54: FILE: fs/squashfs/file.c:505:
+	loff_t start = readahead_pos(ractl) &~ mask;
 	                                    ^

ERROR: space prohibited after that '~' (ctx:OxW)
#54: FILE: fs/squashfs/file.c:505:
+	loff_t start = readahead_pos(ractl) &~ mask;
 	                                     ^

total: 2 errors, 0 warnings, 109 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/squashfs-implement-readahead.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Hsin-Yi Wang <hsinyi@chromium.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/file.c~squashfs-implement-readahead-checkpatch-fixes
+++ a/fs/squashfs/file.c
@@ -502,7 +502,7 @@ static void squashfs_readahead(struct re
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	size_t mask = (1UL << msblk->block_log) - 1;
 	unsigned short shift = msblk->block_log - PAGE_SHIFT;
-	loff_t start = readahead_pos(ractl) &~ mask;
+	loff_t start = readahead_pos(ractl) & ~mask;
 	size_t len = readahead_length(ractl) + readahead_pos(ractl) - start;
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-page_alloc-remotely-drain-per-cpu-lists-checkpatch-fixes.patch
mm-start-tracking-vmas-with-maple-tree-fix.patch
damon-convert-__damon_va_three_regions-to-use-the-vma-iterator-fix.patch
mm-mmap-use-advanced-maple-tree-api-for-mmap_region-fix-checkpatch-fixes.patch
mm-remove-the-vma-linked-list-fix-fix.patch
mm-remove-the-vma-linked-list-fix-fix-fix.patch
mm-handling-non-lru-pages-returned-by-vm_normal_pages-fix.patch
mm-introduce-clear_highpage_tagged-fix.patch
kasan-fix-zeroing-vmalloc-memory-with-hw_tags-fix.patch
mm-shrinkers-add-scan-interface-for-shrinker-debugfs-fix-fix.patch
mm-drop-oom-code-from-exit_mmap-fix-fix.patch
mm-add-merging-after-mremap-resize-checkpatch-fixes.patch

