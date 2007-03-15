From: akpm@linux-foundation.org
Subject: + tc35815-fix-an-usage-of-streaming-dma-api.patch added to -mm tree
Date: Thu, 15 Mar 2007 11:50:22 -0800
Message-ID: <200703151850.l2FIoOZo023305@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35516 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326AbXCOSu2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 14:50:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp


The patch titled
     tc35815: fix an usage of streaming DMA API
has been added to the -mm tree.  Its filename is
     tc35815-fix-an-usage-of-streaming-dma-api.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: tc35815: fix an usage of streaming DMA API
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The tc35815 driver lacks a call to pci_dma_sync_single_for_device() on
receiving.  Recent fix of MIPS dma_sync_single_for_cpu() reveal this bug.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tc35815.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/net/tc35815.c~tc35815-fix-an-usage-of-streaming-dma-api drivers/net/tc35815.c
--- a/drivers/net/tc35815.c~tc35815-fix-an-usage-of-streaming-dma-api
+++ a/drivers/net/tc35815.c
@@ -58,12 +58,13 @@
  *	1.34	Fix netpoll locking.  "BH rule" for NAPI is not enough with
  *		netpoll, hard_start_xmit might be called from irq context.
  *		PM support.
+ *	1.35	Fix an usage of streaming DMA API.
  */
 
 #ifdef TC35815_NAPI
-#define DRV_VERSION	"1.34-NAPI"
+#define DRV_VERSION	"1.35-NAPI"
 #else
-#define DRV_VERSION	"1.34"
+#define DRV_VERSION	"1.35"
 #endif
 static const char *version = "tc35815.c:v" DRV_VERSION "\n";
 #define MODNAME			"tc35815"
@@ -1551,6 +1552,11 @@ tc35815_rx(struct net_device *dev)
 							    PCI_DMA_FROMDEVICE);
 #endif
 				memcpy(data + offset, rxbuf, len);
+#ifdef TC35815_DMA_SYNC_ONDEMAND
+				pci_dma_sync_single_for_device(lp->pci_dev,
+							       dma, len,
+							       PCI_DMA_FROMDEVICE);
+#endif
 				offset += len;
 				cur_bd++;
 			}
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

spi-at25-do-not-use-pointer-before-assignment.patch
git-netdev-all.patch
tc35815-fix-an-usage-of-streaming-dma-api.patch
tc35815-fix-an-usage-of-streaming-dma-api-tidy.patch
8139too-fix-irq-problem-with-napi-netpoll.patch
x86_64-fix-section-mismatch-warnings.patch
serial-allocate-minor-device-numbers-for.patch
