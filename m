From: akpm@linux-foundation.org
Subject: + dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch added to -mm tree
Date: Mon, 20 Jul 2009 23:00:40 -0700
Message-ID: <200907210600.n6L60eCP029082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753253AbZGUGBQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 02:01:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, dan.j.williams@intel.com, haavard.skinnemoen@atmel.com, maciej.sosnowski@intel.com


The patch titled
     dmaengine: dmatest: correct thread_count while using multiple thread per channel
has been added to the -mm tree.  Its filename is
     dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: dmaengine: dmatest: correct thread_count while using multiple thread per channel
From: Nicolas Ferre <nicolas.ferre@atmel.com>

It seems that thread_count is not properly calculated in dmatest.  In fact
the thread count number that is returned from dmatest_add_threads() is not
correctly added to the thread_count and thus not properly printed.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Acked-by: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/dma/dmatest.c~dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel
+++ a/drivers/dma/dmatest.c
@@ -495,11 +495,11 @@ static int dmatest_add_channel(struct dm
 
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_MEMCPY);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		cnt = dmatest_add_threads(dtc, DMA_XOR);
-		thread_count += cnt > 0 ?: 0;
+		thread_count += cnt > 0 ? cnt : 0;
 	}
 
 	pr_info("dmatest: Started %u threads using %s\n",
_

Patches currently in -mm which might be from nicolas.ferre@atmel.com are

linux-next.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations.patch
dmaengine-dmatest-add-a-maximum-number-of-test-iterations-checkpatch-fixes.patch
dmaengine-dmatest-correct-thread_count-while-using-multiple-thread-per-channel.patch

