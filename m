From: akpm@linux-foundation.org
Subject: + mmc-balance-tmio-mmc-cell-enable-disable-calls.patch added to -mm tree
Date: Tue, 01 Dec 2009 13:54:21 -0800
Message-ID: <200912012154.nB1LsL0R029951@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53884 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752753AbZLAVyT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Dec 2009 16:54:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: damm@opensource.se, lethal@linux-sh.org, linux-mmc@vger.kernel.org


The patch titled
     mmc: balance tmio-mmc cell enable()/disable() calls
has been added to the -mm tree.  Its filename is
     mmc-balance-tmio-mmc-cell-enable-disable-calls.patch

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
Subject: mmc: balance tmio-mmc cell enable()/disable() calls
From: Magnus Damm <damm@opensource.se>

Add cell->disable() calls to the tmio-mmc probe() error handling and the
remove() function.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: <linux-mmc@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-balance-tmio-mmc-cell-enable-disable-calls drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-balance-tmio-mmc-cell-enable-disable-calls
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -577,14 +577,14 @@ static int __devinit tmio_mmc_probe(stru
 	if (ret >= 0)
 		host->irq = ret;
 	else
-		goto unmap_ctl;
+		goto cell_disable;
 
 	disable_mmc_irqs(host, TMIO_MASK_ALL);
 
 	ret = request_irq(host->irq, tmio_mmc_irq, IRQF_DISABLED |
 		IRQF_TRIGGER_FALLING, dev_name(&dev->dev), host);
 	if (ret)
-		goto unmap_ctl;
+		goto cell_disable;
 
 	mmc_add_host(mmc);
 
@@ -596,6 +596,9 @@ static int __devinit tmio_mmc_probe(stru
 
 	return 0;
 
+cell_disable:
+	if (cell->disable)
+		cell->disable(dev);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -606,6 +609,7 @@ out:
 
 static int __devexit tmio_mmc_remove(struct platform_device *dev)
 {
+	struct mfd_cell	*cell = (struct mfd_cell *)dev->dev.platform_data;
 	struct mmc_host *mmc = platform_get_drvdata(dev);
 
 	platform_set_drvdata(dev, NULL);
@@ -614,6 +618,8 @@ static int __devexit tmio_mmc_remove(str
 		struct tmio_mmc_host *host = mmc_priv(mmc);
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
+		if (cell->disable)
+			cell->disable(dev);
 		iounmap(host->ctl);
 		mmc_free_host(mmc);
 	}
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch
clocksource-add-argument-to-resume-callback.patch
clocksource-start-cmt-at-clocksource-resume.patch
mmc-let-tmio-mmc-use-dev_name-with-request_irq.patch
mmc-remove-const-from-tmio-mmc-platform-data-v2.patch
mmc-balance-tmio-mmc-cell-enable-disable-calls.patch
spi-superh-msiof-spi-master-driver.patch
spi-superh-msiof-spi-master-driver-update.patch

