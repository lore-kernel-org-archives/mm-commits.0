From: akpm@linux-foundation.org
Subject: [to-be-updated] mmc-make-the-configuration-memory-resource-optional.patch removed from -mm tree
Date: Tue, 29 Sep 2009 15:57:43 -0700
Message-ID: <200909292257.n8TMvnRK026974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50348 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbZI2W6J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:58:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: g.liakhovetski@gmx.de, damm@opensource.se, drzeus@drzeus.cx, ian@mnementh.co.uk, lethal@linux-sh.org, matt@console-pimps.org, philipl@overt.org, roberto.foglietta@gmail.com, mm-commit


The patch titled
     mmc: make the configuration memory resource optional
has been removed from the -mm tree.  Its filename was
     mmc-make-the-configuration-memory-resource-optional.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mmc: make the configuration memory resource optional
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Add support for tmio_mmc hardware configurations, that lack the cnf io
area, like SuperH SoCs.  With this patch such hardware can pass a single
ctl io area with the platform data.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Magnus Damm <damm@opensource.se>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Matt Fleming <matt@console-pimps.org>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: "Roberto A. Foglietta" <roberto.foglietta@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mmc/host/tmio_mmc.c |   18 +++++++++++-------
 drivers/mmc/host/tmio_mmc.h |    6 ++++++
 2 files changed, 17 insertions(+), 7 deletions(-)

diff -puN drivers/mmc/host/tmio_mmc.c~mmc-make-the-configuration-memory-resource-optional drivers/mmc/host/tmio_mmc.c
--- a/drivers/mmc/host/tmio_mmc.c~mmc-make-the-configuration-memory-resource-optional
+++ a/drivers/mmc/host/tmio_mmc.c
@@ -519,12 +519,12 @@ static int __devinit tmio_mmc_probe(stru
 	struct mmc_host *mmc;
 	int ret = -EINVAL;
 
-	if (dev->num_resources != 3)
+	if (dev->num_resources < 2 || dev->num_resources > 3)
 		goto out;
 
 	res_ctl = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	res_cnf = platform_get_resource(dev, IORESOURCE_MEM, 1);
-	if (!res_ctl || !res_cnf)
+	if (!res_ctl)
 		goto out;
 
 	pdata = cell->driver_data;
@@ -548,9 +548,11 @@ static int __devinit tmio_mmc_probe(stru
 	if (!host->ctl)
 		goto host_free;
 
-	host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
-	if (!host->cnf)
-		goto unmap_ctl;
+	if (res_cnf) {
+		host->cnf = ioremap(res_cnf->start, resource_size(res_cnf));
+		if (!host->cnf)
+			goto unmap_ctl;
+	}
 
 	mmc->ops = &tmio_mmc_ops;
 	mmc->caps = MMC_CAP_4_BIT_DATA;
@@ -606,7 +608,8 @@ static int __devinit tmio_mmc_probe(stru
 	return 0;
 
 unmap_cnf:
-	iounmap(host->cnf);
+	if (host->cnf)
+		iounmap(host->cnf);
 unmap_ctl:
 	iounmap(host->ctl);
 host_free:
@@ -626,7 +629,8 @@ static int __devexit tmio_mmc_remove(str
 		mmc_remove_host(mmc);
 		free_irq(host->irq, host);
 		iounmap(host->ctl);
-		iounmap(host->cnf);
+		if (host->cnf)
+			iounmap(host->cnf);
 		mmc_free_host(mmc);
 	}
 
diff -puN drivers/mmc/host/tmio_mmc.h~mmc-make-the-configuration-memory-resource-optional drivers/mmc/host/tmio_mmc.h
--- a/drivers/mmc/host/tmio_mmc.h~mmc-make-the-configuration-memory-resource-optional
+++ a/drivers/mmc/host/tmio_mmc.h
@@ -166,18 +166,24 @@ static inline void sd_ctrl_write32(struc
 static inline void sd_config_write8(struct tmio_mmc_host *host, int addr,
 		u8 val)
 {
+	if (!host->cnf)
+		return;
 	writeb(val, host->cnf + (addr << host->bus_shift));
 }
 
 static inline void sd_config_write16(struct tmio_mmc_host *host, int addr,
 		u16 val)
 {
+	if (!host->cnf)
+		return;
 	writew(val, host->cnf + (addr << host->bus_shift));
 }
 
 static inline void sd_config_write32(struct tmio_mmc_host *host, int addr,
 		u32 val)
 {
+	if (!host->cnf)
+		return;
 	writew(val, host->cnf + (addr << host->bus_shift));
 	writew(val >> 16, host->cnf + ((addr + 2) << host->bus_shift));
 }
_

Patches currently in -mm which might be from g.liakhovetski@gmx.de are

linux-next.patch
mmc-make-the-configuration-memory-resource-optional.patch
tmio_mmc-optionally-support-using-platform-clock.patch
sh-switch-migo-r-to-use-the-tmio-mmc-driver-instead-of-spi.patch

