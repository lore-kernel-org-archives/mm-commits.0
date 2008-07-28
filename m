From: akpm@linux-foundation.org
Subject: + spi_s3c24xx-really-assign-busnum.patch added to -mm tree
Date: Sun, 27 Jul 2008 19:44:42 -0700
Message-ID: <200807280244.m6S2igwm016311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbYG1Cp1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Jul 2008 22:45:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben-linux@fluff.org, dbrownell@users.sourceforge.net


The patch titled
     spi_s3c24xx: really assign busnum
has been added to the -mm tree.  Its filename is
     spi_s3c24xx-really-assign-busnum.patch

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
Subject: spi_s3c24xx: really assign busnum
From: Ben Dooks <ben-linux@fluff.org>

The original "Pass the bus number we expect the S3C24XX SPI driver to
attach to via the platform data." [1] patch was mis-sent, and missed two
important parts of the diff, which was to actually set the bus_num field
and add the relevant field to the platform data.

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

origin.patch
spi_s3c24xx-really-assign-busnum.patch
linux-next.patch
resource-add-resource_size.patch
resource-add-resource_type-and-ioresource_type_bits.patch
resource-add-new-ioresource_clk-type-v2.patch
i2c-sh_mobile-ioresource_clk-support.patch

