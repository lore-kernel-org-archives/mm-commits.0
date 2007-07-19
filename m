From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-e7xxx.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:18 -0700
Message-ID: <200707192006.l6JK6Ivg020125@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50113 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762072AbXGSURM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent e7xxx
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-e7xxx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent e7xxx
From: Dave Jiang <djiang@mvista.com>

Lindent cleanup of e7xxx_edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e7xxx_edac.c |  132 ++++++++++++++++--------------------
 1 file changed, 59 insertions(+), 73 deletions(-)

diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-lindent-e7xxx drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-lindent-e7xxx
+++ a/drivers/edac/e7xxx_edac.c
@@ -146,21 +146,17 @@ struct e7xxx_error_info {
 
 static const struct e7xxx_dev_info e7xxx_devs[] = {
 	[E7500] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7500_1_ERR,
-		.ctl_name = "E7500"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7500_1_ERR,
+		   .ctl_name = "E7500"},
 	[E7501] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7501_1_ERR,
-		.ctl_name = "E7501"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7501_1_ERR,
+		   .ctl_name = "E7501"},
 	[E7505] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7505_1_ERR,
-		.ctl_name = "E7505"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7505_1_ERR,
+		   .ctl_name = "E7505"},
 	[E7205] = {
-		.err_dev = PCI_DEVICE_ID_INTEL_7205_1_ERR,
-		.ctl_name = "E7205"
-	},
+		   .err_dev = PCI_DEVICE_ID_INTEL_7205_1_ERR,
+		   .ctl_name = "E7205"},
 };
 
 /* FIXME - is this valid for both SECDED and S4ECD4ED? */
@@ -181,15 +177,15 @@ static inline int e7xxx_find_channel(u16
 }
 
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
-		unsigned long page)
+				      unsigned long page)
 {
 	u32 remap;
-	struct e7xxx_pvt *pvt = (struct e7xxx_pvt *) mci->pvt_info;
+	struct e7xxx_pvt *pvt = (struct e7xxx_pvt *)mci->pvt_info;
 
 	debugf3("%s()\n", __func__);
 
 	if ((page < pvt->tolm) ||
-			((page >= 0x100000) && (page < pvt->remapbase)))
+	    ((page >= 0x100000) && (page < pvt->remapbase)))
 		return page;
 
 	remap = (page - pvt->tolm) + pvt->remapbase;
@@ -201,8 +197,7 @@ static unsigned long ctl_page_to_phys(st
 	return pvt->tolm - 1;
 }
 
-static void process_ce(struct mem_ctl_info *mci,
-		struct e7xxx_error_info *info)
+static void process_ce(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 {
 	u32 error_1b, page;
 	u16 syndrome;
@@ -213,7 +208,7 @@ static void process_ce(struct mem_ctl_in
 	/* read the error address */
 	error_1b = info->dram_celog_add;
 	/* FIXME - should use PAGE_SHIFT */
-	page = error_1b >> 6;  /* convert the address to 4k page */
+	page = error_1b >> 6;	/* convert the address to 4k page */
 	/* read the syndrome */
 	syndrome = info->dram_celog_syndrome;
 	/* FIXME - check for -1 */
@@ -229,8 +224,7 @@ static void process_ce_no_info(struct me
 	edac_mc_handle_ce_no_info(mci, "e7xxx CE log register overflow");
 }
 
-static void process_ue(struct mem_ctl_info *mci,
-		struct e7xxx_error_info *info)
+static void process_ue(struct mem_ctl_info *mci, struct e7xxx_error_info *info)
 {
 	u32 error_2b, block_page;
 	int row;
@@ -239,7 +233,7 @@ static void process_ue(struct mem_ctl_in
 	/* read the error address */
 	error_2b = info->dram_uelog_add;
 	/* FIXME - should use PAGE_SHIFT */
-	block_page = error_2b >> 6;  /* convert to 4k address */
+	block_page = error_2b >> 6;	/* convert to 4k address */
 	row = edac_mc_find_csrow_by_page(mci, block_page);
 	edac_mc_handle_ue(mci, block_page, 0, row, "e7xxx UE");
 }
@@ -250,28 +244,26 @@ static void process_ue_no_info(struct me
 	edac_mc_handle_ue_no_info(mci, "e7xxx UE log register overflow");
 }
 
-static void e7xxx_get_error_info (struct mem_ctl_info *mci,
-		struct e7xxx_error_info *info)
+static void e7xxx_get_error_info(struct mem_ctl_info *mci,
+				 struct e7xxx_error_info *info)
 {
 	struct e7xxx_pvt *pvt;
 
-	pvt = (struct e7xxx_pvt *) mci->pvt_info;
-	pci_read_config_byte(pvt->bridge_ck, E7XXX_DRAM_FERR,
-			&info->dram_ferr);
-	pci_read_config_byte(pvt->bridge_ck, E7XXX_DRAM_NERR,
-			&info->dram_nerr);
+	pvt = (struct e7xxx_pvt *)mci->pvt_info;
+	pci_read_config_byte(pvt->bridge_ck, E7XXX_DRAM_FERR, &info->dram_ferr);
+	pci_read_config_byte(pvt->bridge_ck, E7XXX_DRAM_NERR, &info->dram_nerr);
 
 	if ((info->dram_ferr & 1) || (info->dram_nerr & 1)) {
 		pci_read_config_dword(pvt->bridge_ck, E7XXX_DRAM_CELOG_ADD,
-				&info->dram_celog_add);
+				      &info->dram_celog_add);
 		pci_read_config_word(pvt->bridge_ck,
-				E7XXX_DRAM_CELOG_SYNDROME,
-				&info->dram_celog_syndrome);
+				     E7XXX_DRAM_CELOG_SYNDROME,
+				     &info->dram_celog_syndrome);
 	}
 
 	if ((info->dram_ferr & 2) || (info->dram_nerr & 2))
 		pci_read_config_dword(pvt->bridge_ck, E7XXX_DRAM_UELOG_ADD,
-				&info->dram_uelog_add);
+				      &info->dram_uelog_add);
 
 	if (info->dram_ferr & 3)
 		pci_write_bits8(pvt->bridge_ck, E7XXX_DRAM_FERR, 0x03, 0x03);
@@ -280,8 +272,9 @@ static void e7xxx_get_error_info (struct
 		pci_write_bits8(pvt->bridge_ck, E7XXX_DRAM_NERR, 0x03, 0x03);
 }
 
-static int e7xxx_process_error_info (struct mem_ctl_info *mci,
-		struct e7xxx_error_info *info, int handle_errors)
+static int e7xxx_process_error_info(struct mem_ctl_info *mci,
+				    struct e7xxx_error_info *info,
+				    int handle_errors)
 {
 	int error_found;
 
@@ -342,7 +335,6 @@ static inline int dual_channel_active(u3
 	return (dev_idx == E7501) ? ((drc >> 22) & 0x1) : 1;
 }
 
-
 /* Return DRB granularity (0=32mb, 1=64mb). */
 static inline int drb_granularity(u32 drc, int dev_idx)
 {
@@ -350,9 +342,8 @@ static inline int drb_granularity(u32 dr
 	return (dev_idx == E7501) ? ((drc >> 18) & 0x3) : 1;
 }
 
-
 static void e7xxx_init_csrows(struct mem_ctl_info *mci, struct pci_dev *pdev,
-		int dev_idx, u32 drc)
+			      int dev_idx, u32 drc)
 {
 	unsigned long last_cumul_size;
 	int index;
@@ -422,13 +413,13 @@ static int e7xxx_probe1(struct pci_dev *
 	debugf0("%s(): mci\n", __func__);
 
 	/* make sure error reporting method is sane */
-	switch(edac_op_state) {
-		case EDAC_OPSTATE_POLL:
-		case EDAC_OPSTATE_NMI:
-			break;
-		default:
-			edac_op_state = EDAC_OPSTATE_POLL;
-			break;
+	switch (edac_op_state) {
+	case EDAC_OPSTATE_POLL:
+	case EDAC_OPSTATE_NMI:
+		break;
+	default:
+		edac_op_state = EDAC_OPSTATE_POLL;
+		break;
 	}
 
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
@@ -442,22 +433,21 @@ static int e7xxx_probe1(struct pci_dev *
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
-			EDAC_FLAG_S4ECD4ED;
+	    EDAC_FLAG_S4ECD4ED;
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E7XXX_REVISION;
 	mci->dev = &pdev->dev;
 	debugf3("%s(): init pvt\n", __func__);
-	pvt = (struct e7xxx_pvt *) mci->pvt_info;
+	pvt = (struct e7xxx_pvt *)mci->pvt_info;
 	pvt->dev_info = &e7xxx_devs[dev_idx];
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
-					pvt->dev_info->err_dev,
-					pvt->bridge_ck);
+					pvt->dev_info->err_dev, pvt->bridge_ck);
 
 	if (!pvt->bridge_ck) {
 		e7xxx_printk(KERN_ERR, "error reporting device not found:"
-			"vendor %x device 0x%x (broken BIOS?)\n",
-			PCI_VENDOR_ID_INTEL, e7xxx_devs[dev_idx].err_dev);
+			     "vendor %x device 0x%x (broken BIOS?)\n",
+			     PCI_VENDOR_ID_INTEL, e7xxx_devs[dev_idx].err_dev);
 		goto fail0;
 	}
 
@@ -477,8 +467,8 @@ static int e7xxx_probe1(struct pci_dev *
 	pci_read_config_word(pdev, E7XXX_REMAPLIMIT, &pci_data);
 	pvt->remaplimit = ((u32) pci_data) << 14;
 	e7xxx_printk(KERN_INFO,
-		"tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
-		pvt->remapbase, pvt->remaplimit);
+		     "tolm = %x, remapbase = %x, remaplimit = %x\n", pvt->tolm,
+		     pvt->remapbase, pvt->remaplimit);
 
 	/* clear any pending errors, or initial state bits */
 	e7xxx_get_error_info(mci, &discard);
@@ -486,7 +476,7 @@ static int e7xxx_probe1(struct pci_dev *
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci,0)) {
+	if (edac_mc_add_mc(mci, 0)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail1;
 	}
@@ -495,10 +485,10 @@ static int e7xxx_probe1(struct pci_dev *
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
-fail1:
+      fail1:
 	pci_dev_put(pvt->bridge_ck);
 
-fail0:
+      fail0:
 	edac_mc_free(mci);
 
 	return -ENODEV;
@@ -506,13 +496,13 @@ fail0:
 
 /* returns count (>= 0), or negative on error */
 static int __devinit e7xxx_init_one(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+				    const struct pci_device_id *ent)
 {
 	debugf0("%s()\n", __func__);
 
 	/* wake up and enable device */
 	return pci_enable_device(pdev) ?
-		-EIO : e7xxx_probe1(pdev, ent->driver_data);
+	    -EIO : e7xxx_probe1(pdev, ent->driver_data);
 }
 
 static void __devexit e7xxx_remove_one(struct pci_dev *pdev)
@@ -525,31 +515,27 @@ static void __devexit e7xxx_remove_one(s
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
-	pvt = (struct e7xxx_pvt *) mci->pvt_info;
+	pvt = (struct e7xxx_pvt *)mci->pvt_info;
 	pci_dev_put(pvt->bridge_ck);
 	edac_mc_free(mci);
 }
 
 static const struct pci_device_id e7xxx_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 7205_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7205
-	},
+	 PCI_VEND_DEV(INTEL, 7205_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7205},
 	{
-		PCI_VEND_DEV(INTEL, 7500_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7500
-	},
+	 PCI_VEND_DEV(INTEL, 7500_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7500},
 	{
-		PCI_VEND_DEV(INTEL, 7501_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7501
-	},
+	 PCI_VEND_DEV(INTEL, 7501_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7501},
 	{
-		PCI_VEND_DEV(INTEL, 7505_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-		E7505
-	},
+	 PCI_VEND_DEV(INTEL, 7505_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 E7505},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, e7xxx_pci_tbl);
@@ -576,7 +562,7 @@ module_exit(e7xxx_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Thayne Harbaugh et al\n"
-	"Based on.work by Dan Hollis et al");
+	      "Based on.work by Dan Hollis et al");
 MODULE_DESCRIPTION("MC support for Intel e7xxx memory controllers");
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
