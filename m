From: akpm@linux-foundation.org
Subject: - block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory.patch removed from -mm tree
Date: Tue, 04 Mar 2008 12:10:23 -0800
Message-ID: <200803042010.m24KANWk026904@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932367AbYCDULF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 15:11:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@windriver.com, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     block: fix DMA access of block device in 64-bit kernel on some non-x86 systems with 4GB or upper 4GB memory
has been removed from the -mm tree.  Its filename was
     block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: block: fix DMA access of block device in 64-bit kernel on some non-x86 systems with 4GB or upper 4GB memory
From: yshi <yang.shi@windriver.com>

For some non-x86 systems with 4GB or upper 4GB memory, we need increase the
range of addresses that can be used for direct DMA in 64-bit kernel.

Signed-off-by: Yang Shi <yang.shi@windriver.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-settings.c~block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory block/blk-settings.c
--- a/block/blk-settings.c~block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory
+++ a/block/blk-settings.c
@@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct reque
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
 	   know of a way to test this here. */
-	if (b_pfn < (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
_

Patches currently in -mm which might be from yang.shi@windriver.com are

origin.patch

