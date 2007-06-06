From: akpm@linux-foundation.org
Subject: + spi_lm70llp-parport-adapter-driver-correction.patch added to -mm tree
Date: Wed, 06 Jun 2007 00:04:29 -0700
Message-ID: <200706060704.l5674T79011464@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60305 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753036AbXFFHF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jun 2007 03:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaiwan@designergraphix.com, david-b@pacbell.net


The patch titled
     spi_lm70llp parport adapter driver: correction
has been added to the -mm tree.  Its filename is
     spi_lm70llp-parport-adapter-driver-correction.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi_lm70llp parport adapter driver: correction
From: Kaiwan N Billimoria <kaiwan@designergraphix.com>

I've found a couple of issues with the patch above

Signed-off-by: Kaiwan N Billimoria <kaiwan@designergraphix.com>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_lm70llp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/spi/spi_lm70llp.c~spi_lm70llp-parport-adapter-driver-correction drivers/spi/spi_lm70llp.c
--- a/drivers/spi/spi_lm70llp.c~spi_lm70llp-parport-adapter-driver-correction
+++ a/drivers/spi/spi_lm70llp.c
@@ -69,7 +69,7 @@
 
 #define DRVNAME		"spi-lm70llp"
 
-#define lm70_INIT	0xFE
+#define lm70_INIT	0xBE
 #define SIO		0x10
 #define nCS		0x20
 #define SCLK		0x40
@@ -294,7 +294,6 @@ static void spi_lm70llp_attach(struct pa
 		goto out_bitbang_stop;
 	}
 	pp->spidev_lm70->bits_per_word = 16;
-	spi_setup(pp->spidev_lm70);
 
 	lm70llp = pp;
 
_

Patches currently in -mm which might be from kaiwan@designergraphix.com are

spi_lm70llp-parport-adapter-driver.patch
spi_lm70llp-parport-adapter-driver-correction.patch
