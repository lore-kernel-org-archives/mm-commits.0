From: akpm@linux-foundation.org
Subject: [merged] omap-mmc-recover-from-transfer-failures-resend.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:50 -0800
Message-ID: <200902191917.n1JJHoxi016415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752631AbZBSTXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpihet@mvista.com, alowe@mvista.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com, jarkko.lavinen@nokia.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     mmc: omap: recover from transfer failures
has been removed from the -mm tree.  Its filename was
     omap-mmc-recover-from-transfer-failures-resend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: omap: recover from transfer failures
From: Jean Pihet <jpihet@mvista.com>

Timeouts during a command that has a data phase can result in the next
command issued after the command that failed not being processed, i.e.  no
interrupt ever occurs to indicate the command has completed.  This failure
can result in a deadlock.

This patch resets the data state machine to clear the error in case of a
command timeout.

Tested on OMAP3430 chip and intensive MMC/SD device removal while
transferring data.

Signed-off-by: Andy Lowe <alowe@mvista.com>
Signed-off-by: Jean Pihet <jpihet@mvista.com>
Signed-off-by: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-mmc-recover-from-transfer-failures-resend drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-mmc-recover-from-transfer-failures-resend
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -416,8 +416,15 @@ static irqreturn_t mmc_omap_irq(int irq,
 				}
 				end_cmd = 1;
 			}
-			if (host->data)
+			if (host->data) {
 				mmc_dma_cleanup(host);
+				OMAP_HSMMC_WRITE(host->base, SYSCTL,
+					OMAP_HSMMC_READ(host->base,
+							SYSCTL) | SRD);
+				while (OMAP_HSMMC_READ(host->base,
+						SYSCTL) & SRD)
+					;
+			}
 		}
 		if ((status & DATA_TIMEOUT) ||
 			(status & DATA_CRC)) {
_

Patches currently in -mm which might be from jpihet@mvista.com are

origin.patch

