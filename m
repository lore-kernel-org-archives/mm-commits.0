Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA6DC7EE29
	for <mm-commits@archiver.kernel.org>; Sat, 10 Jun 2023 00:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjFJA2L (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 20:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFJA2K (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 20:28:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B45BF
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 17:28:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84EB364869
        for <mm-commits@vger.kernel.org>; Sat, 10 Jun 2023 00:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EBAC433EF;
        Sat, 10 Jun 2023 00:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686356889;
        bh=DDwo+jUSDrEGyzK5EgiequZ6ilQ9pPeJqh4dkdvr8DA=;
        h=Date:To:From:Subject:From;
        b=vtEkpKgSRHvfZ6OLHjU0CRwZeZifJYRdIjalXkmdBUd4BIaT+u9SGlg4lVXDi1xor
         QtZWY1veebYukLltubIOntO/v7jTQGMih2/qZKDe1V26AWhuhlgZwkG1mTpPg14VON
         5Pt4fRWyUHN9LUmAiZrNQZSetxf/PqzWEN+oADzE=
Date:   Fri, 09 Jun 2023 17:28:08 -0700
To:     mm-commits@vger.kernel.org, vincent.whitchurch@axis.com,
        phillip@squashfs.org.uk, hch@lst.de, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] squashfs-cache-partial-compressed-blocks-fix.patch removed from -mm tree
Message-Id: <20230610002808.D9EBAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: squashfs-cache-partial-compressed-blocks-fix
has been removed from the -mm tree.  Its filename was
     squashfs-cache-partial-compressed-blocks-fix.patch

This patch was dropped because it was folded into squashfs-cache-partial-compressed-blocks.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-cache-partial-compressed-blocks-fix
Date: Wed May 17 04:01:12 PM PDT 2023

fs/squashfs/block.c needs linux/pagemap.h

fs/squashfs/block.c: In function 'squashfs_bio_read_cached':
fs/squashfs/block.c:143:27: error: implicit declaration of function 'add_to_page_cache_lru' [-Werror=implicit-function-declaration]
  143 |                 int ret = add_to_page_cache_lru(head_to_cache, cache_mapping,
      |                           ^~~~~~~~~~~~~~~~~~~~~
fs/squashfs/block.c:148:25: error: implicit declaration of function 'unlock_page'; did you mean 'alloc_page'? [-Werror=implicit-function-declaration]
  148 |                         unlock_page(head_to_cache);
      |                         ^~~~~~~~~~~
      |                         alloc_page
fs/squashfs/block.c: In function 'squashfs_bio_read':
fs/squashfs/block.c:193:32: error: implicit declaration of function 'find_get_page'; did you mean 'find_get_pid'? [-Werror=implicit-function-declaration]
  193 |                         page = find_get_page(cache_mapping,
      |                                ^~~~~~~~~~~~~
      |                                find_get_pid
fs/squashfs/block.c:193:30: error: assignment to 'struct page *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
  193 |                         page = find_get_page(cache_mapping,
      |                              ^
cc1: all warnings being treated as errors
make[3]: *** [scripts/Makefile.build:252: fs/squashfs/block.o] Error 1
make[2]: *** [scripts/Makefile.build:494: fs/squashfs] Error 2
make[1]: *** [scripts/Makefile.build:494: fs] Error 2
make: *** [Makefile:2026: .] Error 2

Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/squashfs/block.c~squashfs-cache-partial-compressed-blocks-fix
+++ a/fs/squashfs/block.c
@@ -17,6 +17,7 @@
 #include <linux/fs.h>
 #include <linux/vfs.h>
 #include <linux/slab.h>
+#include <linux/pagemap.h>
 #include <linux/string.h>
 #include <linux/bio.h>
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix.patch
mm-page_owner-add-page_owner_stacks-file-to-print-out-only-stacks-and-their-counte-fix-fix.patch
mmpage_owner-filter-out-stacks-by-a-threshold-counter-fix.patch
mm-page_isolation-write-proper-kerneldoc-fix.patch
mm-hugetlb-use-a-folio-in-hugetlb_fault-fix.patch
squashfs-cache-partial-compressed-blocks.patch
squashfs-cache-partial-compressed-blocks-fix-3-fix.patch
init-add-bdev-fs-printk-if-mount_block_root-failed-fix.patch
watchdog-hardlockup-add-comments-to-touch_nmi_watchdog-fix.patch
kexec-add-helper-__crash_shrink_memory-fix.patch

