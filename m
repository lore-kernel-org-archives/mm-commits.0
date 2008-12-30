From: akpm@linux-foundation.org
Subject: + dmatest-flush-and-invalidate-destination-buffer-before-dma.patch added to -mm tree
Date: Tue, 30 Dec 2008 15:14:00 -0800
Message-ID: <200812302314.mBUNE0Ps022077@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752379AbYL3XOk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Dec 2008 18:14:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, dan.j.williams@intel.com, maciej.sosnowski@intel.com


The patch titled
     dmatest: flush and invalidate destination buffer before DMA
has been added to the -mm tree.  Its filename is
     dmatest-flush-and-invalidate-destination-buffer-before-dma.patch

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
Subject: dmatest: flush and invalidate destination buffer before DMA
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

On non-coherent architectures, such as MIPS, the dmatest reports
mismatches on just before and after the DMA area.  This is because test
patterns in the dstbuf discarded from cache without writing to main
memory.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/dmatest.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/dma/dmatest.c~dmatest-flush-and-invalidate-destination-buffer-before-dma drivers/dma/dmatest.c
--- a/drivers/dma/dmatest.c~dmatest-flush-and-invalidate-destination-buffer-before-dma
+++ a/drivers/dma/dmatest.c
@@ -202,6 +202,7 @@ static int dmatest_func(void *data)
 	dma_cookie_t		cookie;
 	enum dma_status		status;
 	int			ret;
+	dma_addr_t		dma_dest;
 
 	thread_name = current->comm;
 
@@ -225,6 +226,12 @@ static int dmatest_func(void *data)
 
 		dmatest_init_srcbuf(thread->srcbuf, src_off, len);
 		dmatest_init_dstbuf(thread->dstbuf, dst_off, len);
+		/* flush and invalidate caches for whole dstbuf */
+		dma_dest = dma_map_single(chan->device->dev,
+				thread->dstbuf,
+				test_buf_size, DMA_BIDIRECTIONAL);
+		dma_unmap_single(chan->device->dev, dma_dest,
+				test_buf_size, DMA_BIDIRECTIONAL);
 
 		cookie = dma_async_memcpy_buf_to_buf(chan,
 				thread->dstbuf + dst_off,
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
dmatest-flush-and-invalidate-destination-buffer-before-dma.patch
physmap-make-map_info-customizable.patch
atmel_serial-might-lose-modem-status-change.patch
rtc-add-alarm-update-irq-interfaces-version-5.patch
rtc-add-rtc-tx4939-driver-v2.patch

