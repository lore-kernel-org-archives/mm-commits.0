From: akpm@linux-foundation.org
Subject: + omap-mmc-recover-from-transfer-failures-resend.patch added to -mm tree
Date: Thu, 05 Feb 2009 12:10:50 -0800
Message-ID: <200902052010.n15KAoWL023053@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33806 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282AbZBEUR5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Feb 2009 15:17:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpihet@mvista.com, alowe@mvista.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com, jarkko.lavinen@nokia.com, tony@atomide.com


The patch titled
     mmc: omap: recover from transfer failures
has been added to the -mm tree.  Its filename is
     omap-mmc-recover-from-transfer-failures-resend.patch

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

omap-mmc-recover-from-transfer-failures-resend.patch

