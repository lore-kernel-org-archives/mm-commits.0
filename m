From: akpm@linux-foundation.org
Subject: - spi_mpc83xxc-underclocking-hotfix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 16:03:03 -0700
Message-ID: <200707172303.l6HN333B011661@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36780 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936243AbXGQXQS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 19:16:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clifford@clifford.at, david-b@pacbell.net, galak@gate.crashing.org, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx.c underclocking hotfix
has been removed from the -mm tree.  Its filename was
     spi_mpc83xxc-underclocking-hotfix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: spi_mpc83xx.c underclocking hotfix
From: Clifford Wolf <clifford@clifford.at>

The MPC83xx SPI controller clock divider can divide the system clock by not
more then 1024.  The spi_mpc83xx driver does not check this and silently
writes garbage to the SPI controller registers when asked to run at lower
frequencies.  I've tried to run the SPI on a 266MHz MPC8349E with 100kHz
for debugging a bus problem and suddenly was confronted with a 2nd problem
to debug..  ;-)

The patch adds an additional check which avoids writing garbage to the SPI
controller registers and warn the user about it.  This might help others to
avoid simmilar problems.

Cc: Kumar Gala <galak@gate.crashing.org>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spi_mpc83xx.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xxc-underclocking-hotfix drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xxc-underclocking-hotfix
+++ a/drivers/spi/spi_mpc83xx.c
@@ -158,6 +158,12 @@ static void mpc83xx_spi_chipselect(struc
 
 		if ((mpc83xx_spi->sysclk / spi->max_speed_hz) >= 64) {
 			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 64);
+			if (pm > 0x0f) {
+				printk(KERN_WARNING "MPC83xx SPI: SPICLK can't be less then a SYSCLK/1024!\n"
+						"Requested SPICLK is %d Hz. Will use %d Hz instead.\n",
+						spi->max_speed_hz, mpc83xx_spi->sysclk / 1024);
+				pm = 0x0f;
+			}
 			regval |= SPMODE_PM(pm) | SPMODE_DIV16;
 		} else {
 			u8 pm = mpc83xx_spi->sysclk / (spi->max_speed_hz * 4);
_

Patches currently in -mm which might be from clifford@clifford.at are

origin.patch
