Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A794C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79C74610F7
	for <mm-commits@archiver.kernel.org>; Fri,  7 May 2021 01:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbhEGBDa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 6 May 2021 21:03:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhEGBD1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 6 May 2021 21:03:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33379611ED;
        Fri,  7 May 2021 01:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620349348;
        bh=yLUDQuxd9eehC69UEE06afJJAnEevPjTzZxYc41X46g=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=gaKonybTmS4BbdHpVadG7dryBsS4sMhtSjZxrPE5X9mKriwf0t4UjyfjR89yIi7Jd
         S/ro7YuaOIGuVod80Bq8+GZXR4ooDi+K2Sz3nV+eqNPe51zHrhDBCVngNWloxcoCxs
         ksBbw6sYeKKdwxOJqy7jPQ+rR5oCKw3e+0yj/UTc=
Date:   Thu, 06 May 2021 18:02:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, axboe@kernel.dk, colyli@suse.de,
        dan.j.williams@intel.com, hch@lst.de, linux-mm@kvack.org,
        martin.petersen@oracle.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        willy@infradead.org
Subject:  [patch 09/91] include: remove pagemap.h from blkdev.h
Message-ID: <20210507010227.0DASBmef7%akpm@linux-foundation.org>
In-Reply-To: <20210506180126.03e1baee7ca52bedb6cc6003@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
 #include <linux/gcd.h>
 #include <linux/lcm.h>
 #include <linux/jiffies.h>
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
