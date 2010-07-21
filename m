From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch added to -mm tree
Date: Wed, 21 Jul 2010 15:40:40 -0700
Message-ID: <201007212240.o6LMeeGS019228@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60477 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020Ab0GUWlA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 18:41:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, djiang@mvista.com, dougthompson@xmission.com, ptyser@xes-inc.com, scottwood@freescale.com


The patch titled
     edac: mpc85xx: add support for new MPCxxx/Pxxxx EDAC controllers
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch

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
Subject: edac: mpc85xx: add support for new MPCxxx/Pxxxx EDAC controllers
From: Anton Vorontsov <avorontsov@mvista.com>

Simply add proper IDs into the device table.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Scott Wood <scottwood@freescale.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers
+++ a/drivers/edac/mpc85xx_edac.c
@@ -646,8 +646,12 @@ static struct of_device_id mpc85xx_l2_er
 	{ .compatible = "fsl,mpc8555-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8560-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8568-l2-cache-controller", },
+	{ .compatible = "fsl,mpc8569-l2-cache-controller", },
 	{ .compatible = "fsl,mpc8572-l2-cache-controller", },
+	{ .compatible = "fsl,p1020-l2-cache-controller", },
+	{ .compatible = "fsl,p1021-l2-cache-controller", },
 	{ .compatible = "fsl,p2020-l2-cache-controller", },
+	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
 
@@ -1123,7 +1127,10 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,mpc8569-memory-controller", },
 	{ .compatible = "fsl,mpc8572-memory-controller", },
 	{ .compatible = "fsl,mpc8349-memory-controller", },
+	{ .compatible = "fsl,p1020-memory-controller", },
+	{ .compatible = "fsl,p1021-memory-controller", },
 	{ .compatible = "fsl,p2020-memory-controller", },
+	{ .compatible = "fsl,p4080-memory-controller", },
 	{},
 };
 
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
linux-next.patch
sdhci-pltfm-switch-to-module-device-table-matching.patch
sdhci-pltfm-reorganize-makefile-entries-to-support-soc-devices.patch
sdhci-pltfm-add-support-for-cns3xxx-soc-devices.patch
sdhci-s3c-add-support-for-the-non-standard-minimal-clock-value.patch
sdhci-turn-timeout-timer-into-delayed-work.patch
sdhci-use-work-structs-instead-of-tasklets.patch
sdhci-clear-interrupt-status-register-just-once.patch
sdhci-use-threaded-irq-handler.patch
sdhci-turn-host-lock-into-a-mutex.patch
sdhci-get-rid-of-card-detect-work.patch
sdhci-get-rid-of-mdelays-where-it-is-safe-and-makes-sense.patch
sdhci-use-jiffies-instead-of-a-timeout-counter.patch
edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch

