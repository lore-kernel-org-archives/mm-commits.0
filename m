From: akpm@linux-foundation.org
Subject: - mmc-omap-fix-omap-to-use-mmc_power_on.patch removed from -mm tree
Date: Thu, 03 May 2007 12:30:43 -0700
Message-ID: <200705031930.l43JUhuB018207@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:51335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767902AbXECTeR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:34:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: carlos.aguiar@indt.org.br, drzeus@drzeus.cx, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     MMC: OMAP: Fix omap to use MMC_POWER_ON
has been removed from the -mm tree.  Its filename was
     mmc-omap-fix-omap-to-use-mmc_power_on.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: MMC: OMAP: Fix omap to use MMC_POWER_ON
From: Carlos Aguiar <carlos.aguiar@indt.org.br>

As discussed earlier on LKML:

http://lkml.org/lkml/2006/5/4/44

Signed-off-by: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap.c~mmc-omap-fix-omap-to-use-mmc_power_on drivers/mmc/host/omap.c
--- a/drivers/mmc/host/omap.c~mmc-omap-fix-omap-to-use-mmc_power_on
+++ a/drivers/mmc/host/omap.c
@@ -969,8 +969,10 @@ static void mmc_omap_set_ios(struct mmc_
 		mmc_omap_power(host, 0);
 		break;
 	case MMC_POWER_UP:
-	case MMC_POWER_ON:
+		/* Cannot touch dsor yet, just power up MMC */
 		mmc_omap_power(host, 1);
+		return;
+	case MMC_POWER_ON:
 		dsor |= 1 << 11;
 		break;
 	}
@@ -986,7 +988,7 @@ static void mmc_omap_set_ios(struct mmc_
 	 * Writing to the CON register twice seems to do the trick. */
 	for (i = 0; i < 2; i++)
 		OMAP_MMC_WRITE(host, CON, dsor);
-	if (ios->power_mode == MMC_POWER_UP) {
+	if (ios->power_mode == MMC_POWER_ON) {
 		/* Send clock cycles, poll completion */
 		OMAP_MMC_WRITE(host, IE, 0);
 		OMAP_MMC_WRITE(host, STAT, 0xffff);
_

Patches currently in -mm which might be from carlos.aguiar@indt.org.br are
