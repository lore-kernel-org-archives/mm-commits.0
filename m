From: akpm@linux-foundation.org
Subject: + drivers-edac-lindent-r82600.patch added to -mm tree
Date: Tue, 05 Jun 2007 18:51:24 -0700
Message-ID: <200706060151.l561pOuA007513@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933954AbXFFB46 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Jun 2007 21:56:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dougthompson@xmission.com, djiang@mvista.com


The patch titled
     drivers-edac: Lindent r82600
has been added to the -mm tree.  Its filename is
     drivers-edac-lindent-r82600.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers-edac: Lindent r82600
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

drivers-edac-remove-depends-on-x86.patch
drivers-edac-add-edac_mc_find-api.patch
drivers-edac-add-rddr2-memory-types.patch
drivers-edac-split-out-functions-to-unique-files.patch
drivers-edac-add-edac_device-class.patch
drivers-edac-mc-sysfs-add-missing-mem-types.patch
drivers-edac-change-from-semaphore-to-mutex-operation.patch
drivers-edac-coreh-fix-scrubdefs.patch
drivers-edac-new-i82443bxgz-mc-driver.patch
drivers-edac-add-new-nmi-rescan.patch
drivers-edac-mod-use-edac_coreh.patch
drivers-edac-add-dev_name-getter-function.patch
drivers-edac-new-inte-30x0-mc-driver.patch
drivers-edac-mod-mc-to-use-workq-instead-of-kthread.patch
drivers-edac-updated-pci-monitoring.patch
drivers-edac-mod-assert_error-check.patch
drivers-edac-core-lindent-cleanup.patch
drivers-edac-edac_device-sysfs-cleanup.patch
drivers-edac-cleanup-workq-ifdefs.patch
drivers-edac-lindent-amd76x.patch
drivers-edac-lindent-i5000.patch
drivers-edac-lindent-e7xxx.patch
drivers-edac-lindent-i3000.patch
drivers-edac-lindent-i82860.patch
drivers-edac-lindent-i82875p.patch
drivers-edac-lindent-e752x.patch
drivers-edac-lindent-i82443bxgx.patch
drivers-edac-lindent-r82600.patch
drivers-edac-drivers-to-use-new-pci-operation.patch
drivers-edac-add-device-sysfs-attributes.patch
drivers-edac-device-output-clenaup.patch
drivers-edac-add-info-kconfig.patch
drivers-edac-update-maintainers-files-for-edac.patch
drivers-edac-cleanup-spaces-gotos-after-lindent-messup.patch
