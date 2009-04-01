From: akpm@linux-foundation.org
Subject: [merged] spi_mpc83xx-rework-chip-selects-handling.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:41:25 -0700
Message-ID: <200904011841.n31IfPRq009347@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755158AbZDATrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avorontsov@ru.mvista.com, benh@kernel.crashing.org, david-b@pacbell.net, galak@gate.crashing.org, grant.likely@secretlab.ca, mm-commits@vger.kernel.org


The patch titled
     spi_mpc83xx: rework chip selects handling
has been removed from the -mm tree.  Its filename was
     spi_mpc83xx-rework-chip-selects-handling.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: spi_mpc83xx: rework chip selects handling
From: Anton Vorontsov <avorontsov@ru.mvista.com>

The main purpose of this patch is to pass 'struct spi_device' to the chip
select handling routines.  This is needed so that we could implement
full-fledged OpenFirmware support for this driver.

While at it, also:
- Replace two {de,activate}_cs routines by single cs_contol().
- Don't duplicate platform data callbacks in mpc83xx_spi struct.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: David Brownell <david-b@pacbell.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/83xx/mpc832x_rdb.c |   16 ++++------------
 arch/powerpc/sysdev/fsl_soc.c             |   14 ++++++--------
 arch/powerpc/sysdev/fsl_soc.h             |    5 +++--
 drivers/spi/spi_mpc83xx.c                 |   20 +++++++-------------
 include/linux/fsl_devices.h               |    5 +++--
 5 files changed, 23 insertions(+), 37 deletions(-)

diff -puN arch/powerpc/platforms/83xx/mpc832x_rdb.c~spi_mpc83xx-rework-chip-selects-handling arch/powerpc/platforms/83xx/mpc832x_rdb.c
--- a/arch/powerpc/platforms/83xx/mpc832x_rdb.c~spi_mpc83xx-rework-chip-selects-handling
+++ a/arch/powerpc/platforms/83xx/mpc832x_rdb.c
@@ -39,16 +39,10 @@
 #endif
 
 #ifdef CONFIG_QUICC_ENGINE
-static void mpc83xx_spi_activate_cs(u8 cs, u8 polarity)
+static void mpc83xx_spi_cs_control(struct spi_device *spi, bool on)
 {
-	pr_debug("%s %d %d\n", __func__, cs, polarity);
-	par_io_data_set(3, 13, polarity);
-}
-
-static void mpc83xx_spi_deactivate_cs(u8 cs, u8 polarity)
-{
-	pr_debug("%s %d %d\n", __func__, cs, polarity);
-	par_io_data_set(3, 13, !polarity);
+	pr_debug("%s %d %d\n", __func__, spi->chip_select, on);
+	par_io_data_set(3, 13, on);
 }
 
 static struct mmc_spi_platform_data mpc832x_mmc_pdata = {
@@ -74,9 +68,7 @@ static int __init mpc832x_spi_init(void)
 	par_io_config_pin(3, 14, 2, 0, 0, 0); /* SD_INSERT, I */
 	par_io_config_pin(3, 15, 2, 0, 0, 0); /* SD_PROTECT,I */
 
-	return fsl_spi_init(&mpc832x_spi_boardinfo, 1,
-			    mpc83xx_spi_activate_cs,
-			    mpc83xx_spi_deactivate_cs);
+	return fsl_spi_init(&mpc832x_spi_boardinfo, 1, mpc83xx_spi_cs_control);
 }
 machine_device_initcall(mpc832x_rdb, mpc832x_spi_init);
 #endif /* CONFIG_QUICC_ENGINE */
diff -puN arch/powerpc/sysdev/fsl_soc.c~spi_mpc83xx-rework-chip-selects-handling arch/powerpc/sysdev/fsl_soc.c
--- a/arch/powerpc/sysdev/fsl_soc.c~spi_mpc83xx-rework-chip-selects-handling
+++ a/arch/powerpc/sysdev/fsl_soc.c
@@ -420,8 +420,8 @@ arch_initcall(fsl_usb_of_init);
 static int __init of_fsl_spi_probe(char *type, char *compatible, u32 sysclk,
 				   struct spi_board_info *board_infos,
 				   unsigned int num_board_infos,
-				   void (*activate_cs)(u8 cs, u8 polarity),
-				   void (*deactivate_cs)(u8 cs, u8 polarity))
+				   void (*cs_control)(struct spi_device *dev,
+						      bool on))
 {
 	struct device_node *np;
 	unsigned int i = 0;
@@ -433,8 +433,7 @@ static int __init of_fsl_spi_probe(char 
 		struct resource res[2];
 		struct platform_device *pdev;
 		struct fsl_spi_platform_data pdata = {
-			.activate_cs = activate_cs,
-			.deactivate_cs = deactivate_cs,
+			.cs_control = cs_control,
 		};
 
 		memset(res, 0, sizeof(res));
@@ -501,8 +500,7 @@ next:
 
 int __init fsl_spi_init(struct spi_board_info *board_infos,
 			unsigned int num_board_infos,
-			void (*activate_cs)(u8 cs, u8 polarity),
-			void (*deactivate_cs)(u8 cs, u8 polarity))
+			void (*cs_control)(struct spi_device *spi, bool on))
 {
 	u32 sysclk = -1;
 	int ret;
@@ -518,10 +516,10 @@ int __init fsl_spi_init(struct spi_board
 	}
 
 	ret = of_fsl_spi_probe(NULL, "fsl,spi", sysclk, board_infos,
-			       num_board_infos, activate_cs, deactivate_cs);
+			       num_board_infos, cs_control);
 	if (!ret)
 		of_fsl_spi_probe("spi", "fsl_spi", sysclk, board_infos,
-				 num_board_infos, activate_cs, deactivate_cs);
+				 num_board_infos, cs_control);
 
 	return spi_register_board_info(board_infos, num_board_infos);
 }
diff -puN arch/powerpc/sysdev/fsl_soc.h~spi_mpc83xx-rework-chip-selects-handling arch/powerpc/sysdev/fsl_soc.h
--- a/arch/powerpc/sysdev/fsl_soc.h~spi_mpc83xx-rework-chip-selects-handling
+++ a/arch/powerpc/sysdev/fsl_soc.h
@@ -4,6 +4,8 @@
 
 #include <asm/mmu.h>
 
+struct spi_device;
+
 extern phys_addr_t get_immrbase(void);
 #if defined(CONFIG_CPM2) || defined(CONFIG_QUICC_ENGINE) || defined(CONFIG_8xx)
 extern u32 get_brgfreq(void);
@@ -19,8 +21,7 @@ struct device_node;
 
 extern int fsl_spi_init(struct spi_board_info *board_infos,
 			unsigned int num_board_infos,
-			void (*activate_cs)(u8 cs, u8 polarity),
-			void (*deactivate_cs)(u8 cs, u8 polarity));
+			void (*cs_control)(struct spi_device *spi, bool on));
 
 extern void fsl_rstcr_restart(char *cmd);
 
diff -puN drivers/spi/spi_mpc83xx.c~spi_mpc83xx-rework-chip-selects-handling drivers/spi/spi_mpc83xx.c
--- a/drivers/spi/spi_mpc83xx.c~spi_mpc83xx-rework-chip-selects-handling
+++ a/drivers/spi/spi_mpc83xx.c
@@ -89,9 +89,6 @@ struct mpc83xx_spi {
 
 	bool qe_mode;
 
-	void (*activate_cs) (u8 cs, u8 polarity);
-	void (*deactivate_cs) (u8 cs, u8 polarity);
-
 	u8 busy;
 
 	struct workqueue_struct *workqueue;
@@ -153,15 +150,14 @@ MPC83XX_SPI_TX_BUF(u32)
 
 static void mpc83xx_spi_chipselect(struct spi_device *spi, int value)
 {
-	struct mpc83xx_spi *mpc83xx_spi;
-	u8 pol = spi->mode & SPI_CS_HIGH ? 1 : 0;
+	struct mpc83xx_spi *mpc83xx_spi = spi_master_get_devdata(spi->master);
+	struct fsl_spi_platform_data *pdata = spi->dev.parent->platform_data;
+	bool pol = spi->mode & SPI_CS_HIGH;
 	struct spi_mpc83xx_cs	*cs = spi->controller_state;
 
-	mpc83xx_spi = spi_master_get_devdata(spi->master);
-
 	if (value == BITBANG_CS_INACTIVE) {
-		if (mpc83xx_spi->deactivate_cs)
-			mpc83xx_spi->deactivate_cs(spi->chip_select, pol);
+		if (pdata->cs_control)
+			pdata->cs_control(spi, !pol);
 	}
 
 	if (value == BITBANG_CS_ACTIVE) {
@@ -186,8 +182,8 @@ static void mpc83xx_spi_chipselect(struc
 			mpc83xx_spi_write_reg(mode, regval);
 			local_irq_restore(flags);
 		}
-		if (mpc83xx_spi->activate_cs)
-			mpc83xx_spi->activate_cs(spi->chip_select, pol);
+		if (pdata->cs_control)
+			pdata->cs_control(spi, pol);
 	}
 }
 
@@ -582,8 +578,6 @@ static int __init mpc83xx_spi_probe(stru
 	master->cleanup = mpc83xx_spi_cleanup;
 
 	mpc83xx_spi = spi_master_get_devdata(master);
-	mpc83xx_spi->activate_cs = pdata->activate_cs;
-	mpc83xx_spi->deactivate_cs = pdata->deactivate_cs;
 	mpc83xx_spi->qe_mode = pdata->qe_mode;
 	mpc83xx_spi->get_rx = mpc83xx_spi_rx_buf_u8;
 	mpc83xx_spi->get_tx = mpc83xx_spi_tx_buf_u8;
diff -puN include/linux/fsl_devices.h~spi_mpc83xx-rework-chip-selects-handling include/linux/fsl_devices.h
--- a/include/linux/fsl_devices.h~spi_mpc83xx-rework-chip-selects-handling
+++ a/include/linux/fsl_devices.h
@@ -95,14 +95,15 @@ struct fsl_usb2_platform_data {
 #define FSL_USB2_PORT0_ENABLED	0x00000001
 #define FSL_USB2_PORT1_ENABLED	0x00000002
 
+struct spi_device;
+
 struct fsl_spi_platform_data {
 	u32 	initial_spmode;	/* initial SPMODE value */
 	u16	bus_num;
 	bool	qe_mode;
 	/* board specific information */
 	u16	max_chipselect;
-	void	(*activate_cs)(u8 cs, u8 polarity);
-	void	(*deactivate_cs)(u8 cs, u8 polarity);
+	void	(*cs_control)(struct spi_device *spi, bool on);
 	u32	sysclk;
 };
 
_

Patches currently in -mm which might be from avorontsov@ru.mvista.com are

origin.patch
linux-next.patch

