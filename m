From: akpm@linux-foundation.org
Subject: + pata_cs5536-mwdma-fix.patch added to -mm tree
Date: Wed, 17 Oct 2007 15:03:56 -0700
Message-ID: <200710172203.l9HM3uCT010542@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53962 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757075AbXJQWFo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Oct 2007 18:05:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bzolnier@gmail.com, alan@lxorguk.ukuu.org.uk, jeff@garzik.org, martin.petersen@oracle.com


The patch titled
     pata_cs5536: MWDMA fix
has been added to the -mm tree.  Its filename is
     pata_cs5536-mwdma-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pata_cs5536: MWDMA fix
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

* Fix out-of-bound array access for MWDMA modes.

* Bump driver version.

Acked-by: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/pata_cs5536.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/ata/pata_cs5536.c~pata_cs5536-mwdma-fix drivers/ata/pata_cs5536.c
--- a/drivers/ata/pata_cs5536.c~pata_cs5536-mwdma-fix
+++ a/drivers/ata/pata_cs5536.c
@@ -40,7 +40,7 @@
 #include <asm/msr.h>
 
 #define DRV_NAME	"pata_cs5536"
-#define DRV_VERSION	"0.0.5"
+#define DRV_VERSION	"0.0.6"
 
 enum {
 	CFG			= 0,
@@ -214,7 +214,7 @@ static void cs5536_set_dmamode(struct at
 		cs5536_read(pdev, DTC, &dtc);
 
 		dtc &= ~(IDE_DRV_MASK << dshift);
-		dtc |= mwdma_timings[mode] << dshift;
+		dtc |= mwdma_timings[mode - XFER_MW_DMA_0] << dshift;
 
 		cs5536_write(pdev, DTC, dtc);
 	}
_

Patches currently in -mm which might be from bzolnier@gmail.com are

origin.patch
pata_cs5536-mwdma-fix.patch
ide-arm-hack.patch
