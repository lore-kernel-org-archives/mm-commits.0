From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-i82875p.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:24 -0700
Message-ID: <200707192006.l6JK6O8h020134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37217 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762053AbXGSURL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent i82875p
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-i82875p.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent i82875p
From: Dave Jiang <djiang@mvista.com>

Lindent cleanup of i82875p_edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82875p_edac.c |   62 ++++++++++++++++------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff -puN drivers/edac/i82875p_edac.c~drivers-edac-lindent-i82875p drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-lindent-i82875p
+++ a/drivers/edac/i82875p_edac.c
@@ -174,8 +174,7 @@ struct i82875p_error_info {
 
 static const struct i82875p_dev_info i82875p_devs[] = {
 	[I82875P] = {
-		.ctl_name = "i82875p"
-	},
+		     .ctl_name = "i82875p"},
 };
 
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code has
@@ -185,7 +184,7 @@ static struct pci_dev *mci_pdev = NULL;	
 static int i82875p_registered = 1;
 
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
-		struct i82875p_error_info *info)
+				   struct i82875p_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -216,13 +215,13 @@ static void i82875p_get_error_info(struc
 	if ((info->errsts ^ info->errsts2) & 0x0081) {
 		pci_read_config_dword(pdev, I82875P_EAP, &info->eap);
 		pci_read_config_byte(pdev, I82875P_DES, &info->des);
-		pci_read_config_byte(pdev, I82875P_DERRSYN,
-				&info->derrsyn);
+		pci_read_config_byte(pdev, I82875P_DERRSYN, &info->derrsyn);
 	}
 }
 
 static int i82875p_process_error_info(struct mem_ctl_info *mci,
-		struct i82875p_error_info *info, int handle_errors)
+				      struct i82875p_error_info *info,
+				      int handle_errors)
 {
 	int row, multi_chan;
 
@@ -246,8 +245,8 @@ static int i82875p_process_error_info(st
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82875p UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row,
-				multi_chan ? (info->des & 0x1) : 0,
-				"i82875p CE");
+				  multi_chan ? (info->des & 0x1) : 0,
+				  "i82875p CE");
 
 	return 1;
 }
@@ -263,7 +262,8 @@ static void i82875p_check(struct mem_ctl
 
 /* Return 0 on success or 1 on failure. */
 static int i82875p_setup_overfl_dev(struct pci_dev *pdev,
-		struct pci_dev **ovrfl_pdev, void __iomem **ovrfl_window)
+				    struct pci_dev **ovrfl_pdev,
+				    void __iomem ** ovrfl_window)
 {
 	struct pci_dev *dev;
 	void __iomem *window;
@@ -284,7 +284,7 @@ static int i82875p_setup_overfl_dev(stru
 		if (dev == NULL)
 			return 1;
 
-        	pci_bus_add_device(dev);
+		pci_bus_add_device(dev);
 	}
 
 	*ovrfl_pdev = dev;
@@ -314,32 +314,31 @@ static int i82875p_setup_overfl_dev(stru
 	*ovrfl_window = window;
 	return 0;
 
-fail1:
+      fail1:
 	pci_release_regions(dev);
 
 #ifdef CORRECT_BIOS
-fail0:
+      fail0:
 	pci_disable_device(dev);
 #endif
 	/* NOTE: the ovrfl proc entry and pci_dev are intentionally left */
 	return 1;
 }
 
-
 /* Return 1 if dual channel mode is active.  Else return 0. */
 static inline int dual_channel_active(u32 drc)
 {
 	return (drc >> 21) & 0x1;
 }
 
-
 static void i82875p_init_csrows(struct mem_ctl_info *mci,
-		struct pci_dev *pdev, void __iomem *ovrfl_window, u32 drc)
+				struct pci_dev *pdev,
+				void __iomem * ovrfl_window, u32 drc)
 {
 	struct csrow_info *csrow;
 	unsigned long last_cumul_size;
 	u8 value;
-	u32 drc_ddim;  /* DRAM Data Integrity Mode 0=none,2=edac */
+	u32 drc_ddim;		/* DRAM Data Integrity Mode 0=none,2=edac */
 	u32 cumul_size;
 	int index;
 
@@ -392,7 +391,7 @@ static int i82875p_probe1(struct pci_dev
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
 	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-				nr_chans);
+			    nr_chans);
 
 	if (!mci) {
 		rc = -ENOMEM;
@@ -411,16 +410,16 @@ static int i82875p_probe1(struct pci_dev
 	mci->edac_check = i82875p_check;
 	mci->ctl_page_to_phys = NULL;
 	debugf3("%s(): init pvt\n", __func__);
-	pvt = (struct i82875p_pvt *) mci->pvt_info;
+	pvt = (struct i82875p_pvt *)mci->pvt_info;
 	pvt->ovrfl_pdev = ovrfl_pdev;
 	pvt->ovrfl_window = ovrfl_window;
 	i82875p_init_csrows(mci, pdev, ovrfl_window, drc);
-	i82875p_get_error_info(mci, &discard);  /* clear counters */
+	i82875p_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail1;
 	}
@@ -429,10 +428,10 @@ static int i82875p_probe1(struct pci_dev
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail1:
+      fail1:
 	edac_mc_free(mci);
 
-fail0:
+      fail0:
 	iounmap(ovrfl_window);
 	pci_release_regions(ovrfl_pdev);
 
@@ -443,7 +442,7 @@ fail0:
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82875p_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				      const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -471,7 +470,7 @@ static void __devexit i82875p_remove_one
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
-	pvt = (struct i82875p_pvt *) mci->pvt_info;
+	pvt = (struct i82875p_pvt *)mci->pvt_info;
 
 	if (pvt->ovrfl_window)
 		iounmap(pvt->ovrfl_window);
@@ -489,12 +488,11 @@ static void __devexit i82875p_remove_one
 
 static const struct pci_device_id i82875p_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82875P
-	},
+	 PCI_VEND_DEV(INTEL, 82875_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I82875P},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i82875p_pci_tbl);
@@ -518,7 +516,7 @@ static int __init i82875p_init(void)
 
 	if (mci_pdev == NULL) {
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-				PCI_DEVICE_ID_INTEL_82875_0, NULL);
+					  PCI_DEVICE_ID_INTEL_82875_0, NULL);
 
 		if (!mci_pdev) {
 			debugf0("875p pci_get_device fail\n");
@@ -537,10 +535,10 @@ static int __init i82875p_init(void)
 
 	return 0;
 
-fail1:
+      fail1:
 	pci_unregister_driver(&i82875p_driver);
 
-fail0:
+      fail0:
 	if (mci_pdev != NULL)
 		pci_dev_put(mci_pdev);
 
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
