From: akpm@linux-foundation.org
Subject: [merged] edac-i5100-add-6-ranks-per-channel.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:39:18 -0800
Message-ID: <200912162039.nBGKdIk7013526@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54070 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964992AbZLPUja (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:39:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nils.carlson@ludd.ltu.se, ajones@riverbed.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     edac: i5100 add 6 ranks per channel
has been removed from the -mm tree.  Its filename was
     edac-i5100-add-6-ranks-per-channel.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: i5100 add 6 ranks per channel
From: Nils Carlson <nils.carlson@ludd.ltu.se>

Add support for 6 ranks per channel to the i5100 chipset.  I have tested
the patch as far as possible with correctible errors and things appear
good.  The DIMM mapping is correct for our board, but boards may differ.

Signed-off-by: Nils Carlson <nils.carlson@ludd.ltu.se>
Acked-by: Arthur Jones <ajones@riverbed.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5100_edac.c |   36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff -puN drivers/edac/i5100_edac.c~edac-i5100-add-6-ranks-per-channel drivers/edac/i5100_edac.c
--- a/drivers/edac/i5100_edac.c~edac-i5100-add-6-ranks-per-channel
+++ a/drivers/edac/i5100_edac.c
@@ -9,6 +9,11 @@
  * Intel 5100X Chipset Memory Controller Hub (MCH) - Datasheet
  *      http://download.intel.com/design/chipsets/datashts/318378.pdf
  *
+ * The intel 5100 has two independent channels. EDAC core currently
+ * can not reflect this configuration so instead the chip-select
+ * rows for each respective channel are layed out one after another,
+ * the first half belonging to channel 0, the second half belonging
+ * to channel 1.
  */
 #include <linux/module.h>
 #include <linux/init.h>
@@ -734,7 +739,6 @@ static int i5100_read_spd_byte(const str
  * fill dimm chip select map
  *
  * FIXME:
- *   o only valid for 4 ranks per channel
  *   o not the only way to may chip selects to dimm slots
  *   o investigate if there is some way to obtain this map from the bios
  */
@@ -743,8 +747,6 @@ static void __devinit i5100_init_dimm_cs
 	struct i5100_priv *priv = mci->pvt_info;
 	int i;
 
-	WARN_ON(priv->ranksperchan != 4);
-
 	for (i = 0; i < I5100_MAX_DIMM_SLOTS_PER_CHAN; i++) {
 		int j;
 
@@ -753,12 +755,21 @@ static void __devinit i5100_init_dimm_cs
 	}
 
 	/* only 2 chip selects per slot... */
-	priv->dimm_csmap[0][0] = 0;
-	priv->dimm_csmap[0][1] = 3;
-	priv->dimm_csmap[1][0] = 1;
-	priv->dimm_csmap[1][1] = 2;
-	priv->dimm_csmap[2][0] = 2;
-	priv->dimm_csmap[3][0] = 3;
+	if (priv->ranksperchan == 4) {
+		priv->dimm_csmap[0][0] = 0;
+		priv->dimm_csmap[0][1] = 3;
+		priv->dimm_csmap[1][0] = 1;
+		priv->dimm_csmap[1][1] = 2;
+		priv->dimm_csmap[2][0] = 2;
+		priv->dimm_csmap[3][0] = 3;
+	} else {
+		priv->dimm_csmap[0][0] = 0;
+		priv->dimm_csmap[0][1] = 1;
+		priv->dimm_csmap[1][0] = 2;
+		priv->dimm_csmap[1][1] = 3;
+		priv->dimm_csmap[2][0] = 4;
+		priv->dimm_csmap[2][1] = 5;
+	}
 }
 
 static void __devinit i5100_init_dimm_layout(struct pci_dev *pdev,
@@ -905,13 +916,6 @@ static int __devinit i5100_init_one(stru
 	pci_read_config_dword(pdev, I5100_MS, &dw);
 	ranksperch = !!(dw & (1 << 8)) * 2 + 4;
 
-	if (ranksperch != 4) {
-		/* FIXME: get 6 ranks / channel to work - need hw... */
-		printk(KERN_INFO "i5100_edac: unsupported configuration.\n");
-		ret = -ENODEV;
-		goto bail_pdev;
-	}
