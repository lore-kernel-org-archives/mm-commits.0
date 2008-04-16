From: akpm@linux-foundation.org
Subject: - spi-spi_s3c24xx-must-initialize-num_chipselect.patch removed from -mm tree
Date: Wed, 16 Apr 2008 15:55:20 -0700
Message-ID: <200804162255.m3GMtKfo011107@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752726AbYDPW47 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Apr 2008 18:56:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     spi: spi_s3c24xx must initialize num_chipselect
has been removed from the -mm tree.  Its filename was
     spi-spi_s3c24xx-must-initialize-num_chipselect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi: spi_s3c24xx must initialize num_chipselect
From: Ben Dooks <ben-linux@fluff.org>

The SPI core now expects num_chipselect to be set correctly as due to added
checks on the chip being selected before an transfer is allowed.  This patch
adds a num_cs field to the platform data which needs to be set correctly
before adding the SPI platform device.

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c          |    4 ++++
 include/asm-arm/arch-s3c2410/spi.h |    1 +
 2 files changed, 5 insertions(+)

diff -puN drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-num_chipselect drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi-spi_s3c24xx-must-initialize-num_chipselect
+++ a/drivers/spi/spi_s3c24xx.c
@@ -267,6 +267,10 @@ static int __init s3c24xx_spi_probe(stru
 	platform_set_drvdata(pdev, hw);
 	init_completion(&hw->done);
 
+	/* setup the master state. */
+
+	master->num_chipselect = hw->pdata->num_cs;
+
 	/* setup the state for the bitbang driver */
 
 	hw->bitbang.master         = hw->master;
diff -puN include/asm-arm/arch-s3c2410/spi.h~spi-spi_s3c24xx-must-initialize-num_chipselect include/asm-arm/arch-s3c2410/spi.h
--- a/include/asm-arm/arch-s3c2410/spi.h~spi-spi_s3c24xx-must-initialize-num_chipselect
+++ a/include/asm-arm/arch-s3c2410/spi.h
@@ -15,6 +15,7 @@
 
 struct s3c2410_spi_info {
 	unsigned long		 pin_cs;	/* simple gpio cs */
+	unsigned int		 num_cs;	/* total chipselects */
 
 	void (*set_cs)(struct s3c2410_spi_info *spi, int cs, int pol);
 };
_

Patches currently in -mm which might be from ben-linux@fluff.org are

origin.patch
net-drivers-fix-platform-driver-hotplug-coldplug.patch
sm501-add-uart-support.patch
video-replace-remaining-__function__-occurrences.patch
drivers-replace-remaining-__function__-occurrences.patch

