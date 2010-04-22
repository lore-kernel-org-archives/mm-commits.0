From: akpm@linux-foundation.org
Subject: + drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file.patch added to -mm tree
Date: Thu, 22 Apr 2010 13:36:13 -0700
Message-ID: <201004222036.o3MKaDqV007806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38567 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758471Ab0DVUhe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Apr 2010 16:37:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, dougthompson@xmission.com, mchehab@redhat.com, tim@buttersideup.com


The patch titled
     drivers/edac: convert logging messages direct uses of __FILE__ to %s, __FILE
has been added to the -mm tree.  Its filename is
     drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file.patch

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
Subject: drivers/edac: convert logging messages direct uses of __FILE__ to %s, __FILE
From: Joe Perches <joe@perches.com>

Reduces text by eliminating multiple __FILE__ uses.

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tim Small <tim@buttersideup.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i5000_edac.c      |   20 ++++++++++----------
 drivers/edac/i5400_edac.c      |   20 ++++++++++----------
 drivers/edac/i82443bxgx_edac.c |   20 ++++++++++----------
 3 files changed, 30 insertions(+), 30 deletions(-)

diff -puN drivers/edac/i5000_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file drivers/edac/i5000_edac.c
--- a/drivers/edac/i5000_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file
+++ a/drivers/edac/i5000_edac.c
@@ -774,7 +774,7 @@ static void i5000_clear_error(struct mem
 static void i5000_check_error(struct mem_ctl_info *mci)
 {
 	struct i5000_error_info info;
-	debugf4("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i5000_get_error_info(mci, &info);
 	i5000_process_error_info(mci, &info, 1);
 }
@@ -1353,8 +1353,8 @@ static int i5000_probe1(struct pci_dev *
 	int num_dimms_per_channel;
 	int num_csrows;
 
-	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__func__,
+	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, __func__,
 		pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
@@ -1389,7 +1389,7 @@ static int i5000_probe1(struct pci_dev *
 		return -ENOMEM;
 
 	kobject_get(&mci->edac_mci_kobj);
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1432,8 +1432,8 @@ static int i5000_probe1(struct pci_dev *
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
+			__FILE__, __func__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1478,7 +1478,7 @@ static int __devinit i5000_init_one(stru
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1497,7 +1497,7 @@ static void __devexit i5000_remove_one(s
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i5000_pci)
 		edac_pci_release_generic_ctl(i5000_pci);
@@ -1544,7 +1544,7 @@ static int __init i5000_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
@@ -1560,7 +1560,7 @@ static int __init i5000_init(void)
  */
 static void __exit i5000_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 	pci_unregister_driver(&i5000_driver);
 }
 
diff -puN drivers/edac/i5400_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file drivers/edac/i5400_edac.c
--- a/drivers/edac/i5400_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file
+++ a/drivers/edac/i5400_edac.c
@@ -694,7 +694,7 @@ static void i5400_clear_error(struct mem
 static void i5400_check_error(struct mem_ctl_info *mci)
 {
 	struct i5400_error_info info;
-	debugf4("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf4("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i5400_get_error_info(mci, &info);
 	i5400_process_error_info(mci, &info);
 }
@@ -1227,8 +1227,8 @@ static int i5400_probe1(struct pci_dev *
 	if (dev_idx >= ARRAY_SIZE(i5400_devs))
 		return -EINVAL;
 
-	debugf0("MC: " __FILE__ ": %s(), pdev bus %u dev=0x%x fn=0x%x\n",
-		__func__,
+	debugf0("MC: %s: %s(), pdev bus %u dev=0x%x fn=0x%x\n",
+		__FILE__, __func__,
 		pdev->bus->number,
 		PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
 
@@ -1256,7 +1256,7 @@ static int i5400_probe1(struct pci_dev *
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 
 	mci->dev = &pdev->dev;	/* record ptr  to the generic device */
 
@@ -1299,8 +1299,8 @@ static int i5400_probe1(struct pci_dev *
 
 	/* add this new MC control structure to EDAC's list of MCs */
 	if (edac_mc_add_mc(mci)) {
-		debugf0("MC: " __FILE__
-			": %s(): failed edac_mc_add_mc()\n", __func__);
+		debugf0("MC: %s: %s(): failed edac_mc_add_mc()\n",
+			__FILE__, __func__);
 		/* FIXME: perhaps some code should go here that disables error
 		 * reporting if we just enabled it
 		 */
@@ -1344,7 +1344,7 @@ static int __devinit i5400_init_one(stru
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* wake up device */
 	rc = pci_enable_device(pdev);
@@ -1363,7 +1363,7 @@ static void __devexit i5400_remove_one(s
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i5400_pci)
 		edac_pci_release_generic_ctl(i5400_pci);
@@ -1409,7 +1409,7 @@ static int __init i5400_init(void)
 {
 	int pci_rc;
 
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* Ensure that the OPSTATE is set correctly for POLL or NMI */
 	opstate_init();
@@ -1425,7 +1425,7 @@ static int __init i5400_init(void)
  */
 static void __exit i5400_exit(void)
 {
-	debugf2("MC: " __FILE__ ": %s()\n", __func__);
+	debugf2("MC: %s: %s()\n", __FILE__, __func__);
 	pci_unregister_driver(&i5400_driver);
 }
 
diff -puN drivers/edac/i82443bxgx_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -178,7 +178,7 @@ static void i82443bxgx_edacmc_check(stru
 {
 	struct i82443bxgx_edacmc_error_info info;
 
-	debugf1("MC%d: " __FILE__ ": %s()\n", mci->mc_idx, __func__);
+	debugf1("MC%d: %s: %s()\n", mci->mc_idx, __FILE__, __func__);
 	i82443bxgx_edacmc_get_error_info(mci, &info);
 	i82443bxgx_edacmc_process_error_info(mci, &info, 1);
 }
@@ -198,13 +198,13 @@ static void i82443bxgx_init_csrows(struc
 	for (index = 0; index < mci->nr_csrows; index++) {
 		csrow = &mci->csrows[index];
 		pci_read_config_byte(pdev, I82443BXGX_DRB + index, &drbar);
-		debugf1("MC%d: " __FILE__ ": %s() Row=%d DRB = %#0x\n",
-			mci->mc_idx, __func__, index, drbar);
+		debugf1("MC%d: %s: %s() Row=%d DRB = %#0x\n",
+			mci->mc_idx, __FILE__, __func__, index, drbar);
 		row_high_limit = ((u32) drbar << 23);
 		/* find the DRAM Chip Select Base address and mask */
-		debugf1("MC%d: " __FILE__ ": %s() Row=%d, "
+		debugf1("MC%d: %s: %s() Row=%d, "
 			"Boundry Address=%#0x, Last = %#0x \n",
-			mci->mc_idx, __func__, index, row_high_limit,
+			mci->mc_idx, __FILE__, __func__, index, row_high_limit,
 			row_high_limit_last);
 
 		/* 440GX goes to 2GB, represented with a DRB of 0. */
@@ -237,7 +237,7 @@ static int i82443bxgx_edacmc_probe1(stru
 	enum mem_type mtype;
 	enum edac_type edac_mode;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* Something is really hosed if PCI config space reads from
 	 * the MC aren't working.
@@ -250,7 +250,7 @@ static int i82443bxgx_edacmc_probe1(stru
 	if (mci == NULL)
 		return -ENOMEM;
 
-	debugf0("MC: " __FILE__ ": %s(): mci = %p\n", __func__, mci);
+	debugf0("MC: %s: %s(): mci = %p\n", __FILE__, __func__, mci);
 	mci->dev = &pdev->dev;
 	mci->mtype_cap = MEM_FLAG_EDO | MEM_FLAG_SDR | MEM_FLAG_RDR;
 	mci->edac_ctl_cap = EDAC_FLAG_NONE | EDAC_FLAG_EC | EDAC_FLAG_SECDED;
@@ -336,7 +336,7 @@ static int i82443bxgx_edacmc_probe1(stru
 			__func__);
 	}
 
-	debugf3("MC: " __FILE__ ": %s(): success\n", __func__);
+	debugf3("MC: %s: %s(): success\n", __FILE__, __func__);
 	return 0;
 
 fail:
@@ -352,7 +352,7 @@ static int __devinit i82443bxgx_edacmc_i
 {
 	int rc;
 
-	debugf0("MC: " __FILE__ ": %s()\n", __func__);
+	debugf0("MC: %s: %s()\n", __FILE__, __func__);
 
 	/* don't need to call pci_device_enable() */
 	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
@@ -367,7 +367,7 @@ static void __devexit i82443bxgx_edacmc_
 {
 	struct mem_ctl_info *mci;
 
-	debugf0(__FILE__ ": %s()\n", __func__);
+	debugf0("%s: %s()\n", __FILE__, __func__);
 
 	if (i82443bxgx_pci)
 		edac_pci_release_generic_ctl(i82443bxgx_pci);
_

Patches currently in -mm which might be from joe@perches.com are

linux-next.patch
cifs-provide-user-with-a-hint-when-name-resolution-fails-fix.patch
drivers-scsi-correct-the-size-argument-to-kmalloc.patch
drivers-scsi-qla2xxx-qla_osc-fix-continuation-line-formats.patch
drivers-scsi-chc-dont-use-vprintk-as-macro.patch
vsprintfc-use-noinline_for_stack.patch
lib-hexdumpc-reduce-stack-variable-size-and-cleanups.patch
drivers-edac-convert-logging-messages-direct-uses-of-__file__-to-%s-__file.patch

