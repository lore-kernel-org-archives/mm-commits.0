From: akpm@linux-foundation.org
Subject: + edac-i5100-cleanup.patch added to -mm tree
Date: Tue, 01 Jul 2008 20:36:17 -0700
Message-ID: <200807020336.m623aHtQ029461@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754566AbYGBDgm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jul 2008 23:36:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ajones@riverbed.com, dougthompson@xmission.com


The patch titled
     edac: i5100: cleanup
has been added to the -mm tree.  Its filename is
     edac-i5100-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100: cleanup
From: Arthur Jones <ajones@riverbed.com>

Some code cleanliness issues found by Andrew Morton (thanks!) which should
not affect functionality, but which should help make the code more
maintainable.

In particular, we now:

* convert all #define's w/ a parameter to static inlines
* use 1UL rather than 1ULL when calculating an unsigned long
* use pci_disable_device

The resulting code is tested and seems to work fine...

Signed-off-by: Arthur Jones <ajones@riverbed.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |  363 +++++++++++++++++++++++++-----------
 1 file changed, 261 insertions(+), 102 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-cleanup drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-cleanup
+++ a/drivers/edac/i5100_edac.c
@@ -21,36 +21,19 @@
 
 #include "edac_core.h"
 
-/* register addresses and bit field accessors... */
+/* register addresses */
 
 /* device 16, func 1 */
 #define I5100_MC		0x40	/* Memory Control Register */
-#define		I5100_MC_ERRDETEN(a)	((a) >> 5 & 1)
 #define I5100_MS		0x44	/* Memory Status Register */
 #define I5100_SPDDATA		0x48	/* Serial Presence Detect Status Reg */
-#define		I5100_SPDDATA_RDO(a)	((a) >> 15 & 1)
-#define		I5100_SPDDATA_SBE(a)	((a) >> 13 & 1)
-#define		I5100_SPDDATA_BUSY(a)	((a) >> 12 & 1)
-#define		I5100_SPDDATA_DATA(a)	((a)       & ((1 << 8) - 1))
 #define I5100_SPDCMD		0x4c	/* Serial Presence Detect Command Reg */
-#define		I5100_SPDCMD_DTI(a)	(((a) & ((1 << 4) - 1)) << 28)
-#define		I5100_SPDCMD_CKOVRD(a)	(((a) & 1)              << 27)
-#define		I5100_SPDCMD_SA(a)	(((a) & ((1 << 3) - 1)) << 24)
-#define		I5100_SPDCMD_BA(a)	(((a) & ((1 << 8) - 1)) << 16)
-#define		I5100_SPDCMD_DATA(a)	(((a) & ((1 << 8) - 1)) <<  8)
-#define		I5100_SPDCMD_CMD(a)	((a) & 1)
 #define I5100_TOLM		0x6c	/* Top of Low Memory */
-#define		I5100_TOLM_TOLM(a)	((a) >> 12 & ((1 << 4) - 1))
 #define I5100_MIR0		0x80	/* Memory Interleave Range 0 */
 #define I5100_MIR1		0x84	/* Memory Interleave Range 1 */
 #define I5100_AMIR_0		0x8c	/* Adjusted Memory Interleave Range 0 */
 #define I5100_AMIR_1		0x90	/* Adjusted Memory Interleave Range 1 */
-#define		I5100_MIR_LIMIT(a)	((a) >> 4 & ((1 << 12) - 1))
-#define		I5100_MIR_WAY1(a)	((a) >> 1 & 1)
-#define		I5100_MIR_WAY0(a)	((a)      & 1)
 #define I5100_FERR_NF_MEM	0xa0	/* MC First Non Fatal Errors */
-#define		I5100_FERR_NF_MEM_CHAN_INDX(a)	((a) >> 28 & 1)
-#define		I5100_FERR_NF_MEM_SPD_MASK	(1 << 18)
 #define		I5100_FERR_NF_MEM_M16ERR_MASK	(1 << 16)
 #define		I5100_FERR_NF_MEM_M15ERR_MASK	(1 << 15)
 #define		I5100_FERR_NF_MEM_M14ERR_MASK	(1 << 14)
@@ -72,47 +55,214 @@
 			I5100_FERR_NF_MEM_M5ERR_MASK | \
 			I5100_FERR_NF_MEM_M4ERR_MASK | \
 			I5100_FERR_NF_MEM_M1ERR_MASK)
-#define		I5100_FERR_NF_MEM_ANY(a)  ((a) & I5100_FERR_NF_MEM_ANY_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
-#define		I5100_NERR_NF_MEM_ANY(a)  I5100_FERR_NF_MEM_ANY(a)
 #define I5100_EMASK_MEM		0xa8	/* MC Error Mask Register */
 
 /* device 21 and 22, func 0 */
 #define I5100_MTR_0	0x154	/* Memory Technology Registers 0-3 */
 #define I5100_DMIR	0x15c	/* DIMM Interleave Range */
-#define		I5100_DMIR_LIMIT(a)	((a) >> 16 & ((1 << 11) - 1))
-#define		I5100_DMIR_RANK(a, i)	((a) >> (4 * i) & ((1 <<  2) - 1))
-#define I5100_MTR_4	0x1b0	/* Memory Technology Registers 4,5 */
-#define		I5100_MTR_PRESENT(a)	((a) >> 10 & 1)
-#define		I5100_MTR_ETHROTTLE(a)	((a) >>  9 & 1)
-#define		I5100_MTR_WIDTH(a)	((a) >>  8 & 1)
-#define		I5100_MTR_NUMBANK(a)	((a) >>  6 & 1)
-#define		I5100_MTR_NUMROW(a)	((a) >>  2 & ((1 << 2) - 1))
-#define		I5100_MTR_NUMCOL(a)	((a)       & ((1 << 2) - 1))
 #define	I5100_VALIDLOG	0x18c	/* Valid Log Markers */
-#define		I5100_VALIDLOG_REDMEMVALID(a)	((a) >> 2 & 1)
-#define		I5100_VALIDLOG_RECMEMVALID(a)	((a) >> 1 & 1)
-#define		I5100_VALIDLOG_NRECMEMVALID(a)	((a)      & 1)
 #define	I5100_NRECMEMA	0x190	/* Non-Recoverable Memory Error Log Reg A */
-#define		I5100_NRECMEMA_MERR(a)		((a) >> 15 & ((1 << 5) - 1))
-#define		I5100_NRECMEMA_BANK(a)		((a) >> 12 & ((1 << 3) - 1))
-#define		I5100_NRECMEMA_RANK(a)		((a) >>  8 & ((1 << 3) - 1))
-#define		I5100_NRECMEMA_DM_BUF_ID(a)	((a)       & ((1 << 8) - 1))
 #define	I5100_NRECMEMB	0x194	/* Non-Recoverable Memory Error Log Reg B */
-#define		I5100_NRECMEMB_CAS(a)		((a) >> 16 & ((1 << 13) - 1))
-#define		I5100_NRECMEMB_RAS(a)		((a)       & ((1 << 16) - 1))
 #define	I5100_REDMEMA	0x198	/* Recoverable Memory Data Error Log Reg A */
-#define		I5100_REDMEMA_SYNDROME(a)	(a)
 #define	I5100_REDMEMB	0x19c	/* Recoverable Memory Data Error Log Reg B */
-#define		I5100_REDMEMB_ECC_LOCATOR(a)	((a) & ((1 << 18) - 1))
 #define	I5100_RECMEMA	0x1a0	/* Recoverable Memory Error Log Reg A */
-#define		I5100_RECMEMA_MERR(a)		I5100_NRECMEMA_MERR(a)
-#define		I5100_RECMEMA_BANK(a)		I5100_NRECMEMA_BANK(a)
-#define		I5100_RECMEMA_RANK(a)		I5100_NRECMEMA_RANK(a)
-#define		I5100_RECMEMA_DM_BUF_ID(a)	I5100_NRECMEMA_DM_BUF_ID(a)
 #define	I5100_RECMEMB	0x1a4	/* Recoverable Memory Error Log Reg B */
-#define		I5100_RECMEMB_CAS(a)		I5100_NRECMEMB_CAS(a)
-#define		I5100_RECMEMB_RAS(a)		I5100_NRECMEMB_RAS(a)
+#define I5100_MTR_4	0x1b0	/* Memory Technology Registers 4,5 */
+
+/* bit field accessors */
+
+static inline u32 i5100_mc_errdeten(u32 mc)
+{
+	return mc >> 5 & 1;
+}
+
+static inline u16 i5100_spddata_rdo(u16 a)
+{
+	return a >> 15 & 1;
+}
+
+static inline u16 i5100_spddata_sbe(u16 a)
+{
+	return a >> 13 & 1;
+}
+
+static inline u16 i5100_spddata_busy(u16 a)
+{
+	return a >> 12 & 1;
+}
+
+static inline u16 i5100_spddata_data(u16 a)
+{
+	return a & ((1 << 8) - 1);
+}
+
+static inline u32 i5100_spdcmd_create(u32 dti, u32 ckovrd, u32 sa, u32 ba,
+				      u32 data, u32 cmd)
+{
+	return	((dti & ((1 << 4) - 1))  << 28) |
+		((ckovrd & 1)            << 27) |
+		((sa & ((1 << 3) - 1))   << 24) |
+		((ba & ((1 << 8) - 1))   << 16) |
+		((data & ((1 << 8) - 1)) <<  8) |
+		(cmd & 1);
+}
+
+static inline u16 i5100_tolm_tolm(u16 a)
+{
+	return a >> 12 & ((1 << 4) - 1);
+}
+
+static inline u16 i5100_mir_limit(u16 a)
+{
+	return a >> 4 & ((1 << 12) - 1);
+}
+
+static inline u16 i5100_mir_way1(u16 a)
+{
+	return a >> 1 & 1;
+}
+
+static inline u16 i5100_mir_way0(u16 a)
+{
+	return a & 1;
+}
+
+static inline u32 i5100_ferr_nf_mem_chan_indx(u32 a)
+{
+	return a >> 28 & 1;
+}
+
+static inline u32 i5100_ferr_nf_mem_any(u32 a)
+{
+	return a & I5100_FERR_NF_MEM_ANY_MASK;
+}
+
+static inline u32 i5100_nerr_nf_mem_any(u32 a)
+{
+	return i5100_ferr_nf_mem_any(a);
+}
+
+static inline u32 i5100_dmir_limit(u32 a)
+{
+	return a >> 16 & ((1 << 11) - 1);
+}
+
+static inline u32 i5100_dmir_rank(u32 a, u32 i)
+{
+	return a >> (4 * i) & ((1 << 2) - 1);
+}
+
+static inline u16 i5100_mtr_present(u16 a)
+{
+	return a >> 10 & 1;
+}
+
+static inline u16 i5100_mtr_ethrottle(u16 a)
+{
+	return a >> 9 & 1;
+}
+
+static inline u16 i5100_mtr_width(u16 a)
+{
+	return a >> 8 & 1;
+}
+
+static inline u16 i5100_mtr_numbank(u16 a)
+{
+	return a >> 6 & 1;
+}
+
+static inline u16 i5100_mtr_numrow(u16 a)
+{
+	return a >> 2 & ((1 << 2) - 1);
+}
+
+static inline u16 i5100_mtr_numcol(u16 a)
+{
+	return a & ((1 << 2) - 1);
+}
+
+
+static inline u32 i5100_validlog_redmemvalid(u32 a)
+{
+	return a >> 2 & 1;
+}
+
+static inline u32 i5100_validlog_recmemvalid(u32 a)
+{
+	return a >> 1 & 1;
+}
+
+static inline u32 i5100_validlog_nrecmemvalid(u32 a)
+{
+	return a & 1;
+}
+
+static inline u32 i5100_nrecmema_merr(u32 a)
+{
+	return a >> 15 & ((1 << 5) - 1);
+}
+
+static inline u32 i5100_nrecmema_bank(u32 a)
+{
+	return a >> 12 & ((1 << 3) - 1);
+}
+
+static inline u32 i5100_nrecmema_rank(u32 a)
+{
+	return a >>  8 & ((1 << 3) - 1);
+}
+
+static inline u32 i5100_nrecmema_dm_buf_id(u32 a)
+{
+	return a & ((1 << 8) - 1);
+}
+
+static inline u32 i5100_nrecmemb_cas(u32 a)
+{
+	return a >> 16 & ((1 << 13) - 1);
+}
+
+static inline u32 i5100_nrecmemb_ras(u32 a)
+{
+	return a & ((1 << 16) - 1);
+}
+
+static inline u32 i5100_redmemb_ecc_locator(u32 a)
+{
+	return a & ((1 << 18) - 1);
+}
+
+static inline u32 i5100_recmema_merr(u32 a)
+{
+	return i5100_nrecmema_merr(a);
+}
+
+static inline u32 i5100_recmema_bank(u32 a)
+{
+	return i5100_nrecmema_bank(a);
+}
+
+static inline u32 i5100_recmema_rank(u32 a)
+{
+	return i5100_nrecmema_rank(a);
+}
+
+static inline u32 i5100_recmema_dm_buf_id(u32 a)
+{
+	return i5100_nrecmema_dm_buf_id(a);
+}
+
+static inline u32 i5100_recmemb_cas(a)
+{
+	return i5100_nrecmemb_cas(a);
+}
+
+static inline u32 i5100_recmemb_ras(a)
+{
+	return i5100_nrecmemb_ras(a);
+}
 
 /* some generic limits */
 #define I5100_MAX_RANKS_PER_CTLR	6
@@ -219,12 +369,12 @@ static unsigned long i5100_ctl_page_to_p
 	if (cntlr_addr < priv->tolm)
 		return cntlr_addr;
 
-	return (1ULL << 32) + (cntlr_addr - priv->tolm);
+	return (1UL << 32) + (cntlr_addr - priv->tolm);
 }
 
 static const char *i5100_err_msg(unsigned err)
 {
-	const char *merrs[] = {
+	static const char *merrs[] = {
 		"unknown", /* 0 */
 		"uncorrectable data ECC on replay", /* 1 */
 		"unknown", /* 2 */
@@ -341,24 +491,24 @@ static void i5100_read_log(struct mem_ct
 
 	pci_read_config_dword(pdev, I5100_VALIDLOG, &dw);
 
-	if (I5100_VALIDLOG_REDMEMVALID(dw)) {
+	if (i5100_validlog_redmemvalid(dw)) {
 		pci_read_config_dword(pdev, I5100_REDMEMA, &dw2);
-		syndrome = I5100_REDMEMA_SYNDROME(dw2);
+		syndrome = dw2;
 		pci_read_config_dword(pdev, I5100_REDMEMB, &dw2);
-		ecc_loc = I5100_REDMEMB_ECC_LOCATOR(dw2);
+		ecc_loc = i5100_redmemb_ecc_locator(dw2);
 	}
 
-	if (I5100_VALIDLOG_RECMEMVALID(dw)) {
+	if (i5100_validlog_recmemvalid(dw)) {
 		const char *msg;
 
 		pci_read_config_dword(pdev, I5100_RECMEMA, &dw2);
-		merr = I5100_RECMEMA_MERR(dw2);
-		bank = I5100_RECMEMA_BANK(dw2);
-		rank = I5100_RECMEMA_RANK(dw2);
+		merr = i5100_recmema_merr(dw2);
+		bank = i5100_recmema_bank(dw2);
+		rank = i5100_recmema_rank(dw2);
 
 		pci_read_config_dword(pdev, I5100_RECMEMB, &dw2);
-		cas = I5100_RECMEMB_CAS(dw2);
-		ras = I5100_RECMEMB_RAS(dw2);
+		cas = i5100_recmemb_cas(dw2);
+		ras = i5100_recmemb_ras(dw2);
 
 		/* FIXME:  not really sure if this is what merr is...
 		 */
@@ -370,17 +520,17 @@ static void i5100_read_log(struct mem_ct
 		i5100_handle_ce(mci, ctlr, bank, rank, syndrome, cas, ras, msg);
 	}
 
-	if (I5100_VALIDLOG_NRECMEMVALID(dw)) {
+	if (i5100_validlog_nrecmemvalid(dw)) {
 		const char *msg;
 
 		pci_read_config_dword(pdev, I5100_NRECMEMA, &dw2);
-		merr = I5100_NRECMEMA_MERR(dw2);
-		bank = I5100_NRECMEMA_BANK(dw2);
-		rank = I5100_NRECMEMA_RANK(dw2);
+		merr = i5100_nrecmema_merr(dw2);
+		bank = i5100_nrecmema_bank(dw2);
+		rank = i5100_nrecmema_rank(dw2);
 
 		pci_read_config_dword(pdev, I5100_NRECMEMB, &dw2);
-		cas = I5100_NRECMEMB_CAS(dw2);
-		ras = I5100_NRECMEMB_RAS(dw2);
+		cas = i5100_nrecmemb_cas(dw2);
+		ras = i5100_nrecmemb_ras(dw2);
 
 		/* FIXME:  not really sure if this is what merr is...
 		 */
@@ -402,7 +552,7 @@ static void i5100_check_error(struct mem
 
 
 	pci_read_config_dword(priv->mc, I5100_FERR_NF_MEM, &dw);
-	if (I5100_FERR_NF_MEM_ANY(dw)) {
+	if (i5100_ferr_nf_mem_any(dw)) {
 		u32 dw2;
 
 		pci_read_config_dword(priv->mc, I5100_NERR_NF_MEM, &dw2);
@@ -411,9 +561,9 @@ static void i5100_check_error(struct mem
 					       dw2);
 		pci_write_config_dword(priv->mc, I5100_FERR_NF_MEM, dw);
 
-		i5100_read_log(mci, I5100_FERR_NF_MEM_CHAN_INDX(dw),
-			       I5100_FERR_NF_MEM_ANY(dw),
-			       I5100_NERR_NF_MEM_ANY(dw2));
+		i5100_read_log(mci, i5100_ferr_nf_mem_chan_indx(dw),
+			       i5100_ferr_nf_mem_any(dw),
+			       i5100_nerr_nf_mem_any(dw2));
 	}
 }
 
@@ -476,12 +626,12 @@ static void __devinit i5100_init_mtr(str
 
 			pci_read_config_word(pdev, addr, &w);
 
-			priv->mtr[i][j].present = I5100_MTR_PRESENT(w);
-			priv->mtr[i][j].ethrottle = I5100_MTR_ETHROTTLE(w);
-			priv->mtr[i][j].width = 4 + 4 * I5100_MTR_WIDTH(w);
-			priv->mtr[i][j].numbank = 2 + I5100_MTR_NUMBANK(w);
-			priv->mtr[i][j].numrow = 13 + I5100_MTR_NUMROW(w);
-			priv->mtr[i][j].numcol = 10 + I5100_MTR_NUMCOL(w);
+			priv->mtr[i][j].present = i5100_mtr_present(w);
+			priv->mtr[i][j].ethrottle = i5100_mtr_ethrottle(w);
+			priv->mtr[i][j].width = 4 + 4 * i5100_mtr_width(w);
+			priv->mtr[i][j].numbank = 2 + i5100_mtr_numbank(w);
+			priv->mtr[i][j].numrow = 13 + i5100_mtr_numrow(w);
+			priv->mtr[i][j].numcol = 10 + i5100_mtr_numcol(w);
 		}
 	}
 }
@@ -495,35 +645,30 @@ static int i5100_read_spd_byte(const str
 {
 	struct i5100_priv *priv = mci->pvt_info;
 	u16 w;
-	u32 dw;
 	unsigned long et;
 
 	pci_read_config_word(priv->mc, I5100_SPDDATA, &w);
-	if (I5100_SPDDATA_BUSY(w))
+	if (i5100_spddata_busy(w))
 		return -1;
 
-	dw =	I5100_SPDCMD_DTI(0xa) |
-		I5100_SPDCMD_CKOVRD(1) |
-		I5100_SPDCMD_SA(ch * 4 + slot) |
-		I5100_SPDCMD_BA(addr) |
-		I5100_SPDCMD_DATA(0) |
-		I5100_SPDCMD_CMD(0);
-	pci_write_config_dword(priv->mc, I5100_SPDCMD, dw);
+	pci_write_config_dword(priv->mc, I5100_SPDCMD,
+			       i5100_spdcmd_create(0xa, 1, ch * 4 + slot, addr,
+						   0, 0));
 
 	/* wait up to 100ms */
 	et = jiffies + HZ / 10;
 	udelay(100);
 	while (1) {
 		pci_read_config_word(priv->mc, I5100_SPDDATA, &w);
-		if (!I5100_SPDDATA_BUSY(w))
+		if (!i5100_spddata_busy(w))
 			break;
 		udelay(100);
 	}
 
-	if (!I5100_SPDDATA_RDO(w) || I5100_SPDDATA_SBE(w))
+	if (!i5100_spddata_rdo(w) || i5100_spddata_sbe(w))
 		return -1;
 
-	*byte = I5100_SPDDATA_DATA(w);
+	*byte = i5100_spddata_data(w);
 
 	return 0;
 }
@@ -591,17 +736,17 @@ static void __devinit i5100_init_interle
 	int i;
 
 	pci_read_config_word(pdev, I5100_TOLM, &w);
-	priv->tolm = (u64) I5100_TOLM_TOLM(w) * 256 * 1024 * 1024;
+	priv->tolm = (u64) i5100_tolm_tolm(w) * 256 * 1024 * 1024;
 
 	pci_read_config_word(pdev, I5100_MIR0, &w);
-	priv->mir[0].limit = (u64) I5100_MIR_LIMIT(w) << 28;
-	priv->mir[0].way[1] = I5100_MIR_WAY1(w);
-	priv->mir[0].way[0] = I5100_MIR_WAY0(w);
+	priv->mir[0].limit = (u64) i5100_mir_limit(w) << 28;
+	priv->mir[0].way[1] = i5100_mir_way1(w);
+	priv->mir[0].way[0] = i5100_mir_way0(w);
 
 	pci_read_config_word(pdev, I5100_MIR1, &w);
-	priv->mir[1].limit = (u64) I5100_MIR_LIMIT(w) << 28;
-	priv->mir[1].way[1] = I5100_MIR_WAY1(w);
-	priv->mir[1].way[0] = I5100_MIR_WAY0(w);
+	priv->mir[1].limit = (u64) i5100_mir_limit(w) << 28;
+	priv->mir[1].way[1] = i5100_mir_way1(w);
+	priv->mir[1].way[0] = i5100_mir_way0(w);
 
 	pci_read_config_word(pdev, I5100_AMIR_0, &w);
 	priv->amir[0] = w;
@@ -617,10 +762,10 @@ static void __devinit i5100_init_interle
 			pci_read_config_dword(mms[i], I5100_DMIR + j * 4, &dw);
 
 			priv->dmir[i][j].limit =
-				(u64) I5100_DMIR_LIMIT(dw) << 28;
+				(u64) i5100_dmir_limit(dw) << 28;
 			for (k = 0; k < I5100_MAX_RANKS_PER_DIMM; k++)
 				priv->dmir[i][j].rank[k] =
-					I5100_DMIR_RANK(dw, k);
+					i5100_dmir_rank(dw, k);
 		}
 	}
 
@@ -693,10 +838,10 @@ static int __devinit i5100_init_one(stru
 
 	/* ECC enabled? */
 	pci_read_config_dword(pdev, I5100_MC, &dw);
-	if (!I5100_MC_ERRDETEN(dw)) {
+	if (!i5100_mc_errdeten(dw)) {
 		printk(KERN_INFO "i5100_edac: ECC not enabled.\n");
 		ret = -ENODEV;
-		goto bail;
+		goto bail_pdev;
 	}
 
 	/* figure out how many ranks, from strapped state of 48GB_Mode input */
@@ -707,7 +852,7 @@ static int __devinit i5100_init_one(stru
 		/* FIXME: get 6 ranks / controller to work - need hw... */
 		printk(KERN_INFO "i5100_edac: unsupported configuration.\n");
 		ret = -ENODEV;
-		goto bail;
+		goto bail_pdev;
 	}
 
 	/* enable error reporting... */
@@ -718,8 +863,10 @@ static int __devinit i5100_init_one(stru
 	/* device 21, func 0, Channel 0 Memory Map, Error Flag/Mask, etc... */
 	ch0mm = pci_get_device_func(PCI_VENDOR_ID_INTEL,
 				    PCI_DEVICE_ID_INTEL_5100_21, 0);
-	if (!ch0mm)
-		return -ENODEV;
+	if (!ch0mm) {
+		ret = -ENODEV;
+		goto bail_pdev;
+	}
 
 	rc = pci_enable_device(ch0mm);
 	if (rc < 0) {
@@ -732,7 +879,7 @@ static int __devinit i5100_init_one(stru
 				    PCI_DEVICE_ID_INTEL_5100_22, 0);
 	if (!ch1mm) {
 		ret = -ENODEV;
-		goto bail_ch0;
+		goto bail_disable_ch0;
 	}
 
 	rc = pci_enable_device(ch1mm);
@@ -744,7 +891,7 @@ static int __devinit i5100_init_one(stru
 	mci = edac_mc_alloc(sizeof(*priv), ranksperch * 2, 1, 0);
 	if (!mci) {
 		ret = -ENOMEM;
-		goto bail_ch1;
+		goto bail_disable_ch1;
 	}
 
 	mci->dev = &pdev->dev;
@@ -786,17 +933,26 @@ static int __devinit i5100_init_one(stru
 		goto bail_mc;
 	}
 
-	goto bail;
+	return ret;
 
 bail_mc:
 	edac_mc_free(mci);
 
+bail_disable_ch1:
+	pci_disable_device(ch1mm);
+
 bail_ch1:
 	pci_dev_put(ch1mm);
 
+bail_disable_ch0:
+	pci_disable_device(ch0mm);
+
 bail_ch0:
 	pci_dev_put(ch0mm);
 
+bail_pdev:
+	pci_disable_device(pdev);
+
 bail:
 	return ret;
 }
@@ -812,6 +968,9 @@ static void __devexit i5100_remove_one(s
 		return;
 
 	priv = mci->pvt_info;
+	pci_disable_device(pdev);
+	pci_disable_device(priv->ch0mm);
+	pci_disable_device(priv->ch1mm);
 	pci_dev_put(priv->ch0mm);
 	pci_dev_put(priv->ch1mm);
 
_

Patches currently in -mm which might be from ajones@riverbed.com are

edac-i5100-new-intel-chipset-driver.patch
edac-i5100-fix-missing-bits.patch
edac-i5100-fix-enable-ecc-hardware.patch
edac-i5100-fix-unmask-ecc-bits.patch
edac-i5100-cleanup.patch
edac-core-fix-to-use-dynamic-kobject.patch
edac-core-fix-workq-timer.patch
edac-core-fix-redundant-sysfs-controls-to-parameters.patch
edac-core-fix-static-to-dynamic-kset.patch
edac-core-fix-added-newline-to-sysfs-dimm-labels.patch

