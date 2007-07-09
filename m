From: akpm@linux-foundation.org
Subject: - spi_lm70llp-parport-adapter-driver-correction.patch removed from -mm tree
Date: Mon, 09 Jul 2007 15:06:41 -0700
Message-ID: <200707092206.l69M6gXE015274@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52609 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819AbXGIWH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 18:07:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaiwan@designergraphix.com, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     spi_lm70llp parport adapter driver: correction
has been removed from the -mm tree.  Its filename was
     spi_lm70llp-parport-adapter-driver-correction.patch

This patch was dropped because it was folded into spi_lm70llp-parport-adapter-driver.patch

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
