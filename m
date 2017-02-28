From: akpm@linux-foundation.org
Subject: [merged]
 scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch
 removed from -mm tree
Date: Tue, 28 Feb 2017 12:51:41 -0800
Message-ID: <58b5e2dd./vIrmnrENw+P6080%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751906AbdB1Uvm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Feb 2017 15:51:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yamada.masahiro@socionext.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "configuartion" pattern and fix typo instances
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "configuartion" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  configuartion||configuration

While we are here, fix the "ouput" as well in the touched hunk in
drivers/media/dvb-frontends/drx39xyj/drx_driver.h.

Link: http://lkml.kernel.org/r/1481573103-11329-23-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb-frontends/drx39xyj/drx_driver.h |    4 +--
 drivers/media/dvb-frontends/drx39xyj/drxj.c       |   16 ++++++------
 drivers/media/dvb-frontends/drx39xyj/drxj.h       |    4 +--
 drivers/media/dvb-frontends/drxk_hard.c           |    2 -
 drivers/net/wireless/ti/wl18xx/main.c             |    2 -
 scripts/spelling.txt                              |    1 
 6 files changed, 15 insertions(+), 14 deletions(-)

diff -puN drivers/media/dvb-frontends/drx39xyj/drx_driver.h~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances drivers/media/dvb-frontends/drx39xyj/drx_driver.h
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -1317,9 +1317,9 @@ struct drx_version_list {
 		DRX_MPEG_STR_WIDTH_8
 	};
 
-/* CTRL CFG MPEG ouput */
+/* CTRL CFG MPEG output */
 /**
-* \struct struct drx_cfg_mpeg_output * \brief Configuartion parameters for MPEG output control.
+* \struct struct drx_cfg_mpeg_output * \brief Configuration parameters for MPEG output control.
 *
 * Used by DRX_CFG_MPEG_OUTPUT, in combination with DRX_CTRL_SET_CFG and
 * DRX_CTRL_GET_CFG.
diff -puN drivers/media/dvb-frontends/drx39xyj/drxj.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances drivers/media/dvb-frontends/drx39xyj/drxj.c
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -601,7 +601,7 @@ static struct drxj_data drxj_data_g = {
 	0,			/* hi_cfg_wake_up_key    */
 	0,			/* hi_cfg_ctrl         */
 	0,			/* HICfgTimeout      */
-	/* UIO configuartion */
+	/* UIO configuration */
 	DRX_UIO_MODE_DISABLE,	/* uio_sma_rx_mode      */
 	DRX_UIO_MODE_DISABLE,	/* uio_sma_tx_mode      */
 	DRX_UIO_MODE_DISABLE,	/* uioASELMode       */
@@ -619,7 +619,7 @@ static struct drxj_data drxj_data_g = {
 /*   false,                  * flagHDevSet       */
 /*   (u16) 0xFFF,          * rdsLastCount      */
 
-	/* ATV configuartion */
+	/* ATV configuration */
 	0UL,			/* flags cfg changes */
 	/* shadow of ATV_TOP_EQU0__A */
 	{-5,
@@ -3352,7 +3352,7 @@ rw_error:
 /*----------------------------------------------------------------------------*/
 
 /*----------------------------------------------------------------------------*/
-/* miscellaneous configuartions - begin                           */
+/* miscellaneous configurations - begin                           */
 /*----------------------------------------------------------------------------*/
 
 /**
@@ -3515,7 +3515,7 @@ rw_error:
 }
 
 /*----------------------------------------------------------------------------*/
-/* miscellaneous configuartions - end                             */
+/* miscellaneous configurations - end                             */
 /*----------------------------------------------------------------------------*/
 
 /*----------------------------------------------------------------------------*/
@@ -10952,7 +10952,7 @@ rw_error:
 
 static void drxj_reset_mode(struct drxj_data *ext_attr)
 {
-	/* Initialize default AFE configuartion for QAM */
+	/* Initialize default AFE configuration for QAM */
 	if (ext_attr->has_lna) {
 		/* IF AGC off, PGA active */
 #ifndef DRXJ_VSB_ONLY
@@ -10996,7 +10996,7 @@ static void drxj_reset_mode(struct drxj_
 	ext_attr->qam_pre_saw_cfg.reference = 0x07;
 	ext_attr->qam_pre_saw_cfg.use_pre_saw = true;
 #endif
-	/* Initialize default AFE configuartion for VSB */
+	/* Initialize default AFE configuration for VSB */
 	ext_attr->vsb_rf_agc_cfg.standard = DRX_STANDARD_8VSB;
 	ext_attr->vsb_rf_agc_cfg.ctrl_mode = DRX_AGC_CTRL_AUTO;
 	ext_attr->vsb_rf_agc_cfg.min_output_level = 0;
@@ -11072,9 +11072,9 @@ ctrl_power_mode(struct drx_demod_instanc
 	}
 
 	if ((*mode == DRX_POWER_UP)) {
-		/* Restore analog & pin configuartion */
+		/* Restore analog & pin configuration */
 
-		/* Initialize default AFE configuartion for VSB */
+		/* Initialize default AFE configuration for VSB */
 		drxj_reset_mode(ext_attr);
 	} else {
 		/* Power down to requested mode */
diff -puN drivers/media/dvb-frontends/drx39xyj/drxj.h~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances drivers/media/dvb-frontends/drx39xyj/drxj.h
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.h~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-frontends/drx39xyj/drxj.h
@@ -447,7 +447,7 @@ struct drxj_cfg_atv_output {
 		u16 hi_cfg_ctrl;	  /**< HI Configure() parameter 5                       */
 		u16 hi_cfg_transmit;	  /**< HI Configure() parameter 6                       */
 
-		/* UIO configuartion */
+		/* UIO configuration */
 		enum drxuio_mode uio_sma_rx_mode;/**< current mode of SmaRx pin                        */
 		enum drxuio_mode uio_sma_tx_mode;/**< current mode of SmaTx pin                        */
 		enum drxuio_mode uio_gpio_mode; /**< current mode of ASEL pin                         */
@@ -459,7 +459,7 @@ struct drxj_cfg_atv_output {
 		/* IQM RC frequecy shift */
 		u32 iqm_rc_rate_ofs;	   /**< frequency shifter setting after setchannel      */
 
-		/* ATV configuartion */
+		/* ATV configuration */
 		u32 atv_cfg_changed_flags; /**< flag: flags cfg changes */
 		s16 atv_top_equ0[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU0__A */
 		s16 atv_top_equ1[DRXJ_COEF_IDX_MAX];	     /**< shadow of ATV_TOP_EQU1__A */
diff -puN drivers/media/dvb-frontends/drxk_hard.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances drivers/media/dvb-frontends/drxk_hard.c
--- a/drivers/media/dvb-frontends/drxk_hard.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/drivers/media/dvb-frontends/drxk_hard.c
@@ -1626,7 +1626,7 @@ static int ctrl_power_mode(struct drxk_s
 	}
 
 	if (*mode == DRX_POWER_UP) {
-		/* Restore analog & pin configuartion */
+		/* Restore analog & pin configuration */
 	} else {
 		/* Power down to requested mode */
 		/* Backup some register settings */
diff -puN drivers/net/wireless/ti/wl18xx/main.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances drivers/net/wireless/ti/wl18xx/main.c
--- a/drivers/net/wireless/ti/wl18xx/main.c~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/ti/wl18xx/main.c
@@ -178,7 +178,7 @@ static struct wlcore_conf wl18xx_conf =
 	.sg = {
 		.params = {
 			[WL18XX_CONF_SG_PARAM_0] = 0,
-			/* Configuartion Parameters */
+			/* Configuration Parameters */
 			[WL18XX_CONF_SG_ANTENNA_CONFIGURATION] = 0,
 			[WL18XX_CONF_SG_ZIGBEE_COEX] = 0,
 			[WL18XX_CONF_SG_TIME_SYNC] = 0,
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-configuartion-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -268,6 +268,7 @@ comunication||communication
 conbination||combination
 conditionaly||conditionally
 conected||connected
+configuartion||configuration
 configuratoin||configuration
 configuraton||configuration
 configuretion||configuration
_

Patches currently in -mm which might be from yamada.masahiro@socionext.com are

scripts-spellingtxt-add-intialised-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-disbled-pattern-and-fix-typo-instances.patch
scripts-spellingtxt-add-overide-pattern-and-fix-typo-instances.patch

