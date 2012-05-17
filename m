From: akpm@linux-foundation.org
Subject: [to-be-updated] ata-sata_mv-remove-conditional-compilation-of-clk-code.patch removed from -mm tree
Date: Thu, 17 May 2012 13:42:25 -0700
Message-ID: <20120517204226.59F10A0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:42213 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab2EQUm1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 16:42:27 -0400
Received: by ggeh3 with SMTP id h3so290626gge.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 13:42:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: viresh.kumar@st.com, andrew@lunn.ch, jgarzik@redhat.com, mturquette@linaro.org, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ata/sata_mv: remove conditional compilation of clk code
has been removed from the -mm tree.  Its filename was
     ata-sata_mv-remove-conditional-compilation-of-clk-code.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: ata/sata_mv: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/ata/sata_mv.c |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN drivers/ata/sata_mv.c~ata-sata_mv-remove-conditional-compilation-of-clk-code drivers/ata/sata_mv.c
--- a/drivers/ata/sata_mv.c~ata-sata_mv-remove-conditional-compilation-of-clk-code
+++ a/drivers/ata/sata_mv.c
@@ -551,10 +551,8 @@ struct mv_host_priv {
 	u32			irq_mask_offset;
 	u32			unmask_all_irqs;
 
-#if defined(CONFIG_HAVE_CLK)
 	struct clk		*clk;
 	struct clk              **port_clks;
-#endif
 	/*
 	 * These consistent DMA memory pools give us guaranteed
 	 * alignment for hardware-accessed data structures,
@@ -4028,9 +4026,7 @@ static int mv_platform_probe(struct plat
 	struct resource *res;
 	int n_ports = 0;
 	int rc;
-#if defined(CONFIG_HAVE_CLK)
 	int port;
-#endif
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
@@ -4058,13 +4054,11 @@ static int mv_platform_probe(struct plat
 
 	if (!host || !hpriv)
 		return -ENOMEM;
-#if defined(CONFIG_HAVE_CLK)
 	hpriv->port_clks = devm_kzalloc(&pdev->dev,
 					sizeof(struct clk *) * n_ports,
 					GFP_KERNEL);
 	if (!hpriv->port_clks)
 		return -ENOMEM;
-#endif
 	host->private_data = hpriv;
 	hpriv->n_ports = n_ports;
 	hpriv->board_idx = chip_soc;
@@ -4074,7 +4068,6 @@ static int mv_platform_probe(struct plat
 				   resource_size(res));
 	hpriv->base -= SATAHC0_REG_BASE;
 
-#if defined(CONFIG_HAVE_CLK)
 	hpriv->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(hpriv->clk))
 		dev_notice(&pdev->dev, "cannot get optional clkdev\n");
@@ -4088,7 +4081,6 @@ static int mv_platform_probe(struct plat
 		if (!IS_ERR(hpriv->port_clks[port]))
 			clk_prepare_enable(hpriv->port_clks[port]);
 	}
-#endif
 
 	/*
 	 * (Re-)program MBUS remapping windows if we are asked to.
@@ -4115,7 +4107,6 @@ static int mv_platform_probe(struct plat
 		return 0;
 
 err:
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
@@ -4126,7 +4117,6 @@ err:
 			clk_put(hpriv->port_clks[port]);
 		}
 	}
-#endif
 
 	return rc;
 }
@@ -4142,13 +4132,10 @@ err:
 static int __devexit mv_platform_remove(struct platform_device *pdev)
 {
 	struct ata_host *host = platform_get_drvdata(pdev);
-#if defined(CONFIG_HAVE_CLK)
 	struct mv_host_priv *hpriv = host->private_data;
 	int port;
-#endif
 	ata_host_detach(host);
 
-#if defined(CONFIG_HAVE_CLK)
 	if (!IS_ERR(hpriv->clk)) {
 		clk_disable_unprepare(hpriv->clk);
 		clk_put(hpriv->clk);
@@ -4159,7 +4146,6 @@ static int __devexit mv_platform_remove(
 			clk_put(hpriv->port_clks[port]);
 		}
 	}
-#endif
 	return 0;
 }
 
_

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

