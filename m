From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-r82600.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:31 -0700
Message-ID: <200707192006.l6JK6VLY020143@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761112AbXGSUPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent r82600
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-r82600.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent r82600
From: Douglas Thompson <dougthompson@xmission.com>

Run r82600_edac.c file through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/r82600_edac.c |   55 +++++++++++++++++------------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff -puN drivers/edac/r82600_edac.c~drivers-edac-lindent-r82600 drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-lindent-r82600
+++ a/drivers/edac/r82600_edac.c
@@ -133,8 +133,8 @@ struct r82600_error_info {
 
 static unsigned int disable_hardware_scrub = 0;
 
-static void r82600_get_error_info (struct mem_ctl_info *mci,
-		struct r82600_error_info *info)
+static void r82600_get_error_info(struct mem_ctl_info *mci,
+				  struct r82600_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -144,18 +144,19 @@ static void r82600_get_error_info (struc
 	if (info->eapr & BIT(0))
 		/* Clear error to allow next error to be reported [p.62] */
 		pci_write_bits32(pdev, R82600_EAP,
-				((u32) BIT(0) & (u32) BIT(1)),
-				((u32) BIT(0) & (u32) BIT(1)));
+				 ((u32) BIT(0) & (u32) BIT(1)),
+				 ((u32) BIT(0) & (u32) BIT(1)));
 
 	if (info->eapr & BIT(1))
 		/* Clear error to allow next error to be reported [p.62] */
 		pci_write_bits32(pdev, R82600_EAP,
-				((u32) BIT(0) & (u32) BIT(1)),
-				((u32) BIT(0) & (u32) BIT(1)));
+				 ((u32) BIT(0) & (u32) BIT(1)),
+				 ((u32) BIT(0) & (u32) BIT(1)));
 }
 
-static int r82600_process_error_info (struct mem_ctl_info *mci,
-		struct r82600_error_info *info, int handle_errors)
+static int r82600_process_error_info(struct mem_ctl_info *mci,
+				     struct r82600_error_info *info,
+				     int handle_errors)
 {
 	int error_found;
 	u32 eapaddr, page;
@@ -172,25 +173,23 @@ static int r82600_process_error_info (st
 	 * granularity (upper 19 bits only)     */
 	page = eapaddr >> PAGE_SHIFT;
 
-	if (info->eapr & BIT(0)) {  /* CE? */
+	if (info->eapr & BIT(0)) {	/* CE? */
 		error_found = 1;
 
 		if (handle_errors)
-			edac_mc_handle_ce(mci, page, 0,  /* not avail */
-					syndrome,
-					edac_mc_find_csrow_by_page(mci, page),
-					0,  /* channel */
-					mci->ctl_name);
+			edac_mc_handle_ce(mci, page, 0,	/* not avail */
+					  syndrome, edac_mc_find_csrow_by_page(mci, page), 0,	/* channel */
+					  mci->ctl_name);
 	}
 
-	if (info->eapr & BIT(1)) {  /* UE? */
+	if (info->eapr & BIT(1)) {	/* UE? */
 		error_found = 1;
 
 		if (handle_errors)
 			/* 82600 doesn't give enough info */
 			edac_mc_handle_ue(mci, page, 0,
-				edac_mc_find_csrow_by_page(mci, page),
-				mci->ctl_name);
+					  edac_mc_find_csrow_by_page(mci, page),
+					  mci->ctl_name);
 	}
 
 	return error_found;
@@ -211,11 +210,11 @@ static inline int ecc_enabled(u8 dramcr)
 }
 
 static void r82600_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-		u8 dramcr)
+			       u8 dramcr)
 {
 	struct csrow_info *csrow;
 	int index;
-	u8 drbar;  /* SDRAM Row Boundry Address Register */
+	u8 drbar;		/* SDRAM Row Boundry Address Register */
 	u32 row_high_limit, row_high_limit_last;
 	u32 reg_sdram, ecc_on, row_base;
 
@@ -309,12 +308,12 @@ static int r82600_probe1(struct pci_dev 
 	mci->edac_check = r82600_check;
 	mci->ctl_page_to_phys = NULL;
 	r82600_init_csrows(mci, pdev, dramcr);
-	r82600_get_error_info(mci, &discard);  /* clear counters */
+	r82600_get_error_info(mci, &discard);	/* clear counters */
 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
@@ -330,14 +329,14 @@ static int r82600_probe1(struct pci_dev 
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
 
 /* returns count (>= 0), or negative on error */
 static int __devinit r82600_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				     const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
@@ -359,11 +358,11 @@ static void __devexit r82600_remove_one(
 
 static const struct pci_device_id r82600_pci_tbl[] __devinitdata = {
 	{
-		PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
-	},
+	 PCI_DEVICE(PCI_VENDOR_ID_RADISYS, R82600_BRIDGE_ID)
+	 },
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, r82600_pci_tbl);
@@ -390,7 +389,7 @@ module_exit(r82600_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD Ltd. "
-	"on behalf of EADS Astrium");
+	      "on behalf of EADS Astrium");
 MODULE_DESCRIPTION("MC support for Radisys 82600 memory controllers");
 
 module_param(disable_hardware_scrub, bool, 0644);
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
