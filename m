From: akpm@linux-foundation.org
Subject: + msm_sdccc-stylistic-cleaning.patch added to -mm tree
Date: Wed, 01 Jul 2009 15:52:00 -0700
Message-ID: <200907012252.n61Mq02A003680@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752840AbZGAWxM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 18:53:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, drzeus-list@drzeus.cx, pavel@ucw.cz, san@android.com, swetland@google.com


The patch titled
     msm_sdcc.c: stylistic cleaning
has been added to the -mm tree.  Its filename is
     msm_sdccc-stylistic-cleaning.patch

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
Subject: msm_sdcc.c: stylistic cleaning
From: Joe Perches <joe@perches.com>

Make it a bit more like typical kernel style.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Brian Swetland <swetland@google.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: San Mehat <san@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/msm_sdcc.c |   45 ++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff -puN drivers/mmc/host/msm_sdcc.c~msm_sdccc-stylistic-cleaning drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~msm_sdccc-stylistic-cleaning
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -43,7 +43,6 @@
 #include <mach/dma.h>
 #include <mach/htc_pwrsink.h>
 
-
 #include "msm_sdcc.h"
 
 #define DRIVER_NAME "msm-sdcc"
@@ -58,8 +57,6 @@ static unsigned int msmsdcc_sdioirq;
 #define PIO_SPINMAX 30
 #define CMD_SPINMAX 20
 
-
-
 static void
 msmsdcc_start_command(struct msmsdcc_host *host, struct mmc_command *cmd,
 		      u32 c);
@@ -98,16 +95,17 @@ msmsdcc_stop_data(struct msmsdcc_host *h
 
 uint32_t msmsdcc_fifo_addr(struct msmsdcc_host *host)
 {
-	if (host->pdev_id == 1)
+	switch (host->pdev_id) {
+	case 1:
 		return MSM_SDC1_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 2)
+	case 2:
 		return MSM_SDC2_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 3)
+	case 3:
 		return MSM_SDC3_PHYS + MMCIFIFO;
-	else if (host->pdev_id == 4)
+	case 4:
 		return MSM_SDC4_PHYS + MMCIFIFO;
-	else
-		BUG();
+	}
+	BUG();
 	return 0;
 }
 
@@ -156,8 +154,8 @@ msmsdcc_dma_complete_func(struct msm_dmo
 		struct scatterlist *sg = host->dma.sg;
 		int i;
 
-		for (i = 0; i < host->dma.num_ents; i++, sg++)
-			flush_dcache_page(sg_page(sg));
+		for (i = 0; i < host->dma.num_ents; i++)
+			flush_dcache_page(sg_page(sg++));
 	}
 
 	host->dma.sg = NULL;
@@ -222,15 +220,20 @@ static int msmsdcc_config_dma(struct msm
 
 	nc = host->dma.nc;
 
-	if (host->pdev_id == 1)
+	switch (host->pdev_id) {
+	case 1:
 		crci = MSMSDCC_CRCI_SDC1;
-	else if (host->pdev_id == 2)
+		break;
+	case 2:
 		crci = MSMSDCC_CRCI_SDC2;
-	else if (host->pdev_id == 3)
+		break;
+	case 3:
 		crci = MSMSDCC_CRCI_SDC3;
-	else if (host->pdev_id == 4)
+		break;
+	case 4:
 		crci = MSMSDCC_CRCI_SDC4;
-	else {
+		break;
+	default:
 		host->dma.sg = NULL;
 		host->dma.num_ents = 0;
 		return -ENOENT;
@@ -244,7 +247,7 @@ static int msmsdcc_config_dma(struct msm
 	host->curr.user_pages = 0;
 
 	n = dma_map_sg(mmc_dev(host->mmc), host->dma.sg,
-			host->dma.num_ents, host->dma.dir);
+		       host->dma.num_ents, host->dma.dir);
 
 	if (n != host->dma.num_ents) {
 		pr_err("%s: Unable to map in all sg elements\n",
@@ -318,7 +321,7 @@ msmsdcc_start_data(struct msmsdcc_host *
 	memset(&host->pio, 0, sizeof(host->pio));
 
 	clks = (unsigned long long)data->timeout_ns * host->clk_rate;
-	do_div(clks, 1000000000UL);
+	do_div(clks, NSEC_PER_SEC);
 	timeout = data->timeout_clks + (unsigned int)clks;
 	writel(timeout, base + MMCIDATATIMER);
 
@@ -371,9 +374,9 @@ msmsdcc_start_command(struct msmsdcc_hos
 		c |= MCI_CPSM_RESPONSE;
 	}
 
-	if ((((cmd->opcode == 17) || (cmd->opcode == 18))  ||
-	     ((cmd->opcode == 24) || (cmd->opcode == 25))) ||
-	      (cmd->opcode == 53))
+	if (cmd->opcode == 17 || cmd->opcode == 18 ||
+	    cmd->opcode == 24 || cmd->opcode == 25 ||
+	    cmd->opcode == 53)
 		c |= MCI_CSPM_DATCMD;
 
 	if (cmd == cmd->mrq->stop)
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch
mmc-msm_sdccc-driver-for-htc-dream.patch
msm_sdccc-convert-printkkern_level-to-pr_level.patch
msm_sdccc-stylistic-cleaning.patch
msm_sdccc-move-overly-indented-code-to-separate-function.patch

