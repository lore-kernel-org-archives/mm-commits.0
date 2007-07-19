From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-i82860.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:22 -0700
Message-ID: <200707192006.l6JK6MaD020131@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35631 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761077AbXGSUPi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent i82860
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-i82860.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent i82860
From: Dave Jiang <djiang@mvista.com>

Lindent cleanup of i82860 edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82860_edac.c |   40 ++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 21 deletions(-)

diff -puN drivers/edac/i82860_edac.c~drivers-edac-lindent-i82860 drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-lindent-i82860
+++ a/drivers/edac/i82860_edac.c
@@ -54,8 +54,7 @@ struct i82860_error_info {
 
 static const struct i82860_dev_info i82860_devs[] = {
 	[I82860] = {
-		.ctl_name = "i82860"
-	},
+		    .ctl_name = "i82860"},
 };
 
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code
@@ -63,7 +62,7 @@ static struct pci_dev *mci_pdev = NULL;	
 					 */
 
 static void i82860_get_error_info(struct mem_ctl_info *mci,
-		struct i82860_error_info *info)
+				  struct i82860_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -91,13 +90,13 @@ static void i82860_get_error_info(struct
 
 	if ((info->errsts ^ info->errsts2) & 0x0003) {
 		pci_read_config_dword(pdev, I82860_EAP, &info->eap);
-		pci_read_config_word(pdev, I82860_DERRCTL_STS,
-				&info->derrsyn);
+		pci_read_config_word(pdev, I82860_DERRCTL_STS, &info->derrsyn);
 	}
 }
 
 static int i82860_process_error_info(struct mem_ctl_info *mci,
-		struct i82860_error_info *info, int handle_errors)
+				     struct i82860_error_info *info,
+				     int handle_errors)
 {
 	int row;
 
@@ -119,7 +118,7 @@ static int i82860_process_error_info(str
 		edac_mc_handle_ue(mci, info->eap, 0, row, "i82860 UE");
 	else
 		edac_mc_handle_ce(mci, info->eap, 0, info->derrsyn, row, 0,
-				"i82860 UE");
+				  "i82860 UE");
 
 	return 1;
 }
@@ -136,7 +135,7 @@ static void i82860_check(struct mem_ctl_
 static void i82860_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev)
 {
 	unsigned long last_cumul_size;
-	u16 mchcfg_ddim;  /* DRAM Data Integrity Mode 0=none, 2=edac */
+	u16 mchcfg_ddim;	/* DRAM Data Integrity Mode 0=none, 2=edac */
 	u16 value;
 	u32 cumul_size;
 	struct csrow_info *csrow;
@@ -204,12 +203,12 @@ static int i82860_probe1(struct pci_dev 
 	mci->edac_check = i82860_check;
 	mci->ctl_page_to_phys = NULL;
 	i82860_init_csrows(mci, pdev);
-	i82860_get_error_info(mci, &discard);  /* clear counters */
+	i82860_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
@@ -219,14 +218,14 @@ static int i82860_probe1(struct pci_dev 
 
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82860_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				     const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -258,12 +257,11 @@ static void __devexit i82860_remove_one(
 
 static const struct pci_device_id i82860_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		I82860
-	},
+	 PCI_VEND_DEV(INTEL, 82860_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I82860},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i82860_pci_tbl);
@@ -286,7 +284,7 @@ static int __init i82860_init(void)
 
 	if (!mci_pdev) {
 		mci_pdev = pci_get_device(PCI_VENDOR_ID_INTEL,
-					PCI_DEVICE_ID_INTEL_82860_0, NULL);
+					  PCI_DEVICE_ID_INTEL_82860_0, NULL);
 
 		if (mci_pdev == NULL) {
 			debugf0("860 pci_get_device fail\n");
@@ -305,10 +303,10 @@ static int __init i82860_init(void)
 
 	return 0;
 
-fail1:
+      fail1:
 	pci_unregister_driver(&i82860_driver);
 
-fail0:
+      fail0:
 	if (mci_pdev != NULL)
 		pci_dev_put(mci_pdev);
 
@@ -330,5 +328,5 @@ module_exit(i82860_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com) "
-	"Ben Woodard <woodard@redhat.com>");
+	      "Ben Woodard <woodard@redhat.com>");
 MODULE_DESCRIPTION("ECC support for Intel 82860 memory hub controllers");
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
