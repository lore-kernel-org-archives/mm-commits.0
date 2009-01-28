From: akpm@linux-foundation.org
Subject: + powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch added to -mm tree
Date: Tue, 27 Jan 2009 17:10:35 -0800
Message-ID: <200901280110.n0S1AZqt027982@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55913 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632AbZA1BK4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Jan 2009 20:10:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca


The patch titled
     powerpc/fsl_soc: isolate legacy fsl_spi support to mpc832x_rdb boards
has been added to the -mm tree.  Its filename is
     powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards.patch

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
Subject: powerpc/fsl_soc: isolate legacy fsl_spi support to mpc832x_rdb boards
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The advantages of this:
- Don't encourage legacy support;
- Less external symbols, less code to compile-in for !MPC832x_RDB
  platforms.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/83xx/mpc832x_rdb.c |  107 ++++++++++++++++++++
 arch/powerpc/sysdev/fsl_soc.c             |  107 --------------------
 arch/powerpc/sysdev/fsl_soc.h             |    4 
 3 files changed, 107 insertions(+), 111 deletions(-)

diff -puN arch/powerpc/platforms/83xx/mpc832x_rdb.c~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards arch/powerpc/platforms/83xx/mpc832x_rdb.c
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards
+++ a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -20,6 +20,7 @@
 #include <linux/spi/mmc_spi.h>
 #include <linux/mmc/host.h>
 #include <linux/of_platform.h>
+#include <linux/fsl_devices.h>
 
 #include <asm/time.h>
 #include <asm/ipic.h>
@@ -39,6 +40,112 @@
 #endif
 
 #ifdef CONFIG_QUICC_ENGINE
+static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
+				   struct spi_board_info *board_infos,
+				   unsigned int num_board_infos,
+				   void (*cs_control)(struct spi_device *dev,
+						      bool on))
+{
+	struct device_node *np;
+	unsigned int i = 0;
+
+	for_each_compatible_node(np, type, compatible) {
+		int ret;
+		unsigned int j;
+		const void *prop;
+		struct resource res[2];
+		struct platform_device *pdev;
+		struct fsl_spi_platform_data pdata = {
+			.cs_control = cs_control,
+		};
+
+		memset(res, 0, sizeof(res));
+
+		pdata.sysclk = sysclk;
+
+		prop = of_get_property(np, "reg", NULL);
+		if (!prop)
+			goto err;
+		pdata.bus_num = *(u32 *)prop;
+
+		prop = of_get_property(np, "cell-index", NULL);
+		if (prop)
+			i = *(u32 *)prop;
+
+		prop = of_get_property(np, "mode", NULL);
+		if (prop && !strcmp(prop, "cpu-qe"))
+			pdata.qe_mode = 1;
+
+		for (j = 0; j < num_board_infos; j++) {
+			if (board_infos[j].bus_num == pdata.bus_num)
+				pdata.max_chipselect++;
+		}
+
+		if (!pdata.max_chipselect)
+			continue;
+
+		ret = of_address_to_resource(np, 0, &res[0]);
+		if (ret)
+			goto err;
+
+		ret = of_irq_to_resource(np, 0, &res[1]);
+		if (ret == NO_IRQ)
+			goto err;
+
+		pdev = platform_device_alloc("mpc83xx_spi", i);
+		if (!pdev)
+			goto err;
+
+		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
+		if (ret)
+			goto unreg;
+
+		ret = platform_device_add_resources(pdev, res,
+						    ARRAY_SIZE(res));
+		if (ret)
+			goto unreg;
+
+		ret = platform_device_add(pdev);
+		if (ret)
+			goto unreg;
+
+		goto next;
+unreg:
+		platform_device_del(pdev);
+err:
+		pr_err("%s: registration failed\n", np->full_name);
+next:
+		i++;
+	}
+
+	return i;
+}
+
+static int __init fsl_spi_init(struct spi_board_info *board_infos,
+			       unsigned int num_board_infos,
+			       void (*cs_control)(struct spi_device *spi,
+						  bool on))
+{
+	u32 sysclk = -1;
+	int ret;
+
+	/* SPI controller is either clocked from QE or SoC clock */
+	sysclk = get_brgfreq();
+	if (sysclk == -1) {
+		sysclk = fsl_get_sys_freq();
+		if (sysclk == -1)
+			return -ENODEV;
+	}
+
+	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
+			       num_board_infos, cs_control);
+	if (!ret)
+		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
+				 num_board_infos, cs_control);
+
+	return spi_register_board_info(board_infos, num_board_infos);
+}
+
 static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
 {
 	pr_debug("%s %d %d\n", __func__, spi->chip_select, on);
diff -puN arch/powerpc/sysdev/fsl_soc.c~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -413,113 +413,6 @@ err:
 
 arch_initcall(fsl_usb_of_init);
 
-static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
-				   struct spi_board_info *board_infos,
-				   unsigned int num_board_infos,
-				   void (*cs_control)(struct spi_device *dev,
-						      bool on))
-{
-	struct device_node *np;
-	unsigned int i = 0;
-
-	for_each_compatible_node(np, type, compatible) {
-		int ret;
-		unsigned int j;
-		const void *prop;
-		struct resource res[2];
-		struct platform_device *pdev;
-		struct fsl_spi_platform_data pdata = {
-			.cs_control = cs_control,
-		};
-
-		memset(res, 0, sizeof(res));
-
-		pdata.sysclk = sysclk;
-
-		prop = of_get_property(np, "reg", NULL);
-		if (!prop)
-			goto err;
-		pdata.bus_num = *(u32 *)prop;
-
-		prop = of_get_property(np, "cell-index", NULL);
-		if (prop)
-			i = *(u32 *)prop;
-
-		prop = of_get_property(np, "mode", NULL);
-		if (prop && !strcmp(prop, "cpu-qe"))
-			pdata.qe_mode = 1;
-
-		for (j = 0; j < num_board_infos; j++) {
-			if (board_infos[j].bus_num == pdata.bus_num)
-				pdata.max_chipselect++;
-		}
-
-		if (!pdata.max_chipselect)
-			continue;
-
-		ret = of_address_to_resource(np, 0, &res[0]);
-		if (ret)
-			goto err;
-
-		ret = of_irq_to_resource(np, 0, &res[1]);
-		if (ret == NO_IRQ)
-			goto err;
-
-		pdev = platform_device_alloc("mpc83xx_spi", i);
-		if (!pdev)
-			goto err;
-
-		ret = platform_device_add_data(pdev, &pdata, sizeof(pdata));
-		if (ret)
-			goto unreg;
-
-		ret = platform_device_add_resources(pdev, res,
-						    ARRAY_SIZE(res));
-		if (ret)
-			goto unreg;
-
-		ret = platform_device_add(pdev);
-		if (ret)
-			goto unreg;
-
-		goto next;
-unreg:
-		platform_device_del(pdev);
-err:
-		pr_err("%s: registration failed\n", np->full_name);
-next:
-		i++;
-	}
-
-	return i;
-}
-
-int __init fsl_spi_init(struct spi_board_info *board_infos,
-			unsigned int num_board_infos,
-			void (*cs_control)(struct spi_device *spi, bool on))
-{
-	u32 sysclk = -1;
-	int ret;
-
-#ifdef CONFIG_QUICC_ENGINE
-	/* SPI controller is either clocked from QE or SoC clock */
-	sysclk = get_brgfreq();
-#endif
-	if (sysclk == -1) {
-		sysclk = fsl_get_sys_freq();
-		if (sysclk == -1)
-			return -ENODEV;
-	}
-
-	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
-			       num_board_infos, cs_control);
-	if (!ret)
-		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
-				 num_board_infos, cs_control);
-
-	return spi_register_board_info(board_infos, num_board_infos);
-}
-
 #if defined(CONFIG_PPC_85xx) || defined(CONFIG_PPC_86xx)
 static __be32 __iomem *rstcr;
 
diff -puN arch/powerpc/sysdev/fsl_soc.h~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards arch/powerpc/sysdev/fsl_soc.h
--- a/arch/powerpc/sysdev/fsl_soc.h~powerpc-fsl_soc-isolate-legacy-fsl_spi-support-to-mpc832x_rdb-boards
+++ a/arch/powerpc/sysdev/fsl_soc.h
@@ -19,10 +19,6 @@ extern u32 fsl_get_sys_freq(void);
 struct spi_board_info;
 struct device_node;
 
-extern int fsl_spi_init(struct spi_board_info *board_infos,
-			unsigned int num_board_infos,
-			void (*cs_control)(struct spi_device *spi, bool on));
