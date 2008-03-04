From: akpm@linux-foundation.org
Subject: + block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory.patch added to -mm tree
Date: Tue, 04 Mar 2008 02:12:00 -0800
Message-ID: <200803041012.m24AC1c4002856@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41416 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752497AbYCDKMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 05:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yang.shi@windriver.com, jens.axboe@oracle.com


The patch titled
     block: fix DMA access of block device in 64-bit kernel on some non-x86 systems with 4GB or upper 4GB memory
has been added to the -mm tree.  Its filename is
     block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

block-fix-dma-access-of-block-device-in-64-bit-kernel-on-some-non-x86-systems-with-4gb-or-upper-4gb-memory.patch

