From: akpm@linux-foundation.org
Subject: [merged] omap-mmc-replace-infinite-loops-with-timeouts.patch removed from -mm tree
Date: Thu, 19 Feb 2009 11:17:53 -0800
Message-ID: <200902191917.n1JJHrjW016422@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbZBSTXo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Feb 2009 14:23:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpihet@mvista.com, alowe@mvista.com, drzeus-mmc@drzeus.cx, ext-adrian.hunter@nokia.com, jarkko.lavinen@nokia.com, tony@atomide.com, mm-commits@vger.kernel.org


The patch titled
     omap: mmc: replace infinite loops with timeouts
has been removed from the -mm tree.  Its filename was
     omap-mmc-replace-infinite-loops-with-timeouts.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: omap: mmc: replace infinite loops with timeouts
From: Jean Pihet <jpihet@mvista.com>

Replace the infinite 'while() ;' loops with a finite loop version.

Signed-off-by: Jean Pihet <jpihet@mvista.com>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Acked-by: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Lavinen <jarkko.lavinen@nokia.com>
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/omap_hsmmc.c |   54 +++++++++++++++++---------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff -puN drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts drivers/mmc/host/omap_hsmmc.c
--- a/drivers/mmc/host/omap_hsmmc.c~omap-mmc-replace-infinite-loops-with-timeouts
+++ a/drivers/mmc/host/omap_hsmmc.c
@@ -375,6 +375,32 @@ static void mmc_omap_report_irq(struct m
 }
 #endif  /* CONFIG_MMC_DEBUG */
 
+/*
+ * MMC controller internal state machines reset
+ *
+ * Used to reset command or data internal state machines, using respectively
+ *  SRC or SRD bit of SYSCTL register
+ * Can be called from interrupt context
+ */
+static inline void mmc_omap_reset_controller_fsm(struct mmc_omap_host *host,
+		unsigned long bit)
+{
+	unsigned long i = 0;
+	unsigned long limit = (loops_per_jiffy *
+				msecs_to_jiffies(MMC_TIMEOUT_MS));
+
+	OMAP_HSMMC_WRITE(host->base, SYSCTL,
+			 OMAP_HSMMC_READ(host->base, SYSCTL) | bit);
+
+	while ((OMAP_HSMMC_READ(host->base, SYSCTL) & bit) &&
+		(i++ < limit))
+		cpu_relax();
+
+	if (OMAP_HSMMC_READ(host->base, SYSCTL) & bit)
+		dev_err(mmc_dev(host->mmc),
+			"Timeout waiting on controller reset in %s\n",
+			__func__);
+}
 
 /*
  * MMC controller IRQ handler
@@ -403,13 +429,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 			(status & CMD_CRC)) {
 			if (host->cmd) {
 				if (status & CMD_TIMEOUT) {
-					OMAP_HSMMC_WRITE(host->base, SYSCTL,
-						OMAP_HSMMC_READ(host->base,
-								SYSCTL) | SRC);
-					while (OMAP_HSMMC_READ(host->base,
-							SYSCTL) & SRC)
-						;
-
+					mmc_omap_reset_controller_fsm(host, SRC);
 					host->cmd->error = -ETIMEDOUT;
 				} else {
 					host->cmd->error = -EILSEQ;
@@ -418,12 +438,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 			}
 			if (host->data) {
 				mmc_dma_cleanup(host);
-				OMAP_HSMMC_WRITE(host->base, SYSCTL,
-					OMAP_HSMMC_READ(host->base,
-							SYSCTL) | SRD);
-				while (OMAP_HSMMC_READ(host->base,
-						SYSCTL) & SRD)
-					;
+				mmc_omap_reset_controller_fsm(host, SRD);
 			}
 		}
 		if ((status & DATA_TIMEOUT) ||
@@ -433,12 +448,7 @@ static irqreturn_t mmc_omap_irq(int irq,
 					mmc_dma_cleanup(host);
 				else
 					host->data->error = -EILSEQ;
-				OMAP_HSMMC_WRITE(host->base, SYSCTL,
-					OMAP_HSMMC_READ(host->base,
-							SYSCTL) | SRD);
-				while (OMAP_HSMMC_READ(host->base,
-						SYSCTL) & SRD)
-					;
+				mmc_omap_reset_controller_fsm(host, SRD);
 				end_trans = 1;
 			}
 		}
@@ -529,11 +539,7 @@ static void mmc_omap_detect(struct work_
 	if (host->carddetect) {
 		mmc_detect_change(host->mmc, (HZ * 200) / 1000);
 	} else {
-		OMAP_HSMMC_WRITE(host->base, SYSCTL,
-			OMAP_HSMMC_READ(host->base, SYSCTL) | SRD);
-		while (OMAP_HSMMC_READ(host->base, SYSCTL) & SRD)
-			;
