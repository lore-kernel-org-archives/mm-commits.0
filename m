From: akpm@linux-foundation.org
Subject: [merged] edac-i5100-add-scrubbing.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:15 -0800
Message-ID: <200912162039.nBGKdFhX013519@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964983AbZLPUjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nils.carlson@ludd.ltu.se, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5100 add scrubbing
has been removed from the -mm tree.  Its filename was
     edac-i5100-add-scrubbing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100 add scrubbing
From: Nils Carlson <nils.carlson@ludd.ltu.se>

Addscrubbing to the i5100 chipset.  The i5100 chipset only supports one
scrubbing rate, which is not constant but dependent on memory load.  The
rate returned by this driver is an estimate based on some experimentation,
but is substantially closer to the truth than the speed supplied in the
documentation.

Also, scrubbing is done once, and then a done-bit is set.  This means that
to accomplish continuous scrubbing a re-enabling mechanism must be used. 
I have created the simplest possible such mechanism in the form of a
work-queue which will check every five minutes.  This interval is quite
arbitrary but should be sufficient for all sizes of system memory.

Signed-off-by: Nils Carlson <nils.carlson@ludd.ltu.se>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |  112 +++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 2 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-add-scrubbing drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-add-scrubbing
+++ a/drivers/edac/i5100_edac.c
@@ -25,6 +25,8 @@
 
 /* device 16, func 1 */
 #define I5100_MC		0x40	/* Memory Control Register */
+#define 	I5100_MC_SCRBEN_MASK	(1 << 7)
+#define 	I5100_MC_SCRBDONE_MASK	(1 << 4)
 #define I5100_MS		0x44	/* Memory Status Register */
 #define I5100_SPDDATA		0x48	/* Serial Presence Detect Status Reg */
 #define I5100_SPDCMD		0x4c	/* Serial Presence Detect Command Reg */
@@ -72,11 +74,21 @@
 
 /* bit field accessors */
 
+static inline u32 i5100_mc_scrben(u32 mc)
+{
+	return mc >> 7 & 1;
+}
+
 static inline u32 i5100_mc_errdeten(u32 mc)
 {
 	return mc >> 5 & 1;
 }
 
+static inline u32 i5100_mc_scrbdone(u32 mc)
+{
+	return mc >> 4 & 1;
+}
+
 static inline u16 i5100_spddata_rdo(u16 a)
 {
 	return a >> 15 & 1;
@@ -272,6 +284,7 @@ static inline u32 i5100_recmemb_ras(u32 
 #define I5100_MAX_DIMM_SLOTS_PER_CHAN	4
 #define I5100_MAX_RANK_INTERLEAVE	4
 #define I5100_MAX_DMIRS			5
+#define I5100_SCRUB_REFRESH_RATE	(5 * 60 * HZ)
 
 struct i5100_priv {
 	/* ranks on each dimm -- 0 maps to not present -- obtained via SPD */
@@ -318,6 +331,9 @@ struct i5100_priv {
 	struct pci_dev *mc;	/* device 16 func 1 */
 	struct pci_dev *ch0mm;	/* device 21 func 0 */
 	struct pci_dev *ch1mm;	/* device 22 func 0 */
+
+	struct delayed_work i5100_scrubbing;
+	int scrub_enable;
 };
 
 /* map a rank/chan to a slot number on the mainboard */
@@ -534,6 +550,80 @@ static void i5100_check_error(struct mem
 	}
 }
 
+/* The i5100 chipset will scrub the entire memory once, then
+ * set a done bit. Continuous scrubbing is achieved by enqueing
+ * delayed work to a workqueue, checking every few minutes if
+ * the scrubbing has completed and if so reinitiating it.
+ */
+
+static void i5100_refresh_scrubbing(struct work_struct *work)
+{
+	struct delayed_work *i5100_scrubbing = container_of(work,
+							    struct delayed_work,
+							    work);
+	struct i5100_priv *priv = container_of(i5100_scrubbing,
+					       struct i5100_priv,
+					       i5100_scrubbing);
+	u32 dw;
+
+	pci_read_config_dword(priv->mc, I5100_MC, &dw);
+
+	if (priv->scrub_enable) {
+
+		pci_read_config_dword(priv->mc, I5100_MC, &dw);
+
+		if (i5100_mc_scrbdone(dw)) {
+			dw |= I5100_MC_SCRBEN_MASK;
+			pci_write_config_dword(priv->mc, I5100_MC, dw);
+			pci_read_config_dword(priv->mc, I5100_MC, &dw);
+		}
+
+		schedule_delayed_work(&(priv->i5100_scrubbing),
+				      I5100_SCRUB_REFRESH_RATE);
+	}
+}
+/*
+ * The bandwidth is based on experimentation, feel free to refine it.
+ */
+static int i5100_set_scrub_rate(struct mem_ctl_info *mci,
+				       u32 *bandwidth)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+	u32 dw;
+
+	pci_read_config_dword(priv->mc, I5100_MC, &dw);
+	if (*bandwidth) {
+		priv->scrub_enable = 1;
+		dw |= I5100_MC_SCRBEN_MASK;
+		schedule_delayed_work(&(priv->i5100_scrubbing),
+				      I5100_SCRUB_REFRESH_RATE);
+	} else {
+		priv->scrub_enable = 0;
+		dw &= ~I5100_MC_SCRBEN_MASK;
+		cancel_delayed_work(&(priv->i5100_scrubbing));
+	}
+	pci_write_config_dword(priv->mc, I5100_MC, dw);
+
+	pci_read_config_dword(priv->mc, I5100_MC, &dw);
+
+	*bandwidth = 5900000 * i5100_mc_scrben(dw);
+
+	return 0;
+}
+
+static int i5100_get_scrub_rate(struct mem_ctl_info *mci,
+				u32 *bandwidth)
+{
+	struct i5100_priv *priv = mci->pvt_info;
+	u32 dw;
+
+	pci_read_config_dword(priv->mc, I5100_MC, &dw);
+
+	*bandwidth = 5900000 * i5100_mc_scrben(dw);
+
+	return 0;
+}
+
 static struct pci_dev *pci_get_device_func(unsigned vendor,
 					   unsigned device,
 					   unsigned func)
@@ -869,6 +959,16 @@ static int __devinit i5100_init_one(stru
 	priv->ch0mm = ch0mm;
 	priv->ch1mm = ch1mm;
 
+	INIT_DELAYED_WORK(&(priv->i5100_scrubbing), i5100_refresh_scrubbing);
+
+	/* If scrubbing was already enabled by the bios, start maintaining it */
+	pci_read_config_dword(pdev, I5100_MC, &dw);
+	if (i5100_mc_scrben(dw)) {
+		priv->scrub_enable = 1;
+		schedule_delayed_work(&(priv->i5100_scrubbing),
+				      I5100_SCRUB_REFRESH_RATE);
+	}
+
 	i5100_init_dimm_layout(pdev, mci);
 	i5100_init_interleaving(pdev, mci);
 
@@ -882,6 +982,8 @@ static int __devinit i5100_init_one(stru
 	mci->ctl_page_to_phys = NULL;
 
 	mci->edac_check = i5100_check_error;
+	mci->set_sdram_scrub_rate = i5100_set_scrub_rate;
+	mci->get_sdram_scrub_rate = i5100_get_scrub_rate;
 
 	i5100_init_csrows(mci);
 
@@ -897,12 +999,14 @@ static int __devinit i5100_init_one(stru
 
 	if (edac_mc_add_mc(mci)) {
 		ret = -ENODEV;
-		goto bail_mc;
+		goto bail_scrub;
 	}
 
 	return ret;
 
-bail_mc:
+bail_scrub:
+	priv->scrub_enable = 0;
+	cancel_delayed_work_sync(&(priv->i5100_scrubbing));
 	edac_mc_free(mci);
 
 bail_disable_ch1:
@@ -935,6 +1039,10 @@ static void __devexit i5100_remove_one(s
 		return;
 
 	priv = mci->pvt_info;
+
+	priv->scrub_enable = 0;
+	cancel_delayed_work_sync(&(priv->i5100_scrubbing));
+
 	pci_disable_device(pdev);
 	pci_disable_device(priv->ch0mm);
 	pci_disable_device(priv->ch1mm);
_

Patches currently in -mm which might be from nils.carlson@ludd.ltu.se are

origin.patch

