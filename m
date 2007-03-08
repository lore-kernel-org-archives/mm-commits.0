From: akpm@linux-foundation.org
Subject: + baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch added to -mm tree
Date: Thu, 08 Mar 2007 00:39:56 -0800
Message-ID: <200703080839.l288dujl023277@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57999 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030294AbXCHIkY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 8 Mar 2007 03:40:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: folkert@vanheusden.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org


The patch titled
     baycom_ser_fdx: also allow i/o ports >= 0x1000 and enhanced failure logging
has been added to the -mm tree.  Its filename is
     baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: baycom_ser_fdx: also allow i/o ports >= 0x1000 and enhanced failure logging
From: Folkert van Heusden <folkert@vanheusden.com>

The baycom_ser_fdx driver did not allow i/o ports >= 0x1000.  Now that
there are pci cards (with rs232 ports) which use for example 0xb800 this
limit should not exists.

Also, for non kernel coders find the cause of problems was challenging so I
added extra logging.

Signed-off-by: Folkert van Heusden <folkert@vanheusden.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/hamradio/baycom_ser_fdx.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN drivers/net/hamradio/baycom_ser_fdx.c~baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced drivers/net/hamradio/baycom_ser_fdx.c
--- a/drivers/net/hamradio/baycom_ser_fdx.c~baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced
+++ a/drivers/net/hamradio/baycom_ser_fdx.c
@@ -413,11 +413,18 @@ static int ser12_open(struct net_device 
 
 	if (!dev || !bc)
 		return -ENXIO;
-	if (!dev->base_addr || dev->base_addr > 0x1000-SER12_EXTENT ||
-	    dev->irq < 2 || dev->irq > 15)
+	if (!dev->base_addr || dev->base_addr > 0xffff-SER12_EXTENT ||
+	    dev->irq < 2 || dev->irq > NR_IRQS) {
+		printk(KERN_INFO "baycom_ser_fdx: invalid portnumber (max %u) "
+				"or irq (2 <= irq <= %d)\n",
+				0xffff-SER12_EXTENT, NR_IRQS);
 		return -ENXIO;
-	if (bc->baud < 300 || bc->baud > 4800)
+	}
+	if (bc->baud < 300 || bc->baud > 4800) {
+		printk(KERN_INFO "baycom_ser_fdx: invalid baudrate "
+				"(300...4800)\n");
 		return -EINVAL;
+	}
 	if (!request_region(dev->base_addr, SER12_EXTENT, "baycom_ser_fdx")) {
 		printk(KERN_WARNING "BAYCOM_SER_FSX: I/O port 0x%04lx busy \n", 
 		       dev->base_addr);
_

Patches currently in -mm which might be from folkert@vanheusden.com are

baycom_ser_fdx-also-allow-i-o-ports-=-0x1000-and-enhanced.patch
