From: akpm@linux-foundation.org
Subject: - rtc-ds1307-typo-fix-found-by-coverity.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:11:21 -0700
Message-ID: <200707290611.l6T6BLcK010977@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45700 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756773AbXG2GLg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     rtc-ds1307: typo fix found by coverity
has been removed from the -mm tree.  Its filename was
     rtc-ds1307-typo-fix-found-by-coverity.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: rtc-ds1307: typo fix found by coverity
From: David Brownell <david-b@pacbell.net>

Fix a typo turned up by a Coverity check:  referring to the wrong register,
which could cause problems with DS1338 RTCs whose oscillators halted.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1307.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-typo-fix-found-by-coverity drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-typo-fix-found-by-coverity
+++ a/drivers/rtc/rtc-ds1307.c
@@ -352,7 +352,7 @@ read_rtc:
 		/* oscillator fault?  clear flag, and warn */
 		if (ds1307->regs[DS1307_REG_CONTROL] & DS1338_BIT_OSF) {
 			i2c_smbus_write_byte_data(client, DS1307_REG_CONTROL,
-					ds1307->regs[DS1337_REG_CONTROL]
+					ds1307->regs[DS1307_REG_CONTROL]
 					& ~DS1338_BIT_OSF);
 			dev_warn(&client->dev, "SET TIME!\n");
 			goto read_rtc;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dev-make-rtc-driver-return-enotty.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-kerneldoc-update.patch
spi-device-setup-gets-better-error-checking.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
use-menuconfig-objects-rtc.patch
