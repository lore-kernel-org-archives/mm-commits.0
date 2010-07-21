From: akpm@linux-foundation.org
Subject: + edac-mpc85xx-fix-coldplug-hotplug-module-autoloading.patch added to -mm tree
Date: Wed, 21 Jul 2010 15:42:27 -0700
Message-ID: <201007212242.o6LMgR86019273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52048 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754908Ab0GUWnA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 18:43:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@mvista.com, djiang@mvista.com, dougthompson@xmission.com, galak@kernel.crashing.org, ptyser@xes-inc.com


The patch titled
     edac: mpc85xx: fix coldplug/hotplug module autoloading
has been added to the -mm tree.  Its filename is
     edac-mpc85xx-fix-coldplug-hotplug-module-autoloading.patch

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
Subject: edac: mpc85xx: fix coldplug/hotplug module autoloading
From: Anton Vorontsov <avorontsov@mvista.com>

MPC85xx EDAC driver is missing module device aliases, so the driver won't
load automatically on boot.  This patch fixes the issue by adding proper
MODULE_DEVICE_TABLE() macros.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Peter Tyser <ptyser@xes-inc.com>
Cc: Dave Jiang <djiang@mvista.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/mpc85xx_edac.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-coldplug-hotplug-module-autoloading drivers/edac/mpc85xx_edac.c
--- a/drivers/edac/mpc85xx_edac.c~edac-mpc85xx-fix-coldplug-hotplug-module-autoloading
+++ a/drivers/edac/mpc85xx_edac.c
@@ -336,6 +336,7 @@ static struct of_device_id mpc85xx_pci_e
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_pci_err_of_match);
 
 static struct of_platform_driver mpc85xx_pci_err_driver = {
 	.probe = mpc85xx_pci_err_probe,
@@ -654,6 +655,7 @@ static struct of_device_id mpc85xx_l2_er
 	{ .compatible = "fsl,p4080-l2-cache-controller", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
 
 static struct of_platform_driver mpc85xx_l2_err_driver = {
 	.probe = mpc85xx_l2_err_probe,
@@ -1133,6 +1135,7 @@ static struct of_device_id mpc85xx_mc_er
 	{ .compatible = "fsl,p4080-memory-controller", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, mpc85xx_mc_err_of_match);
 
 static struct of_platform_driver mpc85xx_mc_err_driver = {
 	.probe = mpc85xx_mc_err_probe,
_

Patches currently in -mm which might be from avorontsov@mvista.com are

origin.patch
edac-mpc85xx-add-support-for-new-mpcxxx-pxxxx-edac-controllers.patch
edac-mpc85xx-fix-coldplug-hotplug-module-autoloading.patch
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

