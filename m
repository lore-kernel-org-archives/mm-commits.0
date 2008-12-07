From: akpm@linux-foundation.org
Subject: + edac-driver-for-i5400-mch-seaburg.patch added to -mm tree
Date: Sat, 06 Dec 2008 22:27:59 -0800
Message-ID: <200812070627.mB76RxEH022834@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYLGG2R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 7 Dec 2008 01:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mchehab@redhat.com, norsk5@yahoo.com, woodard@redhat.com


The patch titled
     edac: driver for i5400 MCH (update)
has been added to the -mm tree.  Its filename is
     edac-driver-for-i5400-mch-seaburg.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: driver for i5400 MCH (update)
From: Mauro Carvalho Chehab <mchehab@redhat.com>

Signed-off-by: Ben Woodard <woodard@redhat.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <norsk5@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5400_edac.c |  119 ++++++++++++++++++------------------
 1 file changed, 62 insertions(+), 57 deletions(-)

diff -puN drivers/edac/i5400_edac.c~edac-driver-for-i5400-mch-seaburg drivers/edac/i5400_edac.c
--- a/drivers/edac/i5400_edac.c~edac-driver-for-i5400-mch-seaburg
+++ a/drivers/edac/i5400_edac.c
@@ -1,5 +1,5 @@
 /*
- * Intel 5400 class Memory Controllers kernel module
+ * Intel 5400 class Memory Controllers kernel module (Seaburg)
  *
  * This file may be distributed under the terms of the
  * GNU General Public License.
@@ -55,13 +55,11 @@
  * Function 1: Memory Branch Map, Control, Errors Register
  * Function 2: FSB Error Registers
  *
- * All 3 functions of Device 16 (0,1,2) share the SAME DID
+ * All 3 functions of Device 16 (0,1,2) share the SAME DID and
+ * uses PCI_DEVICE_ID_INTEL_5400_ERR for device 16 (0,1,2),
+ * PCI_DEVICE_ID_INTEL_5400_FBD0 and PCI_DEVICE_ID_INTEL_5400_FBD1
+ * for device 21 (0,1).
  */
-#ifndef PCI_DEVICE_ID_INTEL_5400_ERR
-#define PCI_DEVICE_ID_INTEL_5400_ERR  0x4030	/* Device 16 (0,1,2) */
-#define PCI_DEVICE_ID_INTEL_5400_FBD0 0x4035	/* Device 21 (0,1) */
-#define PCI_DEVICE_ID_INTEL_5400_FBD1 0x4036	/* Device 21 (0,1) */
-#endif
 
 	/* OFFSETS for Function 0 */
 #define		AMBASE			0x48 /* AMB Mem Mapped Reg Region Base */
@@ -174,17 +172,17 @@ enum error_mask {
 /*
  * Names to translate bit error into something useful
  */
-char *error_name[] = {
+static const char *error_name[] = {
 	[0]  = "Memory Write error on non-redundant retry",
 	[1]  = "Memory or FB-DIMM configuration CRC read error",
 	/* Reserved */
 	[3]  = "Uncorrectable Data ECC on Replay",
 	[4]  = "Aliased Uncorrectable Non-Mirrored Demand Data ECC",
-	/* Unsupported on i5400 */
+	/* M6 Unsupported on i5400 */
 	[6]  = "Aliased Uncorrectable Resilver- or Spare-Copy Data ECC",
 	[7]  = "Aliased Uncorrectable Patrol Data ECC",
 	[8]  = "Non-Aliased Uncorrectable Non-Mirrored Demand Data ECC",
-	/* Unsupported */
+	/* M10 Unsupported on i5400 */
 	[10] = "Non-Aliased Uncorrectable Resilver- or Spare-Copy Data ECC",
 	[11] = "Non-Aliased Uncorrectable Patrol Data ECC",
 	[12] = "Memory Write error on first attempt",
@@ -192,7 +190,7 @@ char *error_name[] = {
 	[14] = "Memory or FB-DIMM configuration CRC read error",
 	[15] = "Channel Failed-Over Occurred",
 	[16] = "Correctable Non-Mirrored Demand Data ECC",
-	/* Unsupported */
+	/* M18 Unsupported on i5400 */
 	[18] = "Correctable Resilver- or Spare-Copy Data ECC",
 	[19] = "Correctable Patrol Data ECC",
 	[20] = "FB-DIMM Northbound parity error on FB-DIMM Sync Status",
@@ -259,24 +257,32 @@ char *error_name[] = {
 #define FERR_FAT_MASK ERROR_FAT_MASK
 
 /* masks for non-fatal error register */
-#define TO_NF_MASK(a)		(((a) & EMASK_M29) | ((a) >> 3))
-#define FROM_NF_FERR(a)		(((a) & EMASK_M29) | (((a) << 3) & ((1 << 30)-1)))
+static inline int to_nf_mask(unsigned int mask)
+{
+	return (mask & EMASK_M29) | (mask >> 3);
+};
+
+static inline int from_nf_ferr(unsigned int mask)
+{
+	return (mask & EMASK_M29) |		/* Bit 28 */
+	       (mask & ((1 << 28) - 1) << 3);	/* Bits 0 to 27 */
+};
 
-#define FERR_NF_MASK		TO_NF_MASK(ERROR_NF_MASK)
-#define FERR_NF_CORRECTABLE	TO_NF_MASK(ERROR_NF_CORRECTABLE)
-#define FERR_NF_DIMM_SPARE	TO_NF_MASK(ERROR_NF_DIMM_SPARE)
-#define FERR_NF_SPD_PROTOCOL	TO_NF_MASK(ERROR_NF_SPD_PROTOCOL)
-#define FERR_NF_NORTH_CRC	TO_NF_MASK(ERROR_NF_NORTH_CRC)
-#define FERR_NF_RECOVERABLE	TO_NF_MASK(ERROR_NF_RECOVERABLE)
-#define FERR_NF_UNCORRECTABLE	TO_NF_MASK(ERROR_NF_UNCORRECTABLE)
+#define FERR_NF_MASK		to_nf_mask(ERROR_NF_MASK)
+#define FERR_NF_CORRECTABLE	to_nf_mask(ERROR_NF_CORRECTABLE)
+#define FERR_NF_DIMM_SPARE	to_nf_mask(ERROR_NF_DIMM_SPARE)
+#define FERR_NF_SPD_PROTOCOL	to_nf_mask(ERROR_NF_SPD_PROTOCOL)
+#define FERR_NF_NORTH_CRC	to_nf_mask(ERROR_NF_NORTH_CRC)
+#define FERR_NF_RECOVERABLE	to_nf_mask(ERROR_NF_RECOVERABLE)
+#define FERR_NF_UNCORRECTABLE	to_nf_mask(ERROR_NF_UNCORRECTABLE)
 
 /* Defines to extract the vaious fields from the
  *	MTRx - Memory Technology Registers
  */
 #define MTR_DIMMS_PRESENT(mtr)		((mtr) & (1 << 10))
 #define MTR_DIMMS_ETHROTTLE(mtr)	((mtr) & (1 << 9))
-#define MTR_DRAM_WIDTH(mtr)		(((mtr) & (1<< 8)) ? 8 : 4)
-#define MTR_DRAM_BANKS(mtr)		(((mtr) & (1<< 6)) ? 8 : 4)
+#define MTR_DRAM_WIDTH(mtr)		(((mtr) & (1 << 8)) ? 8 : 4)
+#define MTR_DRAM_BANKS(mtr)		(((mtr) & (1 << 6)) ? 8 : 4)
 #define MTR_DRAM_BANKS_ADDR_BITS(mtr)	((MTR_DRAM_BANKS(mtr) == 8) ? 3 : 2)
 #define MTR_DIMM_RANK(mtr)		(((mtr) >> 5) & 0x1)
 #define MTR_DIMM_RANK_ADDR_BITS(mtr)	(MTR_DIMM_RANK(mtr) ? 2 : 1)
@@ -293,7 +299,7 @@ static inline int extract_fbdchan_indx(u
 
 #ifdef CONFIG_EDAC_DEBUG
 /* MTR NUMROW */
-static char *numrow_toString[] = {
+static const char *numrow_toString[] = {
 	"8,192 - 13 rows",
 	"16,384 - 14 rows",
 	"32,768 - 15 rows",
@@ -301,7 +307,7 @@ static char *numrow_toString[] = {
 };
 
 /* MTR NUMCOL */
-static char *numcol_toString[] = {
+static const char *numcol_toString[] = {
 	"1,024 - 10 columns",
 	"2,048 - 11 columns",
 	"4,096 - 12 columns",
@@ -341,11 +347,11 @@ struct i5400_pvt {
 
 	u16 mir0, mir1;
 
-	u16 b0_mtr[NUM_MTRS_PER_BRANCH];			/* Memory Technlogy Reg */
+	u16 b0_mtr[NUM_MTRS_PER_BRANCH];	/* Memory Technlogy Reg */
 	u16 b0_ambpresent0;			/* Branch 0, Channel 0 */
 	u16 b0_ambpresent1;			/* Brnach 0, Channel 1 */
 
-	u16 b1_mtr[NUM_MTRS_PER_BRANCH];			/* Memory Technlogy Reg */
+	u16 b1_mtr[NUM_MTRS_PER_BRANCH];	/* Memory Technlogy Reg */
 	u16 b1_ambpresent0;			/* Branch 1, Channel 8 */
 	u16 b1_ambpresent1;			/* Branch 1, Channel 1 */
 
@@ -370,7 +376,7 @@ struct i5400_error_info {
 	u16 recmema;		/* Recoverable Mem Error log A */
 	u32 recmemb;		/* Recoverable Mem Error log B */
 
-	/* These registers are input ONLY if there was a Non-Recoverable Error */
+	/* These registers are input ONLY if there was a Non-Rec Error */
 	u16 nrecmema;		/* Non-Recoverable Mem log A */
 	u16 nrecmemb;		/* Non-Recoverable Mem log B */
 
@@ -560,10 +566,10 @@ static void i5400_proccess_non_recoverab
 
 	/* Form out message */
 	snprintf(msg, sizeof(msg),
-		 "%s (Branch=%d DRAM-Bank=%d Buffer ID = %d RDWR=%s RAS=%d CAS=%d "
-		 "%s Err=0x%lx (%s))",
-		 type, branch >> 1, bank, buf_id, rdwr_str(rdwr), ras, cas, type,
-		 allErrors, error_name[errnum]);
+		 "%s (Branch=%d DRAM-Bank=%d Buffer ID = %d RDWR=%s "
+		 "RAS=%d CAS=%d %s Err=0x%lx (%s))",
+		 type, branch >> 1, bank, buf_id, rdwr_str(rdwr), ras, cas,
+		 type, allErrors, error_name[errnum]);
 
 	/* Call the helper to output message */
 	edac_mc_handle_fbd_ue(mci, rank, channel, channel + 1, msg);
@@ -590,7 +596,7 @@ static void i5400_process_nonfatal_error
 	int errnum;
 
 	/* mask off the Error bits that are possible */
-	allErrors = FROM_NF_FERR(info->ferr_nf_fbd & FERR_NF_MASK);
+	allErrors = from_nf_ferr(info->ferr_nf_fbd & FERR_NF_MASK);
 	if (!allErrors)
 		return;		/* if no error, return now */
 
@@ -631,10 +637,10 @@ static void i5400_process_nonfatal_error
 
 		/* Form out message */
 		snprintf(msg, sizeof(msg),
-			 "Corrected error (Branch=%d DRAM-Bank=%d RDWR=%s RAS=%d "
-			 "CAS=%d, CE Err=0x%lx (%s))", branch >> 1, bank,
-			 rdwr_str(rdwr), ras, cas, allErrors,
-			error_name[errnum]);
+			 "Corrected error (Branch=%d DRAM-Bank=%d RDWR=%s "
+			 "RAS=%d CAS=%d, CE Err=0x%lx (%s))",
+			 branch >> 1, bank, rdwr_str(rdwr), ras, cas,
+			 allErrors, error_name[errnum]);
 
 		/* Call the helper to output message */
 		edac_mc_handle_fbd_ce(mci, rank, channel, msg);
@@ -704,17 +710,10 @@ static void i5400_put_devices(struct mem
 	pvt = mci->pvt_info;
 
 	/* Decrement usage count for devices */
-	if (pvt->branch_1)
-		pci_dev_put(pvt->branch_1);
-
-	if (pvt->branch_0)
-		pci_dev_put(pvt->branch_0);
-
-	if (pvt->fsb_error_regs)
-		pci_dev_put(pvt->fsb_error_regs);
-
-	if (pvt->branchmap_werrors)
-		pci_dev_put(pvt->branchmap_werrors);
+	pci_dev_put(pvt->branch_1);
+	pci_dev_put(pvt->branch_0);
+	pci_dev_put(pvt->fsb_error_regs);
+	pci_dev_put(pvt->branchmap_werrors);
 }
 
 /*
@@ -810,9 +809,9 @@ error:
 /*
  *	determine_amb_present
  *
- *		the information is contained in NUM_MTRS_PER_BRANCH different registers
- *		determining which of the NUM_MTRS_PER_BRANCH requires knowing
- *		which channel is in question
+ *		the information is contained in NUM_MTRS_PER_BRANCH different
+ *		registers determining which of the NUM_MTRS_PER_BRANCH requires
+ *              knowing which channel is in question
  *
  *	2 branches, each with 2 channels
  *		b0_ambpresent0 for channel '0'
@@ -842,7 +841,7 @@ static int determine_amb_present_reg(str
 /*
  * determine_mtr(pvt, csrow, channel)
  *
- *	return the proper MTR register as determine by the csrow and channel desired
+ * return the proper MTR register as determine by the csrow and desired channel
  */
 static int determine_mtr(struct i5400_pvt *pvt, int csrow, int channel)
 {
@@ -857,7 +856,8 @@ static int determine_mtr(struct i5400_pv
 	n = csrow >> 3;
 
 	if (n >= NUM_MTRS_PER_BRANCH) {
-		debugf0("ERROR: trying to access an invalid csrow: %d\n", csrow);
+		debugf0("ERROR: trying to access an invalid csrow: %d\n",
+			csrow);
 		return 0;
 	}
 
@@ -885,7 +885,7 @@ static void decode_mtr(int slot_row, u16
 	debugf2("\t\tWIDTH: x%d\n", MTR_DRAM_WIDTH(mtr));
 
 	debugf2("\t\tELECTRICAL THROTTLING is %s\n",
-		MTR_DIMMS_ETHROTTLE(mtr) ? "enabled": "disabled");
+		MTR_DIMMS_ETHROTTLE(mtr) ? "enabled" : "disabled");
 
 	debugf2("\t\tNUMBANK: %d bank(s)\n", MTR_DRAM_BANKS(mtr));
 	debugf2("\t\tNUMRANK: %s\n", MTR_DIMM_RANK(mtr) ? "double" : "single");
@@ -1251,6 +1251,9 @@ static int i5400_probe1(struct pci_dev *
 	int num_dimms_per_channel;
 	int num_csrows;
 
+	if (dev_idx >= ARRAY_SIZE(i5400_devs))
+		return -EINVAL;
+
 	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
 		__func__,
 		pdev->bus->number,
@@ -1425,7 +1428,7 @@ MODULE_DEVICE_TABLE(pci, i5400_pci_tbl);
  *
  */
 static struct pci_driver i5400_driver = {
-	.name = KBUILD_BASENAME,
+	.name = "i5400_edac",
 	.probe = i5400_init_one,
 	.remove = __devexit_p(i5400_remove_one),
 	.id_table = i5400_pci_tbl,
@@ -1463,9 +1466,11 @@ module_init(i5400_init);
 module_exit(i5400_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Ben Woodard <woodard@redhat.com> Red Hat Inc. (http://www.redhat.com)");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com> Red Hat Inc. (http://www.redhat.com)");
-MODULE_DESCRIPTION("MC Driver for Intel I5400 memory controllers - " I5400_REVISION);
+MODULE_AUTHOR("Ben Woodard <woodard@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
+MODULE_DESCRIPTION("MC Driver for Intel I5400 memory controllers - "
+		   I5400_REVISION);
 
 module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
_

Patches currently in -mm which might be from mchehab@redhat.com are

linux-next.patch
edac-driver-for-i5400-mch.patch
edac-driver-for-i5400-mch-seaburg.patch

