From: akpm@linux-foundation.org
Subject: + block-fix-the-setting-of-the-bounce-limit.patch added to -mm tree
Date: Tue, 01 Apr 2008 09:48:00 -0700
Message-ID: <200804011648.m31Gm0pE003472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759219AbYDAQtj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Apr 2008 12:49:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andrea@qumranet.com, jens.axboe@oracle.com, yang.shi@windriver.com


The patch titled
     block: fix the setting of the bounce limit
has been added to the -mm tree.  Its filename is
     block-fix-the-setting-of-the-bounce-limit.patch

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
Subject: block: fix the setting of the bounce limit
From: Andrea Arcangeli <andrea@qumranet.com>

Fix a post-2.624 regression introduced by

commit 419c434c35614609fd0c79d335c134bf4b88b30b
Author: Yang Shi <yang.shi@windriver.com>
Date:   Tue Mar 4 11:20:51 2008 +0100

    Fix DMA access of block device in 64-bit kernel on some non-x86 systems with 4GB or upper 4GB memory
    
    For some non-x86 systems with 4GB or upper 4GB memory,
    we need increase the range of addresses that can be
    used for direct DMA in 64-bit kernel.
    


This is crashing at boot my lowmem reserved RAM patch.  This is causing
GFP_DMA allocations at boot for no good reason.  It crashes in my case because
there's no ram below 16M available to linux.

Looking a bit closer into this regression the reason this can't be right is
that dma_addr common default is BLK_BOUNCE_HIGH and most machines have less
than 4G.  So if you do:

    if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
	dma = 1

that will translate to:

     if (BLK_BOUNCE_HIGH <= BLK_BOUNCE_HIGH)
     	dma = 1

So for 99% of hardware this will trigger unnecessary GFP_DMA
allocations and isa pooling operations.

Also note how the 32bit code still does b_pfn < blk_max_low_pfn.

I guess this is what you were looking after.  As I can tell, this will stop
the regression with isa dma operations at boot for 99% of blkdev/memory
combinations out there and I guess this fixes the setups with >4G of ram and
32bit pci cards as well (this also retains symmetry with the 32bit code).

Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
Tested-by: Yang Shi <yang.shi@windriver.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/blk-settings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN block/blk-settings.c~block-fix-the-setting-of-the-bounce-limit block/blk-settings.c
--- a/block/blk-settings.c~block-fix-the-setting-of-the-bounce-limit
+++ a/block/blk-settings.c
@@ -140,7 +140,7 @@ void blk_queue_bounce_limit(struct reque
 	/* Assume anything <= 4GB can be handled by IOMMU.
 	   Actually some IOMMUs can handle everything, but I don't
 	   know of a way to test this here. */
-	if (b_pfn <= (min_t(u64, 0xffffffff, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
+	if (b_pfn < (min_t(u64, 0x100000000UL, BLK_BOUNCE_HIGH) >> PAGE_SHIFT))
 		dma = 1;
 	q->bounce_pfn = max_low_pfn;
 #else
_

Patches currently in -mm which might be from andrea@qumranet.com are

block-fix-the-setting-of-the-bounce-limit.patch
git-kvm.patch

