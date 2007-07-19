From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-i82443bxgx.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:29 -0700
Message-ID: <200707192006.l6JK6TFe020140@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51422 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762050AbXGSURL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:17:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, djiang@mvista.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent i82443bxgx
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-i82443bxgx.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent i82443bxgx
From: Douglas Thompson <dougthompson@xmission.com>

Run i82443bxgx.c file through Lindent for cleanup

Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82443bxgx_edac.c |  158 +++++++++++++------------------
 1 file changed, 71 insertions(+), 87 deletions(-)

diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-lindent-i82443bxgx drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-lindent-i82443bxgx
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -35,7 +35,6 @@
 
 #define EDAC_MOD_STR    "i82443bxgx_edac"
 
-
 /* The 82443BX supports SDRAM, or EDO (EDO for mobile only), "Memory
  * Size: 8 MB to 512 MB (1GB with Registered DIMMs) with eight memory
  * rows" "The 82443BX supports multiple-bit error detection and
@@ -61,67 +60,60 @@
 #define I82443BXGX_NR_CHANS  1
 #define I82443BXGX_NR_DIMMS  4
 
-
-
 /* 82443 PCI Device 0 */
-#define I82443BXGX_NBXCFG 0x50   /* 32bit register starting at this PCI
-				* config space offset */
-#define I82443BXGX_NBXCFG_OFFSET_NON_ECCROW 24 /* Array of bits, zero if
-					      * row is non-ECC */
-#define I82443BXGX_NBXCFG_OFFSET_DRAM_FREQ 12 /* 2 bits,00=100MHz,10=66 MHz */
-
-#define I82443BXGX_NBXCFG_OFFSET_DRAM_INTEGRITY 7 /* 2 bits:       */
-#define I82443BXGX_NBXCFG_INTEGRITY_NONE   0x0    /* 00 = Non-ECC */
-#define I82443BXGX_NBXCFG_INTEGRITY_EC     0x1    /* 01 = EC (only) */
-#define I82443BXGX_NBXCFG_INTEGRITY_ECC    0x2    /* 10 = ECC */
-#define I82443BXGX_NBXCFG_INTEGRITY_SCRUB  0x3    /* 11 = ECC + HW Scrub */
+#define I82443BXGX_NBXCFG 0x50	/* 32bit register starting at this PCI
+				 * config space offset */
+#define I82443BXGX_NBXCFG_OFFSET_NON_ECCROW 24	/* Array of bits, zero if
+						 * row is non-ECC */
+#define I82443BXGX_NBXCFG_OFFSET_DRAM_FREQ 12	/* 2 bits,00=100MHz,10=66 MHz */
+
+#define I82443BXGX_NBXCFG_OFFSET_DRAM_INTEGRITY 7	/* 2 bits:       */
+#define I82443BXGX_NBXCFG_INTEGRITY_NONE   0x0	/* 00 = Non-ECC */
+#define I82443BXGX_NBXCFG_INTEGRITY_EC     0x1	/* 01 = EC (only) */
+#define I82443BXGX_NBXCFG_INTEGRITY_ECC    0x2	/* 10 = ECC */
+#define I82443BXGX_NBXCFG_INTEGRITY_SCRUB  0x3	/* 11 = ECC + HW Scrub */
 
 #define I82443BXGX_NBXCFG_OFFSET_ECC_DIAG_ENABLE  6
 
-
 /* 82443 PCI Device 0 */
-#define I82443BXGX_EAP   0x80   /* 32bit register starting at this PCI
-				* config space offset, Error Address
-				* Pointer Register */
-#define I82443BXGX_EAP_OFFSET_EAP  12   /* High 20 bits of error address */
-#define I82443BXGX_EAP_OFFSET_MBE  BIT(1) /* Err at EAP was multi-bit (W1TC) */
-#define I82443BXGX_EAP_OFFSET_SBE  BIT(0) /* Err at EAP was single-bit (W1TC)*/
+#define I82443BXGX_EAP   0x80	/* 32bit register starting at this PCI
+				 * config space offset, Error Address
+				 * Pointer Register */
+#define I82443BXGX_EAP_OFFSET_EAP  12	/* High 20 bits of error address */
+#define I82443BXGX_EAP_OFFSET_MBE  BIT(1)	/* Err at EAP was multi-bit (W1TC) */
+#define I82443BXGX_EAP_OFFSET_SBE  BIT(0)	/* Err at EAP was single-bit (W1TC) */
 
-#define I82443BXGX_ERRCMD  0x90   /* 8bit register starting at this PCI
+#define I82443BXGX_ERRCMD  0x90	/* 8bit register starting at this PCI
 				 * config space offset. */
-#define I82443BXGX_ERRCMD_OFFSET_SERR_ON_MBE BIT(1) /* 1 = enable */
-#define I82443BXGX_ERRCMD_OFFSET_SERR_ON_SBE BIT(0) /* 1 = enable */
+#define I82443BXGX_ERRCMD_OFFSET_SERR_ON_MBE BIT(1)	/* 1 = enable */
+#define I82443BXGX_ERRCMD_OFFSET_SERR_ON_SBE BIT(0)	/* 1 = enable */
 
-#define I82443BXGX_ERRSTS  0x91   /* 16bit register starting at this PCI
+#define I82443BXGX_ERRSTS  0x91	/* 16bit register starting at this PCI
 				 * config space offset. */
-#define I82443BXGX_ERRSTS_OFFSET_MBFRE 5 /* 3 bits - first err row multibit */
-#define I82443BXGX_ERRSTS_OFFSET_MEF   BIT(4) /* 1 = MBE occurred */
-#define I82443BXGX_ERRSTS_OFFSET_SBFRE 1 /* 3 bits - first err row singlebit */
-#define I82443BXGX_ERRSTS_OFFSET_SEF   BIT(0) /* 1 = SBE occurred */
-
+#define I82443BXGX_ERRSTS_OFFSET_MBFRE 5	/* 3 bits - first err row multibit */
+#define I82443BXGX_ERRSTS_OFFSET_MEF   BIT(4)	/* 1 = MBE occurred */
+#define I82443BXGX_ERRSTS_OFFSET_SBFRE 1	/* 3 bits - first err row singlebit */
+#define I82443BXGX_ERRSTS_OFFSET_SEF   BIT(0)	/* 1 = SBE occurred */
 
-#define I82443BXGX_DRAMC 0x57   /* 8bit register starting at this PCI
-			       * config space offset. */
-#define I82443BXGX_DRAMC_OFFSET_DT 3      /* 2 bits, DRAM Type */
-#define I82443BXGX_DRAMC_DRAM_IS_EDO 0    /* 00 = EDO */
+#define I82443BXGX_DRAMC 0x57	/* 8bit register starting at this PCI
+				 * config space offset. */
+#define I82443BXGX_DRAMC_OFFSET_DT 3	/* 2 bits, DRAM Type */
+#define I82443BXGX_DRAMC_DRAM_IS_EDO 0	/* 00 = EDO */
 #define I82443BXGX_DRAMC_DRAM_IS_SDRAM 1	/* 01 = SDRAM */
-#define I82443BXGX_DRAMC_DRAM_IS_RSDRAM 2 /* 10 = Registered SDRAM */
-
-
-#define I82443BXGX_DRB 0x60   /* 8x 8bit registers starting at this PCI
-			     * config space offset. */
+#define I82443BXGX_DRAMC_DRAM_IS_RSDRAM 2	/* 10 = Registered SDRAM */
 
+#define I82443BXGX_DRB 0x60	/* 8x 8bit registers starting at this PCI
+				 * config space offset. */
 
 /* FIXME - don't poll when ECC disabled? */
 
-
 struct i82443bxgx_edacmc_error_info {
 	u32 eap;
 };
 
-
-static void i82443bxgx_edacmc_get_error_info (struct mem_ctl_info *mci,
-		struct i82443bxgx_edacmc_error_info *info)
+static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
+					     struct i82443bxgx_edacmc_error_info
+					     *info)
 {
 	struct pci_dev *pdev;
 	pdev = to_pci_dev(mci->dev);
@@ -139,9 +131,10 @@ static void i82443bxgx_edacmc_get_error_
 				 I82443BXGX_EAP_OFFSET_MBE);
 }
 
-
-static int i82443bxgx_edacmc_process_error_info (struct mem_ctl_info *mci,
-		struct i82443bxgx_edacmc_error_info *info, int handle_errors)
+static int i82443bxgx_edacmc_process_error_info(struct mem_ctl_info *mci,
+						struct
+						i82443bxgx_edacmc_error_info
+						*info, int handle_errors)
 {
 	int error_found = 0;
 	u32 eapaddr, page, pageoffset;
@@ -152,31 +145,26 @@ static int i82443bxgx_edacmc_process_err
 	page = eapaddr >> PAGE_SHIFT;
 	pageoffset = eapaddr - (page << PAGE_SHIFT);
 
-	if (info->eap  & I82443BXGX_EAP_OFFSET_SBE) {
+	if (info->eap & I82443BXGX_EAP_OFFSET_SBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ce(
-				mci, page, pageoffset,
-				/* 440BX/GX don't make syndrome information available */
-				0,
-				edac_mc_find_csrow_by_page(mci, page),
-				0,	/* channel */
-				mci->ctl_name);
+			edac_mc_handle_ce(mci, page, pageoffset,
+					  /* 440BX/GX don't make syndrome information available */
+					  0, edac_mc_find_csrow_by_page(mci, page), 0,	/* channel */
+					  mci->ctl_name);
 	}
 
-	if (info->eap  & I82443BXGX_EAP_OFFSET_MBE) {
+	if (info->eap & I82443BXGX_EAP_OFFSET_MBE) {
 		error_found = 1;
 		if (handle_errors)
-			edac_mc_handle_ue(
-				mci, page, pageoffset,
-				edac_mc_find_csrow_by_page(mci, page),
-				mci->ctl_name);
+			edac_mc_handle_ue(mci, page, pageoffset,
+					  edac_mc_find_csrow_by_page(mci, page),
+					  mci->ctl_name);
 	}
 
 	return error_found;
 }
 
-
 static void i82443bxgx_edacmc_check(struct mem_ctl_info *mci)
 {
 	struct i82443bxgx_edacmc_error_info info;
@@ -186,11 +174,10 @@ static void i82443bxgx_edacmc_check(stru
 	i82443bxgx_edacmc_process_error_info(mci, &info, 1);
 }
 
-
 static void i82443bxgx_init_csrows(struct mem_ctl_info *mci,
-					struct pci_dev *pdev,
-					enum edac_type edac_mode,
-					enum mem_type mtype)
+				   struct pci_dev *pdev,
+				   enum edac_type edac_mode,
+				   enum mem_type mtype)
 {
 	struct csrow_info *csrow;
 	int index;
@@ -233,8 +220,7 @@ static void i82443bxgx_init_csrows(struc
 	}
 }
 
-
-static int  i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
+static int i82443bxgx_edacmc_probe1(struct pci_dev *pdev, int dev_idx)
 {
 	struct mem_ctl_info *mci;
 	u8 dramc;
@@ -260,7 +246,7 @@ static int  i82443bxgx_edacmc_probe1(str
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
 	pci_read_config_byte(pdev, I82443BXGX_DRAMC, &dramc);
 	switch ((dramc >> I82443BXGX_DRAMC_OFFSET_DT) & (BIT(0) | BIT(1))) {
-	case  I82443BXGX_DRAMC_DRAM_IS_EDO:
+	case I82443BXGX_DRAMC_DRAM_IS_EDO:
 		mtype = MEM_EDO;
 		break;
 	case I82443BXGX_DRAMC_DRAM_IS_SDRAM:
@@ -270,7 +256,8 @@ static int  i82443bxgx_edacmc_probe1(str
 		mtype = MEM_RDR;
 		break;
 	default:
-		debugf0("Unknown/reserved DRAM type value in DRAMC register!\n");
+		debugf0
+		    ("Unknown/reserved DRAM type value in DRAMC register!\n");
 		mtype = -MEM_UNKNOWN;
 	}
 
@@ -282,13 +269,12 @@ static int  i82443bxgx_edacmc_probe1(str
 	mci->scrub_cap = SCRUB_FLAG_HW_SRC;
 	pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg);
 	ecc_mode = ((nbxcfg >> I82443BXGX_NBXCFG_OFFSET_DRAM_INTEGRITY) &
-				(BIT(0) | BIT(1)));
+		    (BIT(0) | BIT(1)));
 
 	mci->scrub_mode = (ecc_mode == I82443BXGX_NBXCFG_INTEGRITY_SCRUB)
-		? SCRUB_HW_SRC
-		: SCRUB_NONE;
+	    ? SCRUB_HW_SRC : SCRUB_NONE;
 
-	switch(ecc_mode) {
+	switch (ecc_mode) {
 	case I82443BXGX_NBXCFG_INTEGRITY_NONE:
 		edac_mode = EDAC_NONE;
 		break;
@@ -300,8 +286,9 @@ static int  i82443bxgx_edacmc_probe1(str
 		edac_mode = EDAC_SECDED;
 		break;
 	default:
-		debugf0("%s(): Unknown/reserved ECC state in NBXCFG register!\n",
-			__func__);
+		debugf0
+		    ("%s(): Unknown/reserved ECC state in NBXCFG register!\n",
+		     __func__);
 		edac_mode = EDAC_UNKNOWN;
 		break;
 	}
@@ -312,8 +299,10 @@ static int  i82443bxgx_edacmc_probe1(str
 	 * here, or we get "phantom" errors occuring at module-load
 	 * time. */
 	pci_write_bits32(pdev, I82443BXGX_EAP,
-			 (I82443BXGX_EAP_OFFSET_SBE | I82443BXGX_EAP_OFFSET_MBE),
-			 (I82443BXGX_EAP_OFFSET_SBE | I82443BXGX_EAP_OFFSET_MBE));
+			 (I82443BXGX_EAP_OFFSET_SBE |
+			  I82443BXGX_EAP_OFFSET_MBE),
+			 (I82443BXGX_EAP_OFFSET_SBE |
+			  I82443BXGX_EAP_OFFSET_MBE));
 
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82443_REVISION;
@@ -330,36 +319,36 @@ static int  i82443bxgx_edacmc_probe1(str
 	debugf3("MC: " __FILE__ ": %s(): success\n", __func__);
 	return 0;
 
-fail:
+      fail:
 	edac_mc_free(mci);
 	return -ENODEV;
 }
+
 EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_probe1);
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
-				     const struct pci_device_id *ent)
+						const struct pci_device_id *ent)
 {
 	debugf0("MC: " __FILE__ ": %s()\n", __func__);
 
 	/* don't need to call pci_device_enable() */
-	return  i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
+	return i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
 }
 
-
 static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 
 	debugf0(__FILE__ ": %s()\n", __func__);
 
-	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL )
+	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
 	edac_mc_free(mci);
 }
-EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_remove_one);
 
+EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_remove_one);
 
 static const struct pci_device_id i82443bxgx_pci_tbl[] __devinitdata = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82443BX_0)},
@@ -371,7 +360,6 @@ static const struct pci_device_id i82443
 
 MODULE_DEVICE_TABLE(pci, i82443bxgx_pci_tbl);
 
-
 static struct pci_driver i82443bxgx_edacmc_driver = {
 	.name = EDAC_MOD_STR,
 	.probe = i82443bxgx_edacmc_init_one,
@@ -379,23 +367,19 @@ static struct pci_driver i82443bxgx_edac
 	.id_table = i82443bxgx_pci_tbl,
 };
 
-
 static int __init i82443bxgx_edacmc_init(void)
 {
 	return pci_register_driver(&i82443bxgx_edacmc_driver);
 }
 
-
 static void __exit i82443bxgx_edacmc_exit(void)
 {
 	pci_unregister_driver(&i82443bxgx_edacmc_driver);
 }
 
-
 module_init(i82443bxgx_edacmc_init);
 module_exit(i82443bxgx_edacmc_exit);
 
-
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Tim Small <tim@buttersideup.com> - WPAD");
 MODULE_DESCRIPTION("EDAC MC support for Intel 82443BX/GX memory controllers");
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
