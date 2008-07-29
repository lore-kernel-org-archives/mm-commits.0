From: akpm@linux-foundation.org
Subject: - spi_s3c24xx-really-assign-busnum.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:29:59 -0700
Message-ID: <200807292029.m6TKTxtD019745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbYG2Uar (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben-linux@fluff.org, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi_s3c24xx: really assign busnum
has been removed from the -mm tree.  Its filename was
     spi_s3c24xx-really-assign-busnum.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_s3c24xx: really assign busnum
From: Ben Dooks <ben-linux@fluff.org>

The original "Pass the bus number we expect the S3C24XX SPI driver to
attach to via the platform data." [1] patch was mis-sent, and missed two
important parts of the diff, which was to actually set the bus_num field
and add the relevant field to the platform data.

The previous commit 50f426b55d919dd017af35bb6a08753d1f262920 promised to
add a bus_num field, but failed to include the two hunks that added this
field to include/asm-arm/arch-s3c2410/spi.h and then pass it to the spi
core when creating the new master field in drivers/spi/spi_s3c24xx.c.

[1] git commit 50f426b55d919dd017af35bb6a08753d1f262920

Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_s3c24xx.c          |    1 +
 include/asm-arm/arch-s3c2410/spi.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN drivers/spi/spi_s3c24xx.c~spi_s3c24xx-really-assign-busnum drivers/spi/spi_s3c24xx.c
--- a/drivers/spi/spi_s3c24xx.c~spi_s3c24xx-really-assign-busnum
+++ a/drivers/spi/spi_s3c24xx.c
@@ -270,6 +270,7 @@ static int __init s3c24xx_spi_probe(stru
 	/* setup the master state. */
 
 	master->num_chipselect = hw->pdata->num_cs;
+	master->bus_num = pdata->bus_num;
 
 	/* setup the state for the bitbang driver */
 
diff -puN include/asm-arm/arch-s3c2410/spi.h~spi_s3c24xx-really-assign-busnum include/asm-arm/arch-s3c2410/spi.h
--- a/include/asm-arm/arch-s3c2410/spi.h~spi_s3c24xx-really-assign-busnum
+++ a/include/asm-arm/arch-s3c2410/spi.h
@@ -16,6 +16,7 @@
 struct s3c2410_spi_info {
 	unsigned long		 pin_cs;	/* simple gpio cs */
 	unsigned int		 num_cs;	/* total chipselects */
+	int			 bus_num;       /* bus number to use. */
 
 	void (*set_cs)(struct s3c2410_spi_info *spi, int cs, int pol);
 };
_

Patches currently in -mm which might be from ben-linux@fluff.org are

backlight-give-platform_lcd-the-same-name-as-the-platform-device.patch
resource-add-resource_size.patch
backlight-ensure-platform_lcd-on-by-default.patch
linux-next.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

