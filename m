From: akpm@linux-foundation.org
Subject: [merged] edac-i5100-clean-controller-to-channel-terms.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:12 -0800
Message-ID: <200912162039.nBGKdCCE013511@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49185 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964982AbZLPUjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nils.carlson@ludd.ltu.se, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5100 clean controller to channel terms
has been removed from the -mm tree.  Its filename was
     edac-i5100-clean-controller-to-channel-terms.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100 clean controller to channel terms
From: Nils Carlson <nils.carlson@ludd.ltu.se>

The i5100 driver uses the word controller instead of channel in a lot of
places, this is simply a cleanup of the patch.

Signed-off-by: Nils Carlson <nils.carlson@ludd.ltu.se>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |  110 ++++++++++++++++++------------------
 1 file changed, 55 insertions(+), 55 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-clean-controller-to-channel-terms drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-clean-controller-to-channel-terms
+++ a/drivers/edac/i5100_edac.c
@@ -265,42 +265,42 @@ static inline u32 i5100_recmemb_ras(u32 
 }
 
 /* some generic limits */
-#define I5100_MAX_RANKS_PER_CTLR	6
-#define I5100_MAX_CTLRS			2
+#define I5100_MAX_RANKS_PER_CHAN	6
+#define I5100_CHANNELS			    2
 #define I5100_MAX_RANKS_PER_DIMM	4
 #define I5100_DIMM_ADDR_LINES		(6 - 3)	/* 64 bits / 8 bits per byte */
-#define I5100_MAX_DIMM_SLOTS_PER_CTLR	4
+#define I5100_MAX_DIMM_SLOTS_PER_CHAN	4
 #define I5100_MAX_RANK_INTERLEAVE	4
 #define I5100_MAX_DMIRS			5
 
 struct i5100_priv {
 	/* ranks on each dimm -- 0 maps to not present -- obtained via SPD */
-	int dimm_numrank[I5100_MAX_CTLRS][I5100_MAX_DIMM_SLOTS_PER_CTLR];
+	int dimm_numrank[I5100_CHANNELS][I5100_MAX_DIMM_SLOTS_PER_CHAN];
 
 	/*
 	 * mainboard chip select map -- maps i5100 chip selects to
 	 * DIMM slot chip selects.  In the case of only 4 ranks per
-	 * controller, the mapping is fairly obvious but not unique.
-	 * we map -1 -> NC and assume both controllers use the same
+	 * channel, the mapping is fairly obvious but not unique.
+	 * we map -1 -> NC and assume both channels use the same
 	 * map...
 	 *
 	 */
-	int dimm_csmap[I5100_MAX_DIMM_SLOTS_PER_CTLR][I5100_MAX_RANKS_PER_DIMM];
+	int dimm_csmap[I5100_MAX_DIMM_SLOTS_PER_CHAN][I5100_MAX_RANKS_PER_DIMM];
 
 	/* memory interleave range */
 	struct {
 		u64	 limit;
 		unsigned way[2];
-	} mir[I5100_MAX_CTLRS];
+	} mir[I5100_CHANNELS];
 
 	/* adjusted memory interleave range register */
-	unsigned amir[I5100_MAX_CTLRS];
+	unsigned amir[I5100_CHANNELS];
 
 	/* dimm interleave range */
 	struct {
 		unsigned rank[I5100_MAX_RANK_INTERLEAVE];
 		u64	 limit;
-	} dmir[I5100_MAX_CTLRS][I5100_MAX_DMIRS];
+	} dmir[I5100_CHANNELS][I5100_MAX_DMIRS];
 
 	/* memory technology registers... */
 	struct {
@@ -310,30 +310,30 @@ struct i5100_priv {
 		unsigned numbank;	/* 2 or 3 lines */
 		unsigned numrow;	/* 13 .. 16 lines */
 		unsigned numcol;	/* 11 .. 12 lines */
-	} mtr[I5100_MAX_CTLRS][I5100_MAX_RANKS_PER_CTLR];
+	} mtr[I5100_CHANNELS][I5100_MAX_RANKS_PER_CHAN];
 
 	u64 tolm;		/* top of low memory in bytes */
-	unsigned ranksperctlr;	/* number of ranks per controller */
+	unsigned ranksperchan;	/* number of ranks per channel */
 
 	struct pci_dev *mc;	/* device 16 func 1 */
 	struct pci_dev *ch0mm;	/* device 21 func 0 */
 	struct pci_dev *ch1mm;	/* device 22 func 0 */
 };
 
-/* map a rank/ctlr to a slot number on the mainboard */
+/* map a rank/chan to a slot number on the mainboard */
 static int i5100_rank_to_slot(const struct mem_ctl_info *mci,
-			      int ctlr, int rank)
+			      int chan, int rank)
 {
 	const struct i5100_priv *priv = mci->pvt_info;
 	int i;
 
-	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CTLR; i++) {
+	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CHAN; i++) {
 		int j;
-		const int numrank = priv->dimm_numrank[ctlr][i];
+		const int numrank = priv->dimm_numrank[chan][i];
 
 		for (j = 0; j < numrank; j++)
 			if (priv->dimm_csmap[i][j] == rank)
-				return i * 2 + ctlr;
+				return i * 2 + chan;
 	}
 
 	return -1;
@@ -374,32 +374,32 @@ static const char *i5100_err_msg(unsigne
 	return "none";
 }
 
-/* convert csrow index into a rank (per controller -- 0..5) */
+/* convert csrow index into a rank (per channel -- 0..5) */
 static int i5100_csrow_to_rank(const struct mem_ctl_info *mci, int csrow)
 {
 	const struct i5100_priv *priv = mci->pvt_info;
 
-	return csrow % priv->ranksperctlr;
+	return csrow % priv->ranksperchan;
 }
 
-/* convert csrow index into a controller (0..1) */
-static int i5100_csrow_to_cntlr(const struct mem_ctl_info *mci, int csrow)
+/* convert csrow index into a channel (0..1) */
+static int i5100_csrow_to_chan(const struct mem_ctl_info *mci, int csrow)
 {
 	const struct i5100_priv *priv = mci->pvt_info;
 
-	return csrow / priv->ranksperctlr;
+	return csrow / priv->ranksperchan;
 }
 
 static unsigned i5100_rank_to_csrow(const struct mem_ctl_info *mci,
-				    int ctlr, int rank)
+				    int chan, int rank)
 {
 	const struct i5100_priv *priv = mci->pvt_info;
 
-	return ctlr * priv->ranksperctlr + rank;
+	return chan * priv->ranksperchan + rank;
 }
 
 static void i5100_handle_ce(struct mem_ctl_info *mci,
-			    int ctlr,
+			    int chan,
 			    unsigned bank,
 			    unsigned rank,
 			    unsigned long syndrome,
@@ -407,12 +407,12 @@ static void i5100_handle_ce(struct mem_c
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, ctlr, rank);
+	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
 
 	printk(KERN_ERR
-		"CE ctlr %d, bank %u, rank %u, syndrome 0x%lx, "
+		"CE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		ctlr, bank, rank, syndrome, cas, ras,
+		chan, bank, rank, syndrome, cas, ras,
 		csrow, mci->csrows[csrow].channels[0].label, msg);
 
 	mci->ce_count++;
@@ -421,7 +421,7 @@ static void i5100_handle_ce(struct mem_c
 }
 
 static void i5100_handle_ue(struct mem_ctl_info *mci,
-			    int ctlr,
+			    int chan,
 			    unsigned bank,
 			    unsigned rank,
 			    unsigned long syndrome,
@@ -429,23 +429,23 @@ static void i5100_handle_ue(struct mem_c
 			    unsigned ras,
 			    const char *msg)
 {
-	const int csrow = i5100_rank_to_csrow(mci, ctlr, rank);
+	const int csrow = i5100_rank_to_csrow(mci, chan, rank);
 
 	printk(KERN_ERR
-		"UE ctlr %d, bank %u, rank %u, syndrome 0x%lx, "
+		"UE chan %d, bank %u, rank %u, syndrome 0x%lx, "
 		"cas %u, ras %u, csrow %u, label \"%s\": %s\n",
-		ctlr, bank, rank, syndrome, cas, ras,
+		chan, bank, rank, syndrome, cas, ras,
 		csrow, mci->csrows[csrow].channels[0].label, msg);
 
 	mci->ue_count++;
 	mci->csrows[csrow].ue_count++;
 }
 
-static void i5100_read_log(struct mem_ctl_info *mci, int ctlr,
+static void i5100_read_log(struct mem_ctl_info *mci, int chan,
 			   u32 ferr, u32 nerr)
 {
 	struct i5100_priv *priv = mci->pvt_info;
-	struct pci_dev *pdev = (ctlr) ? priv->ch1mm : priv->ch0mm;
+	struct pci_dev *pdev = (chan) ? priv->ch1mm : priv->ch0mm;
 	u32 dw;
 	u32 dw2;
 	unsigned syndrome = 0;
@@ -484,7 +484,7 @@ static void i5100_read_log(struct mem_ct
 		else
 			msg = i5100_err_msg(nerr);
 
-		i5100_handle_ce(mci, ctlr, bank, rank, syndrome, cas, ras, msg);
+		i5100_handle_ce(mci, chan, bank, rank, syndrome, cas, ras, msg);
 	}
 
 	if (i5100_validlog_nrecmemvalid(dw)) {
@@ -506,7 +506,7 @@ static void i5100_read_log(struct mem_ct
 		else
 			msg = i5100_err_msg(nerr);
 
-		i5100_handle_ue(mci, ctlr, bank, rank, syndrome, cas, ras, msg);
+		i5100_handle_ue(mci, chan, bank, rank, syndrome, cas, ras, msg);
 	}
 
 	pci_write_config_dword(pdev, I5100_VALIDLOG, dw);
@@ -557,19 +557,19 @@ static unsigned long __devinit i5100_npa
 					    int csrow)
 {
 	struct i5100_priv *priv = mci->pvt_info;
-	const unsigned ctlr_rank = i5100_csrow_to_rank(mci, csrow);
-	const unsigned ctlr = i5100_csrow_to_cntlr(mci, csrow);
+	const unsigned chan_rank = i5100_csrow_to_rank(mci, csrow);
+	const unsigned chan = i5100_csrow_to_chan(mci, csrow);
 	unsigned addr_lines;
 
 	/* dimm present? */
-	if (!priv->mtr[ctlr][ctlr_rank].present)
+	if (!priv->mtr[chan][chan_rank].present)
 		return 0ULL;
 
 	addr_lines =
 		I5100_DIMM_ADDR_LINES +
-		priv->mtr[ctlr][ctlr_rank].numcol +
-		priv->mtr[ctlr][ctlr_rank].numrow +
-		priv->mtr[ctlr][ctlr_rank].numbank;
+		priv->mtr[chan][chan_rank].numcol +
+		priv->mtr[chan][chan_rank].numrow +
+		priv->mtr[chan][chan_rank].numbank;
 
 	return (unsigned long)
 		((unsigned long long) (1ULL << addr_lines) / PAGE_SIZE);
@@ -581,11 +581,11 @@ static void __devinit i5100_init_mtr(str
 	struct pci_dev *mms[2] = { priv->ch0mm, priv->ch1mm };
 	int i;
 
-	for (i = 0; i < I5100_MAX_CTLRS; i++) {
+	for (i = 0; i < I5100_CHANNELS; i++) {
 		int j;
 		struct pci_dev *pdev = mms[i];
 
-		for (j = 0; j < I5100_MAX_RANKS_PER_CTLR; j++) {
+		for (j = 0; j < I5100_MAX_RANKS_PER_CHAN; j++) {
 			const unsigned addr =
 				(j < 4) ? I5100_MTR_0 + j * 2 :
 					  I5100_MTR_4 + (j - 4) * 2;
@@ -644,7 +644,7 @@ static int i5100_read_spd_byte(const str
  * fill dimm chip select map
  *
  * FIXME:
- *   o only valid for 4 ranks per controller
+ *   o only valid for 4 ranks per channel
  *   o not the only way to may chip selects to dimm slots
  *   o investigate if there is some way to obtain this map from the bios
  */
@@ -653,9 +653,9 @@ static void __devinit i5100_init_dimm_cs
 	struct i5100_priv *priv = mci->pvt_info;
 	int i;
 
-	WARN_ON(priv->ranksperctlr != 4);
+	WARN_ON(priv->ranksperchan != 4);
 
-	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CTLR; i++) {
+	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CHAN; i++) {
 		int j;
 
 		for (j = 0; j < I5100_MAX_RANKS_PER_DIMM; j++)
@@ -677,10 +677,10 @@ static void __devinit i5100_init_dimm_la
 	struct i5100_priv *priv = mci->pvt_info;
 	int i;
 
-	for (i = 0; i < I5100_MAX_CTLRS; i++) {
+	for (i = 0; i < I5100_CHANNELS; i++) {
 		int j;
 
-		for (j = 0; j < I5100_MAX_DIMM_SLOTS_PER_CTLR; j++) {
+		for (j = 0; j < I5100_MAX_DIMM_SLOTS_PER_CHAN; j++) {
 			u8 rank;
 
 			if (i5100_read_spd_byte(mci, i, j, 5, &rank) < 0)
@@ -720,7 +720,7 @@ static void __devinit i5100_init_interle
 	pci_read_config_word(pdev, I5100_AMIR_1, &w);
 	priv->amir[1] = w;
 
-	for (i = 0; i < I5100_MAX_CTLRS; i++) {
+	for (i = 0; i < I5100_CHANNELS; i++) {
 		int j;
 
 		for (j = 0; j < 5; j++) {
@@ -747,7 +747,7 @@ static void __devinit i5100_init_csrows(
 
 	for (i = 0; i < mci->nr_csrows; i++) {
 		const unsigned long npages = i5100_npages(mci, i);
-		const unsigned cntlr = i5100_csrow_to_cntlr(mci, i);
+		const unsigned chan = i5100_csrow_to_chan(mci, i);
 		const unsigned rank = i5100_csrow_to_rank(mci, i);
 
 		if (!npages)
@@ -765,7 +765,7 @@ static void __devinit i5100_init_csrows(
 		mci->csrows[i].grain = 32;
 		mci->csrows[i].csrow_idx = i;
 		mci->csrows[i].dtype =
-			(priv->mtr[cntlr][rank].width == 4) ? DEV_X4 : DEV_X8;
+			(priv->mtr[chan][rank].width == 4) ? DEV_X4 : DEV_X8;
 		mci->csrows[i].ue_count = 0;
 		mci->csrows[i].ce_count = 0;
 		mci->csrows[i].mtype = MEM_RDDR2;
@@ -777,7 +777,7 @@ static void __devinit i5100_init_csrows(
 		mci->csrows[i].channels[0].csrow = mci->csrows + i;
 		snprintf(mci->csrows[i].channels[0].label,
 			 sizeof(mci->csrows[i].channels[0].label),
-			 "DIMM%u", i5100_rank_to_slot(mci, cntlr, rank));
+			 "DIMM%u", i5100_rank_to_slot(mci, chan, rank));
 
 		total_pages += npages;
 	}
@@ -816,7 +816,7 @@ static int __devinit i5100_init_one(stru
 	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
 
 	if (ranksperch != 4) {
-		/* FIXME: get 6 ranks / controller to work - need hw... */
+		/* FIXME: get 6 ranks / channel to work - need hw... */
 		printk(KERN_INFO "i5100_edac: unsupported configuration.\n");
 		ret = -ENODEV;
 		goto bail_pdev;
@@ -864,7 +864,7 @@ static int __devinit i5100_init_one(stru
 	mci->dev = &pdev->dev;
 
 	priv = mci->pvt_info;
-	priv->ranksperctlr = ranksperch;
+	priv->ranksperchan = ranksperch;
 	priv->mc = pdev;
 	priv->ch0mm = ch0mm;
 	priv->ch1mm = ch1mm;
_

Patches currently in -mm which might be from nils.carlson@ludd.ltu.se are

origin.patch

