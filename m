From: akpm@linux-foundation.org
Subject: - drivers-edac-fix-edac_mc-init-apis.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:07:16 -0700
Message-ID: <200707192007.l6JK7GSV020250@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761310AbXGSUQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dougthompson@xmission.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: fix edac_mc init apis
has been removed from the -mm tree.  Its filename was
     drivers-edac-fix-edac_mc-init-apis.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: fix edac_mc init apis
From: Doug Thompson <dougthompson@xmission.com>

Refactoring of sysfs code necessitated the refactoring of the edac_mc_alloc()
and edac_mc_add_mc() apis, of moving the index value to the alloc() function. 
This patch alters the in tree drivers to utilize this new api signature.

Having the index value performed later created a chicken-and-the-egg issue. 
Moving it to the alloc() function allows for creating the necessary sysfs
entries with the proper index number

Cc: Alan Cox alan@lxorguk.ukuu.org.uk
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c     |    4 ++--
 drivers/edac/e752x_edac.c      |    4 ++--
 drivers/edac/e7xxx_edac.c      |    4 ++--
 drivers/edac/edac_core.h       |   27 ++++++++++++++-------------
 drivers/edac/edac_mc.c         |    9 +++++----
 drivers/edac/i3000_edac.c      |    4 ++--
 drivers/edac/i5000_edac.c      |    6 ++----
 drivers/edac/i82443bxgx_edac.c |    4 ++--
 drivers/edac/i82860_edac.c     |    4 ++--
 drivers/edac/i82875p_edac.c    |    4 ++--
 drivers/edac/pasemi_edac.c     |    5 +++--
 drivers/edac/r82600_edac.c     |    4 ++--
 12 files changed, 40 insertions(+), 39 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/amd76x_edac.c
@@ -238,7 +238,7 @@ static int amd76x_probe1(struct pci_dev 
 	debugf0("%s()\n", __func__);
 	pci_read_config_dword(pdev, AMD76X_ECC_MODE_STATUS, &ems);
 	ems_mode = (ems >> 10) & 0x3;
-	mci = edac_mc_alloc(0, AMD76X_NR_CSROWS, AMD76X_NR_CHANS);
+	mci = edac_mc_alloc(0, AMD76X_NR_CSROWS, AMD76X_NR_CHANS, 0);
 
 	if (mci == NULL) {
 		return -ENOMEM;
@@ -263,7 +263,7 @@ static int amd76x_probe1(struct pci_dev 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
diff -puN drivers/edac/e752x_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/e752x_edac.c
@@ -977,7 +977,7 @@ static int e752x_probe1(struct pci_dev *
 	/* Dual channel = 1, Single channel = 0 */
 	drc_chan = dual_channel_active(ddrcsr);
 
-	mci = edac_mc_alloc(sizeof(*pvt), E752X_NR_CSROWS, drc_chan + 1);
+	mci = edac_mc_alloc(sizeof(*pvt), E752X_NR_CSROWS, drc_chan + 1, 0);
 
 	if (mci == NULL) {
 		return -ENOMEM;
@@ -1035,7 +1035,7 @@ static int e752x_probe1(struct pci_dev *
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/e7xxx_edac.c
@@ -427,7 +427,7 @@ static int e7xxx_probe1(struct pci_dev *
 	pci_read_config_dword(pdev, E7XXX_DRC, &drc);
 
 	drc_chan = dual_channel_active(drc, dev_idx);
-	mci = edac_mc_alloc(sizeof(*pvt), E7XXX_NR_CSROWS, drc_chan + 1);
+	mci = edac_mc_alloc(sizeof(*pvt), E7XXX_NR_CSROWS, drc_chan + 1, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -478,7 +478,7 @@ static int e7xxx_probe1(struct pci_dev *
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail1;
 	}
diff -puN drivers/edac/edac_core.h~drivers-edac-fix-edac_mc-init-apis drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/edac_core.h
@@ -765,8 +765,11 @@ static inline void pci_write_bits32(stru
 
 #endif				/* CONFIG_PCI */
 
+extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
+					  unsigned nr_chans, int edac_index);
+extern int edac_mc_add_mc(struct mem_ctl_info *mci);
+extern void edac_mc_free(struct mem_ctl_info *mci);
 extern struct mem_ctl_info *edac_mc_find(int idx);
-extern int edac_mc_add_mc(struct mem_ctl_info *mci, int mc_idx);
 extern struct mem_ctl_info *edac_mc_del_mc(struct device *dev);
 extern int edac_mc_find_csrow_by_page(struct mem_ctl_info *mci,
 				      unsigned long page);
@@ -803,33 +806,31 @@ extern void edac_mc_handle_fbd_ce(struct
 /*
  * edac_device APIs
  */
-extern struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-					  unsigned nr_chans);
-extern void edac_mc_free(struct mem_ctl_info *mci);
 extern int edac_device_add_device(struct edac_device_ctl_info *edac_dev,
-				  int edac_idx);
+				int dev_idx);
 extern struct edac_device_ctl_info *edac_device_del_device(struct device *dev);
 extern void edac_device_handle_ue(struct edac_device_ctl_info *edac_dev,
-				  int inst_nr, int block_nr, const char *msg);
+				int inst_nr, int block_nr, const char *msg);
 extern void edac_device_handle_ce(struct edac_device_ctl_info *edac_dev,
-				  int inst_nr, int block_nr, const char *msg);
+				int inst_nr, int block_nr, const char *msg);
 
 /*
  * edac_pci APIs
  */
-extern struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt, const char
-							 *edac_pci_name);
+extern struct edac_pci_ctl_info *edac_pci_alloc_ctl_info(unsigned int sz_pvt,
+				const char *edac_pci_name);
 
 extern void edac_pci_free_ctl_info(struct edac_pci_ctl_info *pci);
 
-extern void
-edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci, unsigned long value);
+extern void edac_pci_reset_delay_period(struct edac_pci_ctl_info *pci,
+				unsigned long value);
 
 extern int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx);
 extern struct edac_pci_ctl_info *edac_pci_del_device(struct device *dev);
 
-extern struct edac_pci_ctl_info *edac_pci_create_generic_ctl(struct device *dev, const char
-							     *mod_name);
+extern struct edac_pci_ctl_info *edac_pci_create_generic_ctl(
+				struct device *dev,
+				const char *mod_name);
 
 extern void edac_pci_release_generic_ctl(struct edac_pci_ctl_info *pci);
 extern int edac_pci_create_sysfs(struct edac_pci_ctl_info *pci);
diff -puN drivers/edac/edac_mc.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/edac_mc.c
@@ -129,7 +129,7 @@ void *edac_align_ptr(void *ptr, unsigned
  *	struct mem_ctl_info pointer
  */
 struct mem_ctl_info *edac_mc_alloc(unsigned sz_pvt, unsigned nr_csrows,
-				unsigned nr_chans)
+				unsigned nr_chans, int edac_index)
 {
 	struct mem_ctl_info *mci;
 	struct csrow_info *csi, *csrow;
@@ -159,7 +159,8 @@ struct mem_ctl_info *edac_mc_alloc(unsig
 	chi = (struct channel_info *)(((char *)mci) + ((unsigned long)chi));
 	pvt = sz_pvt ? (((char *)mci) + ((unsigned long)pvt)) : NULL;
 
-	memset(mci, 0, size);	/* clear all fields */
+	/* setup index and various internal pointers */
+	mci->mc_idx = edac_index;
 	mci->csrows = csi;
 	mci->pvt_info = pvt;
 	mci->nr_csrows = nr_csrows;
@@ -405,10 +406,10 @@ EXPORT_SYMBOL(edac_mc_find);
  */
 
 /* FIXME - should a warning be printed if no error detection? correction? */
-int edac_mc_add_mc(struct mem_ctl_info *mci, int mc_idx)
+int edac_mc_add_mc(struct mem_ctl_info *mci)
 {
 	debugf0("%s()\n", __func__);
-	mci->mc_idx = mc_idx;
+
 #ifdef CONFIG_EDAC_DEBUG
 	if (edac_debug_level >= 3)
 		edac_mc_dump_mci(mci);
diff -puN drivers/edac/i3000_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/i3000_edac.c
@@ -309,7 +309,7 @@ static int i3000_probe1(struct pci_dev *
 	 */
 	interleaved = i3000_is_interleaved(c0dra, c1dra, c0drb, c1drb);
 	nr_channels = interleaved ? 2 : 1;
-	mci = edac_mc_alloc(0, I3000_RANKS / nr_channels, nr_channels);
+	mci = edac_mc_alloc(0, I3000_RANKS / nr_channels, nr_channels, 0);
 	if (!mci)
 		return -ENOMEM;
 
@@ -370,7 +370,7 @@ static int i3000_probe1(struct pci_dev *
 			 I3000_ERRSTS_BITS);
 
 	rc = -ENODEV;
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("MC: %s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
diff -puN drivers/edac/i5000_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/i5000_edac.c
@@ -338,8 +338,6 @@ struct i5000_pvt {
 	struct pci_dev *branch_0;	/* 21.0 */
 	struct pci_dev *branch_1;	/* 22.0 */
 
-	int node_id;		/* ID of this node */
-
 	u16 tolm;		/* top of low memory */
 	u64 ambase;		/* AMB BAR */
 
@@ -1319,7 +1317,7 @@ static int i5000_probe1(struct pci_dev *
 		__func__, num_channels, num_dimms_per_channel, num_csrows);
 
 	/* allocate a new MC control structure */
-	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels);
+	mci = edac_mc_alloc(sizeof(*pvt), num_csrows, num_channels, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -1366,7 +1364,7 @@ static int i5000_probe1(struct pci_dev *
 	}
 
 	/* add this new MC control structure to EDAC's list of MCs */
-	if (edac_mc_add_mc(mci, pvt->node_id)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf0("MC: " __FILE__
 			": %s(): failed edac_mc_add_mc()\n", __func__);
 		/* FIXME: perhaps some code should go here that disables error
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -239,7 +239,7 @@ static int i82443bxgx_edacmc_probe1(stru
 	if (pci_read_config_dword(pdev, I82443BXGX_NBXCFG, &nbxcfg))
 		return -EIO;
 
-	mci = edac_mc_alloc(0, I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS);
+	mci = edac_mc_alloc(0, I82443BXGX_NR_CSROWS, I82443BXGX_NR_CHANS, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -314,7 +314,7 @@ static int i82443bxgx_edacmc_probe1(stru
 	mci->edac_check = i82443bxgx_edacmc_check;
 	mci->ctl_page_to_phys = NULL;
 
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
diff -puN drivers/edac/i82860_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/i82860_edac.c
@@ -186,7 +186,7 @@ static int i82860_probe1(struct pci_dev 
 	   the channel and the GRA registers map to physical devices so we are
 	   going to make 1 channel for group.
 	 */
-	mci = edac_mc_alloc(0, 16, 1);
+	mci = edac_mc_alloc(0, 16, 1, 0);
 
 	if (!mci)
 		return -ENOMEM;
@@ -209,7 +209,7 @@ static int i82860_probe1(struct pci_dev 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
diff -puN drivers/edac/i82875p_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/i82875p_edac.c
@@ -400,7 +400,7 @@ static int i82875p_probe1(struct pci_dev
 	drc = readl(ovrfl_window + I82875P_DRC);
 	nr_chans = dual_channel_active(drc) + 1;
 	mci = edac_mc_alloc(sizeof(*pvt), I82875P_NR_CSROWS(nr_chans),
-			nr_chans);
+			nr_chans, 0);
 
 	if (!mci) {
 		rc = -ENOMEM;
@@ -428,7 +428,7 @@ static int i82875p_probe1(struct pci_dev
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail1;
 	}
diff -puN drivers/edac/pasemi_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/pasemi_edac.c
--- a/drivers/edac/pasemi_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/pasemi_edac.c
@@ -205,7 +205,8 @@ static int __devinit pasemi_edac_probe(s
 		MCDEBUG_ERRCTL1_RFL_LOG_EN;
 	pci_write_config_dword(pdev, MCDEBUG_ERRCTL1, errctl1);
 
-	mci = edac_mc_alloc(0, PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS);
+	mci = edac_mc_alloc(0, PASEMI_EDAC_NR_CSROWS, PASEMI_EDAC_NR_CHANS,
+				system_mmc_id++);
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -245,7 +246,7 @@ static int __devinit pasemi_edac_probe(s
 	 */
 	pasemi_edac_get_error_info(mci);
 
-	if (edac_mc_add_mc(mci, system_mmc_id++))
+	if (edac_mc_add_mc(mci))
 		goto fail;
 
 	/* get this far and it's successful */
diff -puN drivers/edac/r82600_edac.c~drivers-edac-fix-edac_mc-init-apis drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-fix-edac_mc-init-apis
+++ a/drivers/edac/r82600_edac.c
@@ -278,7 +278,7 @@ static int r82600_probe1(struct pci_dev 
 	debugf2("%s(): sdram refresh rate = %#0x\n", __func__,
 		sdram_refresh_rate);
 	debugf2("%s(): DRAMC register = %#0x\n", __func__, dramcr);
-	mci = edac_mc_alloc(0, R82600_NR_CSROWS, R82600_NR_CHANS);
+	mci = edac_mc_alloc(0, R82600_NR_CSROWS, R82600_NR_CHANS, 0);
 
 	if (mci == NULL)
 		return -ENOMEM;
@@ -316,7 +316,7 @@ static int r82600_probe1(struct pci_dev 
 	/* Here we assume that we will never see multiple instances of this
 	 * type of memory controller.  The ID is therefore hardcoded to 0.
 	 */
-	if (edac_mc_add_mc(mci, 0)) {
+	if (edac_mc_add_mc(mci)) {
 		debugf3("%s(): failed edac_mc_add_mc()\n", __func__);
 		goto fail;
 	}
_

Patches currently in -mm which might be from dougthompson@xmission.com are

origin.patch
