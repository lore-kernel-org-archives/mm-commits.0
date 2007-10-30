From: akpm@linux-foundation.org
Subject: + spi-spi_bfin-dont-bypass-spi-framework.patch added to -mm tree
Date: Tue, 30 Oct 2007 15:42:32 -0700
Message-ID: <200710302242.l9UMgWot031677@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33829 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756366AbXJ3Wml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 18:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: michael.frysinger@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net


The patch titled
     spi: spi_bfin, don't bypass spi framework
has been added to the -mm tree.  Its filename is
     spi-spi_bfin-dont-bypass-spi-framework.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: spi: spi_bfin, don't bypass spi framework
From: Mike Frysinger <michael.frysinger@analog.com>

Prevent people from setting bits in ctl_reg that the SPI framework already
handles, hopefully we can one day drop ctl_reg completely

Signed-off-by: Mike Frysinger <michael.frysinger@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_bfin5xx.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN drivers/spi/spi_bfin5xx.c~spi-spi_bfin-dont-bypass-spi-framework drivers/spi/spi_bfin5xx.c
--- a/drivers/spi/spi_bfin5xx.c~spi-spi_bfin-dont-bypass-spi-framework
+++ a/drivers/spi/spi_bfin5xx.c
@@ -998,6 +998,18 @@ static int setup(struct spi_device *spi)
 
 	/* chip_info isn't always needed */
 	if (chip_info) {
+		/* Make sure people stop trying to set fields via ctl_reg
+		 * when they should actually be using common SPI framework.
+		 * Currently we let through: WOM EMISO PSSE GM SZ TIMOD.
+		 * Not sure if a user actually needs/uses any of these,
+		 * but let's assume (for now) they do.
+		 */
+		if (chip_info->ctl_reg & (SPE|MSTR|CPOL|CPHA|LSBF|SIZE)) {
+			dev_err(&spi->dev, "do not set bits in ctl_reg "
+				"that the SPI framework manages\n");
+			return -EINVAL;
+		}
+
 		chip->enable_dma = chip_info->enable_dma != 0
 		    && drv_data->master_info->enable_dma;
 		chip->ctl_reg = chip_info->ctl_reg;
_

Patches currently in -mm which might be from michael.frysinger@analog.com are

origin.patch
spi-spi_bfin-dont-bypass-spi-framework.patch
