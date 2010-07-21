From: akpm@linux-foundation.org
Subject: + drivers-mmc-host-msm-sdcc-remove-dead-config-options.patch added to -mm tree
Date: Wed, 21 Jul 2010 14:18:03 -0700
Message-ID: <201007212118.o6LLI3fc015813__31133.9322630831$1279747130$gmane$org@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143Ab0GUVSo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 17:18:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qy03fugy@stud.informatik.uni-erlangen.de, davidb@codeaurora.org, dwalker@codeaurora.org, linux-mmc@vger.kernel.org


The patch titled
     drivers/mmc/host/msm-sdcc: remove dead config options
has been added to the -mm tree.  Its filename is
     drivers-mmc-host-msm-sdcc-remove-dead-config-options.patch

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
Subject: drivers/mmc/host/msm-sdcc: remove dead config options
From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

CONFIG_MMC_MSM7X00A_RESUME_IN_WQ and CONFIG_MMC_EMBEDDED_SDIO don't exist
in Kconfig and is never defined anywhere else, therefore removing all
references for it from the source code.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Acked-by: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@codeaurora.org>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/msm_sdcc.c |   25 -------------------------
 drivers/mmc/host/msm_sdcc.h |    4 ----
 2 files changed, 29 deletions(-)

diff -puN drivers/mmc/host/msm_sdcc.c~drivers-mmc-host-msm-sdcc-remove-dead-config-options drivers/mmc/host/msm_sdcc.c
--- a/drivers/mmc/host/msm_sdcc.c~drivers-mmc-host-msm-sdcc-remove-dead-config-options
+++ a/drivers/mmc/host/msm_sdcc.c
@@ -1129,15 +1129,6 @@ msmsdcc_probe(struct platform_device *pd
 	host->dmares = dmares;
 	spin_lock_init(&host->lock);
 
-#ifdef CONFIG_MMC_EMBEDDED_SDIO
-	if (plat->embedded_sdio)
-		mmc_set_embedded_sdio_data(mmc,
-					   &plat->embedded_sdio->cis,
-					   &plat->embedded_sdio->cccr,
-					   plat->embedded_sdio->funcs,
-					   plat->embedded_sdio->num_funcs);
-#endif
-
 	/*
 	 * Setup DMA
 	 */
@@ -1299,22 +1290,6 @@ msmsdcc_probe(struct platform_device *pd
 }
 
 #ifdef CONFIG_PM
-#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
-static void
-do_resume_work(struct work_struct *work)
-{
-	struct msmsdcc_host *host =
-		container_of(work, struct msmsdcc_host, resume_task);
-	struct mmc_host	*mmc = host->mmc;
-
-	if (mmc) {
-		mmc_resume_host(mmc);
-		if (host->stat_irq)
-			enable_irq(host->stat_irq);
-	}
-}
-#endif
-
 
 static int
 msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
diff -puN drivers/mmc/host/msm_sdcc.h~drivers-mmc-host-msm-sdcc-remove-dead-config-options drivers/mmc/host/msm_sdcc.h
--- a/drivers/mmc/host/msm_sdcc.h~drivers-mmc-host-msm-sdcc-remove-dead-config-options
+++ a/drivers/mmc/host/msm_sdcc.h
@@ -235,10 +235,6 @@ struct msmsdcc_host {
 	int			cmdpoll;
 	struct msmsdcc_stats	stats;
 
-#ifdef CONFIG_MMC_MSM7X00A_RESUME_IN_WQ
-	struct work_struct	resume_task;
-#endif
