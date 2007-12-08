From: akpm@linux-foundation.org
Subject: - spi-spi_bfin-dont-bypass-spi-framework.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:29:12 -0800
Message-ID: <200712080129.lB81TCP2013387@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48514 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbXLHB3w (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:29:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: michael.frysinger@analog.com, bryan.wu@analog.com, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: spi_bfin, don't bypass spi framework
has been removed from the -mm tree.  Its filename was
     spi-spi_bfin-dont-bypass-spi-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
blackfin-rtc-driver-the-frequency-function-is-in-units-of-hz-not-units-of-seconds-so-lock-our-driver-down-to-1-hz.patch
blackfin-rtc-driver-we-pass-in-a-struct-device-to-the-irq-handler-not-a-struct-platform_device-so-fix-the-irq-handler.patch
blackfin-rtc-driver-cleanup-proc-handler-we-dont-need-rtc-reg-dump-now-that-we-have-mmr-filesystem-in-sysfs.patch
blackfin-rtc-driver-use-dev_dbg-rather-than-pr_stamp.patch
blackfin-rtc-driver-read_alarm-checks-the-enabled-field-not-the-pending-field.patch
blackfin-rtc-driver-shave-off-another-memcpy-by-using-assignment.patch
blackfin-rtc-driver-convert-sync-wait-to-use-the-irq-write-complete-notice.patch
add-cmpxchg_local-to-blackfin-replace-__cmpxchg-by-generic-cmpxchg.patch
