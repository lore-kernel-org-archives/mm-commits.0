From: akpm@linux-foundation.org
Subject: + mmc-make-the-configuration-memory-resource-optional.patch added to -mm tree
Date: Fri, 24 Jul 2009 15:19:32 -0700
Message-ID: <200907242219.n6OMJWYr007241@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50947 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751793AbZGXWU2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Jul 2009 18:20:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: g.liakhovetski@gmx.de, damm@opensource.se, drzeus@drzeus.cx, ian@mnementh.co.uk, lethal@linux-sh.org, matt@console-pimps.org, roberto.foglietta@gmail.com


The patch titled
     mmc: make the configuration memory resource optional
has been added to the -mm tree.  Its filename is
     mmc-make-the-configuration-memory-resource-optional.patch

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
spi-remove-imx-spi-driver.patch
spi-add-spi-driver-for-most-known-imx-socs.patch

