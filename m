From: akpm@linux-foundation.org
Subject: - edac-new-support-for-intel-3100-chipset.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:48:39 -0700
Message-ID: <200804300548.m3U5mdlL029897@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758748AbYD3Ft3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:49:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akonovalov@ru.mvista.com, alan@lxorguk.ukuu.org.uk, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: new support for Intel 3100 chipset
has been removed from the -mm tree.  Its filename was
     edac-new-support-for-intel-3100-chipset.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: new support for Intel 3100 chipset
From: Andrei Konovalov <akonovalov@ru.mvista.com>

Add Intel 3100 chipset support to e752x EDAC driver.

Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrei Konovalov <akonovalov@ru.mvista.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/Kconfig      |    2 
 drivers/edac/e752x_edac.c |  165 +++++++++++++++++++++++++++++++++---
 2 files changed, 154 insertions(+), 13 deletions(-)

diff -puN drivers/edac/Kconfig~edac-new-support-for-intel-3100-chipset drivers/edac/Kconfig
--- a/drivers/edac/Kconfig~edac-new-support-for-intel-3100-chipset
+++ a/drivers/edac/Kconfig
@@ -67,7 +67,7 @@ config EDAC_E7XXX
 	  E7205, E7500, E7501 and E7505 server chipsets.
 
 config EDAC_E752X
-	tristate "Intel e752x (e7520, e7525, e7320)"
+	tristate "Intel e752x (e7520, e7525, e7320) and 3100"
 	depends on EDAC_MM_EDAC && PCI && X86 && HOTPLUG
 	help
 	  Support for error detection and correction on the Intel
diff -puN drivers/edac/e752x_edac.c~edac-new-support-for-intel-3100-chipset drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~edac-new-support-for-intel-3100-chipset
+++ a/drivers/edac/e752x_edac.c
@@ -62,6 +62,14 @@ static struct edac_pci_ctl_info *e752x_p
 #define PCI_DEVICE_ID_INTEL_7320_1_ERR	0x3593
 #endif				/* PCI_DEVICE_ID_INTEL_7320_1_ERR */
 
+#ifndef PCI_DEVICE_ID_INTEL_3100_0
+#define PCI_DEVICE_ID_INTEL_3100_0	0x35B0
+#endif				/* PCI_DEVICE_ID_INTEL_3100_0 */
+
+#ifndef PCI_DEVICE_ID_INTEL_3100_1_ERR
+#define PCI_DEVICE_ID_INTEL_3100_1_ERR	0x35B1
+#endif				/* PCI_DEVICE_ID_INTEL_3100_1_ERR */
+
 #define E752X_NR_CSROWS		8	/* number of csrows */
 
 /* E752X register addresses - device 0 function 0 */
@@ -152,6 +160,12 @@ static struct edac_pci_ctl_info *e752x_p
 					/*     error syndrome register (16b) */
 #define E752X_DEVPRES1		0xF4	/* Device Present 1 register (8b) */
 
+/* 3100 IMCH specific register addresses - device 0 function 1 */
+#define I3100_NSI_FERR		0x48	/* NSI first error reg (32b) */
+#define I3100_NSI_NERR		0x4C	/* NSI next error reg (32b) */
+#define I3100_NSI_SMICMD	0x54	/* NSI SMI command register (32b) */
+#define I3100_NSI_EMASK		0x90	/* NSI error mask register (32b) */
+
 /* ICH5R register addresses - device 30 function 0 */
 #define ICH5R_PCI_STAT		0x06	/* PCI status register (16b) */
 #define ICH5R_PCI_2ND_STAT	0x1E	/* PCI status secondary reg (16b) */
@@ -160,7 +174,8 @@ static struct edac_pci_ctl_info *e752x_p
 enum e752x_chips {
 	E7520 = 0,
 	E7525 = 1,
-	E7320 = 2
+	E7320 = 2,
+	I3100 = 3
 };
 
 struct e752x_pvt {
@@ -185,8 +200,10 @@ struct e752x_dev_info {
 struct e752x_error_info {
 	u32 ferr_global;
 	u32 nerr_global;
-	u8 hi_ferr;
-	u8 hi_nerr;
+	u32 nsi_ferr;	/* 3100 only */
+	u32 nsi_nerr;	/* 3100 only */
+	u8 hi_ferr;	/* all but 3100 */
+	u8 hi_nerr;	/* all but 3100 */
 	u16 sysbus_ferr;
 	u16 sysbus_nerr;
 	u8 buf_ferr;
@@ -215,6 +232,10 @@ static const struct e752x_dev_info e752x
 		.err_dev = PCI_DEVICE_ID_INTEL_7320_1_ERR,
 		.ctl_dev = PCI_DEVICE_ID_INTEL_7320_0,
 		.ctl_name = "E7320"},
+	[I3100] = {
+		.err_dev = PCI_DEVICE_ID_INTEL_3100_1_ERR,
+		.ctl_dev = PCI_DEVICE_ID_INTEL_3100_0,
+		.ctl_name = "3100"},
 };
 
 static unsigned long ctl_page_to_phys(struct mem_ctl_info *mci,
@@ -402,7 +423,7 @@ static inline void process_threshold_ce(
 static char *global_message[11] = {
 	"PCI Express C1", "PCI Express C", "PCI Express B1",
 	"PCI Express B", "PCI Express A1", "PCI Express A",
-	"DMA Controler", "HUB Interface", "System Bus",
+	"DMA Controler", "HUB or NS Interface", "System Bus",
 	"DRAM Controler", "Internal Buffer"
 };
 
@@ -455,6 +476,63 @@ static inline void hub_error(int fatal, 
 		do_hub_error(fatal, errors);
 }
 
+#define NSI_FATAL_MASK		0x0c080081
+#define NSI_NON_FATAL_MASK	0x23a0ba64
+#define NSI_ERR_MASK		(NSI_FATAL_MASK | NSI_NON_FATAL_MASK)
+
+static char *nsi_message[30] = {
+	"NSI Link Down",	/* NSI_FERR/NSI_NERR bit 0, fatal error */
+	"",						/* reserved */
+	"NSI Parity Error",				/* bit 2, non-fatal */
+	"",						/* reserved */
+	"",						/* reserved */
+	"Correctable Error Message",			/* bit 5, non-fatal */
+	"Non-Fatal Error Message",			/* bit 6, non-fatal */
+	"Fatal Error Message",				/* bit 7, fatal */
+	"",						/* reserved */
+	"Receiver Error",				/* bit 9, non-fatal */
+	"",						/* reserved */
+	"Bad TLP",					/* bit 11, non-fatal */
+	"Bad DLLP",					/* bit 12, non-fatal */
+	"REPLAY_NUM Rollover",				/* bit 13, non-fatal */
+	"",						/* reserved */
+	"Replay Timer Timeout",				/* bit 15, non-fatal */
+	"",						/* reserved */
+	"",						/* reserved */
+	"",						/* reserved */
+	"Data Link Protocol Error",			/* bit 19, fatal */
+	"",						/* reserved */
+	"Poisoned TLP",					/* bit 21, non-fatal */
+	"",						/* reserved */
+	"Completion Timeout",				/* bit 23, non-fatal */
+	"Completer Abort",				/* bit 24, non-fatal */
+	"Unexpected Completion",			/* bit 25, non-fatal */
+	"Receiver Overflow",				/* bit 26, fatal */
+	"Malformed TLP",				/* bit 27, fatal */
+	"",						/* reserved */
+	"Unsupported Request"				/* bit 29, non-fatal */
+};
+
+static void do_nsi_error(int fatal, u32 errors)
+{
+	int i;
+
+	for (i = 0; i < 30; i++) {
+		if (errors & (1 << i))
+			printk(KERN_WARNING "%sError %s\n",
+			       fatal_message[fatal], nsi_message[i]);
+	}
+}
+
+static inline void nsi_error(int fatal, u32 errors, int *error_found,
+		int handle_error)
+{
+	*error_found = 1;
+
+	if (handle_error)
+		do_nsi_error(fatal, errors);
+}
+
 static char *membuf_message[4] = {
 	"Internal PMWB to DRAM parity",
 	"Internal PMWB to System Bus Parity",
@@ -546,6 +624,31 @@ static void e752x_check_hub_interface(st
 	}
 }
 
+static void e752x_check_ns_interface(struct e752x_error_info *info,
+				int *error_found, int handle_error)
+{
+	u32 stat32;
+
+	stat32 = info->nsi_ferr;
+	if (stat32 & NSI_ERR_MASK) { /* Error, so process */
+		if (stat32 & NSI_FATAL_MASK)	/* check for fatal errors */
+			nsi_error(1, stat32 & NSI_FATAL_MASK, error_found,
+				  handle_error);
+		if (stat32 & NSI_NON_FATAL_MASK) /* check for non-fatal ones */
+			nsi_error(0, stat32 & NSI_NON_FATAL_MASK, error_found,
+				  handle_error);
+	}
+	stat32 = info->nsi_nerr;
+	if (stat32 & NSI_ERR_MASK) {
+		if (stat32 & NSI_FATAL_MASK)
+			nsi_error(1, stat32 & NSI_FATAL_MASK, error_found,
+				  handle_error);
+		if (stat32 & NSI_NON_FATAL_MASK)
+			nsi_error(0, stat32 & NSI_NON_FATAL_MASK, error_found,
+				  handle_error);
+	}
+}
+
 static void e752x_check_sysbus(struct e752x_error_info *info,
 			int *error_found, int handle_error)
 {
@@ -653,7 +756,15 @@ static void e752x_get_error_info(struct 
 	pci_read_config_dword(dev, E752X_FERR_GLOBAL, &info->ferr_global);
 
 	if (info->ferr_global) {
-		pci_read_config_byte(dev, E752X_HI_FERR, &info->hi_ferr);
+		if (pvt->dev_info->err_dev == PCI_DEVICE_ID_INTEL_3100_1_ERR) {
+			pci_read_config_dword(dev, I3100_NSI_FERR,
+					     &info->nsi_ferr);
+			info->hi_ferr = 0;
+		} else {
+			pci_read_config_byte(dev, E752X_HI_FERR,
+					     &info->hi_ferr);
+			info->nsi_ferr = 0;
+		}
 		pci_read_config_word(dev, E752X_SYSBUS_FERR,
 				&info->sysbus_ferr);
 		pci_read_config_byte(dev, E752X_BUF_FERR, &info->buf_ferr);
@@ -669,10 +780,15 @@ static void e752x_get_error_info(struct 
 		pci_read_config_dword(dev, E752X_DRAM_RETR_ADD,
 				&info->dram_retr_add);
 
+		/* ignore the reserved bits just in case */
 		if (info->hi_ferr & 0x7f)
 			pci_write_config_byte(dev, E752X_HI_FERR,
 					info->hi_ferr);
 
+		if (info->nsi_ferr & NSI_ERR_MASK)
+			pci_write_config_dword(dev, I3100_NSI_FERR,
+					info->nsi_ferr);
+
 		if (info->sysbus_ferr)
 			pci_write_config_word(dev, E752X_SYSBUS_FERR,
 					info->sysbus_ferr);
@@ -692,7 +808,15 @@ static void e752x_get_error_info(struct 
 	pci_read_config_dword(dev, E752X_NERR_GLOBAL, &info->nerr_global);
 
 	if (info->nerr_global) {
-		pci_read_config_byte(dev, E752X_HI_NERR, &info->hi_nerr);
+		if (pvt->dev_info->err_dev == PCI_DEVICE_ID_INTEL_3100_1_ERR) {
+			pci_read_config_dword(dev, I3100_NSI_NERR,
+					     &info->nsi_nerr);
+			info->hi_nerr = 0;
+		} else {
+			pci_read_config_byte(dev, E752X_HI_NERR,
+					     &info->hi_nerr);
+			info->nsi_nerr = 0;
+		}
 		pci_read_config_word(dev, E752X_SYSBUS_NERR,
 				&info->sysbus_nerr);
 		pci_read_config_byte(dev, E752X_BUF_NERR, &info->buf_nerr);
@@ -706,6 +830,10 @@ static void e752x_get_error_info(struct 
 			pci_write_config_byte(dev, E752X_HI_NERR,
 					info->hi_nerr);
 
+		if (info->nsi_nerr & NSI_ERR_MASK)
+			pci_write_config_dword(dev, I3100_NSI_NERR,
+					info->nsi_nerr);
+
 		if (info->sysbus_nerr)
 			pci_write_config_word(dev, E752X_SYSBUS_NERR,
 					info->sysbus_nerr);
@@ -750,6 +878,7 @@ static int e752x_process_error_info(stru
 		global_error(0, stat32, &error_found, handle_errors);
 
 	e752x_check_hub_interface(info, &error_found, handle_errors);
+	e752x_check_ns_interface(info, &error_found, handle_errors);
 	e752x_check_sysbus(info, &error_found, handle_errors);
 	e752x_check_membuf(info, &error_found, handle_errors);
 	e752x_check_dram(mci, info, &error_found, handle_errors);
@@ -926,8 +1055,13 @@ static void e752x_init_error_reporting_r
 
 	dev = pvt->dev_d0f1;
 	/* Turn off error disable & SMI in case the BIOS turned it on */
-	pci_write_config_byte(dev, E752X_HI_ERRMASK, 0x00);
-	pci_write_config_byte(dev, E752X_HI_SMICMD, 0x00);
+	if (pvt->dev_info->err_dev == PCI_DEVICE_ID_INTEL_3100_1_ERR) {
+		pci_write_config_dword(dev, I3100_NSI_EMASK, 0);
+		pci_write_config_dword(dev, I3100_NSI_SMICMD, 0);
+	} else {
+		pci_write_config_byte(dev, E752X_HI_ERRMASK, 0x00);
+		pci_write_config_byte(dev, E752X_HI_SMICMD, 0x00);
+	}
 	pci_write_config_word(dev, E752X_SYSBUS_ERRMASK, 0x00);
 	pci_write_config_word(dev, E752X_SYSBUS_SMICMD, 0x00);
 	pci_write_config_byte(dev, E752X_BUF_ERRMASK, 0x00);
@@ -985,8 +1119,9 @@ static int e752x_probe1(struct pci_dev *
 
 	debugf3("%s(): init mci\n", __func__);
 	mci->mtype_cap = MEM_FLAG_RDDR;
-	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_SECDED |
-		EDAC_FLAG_S4ECD4ED;
+	/* 3100 IMCH supports SECDEC only */
+	mci->edac_ctl_cap = (dev_idx == I3100) ? EDAC_FLAG_SECDED :
+		(EDAC_FLAG_NONE | EDAC_FLAG_SECDED | EDAC_FLAG_S4ECD4ED);
 	/* FIXME - what if different memory types are in different csrows? */
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = E752X_REVISION;
@@ -1018,7 +1153,10 @@ static int e752x_probe1(struct pci_dev *
 	e752x_init_csrows(mci, pdev, ddrcsr);
 	e752x_init_mem_map_table(pdev, pvt);
 
-	mci->edac_cap |= EDAC_FLAG_NONE;
+	if (dev_idx == I3100)
+		mci->edac_cap = EDAC_FLAG_SECDED; /* the only mode supported */
+	else
+		mci->edac_cap |= EDAC_FLAG_NONE;
 	debugf3("%s(): tolm, remapbase, remaplimit\n", __func__);
 
 	/* load the top of low memory, remap base, and remap limit vars */
@@ -1110,6 +1248,9 @@ static const struct pci_device_id e752x_
 	 PCI_VEND_DEV(INTEL, 7320_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 	 E7320},
 	{
+	 PCI_VEND_DEV(INTEL, 3100_0), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I3100},
+	{
 	 0,
 	 }			/* 0 terminated list. */
 };
@@ -1143,7 +1284,7 @@ module_exit(e752x_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Linux Networx (http://lnxi.com) Tom Zimmerman\n");
-MODULE_DESCRIPTION("MC support for Intel e752x memory controllers");
+MODULE_DESCRIPTION("MC support for Intel e752x/3100 memory controllers");
 
 module_param(force_function_unhide, int, 0444);
 MODULE_PARM_DESC(force_function_unhide, "if BIOS sets Dev0:Fun1 up as hidden:"
_

Patches currently in -mm which might be from akonovalov@ru.mvista.com are

origin.patch

