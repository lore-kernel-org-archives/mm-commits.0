From: akpm@linux-foundation.org
Subject: - drivers-edac-lindent-i3000.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:20 -0700
Message-ID: <200707192006.l6JK6KfX020128@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57865 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761113AbXGSUPk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: Lindent i3000
has been removed from the -mm tree.  Its filename was
     drivers-edac-lindent-i3000.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: Lindent i3000
From: Dave Jiang <djiang@mvista.com>

Lindent cleanup of i3000_edac driver

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i3000_edac.c |   55 +++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 29 deletions(-)

diff -puN drivers/edac/i3000_edac.c~drivers-edac-lindent-i3000 drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-lindent-i3000
+++ a/drivers/edac/i3000_edac.c
@@ -130,7 +130,6 @@
 					 * 30:0  reserved
 					 */
 
-
 enum i3000p_chips {
 	I3000 = 0,
 };
@@ -149,15 +148,14 @@ struct i3000_error_info {
 
 static const struct i3000_dev_info i3000_devs[] = {
 	[I3000] = {
-		     .ctl_name = "i3000"
-	},
+		   .ctl_name = "i3000"},
 };
 
 static struct pci_dev *mci_pdev = NULL;
 static int i3000_registered = 1;
 
 static void i3000_get_error_info(struct mem_ctl_info *mci,
-		struct i3000_error_info *info)
+				 struct i3000_error_info *info)
 {
 	struct pci_dev *pdev;
 
@@ -183,22 +181,21 @@ static void i3000_get_error_info(struct 
 	 * should be UE info.
 	 */
 	if ((info->errsts ^ info->errsts2) & I3000_ERRSTS_BITS) {
-			pci_read_config_byte(pdev, I3000_EDEAP,
-					&info->edeap);
-			pci_read_config_dword(pdev, I3000_DEAP,
-					&info->deap);
-			pci_read_config_byte(pdev, I3000_DERRSYN,
-					&info->derrsyn);
+		pci_read_config_byte(pdev, I3000_EDEAP, &info->edeap);
+		pci_read_config_dword(pdev, I3000_DEAP, &info->deap);
+		pci_read_config_byte(pdev, I3000_DERRSYN, &info->derrsyn);
 	}
 
 	/* Clear any error bits.
 	 * (Yes, we really clear bits by writing 1 to them.)
 	 */
-	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS, I3000_ERRSTS_BITS);
+	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
+			 I3000_ERRSTS_BITS);
 }
 
 static int i3000_process_error_info(struct mem_ctl_info *mci,
-		struct i3000_error_info *info, int handle_errors)
+				    struct i3000_error_info *info,
+				    int handle_errors)
 {
 	int row, multi_chan;
 	int pfn, offset, channel;
@@ -226,8 +223,7 @@ static int i3000_process_error_info(stru
 		edac_mc_handle_ue(mci, pfn, offset, row, "i3000 UE");
 	else
 		edac_mc_handle_ce(mci, pfn, offset, info->derrsyn, row,
-				       multi_chan ? channel : 0,
-				       "i3000 CE");
+				  multi_chan ? channel : 0, "i3000 CE");
 
 	return 1;
 }
@@ -281,18 +277,19 @@ static int i3000_probe1(struct pci_dev *
 
 	debugf0("MC: %s()\n", __func__);
 
-	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *)&mchbar);
+	pci_read_config_dword(pdev, I3000_MCHBAR, (u32 *) & mchbar);
 	mchbar &= I3000_MCHBAR_MASK;
 	window = ioremap_nocache(mchbar, I3000_MMR_WINDOW_SIZE);
 	if (!window) {
-		printk(KERN_ERR "i3000: cannot map mmio space at 0x%lx\n", mchbar);
+		printk(KERN_ERR "i3000: cannot map mmio space at 0x%lx\n",
+		       mchbar);
 		return -ENODEV;
 	}
 
-	c0dra[0] = readb(window + I3000_C0DRA + 0); /* ranks 0,1 */
-	c0dra[1] = readb(window + I3000_C0DRA + 1); /* ranks 2,3 */
-	c1dra[0] = readb(window + I3000_C1DRA + 0); /* ranks 0,1 */
-	c1dra[1] = readb(window + I3000_C1DRA + 1); /* ranks 2,3 */
+	c0dra[0] = readb(window + I3000_C0DRA + 0);	/* ranks 0,1 */
+	c0dra[1] = readb(window + I3000_C0DRA + 1);	/* ranks 2,3 */
+	c1dra[0] = readb(window + I3000_C1DRA + 0);	/* ranks 0,1 */
+	c1dra[1] = readb(window + I3000_C1DRA + 1);	/* ranks 2,3 */
 
 	for (i = 0; i < I3000_RANKS_PER_CHANNEL; i++) {
 		c0drb[i] = readb(window + I3000_C0DRB + i);
@@ -367,7 +364,8 @@ static int i3000_probe1(struct pci_dev *
 	/* Clear any error bits.
 	 * (Yes, we really clear bits by writing 1 to them.)
 	 */
-	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS, I3000_ERRSTS_BITS);
+	pci_write_bits16(pdev, I3000_ERRSTS, I3000_ERRSTS_BITS,
+			 I3000_ERRSTS_BITS);
 
 	rc = -ENODEV;
 	if (edac_mc_add_mc(mci, 0)) {
@@ -388,7 +386,7 @@ static int i3000_probe1(struct pci_dev *
 
 /* returns count (>= 0), or negative on error */
 static int __devinit i3000_init_one(struct pci_dev *pdev,
-				      const struct pci_device_id *ent)
+				    const struct pci_device_id *ent)
 {
 	int rc;
 
@@ -418,12 +416,11 @@ static void __devexit i3000_remove_one(s
 
 static const struct pci_device_id i3000_pci_tbl[] __devinitdata = {
 	{
-		PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-	 	I3000
-	},
+	 PCI_VEND_DEV(INTEL, 3000_HB), PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+	 I3000},
 	{
-		0,
-	}	/* 0 terminated list. */
+	 0,
+	 }			/* 0 terminated list. */
 };
 
 MODULE_DEVICE_TABLE(pci, i3000_pci_tbl);
@@ -464,10 +461,10 @@ static int __init i3000_init(void)
 
 	return 0;
 
-fail1:
+      fail1:
 	pci_unregister_driver(&i3000_driver);
 
-fail0:
+      fail0:
 	if (mci_pdev)
 		pci_dev_put(mci_pdev);
 
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
