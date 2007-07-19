From: akpm@linux-foundation.org
Subject: - drivers-edac-drivers-to-use-new-pci-operation.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:06:33 -0700
Message-ID: <200707192006.l6JK6XN6020147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47502 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759751AbXGSUPr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: drivers to use new PCI operation
has been removed from the -mm tree.  Its filename was
     drivers-edac-drivers-to-use-new-pci-operation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: drivers to use new PCI operation
From: Dave Jiang <djiang@mvista.com>

Move x86 drivers to new pci controller setup

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c     |   16 ++++++++++++++++
 drivers/edac/e7xxx_edac.c      |   16 ++++++++++++++++
 drivers/edac/i3000_edac.c      |   15 +++++++++++++++
 drivers/edac/i5000_edac.c      |   17 +++++++++++++++++
 drivers/edac/i82443bxgx_edac.c |   16 ++++++++++++++++
 drivers/edac/i82860_edac.c     |   15 +++++++++++++++
 drivers/edac/i82875p_edac.c    |   16 ++++++++++++++++
 drivers/edac/r82600_edac.c     |   16 ++++++++++++++++
 8 files changed, 127 insertions(+)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/amd76x_edac.c
@@ -91,6 +91,8 @@ static const struct amd76x_dev_info amd7
 		    .ctl_name = "AMD762"},
 };
 
+static struct edac_pci_ctl_info *amd76x_pci;
+
 /**
  *	amd76x_get_error_info	-	fetch error information
  *	@mci: Memory controller
@@ -266,6 +268,17 @@ static int amd76x_probe1(struct pci_dev 
 		goto fail;
 	}
 
+	/* allocating generic PCI control info */
+	amd76x_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!amd76x_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
@@ -299,6 +312,9 @@ static void __devexit amd76x_remove_one(
 
 	debugf0("%s()\n", __func__);
 
+	if (amd76x_pci)
+		edac_pci_release_generic_ctl(amd76x_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/e7xxx_edac.c
@@ -144,6 +144,8 @@ struct e7xxx_error_info {
 	u32 dram_uelog_add;
 };
 
+static struct edac_pci_ctl_info *e7xxx_pci;
+
 static const struct e7xxx_dev_info e7xxx_devs[] = {
 	[E7500] = {
 		   .err_dev = PCI_DEVICE_ID_INTEL_7500_1_ERR,
@@ -481,6 +483,17 @@ static int e7xxx_probe1(struct pci_dev *
 		goto fail1;
 	}
 
+	/* allocating generic PCI control info */
+	e7xxx_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!e7xxx_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
@@ -512,6 +525,9 @@ static void __devexit e7xxx_remove_one(s
 
 	debugf0("%s()\n", __func__);
 
+	if (e7xxx_pci)
+		edac_pci_release_generic_ctl(e7xxx_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/i3000_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/i3000_edac.c
--- a/drivers/edac/i3000_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/i3000_edac.c
@@ -153,6 +153,7 @@ static const struct i3000_dev_info i3000
 
 static struct pci_dev *mci_pdev = NULL;
 static int i3000_registered = 1;
+static struct edac_pci_ctl_info *i3000_pci;
 
 static void i3000_get_error_info(struct mem_ctl_info *mci,
 				 struct i3000_error_info *info)
@@ -373,6 +374,17 @@ static int i3000_probe1(struct pci_dev *
 		goto fail;
 	}
 
+	/* allocating generic PCI control info */
+	i3000_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!i3000_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("MC: %s(): success\n", __func__);
 	return 0;
@@ -408,6 +420,9 @@ static void __devexit i3000_remove_one(s
 
 	debugf0("%s()\n", __func__);
 
+	if (i3000_pci)
+		edac_pci_release_generic_ctl(i3000_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/i5000_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/i5000_edac.c
@@ -28,6 +28,7 @@
  * Alter this version for the I5000 module when modifications are made
  */
 #define I5000_REVISION    " Ver: 2.0.12 " __DATE__
+#define EDAC_MOD_STR      "i5000_edac"
 
 #define i5000_printk(level, fmt, arg...) \
         edac_printk(level, "i5000", fmt, ##arg)
@@ -381,6 +382,8 @@ struct i5000_error_info {
 
 };
 
+static struct edac_pci_ctl_info *i5000_pci;
+
 /******************************************************************************
  *	i5000_get_error_info	Retrieve the hardware error information from
  *				the hardware and cache it in the 'info'
@@ -1375,6 +1378,17 @@ static int i5000_probe1(struct pci_dev *
 
 	i5000_clear_error(mci);
 
+	/* allocating generic PCI control info */
+	i5000_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!i5000_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	return 0;
 
 	/* Error exit unwinding stack */
@@ -1420,6 +1434,9 @@ static void __devexit i5000_remove_one(s
 
 	debugf0(__FILE__ ": %s()\n", __func__);
 
+	if (i5000_pci)
+		edac_pci_release_generic_ctl(i5000_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -111,6 +111,8 @@ struct i82443bxgx_edacmc_error_info {
 	u32 eap;
 };
 
+static struct edac_pci_ctl_info *i82443bxgx_pci;
+
 static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
 					     struct i82443bxgx_edacmc_error_info
 					     *info)
@@ -316,6 +318,17 @@ static int i82443bxgx_edacmc_probe1(stru
 		goto fail;
 	}
 
+	/* allocating generic PCI control info */
+	i82443bxgx_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!i82443bxgx_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	debugf3("MC: " __FILE__ ": %s(): success\n", __func__);
 	return 0;
 
@@ -342,6 +355,9 @@ static void __devexit i82443bxgx_edacmc_
 
 	debugf0(__FILE__ ": %s()\n", __func__);
 
+	if (i82443bxgx_pci)
+		edac_pci_release_generic_ctl(i82443bxgx_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/i82860_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/i82860_edac.c
@@ -60,6 +60,7 @@ static const struct i82860_dev_info i828
 static struct pci_dev *mci_pdev = NULL;	/* init dev: in case that AGP code
 					 * has already registered driver
 					 */
+static struct edac_pci_ctl_info *i82860_pci;
 
 static void i82860_get_error_info(struct mem_ctl_info *mci,
 				  struct i82860_error_info *info)
@@ -213,6 +214,17 @@ static int i82860_probe1(struct pci_dev 
 		goto fail;
 	}
 
+	/* allocating generic PCI control info */
+	i82860_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!i82860_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 
@@ -249,6 +261,9 @@ static void __devexit i82860_remove_one(
 
 	debugf0("%s()\n", __func__);
 
+	if (i82860_pci)
+		edac_pci_release_generic_ctl(i82860_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/i82875p_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/i82875p_edac.c
@@ -183,6 +183,8 @@ static struct pci_dev *mci_pdev = NULL;	
 
 static int i82875p_registered = 1;
 
+static struct edac_pci_ctl_info *i82875p_pci;
+
 static void i82875p_get_error_info(struct mem_ctl_info *mci,
 				   struct i82875p_error_info *info)
 {
@@ -424,6 +426,17 @@ static int i82875p_probe1(struct pci_dev
 		goto fail1;
 	}
 
+	/* allocating generic PCI control info */
+	i82875p_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!i82875p_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	/* get this far and it's successful */
 	debugf3("%s(): success\n", __func__);
 	return 0;
@@ -467,6 +480,9 @@ static void __devexit i82875p_remove_one
 
 	debugf0("%s()\n", __func__);
 
+	if (i82875p_pci)
+		edac_pci_release_generic_ctl(i82875p_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
diff -puN drivers/edac/r82600_edac.c~drivers-edac-drivers-to-use-new-pci-operation drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-drivers-to-use-new-pci-operation
+++ a/drivers/edac/r82600_edac.c
@@ -133,6 +133,8 @@ struct r82600_error_info {
 
 static unsigned int disable_hardware_scrub = 0;
 
+static struct edac_pci_ctl_info *r82600_pci;
+
 static void r82600_get_error_info(struct mem_ctl_info *mci,
 				  struct r82600_error_info *info)
 {
@@ -326,6 +328,17 @@ static int r82600_probe1(struct pci_dev 
 		pci_write_bits32(pdev, R82600_EAP, BIT(31), BIT(31));
 	}
 
+	/* allocating generic PCI control info */
+	r82600_pci = edac_pci_create_generic_ctl(&pdev->dev, EDAC_MOD_STR);
+	if (!r82600_pci) {
+		printk(KERN_WARNING
+			"%s(): Unable to create PCI control\n",
+			__func__);
+		printk(KERN_WARNING
+			"%s(): PCI error report via EDAC not setup\n",
+			__func__);
+	}
+
 	debugf3("%s(): success\n", __func__);
 	return 0;
 
@@ -350,6 +363,9 @@ static void __devexit r82600_remove_one(
 
 	debugf0("%s()\n", __func__);
 
+	if (r82600_pci)
+		edac_pci_release_generic_ctl(r82600_pci);
+
 	if ((mci = edac_mc_del_mc(&pdev->dev)) == NULL)
 		return;
 
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
