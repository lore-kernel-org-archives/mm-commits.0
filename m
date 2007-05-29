From: akpm@linux-foundation.org
Subject: - mpc52xx_psc_spi-fix-it-for-config_ppc_merge.patch removed from -mm tree
Date: Tue, 29 May 2007 11:50:33 -0700
Message-ID: <200705291850.l4TIoWSB008270@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756302AbXE2TEW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 15:04:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: domen@coderock.org, dbrownell@users.sourceforge.net, domen.puncer@telargo.com, dragos.carp@toptica.com, mm-commits@vger.kernel.org


The patch titled
     mpc52xx_psc_spi: fix it for CONFIG_PPC_MERGE
has been removed from the -mm tree.  Its filename was
     mpc52xx_psc_spi-fix-it-for-config_ppc_merge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mpc52xx_psc_spi: fix it for CONFIG_PPC_MERGE
From: Domen Puncer <domen@coderock.org>

Fix mpc5200 PSC SPI driver to actually work for CONFIG_PPC_MERGE
- s/mpc52xx/mpc5200/, as this was changed in device tree some time ago
- fix spi id detection

The move from 'ppc' to 'powerpc' didn't quite match the latest
kernel.org code.

Signed-off-by: Domen Puncer <domen.puncer@telargo.com>
Acked-by: Dragos Carp <dragos.carp@toptica.com>
Acked-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/mpc52xx_psc_spi.c |   25 +++++++++++--------------
 1 files changed, 11 insertions(+), 14 deletions(-)

diff -puN drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-fix-it-for-config_ppc_merge drivers/spi/mpc52xx_psc_spi.c
--- a/drivers/spi/mpc52xx_psc_spi.c~mpc52xx_psc_spi-fix-it-for-config_ppc_merge
+++ a/drivers/spi/mpc52xx_psc_spi.c
@@ -329,8 +329,8 @@ static int mpc52xx_psc_spi_port_config(i
 	int ret = 0;
 
 #if defined(CONFIG_PPC_MERGE)
-	cdm = mpc52xx_find_and_map("mpc52xx-cdm");
-	gpio = mpc52xx_find_and_map("mpc52xx-gpio");
+	cdm = mpc52xx_find_and_map("mpc5200-cdm");
+	gpio = mpc52xx_find_and_map("mpc5200-gpio");
 #else
 	cdm = ioremap(MPC52xx_PA(MPC52xx_CDM_OFFSET), MPC52xx_CDM_SIZE);
 	gpio = ioremap(MPC52xx_PA(MPC52xx_GPIO_OFFSET), MPC52xx_GPIO_SIZE);
@@ -445,9 +445,6 @@ static int __init mpc52xx_psc_spi_do_pro
 	struct spi_master *master;
 	int ret;
 
-	if (pdata == NULL)
-		return -ENODEV;
-
 	master = spi_alloc_master(dev, sizeof *mps);
 	if (master == NULL)
 		return -ENOMEM;
@@ -594,17 +591,17 @@ static int __init mpc52xx_psc_spi_of_pro
 	}
 	regaddr64 = of_translate_address(op->node, regaddr_p);
 
+	/* get PSC id (1..6, used by port_config) */
 	if (op->dev.platform_data == NULL) {
-		struct device_node *np;
-		int i = 0;
+		const u32 *psc_nump;
 
-		for_each_node_by_type(np, "spi") {
-			if (of_find_device_by_node(np) == op) {
-				id = i;
-				break;
-			}
-			i++;
+		psc_nump = of_get_property(op->node, "cell-index", NULL);
+		if (!psc_nump || *psc_nump > 5) {
+			printk(KERN_ERR "mpc52xx_psc_spi: Device node %s has invalid "
+					"cell-index property\n", op->node->full_name);
+			return -EINVAL;
 		}
+		id = *psc_nump + 1;
 	}
 
 	return mpc52xx_psc_spi_do_probe(&op->dev, (u32)regaddr64, (u32)size64,
@@ -617,7 +614,7 @@ static int __exit mpc52xx_psc_spi_of_rem
 }
 
 static struct of_device_id mpc52xx_psc_spi_of_match[] = {
-	{ .type = "spi", .compatible = "mpc52xx-psc-spi", },
+	{ .type = "spi", .compatible = "mpc5200-psc-spi", },
 	{},
 };
 
_

Patches currently in -mm which might be from domen@coderock.org are
