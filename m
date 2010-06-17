From: akpm@linux-foundation.org
Subject: + mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch added to -mm tree
Date: Thu, 17 Jun 2010 13:11:22 -0700
Message-ID: <201006172011.o5HKBM3e024837__43567.7761598074$1276805503$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245Ab0FQULg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 Jun 2010 16:11:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kishore.kadiyala@ti.com, adrian.hunter@nokia.com, jhnikula@gmail.com, linux-mmc@vger.kernel.org, madhu.cr@ti.com, matt@console-pimps.org, nm@ti.com, svenkatr@ti.com, tony@atomide.com


The patch titled
     mmc: omap: fix for bus width which improves SD card's  peformance.
has been added to the -mm tree.  Its filename is
     mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: fix for bus width which improves SD card's  peformance.
From: Kishore Kadiyala <kishore.kadiyala@ti.com>

This patch improves low speeds for SD cards.

OMAP-MMC controller's can support maximum bus width of '8'.  when bus
width is mentioned as "8" in controller data,the SD stack will check
whether bus width is "4" and if not it will set bus width to "1" and there
by degrading performance.  This patch fixes the issue and improves the
performance of SD cards.

Signed-off-by: Kishore Kadiyala <kishore.kadiyala@ti.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Madhusudhan Chikkature <madhu.cr@ti.com>
Tested-by: Jarkko Nikula <jhnikula@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -2096,10 +2096,23 @@ static int __init omap_hsmmc_probe(struc
 	mmc->caps |= MMC_CAP_MMC_HIGHSPEED | MMC_CAP_SD_HIGHSPEED |
 		     MMC_CAP_WAIT_WHILE_BUSY;
 
-	if (mmc_slot(host).wires >= 8)
+	switch (mmc_slot(host).wires) {
+	case 8:
 		mmc->caps |= MMC_CAP_8_BIT_DATA;
-	else if (mmc_slot(host).wires >= 4)
+		/* Fall through */
+	case 4:
 		mmc->caps |= MMC_CAP_4_BIT_DATA;
+		break;
+	case 1:
+		/* Nothing to crib here */
+	case 0:
+		/* Assuming nothing was given by board, Core use's 1-Bit */
+		break;
+	default:
+		/* Completely unexpected.. Core goes with 1-Bit Width */
+		dev_crit(mmc_dev(host->mmc), "Invalid width %d\n used!"
+			"using 1 instead\n", mmc_slot(host).wires);
+	}
 
 	if (mmc_slot(host).nonremovable)
 		mmc->caps |= MMC_CAP_NONREMOVABLE;
_

Patches currently in -mm which might be from kishore.kadiyala@ti.com are

mmc-omap-fix-for-bus-width-which-improves-sd-cards-peformance.patch

