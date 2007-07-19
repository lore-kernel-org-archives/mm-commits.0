From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-amd76x.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:14 -0700
Message-ID: <200707192006.l6JK6EGM020119@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37796 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762095AbXGSURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent amd76x
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-amd76x.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent amd76x
From: Douglas Thompson <dougthompson@xmission.com>

Ran this driver through Lindent for cleanup

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c |   54 ++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 29 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-lindent-amd76x drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-lindent-amd76x
+++ a/drivers/edac/amd76x_edac.c
@@ -86,11 +86,9 @@ struct amd76x_dev_info {
 
 static const struct amd76x_dev_info amd76x_devs[] = {
 	[AMD761] = {
-		.ctl_name = "AMD761"
-	},
+		    .ctl_name = "AMD761"},
 	[AMD762] = {
-		.ctl_name = "AMD762"
-	},
+		    .ctl_name = "AMD762"},
 };
 
 /**
@@ -102,21 +100,21 @@ static const struct amd76x_dev_info amd7
  *	on the chip so that further errors will be reported
  */
 static void amd76x_get_error_info(struct mem_ctl_info *mci,
-		struct amd76x_error_info *info)
+				  struct amd76x_error_info *info)
 {
 	struct pci_dev *pdev;
 
 	pdev = to_pci_dev(mci->dev);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS,
-				&info->ecc_mode_status);
+			      &info->ecc_mode_status);
 
 	if (info->ecc_mode_status & BIT(8))
 		pci_write_bits32(pdev, AMD76X_ECC_MODE_STATUS,
-				(u32) BIT(8), (u32) BIT(8));
+				 (u32) BIT(8), (u32) BIT(8));
 
 	if (info->ecc_mode_status & BIT(9))
 		pci_write_bits32(pdev, AMD76X_ECC_MODE_STATUS,
-				(u32) BIT(9), (u32) BIT(9));
+				 (u32) BIT(9), (u32) BIT(9));
 }
 
 /**
@@ -130,7 +128,8 @@ static void amd76x_get_error_info(struct
  *	then attempt to handle and clean up after the error
  */
 static int amd76x_process_error_info(struct mem_ctl_info *mci,
-		struct amd76x_error_info *info, int handle_errors)
+				     struct amd76x_error_info *info,
+				     int handle_errors)
 {
 	int error_found;
 	u32 row;
@@ -138,7 +137,7 @@ static int amd76x_process_error_info(str
 	error_found = 0;
 
 	/*
-	 *	Check for an uncorrectable error
+	 *      Check for an uncorrectable error
 	 */
 	if (info->ecc_mode_status & BIT(8)) {
 		error_found = 1;
@@ -146,12 +145,12 @@ static int amd76x_process_error_info(str
 		if (handle_errors) {
 			row = (info->ecc_mode_status >> 4) & 0xf;
 			edac_mc_handle_ue(mci, mci->csrows[row].first_page, 0,
-				row, mci->ctl_name);
+					  row, mci->ctl_name);
 		}
 	}
 
 	/*
-	 *	Check for a correctable error
+	 *      Check for a correctable error
 	 */
 	if (info->ecc_mode_status & BIT(9)) {
 		error_found = 1;
@@ -159,7 +158,7 @@ static int amd76x_process_error_info(str
 		if (handle_errors) {
 			row = info->ecc_mode_status & 0xf;
 			edac_mc_handle_ce(mci, mci->csrows[row].first_page, 0,
-				0, row, 0, mci->ctl_name);
+					  0, row, 0, mci->ctl_name);
 		}
 	}
 
@@ -182,7 +181,7 @@ static void amd76x_check(struct mem_ctl_
 }
 
 static void amd76x_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-		enum edac_type edac_mode)
+			       enum edac_type edac_mode)
 {
 	struct csrow_info *csrow;
 	u32 mba, mba_base, mba_mask, dms;
@@ -193,8 +192,7 @@ static void amd76x_init_csrows(struct me
 
 		/* find the DRAM Chip Select Base address and mask */
 		pci_read_config_dword(pdev,
-				      AMD76X_MEM_BASE_ADDR + (index * 4),
-				      &mba);
+				      AMD76X_MEM_BASE_ADDR + (index * 4), &mba);
 
 		if (!(mba & BIT(0)))
 			continue;
@@ -249,7 +247,7 @@ static int amd76x_probe1(struct pci_dev 
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	mci->edac_cap = ems_mode ?
-			(EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
+	    (EDAC_FLAG_EC | EDAC_FLAG_SECDED) : EDAC_FLAG_NONE;
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = AMD76X_REVISION;
 	mci->ctl_name = amd76x_devs[dev_idx].ctl_name;
@@ -258,12 +256,12 @@ static int amd76x_probe1(struct pci_dev 
 	mci->ctl_page_to_phys = NULL;
 
 	amd76x_init_csrows(mci, pdev, ems_modes[ems_mode]);
-	amd76x_get_error_info(mci, &discard);  /* clear counters */
+	amd76x_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
@@ -272,14 +270,14 @@ static int amd76x_probe1(struct pci_dev 
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit amd76x_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				     const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
@@ -309,16 +307,14 @@ static void __devexit amd76x_remove_one(
 
 static const struct pci_device_id amd76x_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(AMD, FE_GATE_700C), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		AMD762
-	},
+	 PCI_VEND_DEV(AMD, FE_GATE_700C), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 AMD762},
 	{
-		PCI_VEND_DEV(AMD, FE_GATE_700E), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		AMD761
-	},
+	 PCI_VEND_DEV(AMD, FE_GATE_700E), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 AMD761},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, amd76x_pci_tbl);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
