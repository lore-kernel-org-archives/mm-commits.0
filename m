From: akpm@linux-foundation.org
Subject: + net-stmmac-remove-conditional-compilation-of-clk-code.patch added to -mm tree
Date: Tue, 08 May 2012 15:33:04 -0700
Message-ID: <20120508223304.F13B9A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:59134 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757713Ab2EHWdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2012 18:33:07 -0400
Received: by lagm6 with SMTP id m6so168208lag.1
        for <mm-commits@vger.kernel.org>; Tue, 08 May 2012 15:33:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: viresh.kumar@st.com, davem@davemloft.net, mturquette@linaro.org, peppe.cavallaro@st.com, rmk@arm.linux.org.uk, sshtylyov@ru.mvista.com


The patch titled
     Subject: net/stmmac: remove conditional compilation of clk code
has been added to the -mm tree.  Its filename is
     net-stmmac-remove-conditional-compilation-of-clk-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Viresh Kumar <viresh.kumar@st.com>
Subject: net/stmmac: remove conditional compilation of clk code

With addition of dummy clk_*() calls for non CONFIG_HAVE_CLK cases in
clk.h, there is no need to have clk code enclosed in #ifdef
CONFIG_HAVE_CLK, #endif macros.

This also fixes error paths of probe(), as a goto is required in this patch.

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/ethernet/stmicro/stmmac/stmmac.h      |   41 ------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   33 ++++-----
 2 files changed, 17 insertions(+), 57 deletions(-)

diff -puN drivers/net/ethernet/stmicro/stmmac/stmmac.h~net-stmmac-remove-conditional-compilation-of-clk-code drivers/net/ethernet/stmicro/stmmac/stmmac.h
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h~net-stmmac-remove-conditional-compilation-of-clk-code
+++ a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -81,9 +81,7 @@ struct stmmac_priv {
 	struct stmmac_counters mmc;
 	struct dma_features dma_cap;
 	int hw_cap_support;
-#ifdef CONFIG_HAVE_CLK
 	struct clk *stmmac_clk;
-#endif
 	int clk_csr;
 };
 
@@ -103,42 +101,3 @@ int stmmac_dvr_remove(struct net_device 
 struct stmmac_priv *stmmac_dvr_probe(struct device *device,
 				     struct plat_stmmacenet_data *plat_dat,
 				     void __iomem *addr);
-
-#ifdef CONFIG_HAVE_CLK
-static inline int stmmac_clk_enable(struct stmmac_priv *priv)
-{
-	if (!IS_ERR(priv->stmmac_clk))
-		return clk_enable(priv->stmmac_clk);
-
-	return 0;
-}
-
-static inline void stmmac_clk_disable(struct stmmac_priv *priv)
-{
-	if (IS_ERR(priv->stmmac_clk))
-		return;
-
-	clk_disable(priv->stmmac_clk);
-}
-static inline int stmmac_clk_get(struct stmmac_priv *priv)
-{
-	priv->stmmac_clk = clk_get(priv->device, NULL);
-
-	if (IS_ERR(priv->stmmac_clk))
-		return PTR_ERR(priv->stmmac_clk);
-
-	return 0;
-}
-#else
-static inline int stmmac_clk_enable(struct stmmac_priv *priv)
-{
-	return 0;
-}
-static inline void stmmac_clk_disable(struct stmmac_priv *priv)
-{
-}
-static inline int stmmac_clk_get(struct stmmac_priv *priv)
-{
-	return 0;
-}
-#endif /* CONFIG_HAVE_CLK */
diff -puN drivers/net/ethernet/stmicro/stmmac/stmmac_main.c~net-stmmac-remove-conditional-compilation-of-clk-code drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c~net-stmmac-remove-conditional-compilation-of-clk-code
+++ a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -28,6 +28,7 @@
 	https://bugzilla.stlinux.com/
 *******************************************************************************/
 
+#include <linux/clk.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/ip.h>
@@ -165,12 +166,8 @@ static void stmmac_verify_args(void)
 
 static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 {
-#ifdef CONFIG_HAVE_CLK
 	u32 clk_rate;
 
-	if (IS_ERR(priv->stmmac_clk))
-		return;
-
 	clk_rate = clk_get_rate(priv->stmmac_clk);
 
 	/* Platform provided default clk_csr would be assumed valid
@@ -192,7 +189,6 @@ static void stmmac_clk_csr_set(struct st
 	   * we can not estimate the proper divider as it is not known
 	   * the frequency of clk_csr_i. So we do not change the default
 	   * divider. */
-#endif
 }
 
 #if defined(STMMAC_XMIT_DEBUG) || defined(STMMAC_RX_DEBUG)
@@ -971,7 +967,7 @@ static int stmmac_open(struct net_device
 	} else
 		priv->tm->enable = 1;
 #endif
-	stmmac_clk_enable(priv);
+	clk_enable(priv->stmmac_clk);
 
 	stmmac_check_ether_addr(priv);
 
@@ -1075,7 +1071,7 @@ open_error:
 	if (priv->phydev)
 		phy_disconnect(priv->phydev);
 
-	stmmac_clk_disable(priv);
+	clk_disable(priv->stmmac_clk);
 
 	return ret;
 }
@@ -1128,7 +1124,7 @@ static int stmmac_release(struct net_dev
 #ifdef CONFIG_STMMAC_DEBUG_FS
 	stmmac_exit_fs();
 #endif
-	stmmac_clk_disable(priv);
+	clk_disable(priv->stmmac_clk);
 
 	return 0;
 }
@@ -1922,11 +1918,14 @@ struct stmmac_priv *stmmac_dvr_probe(str
 	ret = register_netdev(ndev);
 	if (ret) {
 		pr_err("%s: ERROR %i registering the device\n", __func__, ret);
-		goto error;
+		goto error_netdev_register;
 	}
 
-	if (stmmac_clk_get(priv))
+	priv->stmmac_clk = clk_get(priv->device, NULL);
+	if (IS_ERR(priv->stmmac_clk)) {
 		pr_warning("%s: warning: cannot get CSR clock\n", __func__);
+		goto error_clk_get;
+	}
 
 	/* If a specific clk_csr value is passed from the platform
 	 * this means that the CSR Clock Range selection cannot be
@@ -1944,15 +1943,17 @@ struct stmmac_priv *stmmac_dvr_probe(str
 	if (ret < 0) {
 		pr_debug("%s: MDIO bus (id: %d) registration failed",
 			 __func__, priv->plat->bus_id);
-		goto error;
+		goto error_mdio_register;
 	}
 
 	return priv;
 
-error:
-	netif_napi_del(&priv->napi);
-
+error_mdio_register:
+	clk_put(priv->stmmac_clk);
+error_clk_get:
 	unregister_netdev(ndev);
+error_netdev_register:
+	netif_napi_del(&priv->napi);
 	free_netdev(ndev);
 
 	return NULL;
@@ -2020,7 +2021,7 @@ int stmmac_suspend(struct net_device *nd
 	else {
 		stmmac_set_mac(priv->ioaddr, false);
 		/* Disable clock in case of PWM is off */
-		stmmac_clk_disable(priv);
+		clk_disable(priv->stmmac_clk);
 	}
 	spin_unlock(&priv->lock);
 	return 0;
@@ -2044,7 +2045,7 @@ int stmmac_resume(struct net_device *nde
 		priv->hw->mac->pmt(priv->ioaddr, 0);
 	else
 		/* enable the clk prevously disabled */
-		stmmac_clk_enable(priv);
+		clk_enable(priv->stmmac_clk);
 
 	netif_device_attach(ndev);
 
_
Subject: Subject: net/stmmac: remove conditional compilation of clk code

Patches currently in -mm which might be from viresh.kumar@st.com are

linux-next.patch
drivers-thermal-spear_thermalc-add-device-tree-probing-capability.patch
clk-add-non-config_have_clk-routines.patch
clk-remove-redundant-depends-on-from-drivers-kconfig.patch
i2c-i2c-pxa-remove-conditional-compilation-of-clk-code.patch
usb-marvell-remove-conditional-compilation-of-clk-code.patch
usb-musb-remove-conditional-compilation-of-clk-code.patch
ata-pata_arasan-remove-conditional-compilation-of-clk-code.patch
ata-sata_mv-remove-conditional-compilation-of-clk-code.patch
net-c_can-remove-conditional-compilation-of-clk-code.patch
net-stmmac-remove-conditional-compilation-of-clk-code.patch
gadget-m66592-remove-conditional-compilation-of-clk-code.patch
gadget-r8a66597-remove-conditional-compilation-of-clk-code.patch
usb-host-r8a66597-remove-conditional-compilation-of-clk-code.patch
rtc-spear-add-device-tree-probing-capability.patch

