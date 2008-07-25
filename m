From: akpm@linux-foundation.org
Subject: - edac-e752x-fix-too-loud-on-nonmemory-errors.patch removed from -mm tree
Date: Fri, 25 Jul 2008 16:04:10 -0700
Message-ID: <200807252304.m6PN4AEi004025@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754050AbYGYXEh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:04:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: e752x fix too loud on nonmemory errors
has been removed from the -mm tree.  Its filename was
     edac-e752x-fix-too-loud-on-nonmemory-errors.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: e752x fix too loud on nonmemory errors
From: Doug Thompson <dougthompson@xmission.com>

This module harvests more than just memory errors, it also harvests
various bus and dma errors that the Chipset detects.  Previously, it would
report all such errors, which would cause output to be TOO loud.

This patches therefore adds a parameter which is used to turn off
NON-MEMORY error reports by default.  Or the reporting can be enabled via
the parameter

Also did code style cleanup: less than 80 characters per line rule

Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/e752x_edac.c |   59 +++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff -puN drivers/edac/e752x_edac.c~edac-e752x-fix-too-loud-on-nonmemory-errors drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-e752x-fix-too-loud-on-nonmemory-errors
+++ a/drivers/edac/e752x_edac.c
@@ -28,6 +28,7 @@
 #define E752X_REVISION	" Ver: 2.0.2 " __DATE__
 #define EDAC_MOD_STR	"e752x_edac"
 
+static int report_non_memory_errors;
 static int force_function_unhide;
 static int sysbus_parity = -1;
 
@@ -117,7 +118,7 @@ static struct edac_pci_ctl_info *e752x_p
 #define E752X_BUF_FERR		0x70	/* Memory buffer first error reg (8b) */
 #define E752X_BUF_NERR		0x72	/* Memory buffer next error reg (8b) */
 #define E752X_BUF_ERRMASK	0x74	/* Memory buffer error mask reg (8b) */
-#define E752X_BUF_SMICMD	0x7A	/* Memory buffer SMI command reg (8b) */
+#define E752X_BUF_SMICMD	0x7A	/* Memory buffer SMI cmd reg (8b) */
 #define E752X_DRAM_FERR		0x80	/* DRAM first error register (16b) */
 #define E752X_DRAM_NERR		0x82	/* DRAM next error register (16b) */
 #define E752X_DRAM_ERRMASK	0x84	/* DRAM error mask register (8b) */
@@ -127,7 +128,7 @@ static struct edac_pci_ctl_info *e752x_p
 					/*     error address register (32b) */
 					/*
 					 * 31    Reserved
-					 * 30:2  CE address (64 byte block 34:6)
+					 * 30:2  CE address (64 byte block 34:6
 					 * 1     Reserved
 					 * 0     HiLoCS
 					 */
@@ -147,11 +148,11 @@ static struct edac_pci_ctl_info *e752x_p
 					 * 1     Reserved
 					 * 0     HiLoCS
 					 */
-#define E752X_DRAM_SCRB_ADD	0xA8	/* DRAM first uncorrectable scrub memory */
+#define E752X_DRAM_SCRB_ADD	0xA8	/* DRAM 1st uncorrectable scrub mem */
 					/*     error address register (32b) */
 					/*
 					 * 31    Reserved
-					 * 30:2  CE address (64 byte block 34:6)
+					 * 30:2  CE address (64 byte block 34:6
 					 * 1     Reserved
 					 * 0     HiLoCS
 					 */
@@ -394,9 +395,12 @@ static void do_process_ded_retry(struct 
 	struct e752x_pvt *pvt = (struct e752x_pvt *)mci->pvt_info;
 
 	error_1b = retry_add;
-	page = error_1b >> (PAGE_SHIFT - 4);	/* convert the addr to 4k page */
-	row = pvt->mc_symmetric ? ((page >> 1) & 3) :	/* chip select are bits 14 & 13 */
+	page = error_1b >> (PAGE_SHIFT - 4);  /* convert the addr to 4k page */
+
+	/* chip select are bits 14 & 13 */
+	row = pvt->mc_symmetric ? ((page >> 1) & 3) :
 		edac_mc_find_csrow_by_page(mci, page);
+
 	e752x_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, row %d : Memory read retry\n",
 			(long unsigned int)page, row);
@@ -422,12 +426,21 @@ static inline void process_threshold_ce(
 }
 
 static char *global_message[11] = {
-	"PCI Express C1", "PCI Express C", "PCI Express B1",
-	"PCI Express B", "PCI Express A1", "PCI Express A",
-	"DMA Controler", "HUB or NS Interface", "System Bus",
-	"DRAM Controler", "Internal Buffer"
+	"PCI Express C1",
+	"PCI Express C",
+	"PCI Express B1",
+	"PCI Express B",
+	"PCI Express A1",
+	"PCI Express A",
+	"DMA Controller",
+	"HUB or NS Interface",
+	"System Bus",
+	"DRAM Controller",  /* 9th entry */
+	"Internal Buffer"
 };
 
+#define DRAM_ENTRY	9
+
 static char *fatal_message[2] = { "Non-Fatal ", "Fatal " };
 
 static void do_global_error(int fatal, u32 errors)
@@ -435,9 +448,16 @@ static void do_global_error(int fatal, u
 	int i;
 
 	for (i = 0; i < 11; i++) {
-		if (errors & (1 << i))
-			e752x_printk(KERN_WARNING, "%sError %s\n",
-				fatal_message[fatal], global_message[i]);
+		if (errors & (1 << i)) {
+			/* If the error is from DRAM Controller OR
+			 * we are to report ALL errors, then
+			 * report the error
+			 */
+			if ((i == DRAM_ENTRY) || report_non_memory_errors)
+				e752x_printk(KERN_WARNING, "%sError %s\n",
+					fatal_message[fatal],
+					global_message[i]);
+		}
 	}
 }
 
@@ -1021,7 +1041,7 @@ static int e752x_get_devs(struct pci_dev
 	struct pci_dev *dev;
 
 	pvt->bridge_ck = pci_get_device(PCI_VENDOR_ID_INTEL,
-					pvt->dev_info->err_dev, pvt->bridge_ck);
+				pvt->dev_info->err_dev, pvt->bridge_ck);
 
 	if (pvt->bridge_ck == NULL)
 		pvt->bridge_ck = pci_scan_single_device(pdev->bus,
@@ -1034,8 +1054,9 @@ static int e752x_get_devs(struct pci_dev
 		return 1;
 	}
 
-	dev = pci_get_device(PCI_VENDOR_ID_INTEL, e752x_devs[dev_idx].ctl_dev,
-			NULL);
+	dev = pci_get_device(PCI_VENDOR_ID_INTEL,
+				e752x_devs[dev_idx].ctl_dev,
+				NULL);
 
 	if (dev == NULL)
 		goto fail;
@@ -1316,7 +1337,8 @@ MODULE_DESCRIPTION("MC support for Intel
 
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as hidden:"
-		 " 1=force unhide and hope BIOS doesn't fight driver for Dev0:Fun1 access");
+		 " 1=force unhide and hope BIOS doesn't fight driver for "
+		"Dev0:Fun1 access");
 
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
@@ -1324,3 +1346,6 @@ MODULE_PARM_DESC(edac_op_state, "EDAC Er
 module_param(sysbus_parity, int, 0444);
 MODULE_PARM_DESC(sysbus_parity, "0=disable system bus parity checking,"
 		" 1=enable system bus parity checking, default=auto-detect");
+module_param(report_non_memory_errors, int, 0644);
+MODULE_PARM_DESC(report_non_memory_errors, "0=disable non-memory error "
+		"reporting, 1=enable non-memory error reporting");
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch

