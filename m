From: akpm@linux-foundation.org
Subject: [patch 55/78] scripts/spelling.txt: add "intialization" pattern
 and fix typo instances
Date: Mon, 27 Feb 2017 14:29:20 -0800
Message-ID: <58b4a840.XkgLDflXcNKAfaAE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45682 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdB0Woh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 17:44:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com

From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: scripts/spelling.txt: add "intialization" pattern and fix typo instances

Fix typos and add the following to the scripts/spelling.txt:

  intialization||initialization

The "inintialization" in drivers/acpi/spcr.c is a different pattern
but I fixed it as well in this commit.

Link: http://lkml.kernel.org/r/1481573103-11329-16-git-send-email-yamada.masahiro@socionext.com
Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-omap2/omap_twl.c               |    2 +-
 drivers/acpi/spcr.c                          |    2 +-
 drivers/firewire/core-device.c               |    4 ++--
 drivers/mmc/host/mmci_qcom_dml.c             |    2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c |    4 ++--
 drivers/net/wireless/intel/ipw2x00/ipw2200.c |    2 +-
 drivers/net/wireless/ti/wlcore/init.c        |    2 +-
 drivers/power/avs/smartreflex.c              |    6 +++---
 drivers/scsi/ipr.c                           |    2 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |   14 +++++++-------
 drivers/scsi/scsi_transport_sas.c            |    2 +-
 drivers/scsi/storvsc_drv.c                   |    2 +-
 drivers/usb/gadget/udc/fsl_udc_core.c        |    4 ++--
 scripts/spelling.txt                         |    1 +
 sound/soc/qcom/lpass.h                       |    2 +-
 sound/soc/soc-topology.c                     |    4 ++--
 16 files changed, 28 insertions(+), 27 deletions(-)

diff -puN arch/arm/mach-omap2/omap_twl.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances arch/arm/mach-omap2/omap_twl.c
--- a/arch/arm/mach-omap2/omap_twl.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/arch/arm/mach-omap2/omap_twl.c
@@ -1,5 +1,5 @@
 /**
- * OMAP and TWL PMIC specific intializations.
+ * OMAP and TWL PMIC specific initializations.
  *
  * Copyright (C) 2010 Texas Instruments Incorporated.
  * Thara Gopinath
diff -puN drivers/acpi/spcr.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/acpi/spcr.c
--- a/drivers/acpi/spcr.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/acpi/spcr.c
@@ -46,7 +46,7 @@ static bool qdf2400_erratum_44_present(s
  * console is registered and if @earlycon is true, earlycon is set up.
  *
  * When CONFIG_ACPI_SPCR_TABLE is defined, this function should be called
- * from arch inintialization code as soon as the DT/ACPI decision is made.
+ * from arch initialization code as soon as the DT/ACPI decision is made.
  *
  */
 int __init parse_spcr(bool earlycon)
diff -puN drivers/firewire/core-device.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/firewire/core-device.c
--- a/drivers/firewire/core-device.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/firewire/core-device.c
@@ -1068,7 +1068,7 @@ static void fw_device_init(struct work_s
 
 	/*
 	 * Transition the device to running state.  If it got pulled
-	 * out from under us while we did the intialization work, we
+	 * out from under us while we did the initialization work, we
 	 * have to shut down the device again here.  Normally, though,
 	 * fw_node_event will be responsible for shutting it down when
 	 * necessary.  We have to use the atomic cmpxchg here to avoid
@@ -1231,7 +1231,7 @@ void fw_node_event(struct fw_card *card,
 			break;
 
 		/*
-		 * Do minimal intialization of the device here, the
+		 * Do minimal initialization of the device here, the
 		 * rest will happen in fw_device_init().
 		 *
 		 * Attention:  A lot of things, even fw_device_get(),
diff -puN drivers/mmc/host/mmci_qcom_dml.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/mmc/host/mmci_qcom_dml.c
--- a/drivers/mmc/host/mmci_qcom_dml.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/mmc/host/mmci_qcom_dml.c
@@ -170,7 +170,7 @@ int dml_hw_init(struct mmci_host *host,
 	writel_relaxed(producer_id | (consumer_id << CONSUMER_PIPE_ID_SHFT),
 		       base + DML_PIPE_ID);
 
-	/* Make sure dml intialization is finished */
+	/* Make sure dml initialization is finished */
 	mb();
 
 	return 0;
diff -puN drivers/net/wireless/intel/ipw2x00/ipw2100.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/net/wireless/intel/ipw2x00/ipw2100.c
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -1238,7 +1238,7 @@ static int ipw2100_get_hw_features(struc
 }
 
 /*
- * Start firmware execution after power on and intialization
+ * Start firmware execution after power on and initialization
  * The sequence is:
  *  1. Release ARC
  *  2. Wait for f/w initialization completes;
@@ -1277,7 +1277,7 @@ static int ipw2100_start_adapter(struct
 	/* Release ARC - clear reset bit */
 	write_register(priv->net_dev, IPW_REG_RESET_REG, 0);
 
-	/* wait for f/w intialization complete */
+	/* wait for f/w initialization complete */
 	IPW_DEBUG_FW("Waiting for f/w initialization to complete...\n");
 	i = 5000;
 	do {
diff -puN drivers/net/wireless/intel/ipw2x00/ipw2200.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/net/wireless/intel/ipw2x00/ipw2200.c
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -5196,7 +5196,7 @@ static void ipw_rx_queue_restock(struct
  * Move all used packet from rx_used to rx_free, allocating a new SKB for each.
  * Also restock the Rx queue via ipw_rx_queue_restock.
  *
- * This is called as a scheduled work item (except for during intialization)
+ * This is called as a scheduled work item (except for during initialization)
  */
 static void ipw_rx_queue_replenish(void *data)
 {
diff -puN drivers/net/wireless/ti/wlcore/init.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/net/wireless/ti/wlcore/init.c
--- a/drivers/net/wireless/ti/wlcore/init.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/net/wireless/ti/wlcore/init.c
@@ -544,7 +544,7 @@ static int wl12xx_init_sta_role(struct w
 	return 0;
 }
 
-/* vif-specific intialization */
+/* vif-specific initialization */
 static int wl12xx_init_ap_role(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	int ret;
diff -puN drivers/power/avs/smartreflex.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/power/avs/smartreflex.c
--- a/drivers/power/avs/smartreflex.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/power/avs/smartreflex.c
@@ -195,7 +195,7 @@ static void sr_stop_vddautocomp(struct o
 }
 
 /*
- * This function handles the intializations which have to be done
+ * This function handles the initializations which have to be done
  * only when both sr device and class driver regiter has
  * completed. This will be attempted to be called from both sr class
  * driver register and sr device intializtion API's. Only one call
@@ -671,7 +671,7 @@ int sr_register_class(struct omap_sr_cla
 	sr_class = class_data;
 
 	/*
-	 * Call into late init to do intializations that require
+	 * Call into late init to do initializations that require
 	 * both sr driver and sr class driver to be initiallized.
 	 */
 	list_for_each_entry(sr_info, &sr_list, node)
@@ -899,7 +899,7 @@ static int __init omap_sr_probe(struct p
 	list_add(&sr_info->node, &sr_list);
 
 	/*
-	 * Call into late init to do intializations that require
+	 * Call into late init to do initializations that require
 	 * both sr driver and sr class driver to be initiallized.
 	 */
 	if (sr_class) {
diff -puN drivers/scsi/ipr.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/scsi/ipr.c
@@ -9330,7 +9330,7 @@ static pci_ers_result_t ipr_pci_error_de
  * ipr_probe_ioa_part2 - Initializes IOAs found in ipr_probe_ioa(..)
  * @ioa_cfg:	ioa cfg struct
  *
- * Description: This is the second phase of adapter intialization
+ * Description: This is the second phase of adapter initialization
  * This function takes care of initilizing the adapter to the point
  * where it can accept new commands.
 
diff -puN drivers/scsi/lpfc/lpfc_sli.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/scsi/lpfc/lpfc_sli.c
@@ -4510,7 +4510,7 @@ lpfc_sli4_rb_setup(struct lpfc_hba *phba
  * @phba: Pointer to HBA context object.
  * @sli_mode: sli mode - 2/3
  *
- * This function is called by the sli intialization code path
+ * This function is called by the sli initialization code path
  * to issue config_port mailbox command. This function restarts the
  * HBA firmware and issues a config_port mailbox command to configure
  * the SLI interface in the sli mode specified by sli_mode
@@ -4650,11 +4650,11 @@ do_prep_failed:
 
 
 /**
- * lpfc_sli_hba_setup - SLI intialization function
+ * lpfc_sli_hba_setup - SLI initialization function
  * @phba: Pointer to HBA context object.
  *
- * This function is the main SLI intialization function. This function
- * is called by the HBA intialization code, HBA reset code and HBA
+ * This function is the main SLI initialization function. This function
+ * is called by the HBA initialization code, HBA reset code and HBA
  * error attention handler code. Caller is not required to hold any
  * locks. This function issues config_port mailbox command to configure
  * the SLI, setup iocb rings and HBQ rings. In the end the function
@@ -6324,11 +6324,11 @@ lpfc_set_host_data(struct lpfc_hba *phba
 }
 
 /**
- * lpfc_sli4_hba_setup - SLI4 device intialization PCI function
+ * lpfc_sli4_hba_setup - SLI4 device initialization PCI function
  * @phba: Pointer to HBA context object.
  *
- * This function is the main SLI4 device intialization PCI function. This
- * function is called by the HBA intialization code, HBA reset code and
+ * This function is the main SLI4 device initialization PCI function. This
+ * function is called by the HBA initialization code, HBA reset code and
  * HBA error attention handler code. Caller is not required to hold any
  * locks.
  **/
diff -puN drivers/scsi/scsi_transport_sas.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/scsi/scsi_transport_sas.c
--- a/drivers/scsi/scsi_transport_sas.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/scsi/scsi_transport_sas.c
@@ -1475,7 +1475,7 @@ static void sas_end_device_release(struc
 }
 
 /**
- * sas_rphy_initialize - common rphy intialization
+ * sas_rphy_initialize - common rphy initialization
  * @rphy:	rphy to initialise
  *
  * Used by both sas_end_device_alloc() and sas_expander_alloc() to
diff -puN drivers/scsi/storvsc_drv.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/scsi/storvsc_drv.c
--- a/drivers/scsi/storvsc_drv.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/scsi/storvsc_drv.c
@@ -280,7 +280,7 @@ static const struct vmstor_protocol vmst
 
 
 /*
- * This structure is sent during the intialization phase to get the different
+ * This structure is sent during the initialization phase to get the different
  * properties of the channel.
  */
 
diff -puN drivers/usb/gadget/udc/fsl_udc_core.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances drivers/usb/gadget/udc/fsl_udc_core.c
--- a/drivers/usb/gadget/udc/fsl_udc_core.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -520,7 +520,7 @@ static void struct_ep_qh_setup(struct fs
 /* Setup qh structure and ep register for ep0. */
 static void ep0_setup(struct fsl_udc *udc)
 {
-	/* the intialization of an ep includes: fields in QH, Regs,
+	/* the initialization of an ep includes: fields in QH, Regs,
 	 * fsl_ep struct */
 	struct_ep_qh_setup(udc, 0, USB_RECV, USB_ENDPOINT_XFER_CONTROL,
 			USB_MAX_CTRL_PAYLOAD, 0, 0);
@@ -2349,7 +2349,7 @@ static int struct_ep_setup(struct fsl_ud
 }
 
 /* Driver probe function
- * all intialization operations implemented here except enabling usb_intr reg
+ * all initialization operations implemented here except enabling usb_intr reg
  * board setup should have been done in the platform code
  */
 static int fsl_udc_probe(struct platform_device *pdev)
diff -puN scripts/spelling.txt~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/scripts/spelling.txt
@@ -575,6 +575,7 @@ interruptted||interrupted
 interupted||interrupted
 interupt||interrupt
 intial||initial
+intialization||initialization
 intialized||initialized
 intialize||initialize
 intregral||integral
diff -puN sound/soc/qcom/lpass.h~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances sound/soc/qcom/lpass.h
--- a/sound/soc/qcom/lpass.h~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/sound/soc/qcom/lpass.h
@@ -82,7 +82,7 @@ struct lpass_variant {
 	 **/
 	u32	dmactl_audif_start;
 	u32	wrdma_channel_start;
-	/* SOC specific intialization like clocks */
+	/* SOC specific initialization like clocks */
 	int (*init)(struct platform_device *pdev);
 	int (*exit)(struct platform_device *pdev);
 	int (*alloc_dma_channel)(struct lpass_data *data, int direction);
diff -puN sound/soc/soc-topology.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances sound/soc/soc-topology.c
--- a/sound/soc/soc-topology.c~scripts-spellingtxt-add-intialization-pattern-and-fix-typo-instances
+++ a/sound/soc/soc-topology.c
@@ -344,7 +344,7 @@ static int soc_tplg_widget_load(struct s
 	return 0;
 }
 
-/* pass DAI configurations to component driver for extra intialization */
+/* pass DAI configurations to component driver for extra initialization */
 static int soc_tplg_dai_load(struct soc_tplg *tplg,
 	struct snd_soc_dai_driver *dai_drv)
 {
@@ -354,7 +354,7 @@ static int soc_tplg_dai_load(struct soc_
 	return 0;
 }
 
-/* pass link configurations to component driver for extra intialization */
+/* pass link configurations to component driver for extra initialization */
 static int soc_tplg_dai_link_load(struct soc_tplg *tplg,
 	struct snd_soc_dai_link *link)
 {
_
