From: akpm@linux-foundation.org
Subject: [to-be-updated] tmio_mmc-optionally-support-using-platform-clock.patch removed from -mm tree
Date: Tue, 29 Sep 2009 15:57:51 -0700
Message-ID: <200909292257.n8TMvpWD027074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZI2W6K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:58:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, damm@opensource.se, ian@mnementh.co.uk, lethal@linux-sh.org, matt@console-pimps.org, philipl@overt.org, philipp.zabel@gmail.com, pierre@ossman.eu, roberto.fogli


The patch titled
     tmio_mmc: optionally support using platform clock
has been removed from the -mm tree.  Its filename was
     tmio_mmc-optionally-support-using-platform-clock.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tmio_mmc: optionally support using platform clock
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

If the platform device has a clock associated with the tmio-mmc device,
use it.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Magnus Damm <damm@opensource.se>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Philip Langdale <philipl@overt.org>
Cc: Pierre Ossman <pierre@ossman.eu>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: pHilipp Zabel <philipp.zabel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch
#


 drivers/mmc/host/tmio_mmc.c |   21 +++++++++++++++++++++
 drivers/mmc/host/tmio_mmc.h |    3 +++
 include/linux/mfd/tmio.h    |    1 +
 3 files changed, 25 insertions(+)

diff -puN drivers/mmc/host/tmio_mmc.c~tmio_mmc-optionally-support-using-platform-clock drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~tmio_mmc-optionally-support-using-platform-clock
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -32,6 +32,7 @@
 #include <linux/mmc/host.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/tmio.h>
+#include <linux/clk.h>
 
 #include "tmio_mmc.h"
 
@@ -57,10 +58,18 @@ static void tmio_mmc_clk_stop(struct tmi
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, ~0x0100 &
 		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
+	if (!IS_ERR(host->clk) && host->clk_is_running) {
+		clk_disable(host->clk);
+		host->clk_is_running = false;
+	}
 }
 
 static void tmio_mmc_clk_start(struct tmio_mmc_host *host)
 {
+	if (!IS_ERR(host->clk) && !host->clk_is_running &&
+	    !clk_enable(host->clk))
+		host->clk_is_running = true;
+
 	sd_ctrl_write16(host, CTL_SD_CARD_CLK_CTL, 0x0100 |
 		sd_ctrl_read16(host, CTL_SD_CARD_CLK_CTL));
 	msleep(10);
@@ -567,6 +576,11 @@ static int __devinit tmio_mmc_probe(stru
 			goto unmap_cnf;
 	}
 
+	host->clk = clk_get(&dev->dev, pdata->clk_name);
+
+	if (!IS_ERR(host->clk) && !clk_enable(host->clk))
+		host->clk_is_running = true;
+
 	/* Enable the MMC/SD Control registers */
 	sd_config_write16(host, CNF_CMD, SDCREN);
 	sd_config_write32(host, CNF_CTL_BASE,
@@ -608,6 +622,11 @@ static int __devinit tmio_mmc_probe(stru
 	return 0;
 
 unmap_cnf:
+	if (!IS_ERR(host->clk)) {
+		clk_disable(host->clk);
+		host->clk_is_running = false;
+		clk_put(host->clk);
+	}
 	if (host->cnf)
 		iounmap(host->cnf);
 unmap_ctl:
@@ -632,6 +651,8 @@ static int __devexit tmio_mmc_remove(str
 		if (host->cnf)
 			iounmap(host->cnf);
 		mmc_free_host(mmc);
+		if (!IS_ERR(host->clk))
+			clk_put(host->clk);
 	}
 
 	return 0;
diff -puN drivers/mmc/host/tmio_mmc.h~tmio_mmc-optionally-support-using-platform-clock drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~tmio_mmc-optionally-support-using-platform-clock
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -108,6 +108,7 @@
 		sd_ctrl_write32((host), CTL_STATUS, mask); \
 	} while (0)
 
+struct clk;
 
 struct tmio_mmc_host {
 	void __iomem *cnf;
@@ -117,6 +118,8 @@ struct tmio_mmc_host {
 	struct mmc_request      *mrq;
 	struct mmc_data         *data;
 	struct mmc_host         *mmc;
+	struct clk		*clk;
+	bool			clk_is_running;
 	int                     irq;
 
 	/* pio related stuff */
diff -puN include/linux/mfd/tmio.h~tmio_mmc-optionally-support-using-platform-clock include/linux/mfd/tmio.h
--- a/include/linux/mfd/tmio.h~tmio_mmc-optionally-support-using-platform-clock
+++ a/include/linux/mfd/tmio.h
@@ -23,6 +23,7 @@
  */
 struct tmio_mmc_data {
 	const unsigned int		hclk;
+	const char			*clk_name;
 };
 
 /*
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch

