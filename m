From: akpm@linux-foundation.org
Subject: - tmio_nand-fix-base-address-programming.patch removed from -mm tree
Date: Mon, 08 Sep 2008 12:07:21 -0700
Message-ID: <200809081907.m88J7L2h005549@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbYIHTHb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Sep 2008 15:07:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dbaryshkov@gmail.com, spyro@f2s.com, mm-commits@vger.kernel.org


The patch titled
     tmio_nand: fix base address programming
has been removed from the -mm tree.  Its filename was
     tmio_nand-fix-base-address-programming.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmio_nand: fix base address programming
From: Dmitry Baryshkov <dbaryshkov@gmail.com>

Fix offset of second word used for programming base address of memory
window.  Also program tmio with offset of the FCR, not with physical
memory location.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
Acked-by: Ian Molton <spyro@f2s.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/nand/tmio_nand.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/mtd/nand/tmio_nand.c~tmio_nand-fix-base-address-programming drivers/mtd/nand/tmio_nand.c
--- a/drivers/mtd/nand/tmio_nand.c~tmio_nand-fix-base-address-programming
+++ a/drivers/mtd/nand/tmio_nand.c
@@ -109,7 +109,7 @@ struct tmio_nand {
 
 	void __iomem *ccr;
 	void __iomem *fcr;
-	unsigned long fcr_phys;
+	unsigned long fcr_base;
 
 	unsigned int irq;
 
@@ -316,8 +316,8 @@ static int tmio_hw_init(struct platform_
 	tmio_iowrite8(0x81, tmio->ccr + CCR_ICC);
 
 	/* (10h)BaseAddress    0x1000 spba.spba2 */
-	tmio_iowrite16(tmio->fcr_phys, tmio->ccr + CCR_BASE);
-	tmio_iowrite16(tmio->fcr_phys >> 16, tmio->ccr + CCR_BASE + 16);
+	tmio_iowrite16(tmio->fcr_base, tmio->ccr + CCR_BASE);
+	tmio_iowrite16(tmio->fcr_base >> 16, tmio->ccr + CCR_BASE + 2);
 
 	/* (04h)Command Register I/O spcmd */
 	tmio_iowrite8(0x02, tmio->ccr + CCR_COMMAND);
@@ -395,7 +395,7 @@ static int tmio_probe(struct platform_de
 		goto err_iomap_ccr;
 	}
 
-	tmio->fcr_phys = (unsigned long)fcr->start;
+	tmio->fcr_base = fcr->start & 0xfffff;
 	tmio->fcr = ioremap(fcr->start, fcr->end - fcr->start + 1);
 	if (!tmio->fcr) {
 		retval = -EIO;
_

Patches currently in -mm which might be from dbaryshkov@gmail.com are

origin.patch
linux-next.patch
platform-add-new-device-registration-helper.patch
make-gpiochip-label-const.patch
gpio-max7301-fix-the-race-between-chip-addition-and-pins-reconfiguration.patch

