From: akpm@linux-foundation.org
Subject: - drivers-edac-add-dev_name-getter-function.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:05:46 -0700
Message-ID: <200707192005.l6JK5k7P020069@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59452 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761208AbXGSUPp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:15:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: djiang@mvista.com, dougthompson@xmission.com, mm-commits@vger.kernel.org


The patch titled
     drivers/edac: add dev_name getter function
has been removed from the -mm tree.  Its filename was
     drivers-edac-add-dev_name-getter-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: drivers/edac: add dev_name getter function
From: Dave Jiang <djiang@mvista.com>

Move dev_name() macro to a more generic interface since it's not possible
to determine whether a device is pci, platform, or of_device easily.

Now each low level driver sets the name into the control structure, and
the EDAC core references the control structure for the information.

Better abstraction.

Signed-off-by: Dave Jiang <djiang@mvista.com>
Signed-off-by: Douglas Thompson <dougthompson@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/amd76x_edac.c     |    1 +
 drivers/edac/e752x_edac.c      |    1 +
 drivers/edac/e7xxx_edac.c      |    1 +
 drivers/edac/edac_core.h       |    8 +++-----
 drivers/edac/edac_device.c     |    6 +++---
 drivers/edac/edac_mc.c         |    6 +++---
 drivers/edac/i5000_edac.c      |    1 +
 drivers/edac/i82443bxgx_edac.c |    1 +
 drivers/edac/i82860_edac.c     |    1 +
 drivers/edac/i82875p_edac.c    |    1 +
 drivers/edac/r82600_edac.c     |    3 ++-
 11 files changed, 18 insertions(+), 12 deletions(-)

diff -puN drivers/edac/amd76x_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/amd76x_edac.c
--- a/drivers/edac/amd76x_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/amd76x_edac.c
@@ -253,6 +253,7 @@ static int amd76x_probe1(struct pci_dev 
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = AMD76X_REVISION;
 	mci->ctl_name = amd76x_devs[dev_idx].ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = amd76x_check;
 	mci->ctl_page_to_phys = NULL;
 
diff -puN drivers/edac/e752x_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/e752x_edac.c
--- a/drivers/edac/e752x_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/e752x_edac.c
@@ -1004,6 +1004,7 @@ static int e752x_probe1(struct pci_dev *
 
 	debugf3("%s(): more mci init\n", __func__);
 	mci->ctl_name = pvt->dev_info->ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e752x_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
 
diff -puN drivers/edac/e7xxx_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/e7xxx_edac.c
--- a/drivers/edac/e7xxx_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/e7xxx_edac.c
@@ -463,6 +463,7 @@ static int e7xxx_probe1(struct pci_dev *
 
 	debugf3("%s(): more mci init\n", __func__);
 	mci->ctl_name = pvt->dev_info->ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = e7xxx_check;
 	mci->ctl_page_to_phys = ctl_page_to_phys;
 	e7xxx_init_csrows(mci, pdev, dev_idx, drc);
diff -puN drivers/edac/edac_core.h~drivers-edac-add-dev_name-getter-function drivers/edac/edac_core.h
--- a/drivers/edac/edac_core.h~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/edac_core.h
@@ -95,11 +95,7 @@ extern int edac_debug_level;
 #define PCI_VEND_DEV(vend, dev) PCI_VENDOR_ID_ ## vend, \
 	PCI_DEVICE_ID_ ## vend ## _ ## dev
 
-#if defined(CONFIG_X86) && defined(CONFIG_PCI)
-#define dev_name(dev) pci_name(to_pci_dev(dev))
-#else
-#define dev_name(dev) to_platform_device(dev)->name
-#endif
+#define dev_name(dev) (dev)->dev_name
 
 /* memory devices */
 enum dev_type {
@@ -368,6 +364,7 @@ struct mem_ctl_info {
 	const char *mod_name;
 	const char *mod_ver;
 	const char *ctl_name;
+	const char *dev_name;
 	char proc_name[MC_PROC_NAME_MAX_LEN + 1];
 	void *pvt_info;
 	u32 ue_noinfo_count;	/* Uncorrectable Errors w/o info */
@@ -538,6 +535,7 @@ struct edac_device_ctl_info {
 
 	const char *mod_name;	/* module name */
 	const char *ctl_name;	/* edac controller  name */
+	const char *dev_name;	/* pci/platform/etc... name */
 
 	void *pvt_info;		/* pointer to 'private driver' info */
 
diff -puN drivers/edac/edac_device.c~drivers-edac-add-dev_name-getter-function drivers/edac/edac_device.c
--- a/drivers/edac/edac_device.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/edac_device.c
@@ -264,7 +264,7 @@ static int add_edac_dev_to_global_list (
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 		"%s (%s) %s %s already assigned %d\n",
-		rover->dev->bus_id, dev_name(rover->dev),
+		rover->dev->bus_id, dev_name(rover),
 		rover->mod_name, rover->ctl_name, rover->dev_idx);
 	return 1;
 
@@ -491,7 +491,7 @@ int edac_device_add_device(struct edac_d
 		"Giving out device to module '%s' controller '%s': DEV '%s' (%s)\n",
 		edac_dev->mod_name,
 		edac_dev->ctl_name,
-		dev_name(edac_dev->dev),
+		dev_name(edac_dev),
 		edac_op_state_toString(edac_dev)
 		);
 
@@ -553,7 +553,7 @@ struct edac_device_ctl_info * edac_devic
 		edac_dev->dev_idx,
 		edac_dev->mod_name,
 		edac_dev->ctl_name,
-		dev_name(edac_dev->dev));
+		dev_name(edac_dev));
 
 	return edac_dev;
 }
diff -puN drivers/edac/edac_mc.c~drivers-edac-add-dev_name-getter-function drivers/edac/edac_mc.c
--- a/drivers/edac/edac_mc.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/edac_mc.c
@@ -248,7 +248,7 @@ static int add_mc_to_global_list (struct
 fail0:
 	edac_printk(KERN_WARNING, EDAC_MC,
 		    "%s (%s) %s %s already assigned %d\n", p->dev->bus_id,
-		    dev_name(p->dev), p->mod_name, p->ctl_name, p->mc_idx);
+		    dev_name(mci), p->mod_name, p->ctl_name, p->mc_idx);
 	return 1;
 
 fail1:
@@ -353,7 +353,7 @@ int edac_mc_add_mc(struct mem_ctl_info *
 
 	/* Report action taken */
 	edac_mc_printk(mci, KERN_INFO, "Giving out device to %s %s: DEV %s\n",
-		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
+		mci->mod_name, mci->ctl_name, dev_name(mci));
 
 	mutex_unlock(&mem_ctls_mutex);
 	return 0;
@@ -391,7 +391,7 @@ struct mem_ctl_info * edac_mc_del_mc(str
 	mutex_unlock(&mem_ctls_mutex);
 	edac_printk(KERN_INFO, EDAC_MC,
 		"Removed device %d for %s %s: DEV %s\n", mci->mc_idx,
-		mci->mod_name, mci->ctl_name, dev_name(mci->dev));
+		mci->mod_name, mci->ctl_name, dev_name(mci));
 	return mci;
 }
 EXPORT_SYMBOL_GPL(edac_mc_del_mc);
diff -puN drivers/edac/i5000_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/i5000_edac.c
@@ -1345,6 +1345,7 @@ static int i5000_probe1(struct pci_dev *
 	mci->mod_name = "i5000_edac.c";
 	mci->mod_ver = I5000_REVISION;
 	mci->ctl_name = i5000_devs[dev_idx].ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->ctl_page_to_phys = NULL;
 
 	/* Set the function pointer to an actual operation function */
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -318,6 +318,7 @@ static int  i82443bxgx_edacmc_probe1(str
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82443_REVISION;
 	mci->ctl_name = "I82443BXGX";
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82443bxgx_edacmc_check;
 	mci->ctl_page_to_phys = NULL;
 
diff -puN drivers/edac/i82860_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/i82860_edac.c
--- a/drivers/edac/i82860_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/i82860_edac.c
@@ -200,6 +200,7 @@ static int i82860_probe1(struct pci_dev 
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82860_REVISION;
 	mci->ctl_name = i82860_devs[dev_idx].ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82860_check;
 	mci->ctl_page_to_phys = NULL;
 	i82860_init_csrows(mci, pdev);
diff -puN drivers/edac/i82875p_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/i82875p_edac.c
--- a/drivers/edac/i82875p_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/i82875p_edac.c
@@ -407,6 +407,7 @@ static int i82875p_probe1(struct pci_dev
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = I82875P_REVISION;
 	mci->ctl_name = i82875p_devs[dev_idx].ctl_name;
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = i82875p_check;
 	mci->ctl_page_to_phys = NULL;
 	debugf3("%s(): init pvt\n", __func__);
diff -puN drivers/edac/r82600_edac.c~drivers-edac-add-dev_name-getter-function drivers/edac/r82600_edac.c
--- a/drivers/edac/r82600_edac.c~drivers-edac-add-dev_name-getter-function
+++ a/drivers/edac/r82600_edac.c
@@ -11,7 +11,7 @@
  *
  * Written with reference to 82600 High Integration Dual PCI System
  * Controller Data Book:
- * http://www.radisys.com/files/support_downloads/007-01277-0002.82600DataBook.pdf
+ * www.radisys.com/files/support_downloads/007-01277-0002.82600DataBook.pdf
  * references to this document given in []
  */
 
@@ -305,6 +305,7 @@ static int r82600_probe1(struct pci_dev 
 	mci->mod_name = EDAC_MOD_STR;
 	mci->mod_ver = R82600_REVISION;
 	mci->ctl_name = "R82600";
+	mci->dev_name = pci_name(pdev);
 	mci->edac_check = r82600_check;
 	mci->ctl_page_to_phys = NULL;
 	r82600_init_csrows(mci, pdev, dramcr);
_

Patches currently in -mm which might be from djiang@mvista.com are

origin.patch
