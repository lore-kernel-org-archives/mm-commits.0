Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD047C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A2FB64FAE
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 00:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhCKAZw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 10 Mar 2021 19:25:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCKAZc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 10 Mar 2021 19:25:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC8964F60;
        Thu, 11 Mar 2021 00:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615422332;
        bh=BjP0NMS/N5voMb6whxUxadfTBFyzoFiSQbWinDTIaDY=;
        h=Date:From:To:Subject:From;
        b=v4SgBGXD0r9pA91c0YMVv9n/Uflo47ygm7bQdJg7Y/Yk3iiyMtZ7wDCC4XjXWZvt9
         ukq/pA8n085wDS/oERjPC2kL2KzNG3rsFmT41/HKfH044N/bl5DVSqkFqD/3a4sKU3
         M0lRsonCb7rp/xZ5j+SIwX0Pmy+bC6pDjuVoU55U=
Date:   Wed, 10 Mar 2021 16:25:31 -0800
From:   akpm@linux-foundation.org
To:     axboe@kernel.dk, colyli@suse.de, dan.j.williams@intel.com,
        hch@lst.de, martin.petersen@oracle.com, mm-commits@vger.kernel.org,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  + include-remove-pagemaph-from-blkdevh.patch added to -mm
 tree
Message-ID: <20210311002531.di33dDfoX%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: include: remove pagemap.h from blkdev.h
has been added to the -mm tree.  Its filename is
     include-remove-pagemaph-from-blkdevh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/include-remove-pagemaph-from-blkdevh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/include-remove-pagemaph-from-blkdevh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: include: remove pagemap.h from blkdev.h

My UEK-derived config has 1030 files depending on pagemap.h before this
change.  Afterwards, just 326 files need to be rebuilt when I touch
pagemap.h.  I think blkdev.h is probably included too widely, but
untangling that dependency is harder and this solves my problem.  x86
allmodconfig builds, but there may be implicit include problems on other
architectures.

Link: https://lkml.kernel.org/r/20210309195747.283796-1-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Dan Williams <dan.j.williams@intel.com>		[nvdimm]
Acked-by: Jens Axboe <axboe@kernel.dk>				[block]
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Coly Li <colyli@suse.de>				[bcache]
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>	[scsi]
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c      |    1 +
 drivers/block/brd.c       |    1 +
 drivers/block/loop.c      |    1 +
 drivers/md/bcache/super.c |    1 +
 drivers/nvdimm/btt.c      |    1 +
 drivers/nvdimm/pmem.c     |    1 +
 drivers/scsi/scsicam.c    |    1 +
 include/linux/blkdev.h    |    1 -
 include/linux/swap.h      |    1 +
 9 files changed, 8 insertions(+), 1 deletion(-)

--- a/block/blk-settings.c~include-remove-pagemaph-from-blkdevh
+++ a/block/blk-settings.c
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <linux/memblock.h>	/* for max_pfn/max_low_pfn */
 #include <linux/gcd.h>
 #include <linux/lcm.h>
--- a/drivers/block/brd.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/block/brd.c
@@ -18,6 +18,7 @@
 #include <linux/bio.h>
 #include <linux/highmem.h>
 #include <linux/mutex.h>
+#include <linux/pagemap.h>
 #include <linux/radix-tree.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
--- a/drivers/block/loop.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/block/loop.c
@@ -53,6 +53,7 @@
 #include <linux/moduleparam.h>
 #include <linux/sched.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/file.h>
 #include <linux/stat.h>
 #include <linux/errno.h>
--- a/drivers/md/bcache/super.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/md/bcache/super.c
@@ -16,6 +16,7 @@
 #include "features.h"
 
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <linux/debugfs.h>
 #include <linux/genhd.h>
 #include <linux/idr.h>
--- a/drivers/nvdimm/btt.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/nvdimm/btt.c
@@ -6,6 +6,7 @@
 #include <linux/highmem.h>
 #include <linux/debugfs.h>
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <linux/module.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
--- a/drivers/nvdimm/pmem.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/nvdimm/pmem.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
--- a/drivers/scsi/scsicam.c~include-remove-pagemaph-from-blkdevh
+++ a/drivers/scsi/scsicam.c
@@ -17,6 +17,7 @@
 #include <linux/genhd.h>
 #include <linux/kernel.h>
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <linux/msdos_partition.h>
 #include <asm/unaligned.h>
 
--- a/include/linux/blkdev.h~include-remove-pagemaph-from-blkdevh
+++ a/include/linux/blkdev.h
@@ -11,7 +11,6 @@
 #include <linux/minmax.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
-#include <linux/pagemap.h>
 #include <linux/backing-dev-defs.h>
 #include <linux/wait.h>
 #include <linux/mempool.h>
--- a/include/linux/swap.h~include-remove-pagemaph-from-blkdevh
+++ a/include/linux/swap.h
@@ -10,6 +10,7 @@
 #include <linux/sched.h>
 #include <linux/node.h>
 #include <linux/fs.h>
+#include <linux/pagemap.h>
 #include <linux/atomic.h>
 #include <linux/page-flags.h>
 #include <uapi/linux/mempolicy.h>
_

Patches currently in -mm which might be from willy@infradead.org are

mm-use-rcu_dereference-in-in_vfork.patch
mm-filemap-use-filemap_read_page-in-filemap_fault.patch
mm-filemap-drop-check-for-truncated-page-after-i-o.patch
mm-page_alloc-rename-alloc_mask-to-alloc_gfp.patch
mm-page_alloc-rename-gfp_mask-to-gfp.patch
mm-page_alloc-combine-__alloc_pages-and-__alloc_pages_nodemask.patch
mm-mempolicy-rename-alloc_pages_current-to-alloc_pages.patch
mm-mempolicy-rewrite-alloc_pages-documentation.patch
mm-mempolicy-rewrite-alloc_pages_vma-documentation.patch
mm-mempolicy-fix-mpol_misplaced-kernel-doc.patch
include-remove-pagemaph-from-blkdevh.patch

