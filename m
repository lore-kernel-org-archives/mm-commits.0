From: akpm@linux-foundation.org
Subject: + spi-add-3wire-mode-flag-fix.patch added to -mm tree
Date: Wed, 23 May 2007 11:31:35 -0700
Message-ID: <200705231831.l4NIVYAE029234@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:37320 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbXEWSbs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 May 2007 14:31:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, dbrownell@users.sourceforge.net


The patch titled
     SPI: add 3wire mode flag (fix)
has been added to the -mm tree.  Its filename is
     spi-add-3wire-mode-flag-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SPI: add 3wire mode flag (fix)
From: David Brownell <david-b@pacbell.net>

Add missing parenthesis ... evidently GCC warns inconsistently.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/lm70.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/hwmon/lm70.c~spi-add-3wire-mode-flag-fix drivers/hwmon/lm70.c
--- a/drivers/hwmon/lm70.c~spi-add-3wire-mode-flag-fix
+++ a/drivers/hwmon/lm70.c
@@ -97,7 +97,7 @@ static int __devinit lm70_probe(struct s
 	int status;
 
 	/* signaling is SPI_MODE_0 on a 3-wire link (shared SI/SO) */
-	if ((spi->mode & (SPI_CPOL|SPI_CPHA)) || !spi->mode & SPI_3WIRE)
+	if ((spi->mode & (SPI_CPOL|SPI_CPHA)) || !(spi->mode & SPI_3WIRE))
 		return -EINVAL;
 
 	p_lm70 = kzalloc(sizeof *p_lm70, GFP_KERNEL);
_

Patches currently in -mm which might be from david-b@pacbell.net are

spi-doc-update-describe-clock-mode-bits.patch
git-leds.patch
git-mmc.patch
at91-fix-enable-disable_irq_wake-symmetry-in-pcmcia-driver.patch
ehci-fsl-fix-cache-coherency-problem-on-system-with-large-memory.patch
spi-controller-drivers-check-for-unsupported-modes.patch
spi-add-3wire-mode-flag.patch
spi-add-3wire-mode-flag-fix.patch
rtc-ds1307-cleanups.patch
