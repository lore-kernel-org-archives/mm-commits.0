From: akpm@linux-foundation.org
Subject: - make-i82443bxgx_edac-coexist-with-intel_agp.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:19:18 -0700
Message-ID: <200810182319.m9INJIdh029465@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbYJRXTe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:19:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: slava_reg@nsys.by, airlied@linux.ie, norsk5@yahoo.com, slava@nsys.by, mm-commits@vger.kernel.org


The patch titled
     edac: make i82443bxgx_edac coexist with intel_agp
has been removed from the -mm tree.  Its filename was
     make-i82443bxgx_edac-coexist-with-intel_agp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: edac: make i82443bxgx_edac coexist with intel_agp
From: Vladislav Bogdanov <slava_reg@nsys.by>

Fix 443BX/GX MCH suppport in a EDAC.

It makes i82443bxgx_edac coexist with intel_agp using the same approach as
several other EDAC drivers.

Tested on Intel's L443GX with redhat's 2.6.18 with whole EDAC subsystem
backported a while ago.

[root@host ~]# dmesg|grep -iE '(AGP|EDAC)'
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected an Intel 440GX Chipset.
agpgart: AGP aperture is 64M @ 0xf8000000
EDAC MC: Ver: 2.1.0 Jun 27 2008
EDAC MC0: Giving out device to 'i82443bxgx_edac' 'I82443BXGX': DEV 0000:00:00.0
EDAC PCI0: Giving out device to module 'i82443bxgx_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)

Signed-off-by: Vladislav Bogdanov <slava@nsys.by>
Cc: Doug Thompson <norsk5@yahoo.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/edac/i82443bxgx_edac.c |   63 ++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 2 deletions(-)

diff -puN drivers/edac/i82443bxgx_edac.c~make-i82443bxgx_edac-coexist-with-intel_agp drivers/edac/i82443bxgx_edac.c
--- a/drivers/edac/i82443bxgx_edac.c~make-i82443bxgx_edac-coexist-with-intel_agp
+++ a/drivers/edac/i82443bxgx_edac.c
@@ -114,6 +114,12 @@ struct i82443bxgx_edacmc_error_info {
 
 static struct edac_pci_ctl_info *i82443bxgx_pci;
 
+static struct pci_dev *mci_pdev;	/* init dev: in case that AGP code has
+					 * already registered driver
+					 */
+
+static int i82443bxgx_registered = 1;
+
 static void i82443bxgx_edacmc_get_error_info(struct mem_ctl_info *mci,
 				struct i82443bxgx_edacmc_error_info
 				*info)
@@ -345,10 +351,17 @@ EXPORT_SYMBOL_GPL(i82443bxgx_edacmc_prob
 static int __devinit i82443bxgx_edacmc_init_one(struct pci_dev *pdev,
 						const struct pci_device_id *ent)
 {
+	int rc;
+
 	debugf0("MC: " __FILE__ ": %s()\n", __func__);
 
 	/* don't need to call pci_device_enable() */
-	return i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
+	rc = i82443bxgx_edacmc_probe1(pdev, ent->driver_data);
+
+	if (mci_pdev == NULL)
+		mci_pdev = pci_dev_get(pdev);
+
+	return rc;
 }
 
 static void __devexit i82443bxgx_edacmc_remove_one(struct pci_dev *pdev)
@@ -387,15 +400,61 @@ static struct pci_driver i82443bxgx_edac
 
 static int __init i82443bxgx_edacmc_init(void)
 {
+	int pci_rc;
        /* Ensure that the OPSTATE is set correctly for POLL or NMI */
        opstate_init();
 
-	return pci_register_driver(&i82443bxgx_edacmc_driver);
+	pci_rc = pci_register_driver(&i82443bxgx_edacmc_driver);
+	if (pci_rc < 0)
+		goto fail0;
+
+	if (mci_pdev == NULL) {
+		const struct pci_device_id *id = &i82443bxgx_pci_tbl[0];
+		int i = 0;
+		i82443bxgx_registered = 0;
+
+		while (mci_pdev == NULL && id->vendor != 0) {
+			mci_pdev = pci_get_device(id->vendor,
+					id->device, NULL);
+			i++;
+			id = &i82443bxgx_pci_tbl[i];
+		}
+		if (!mci_pdev) {
+			debugf0("i82443bxgx pci_get_device fail\n");
+			pci_rc = -ENODEV;
+			goto fail1;
+		}
+
+		pci_rc = i82443bxgx_edacmc_init_one(mci_pdev, i82443bxgx_pci_tbl);
+
+		if (pci_rc < 0) {
+			debugf0("i82443bxgx init fail\n");
+			pci_rc = -ENODEV;
+			goto fail1;
+		}
+	}
+
+	return 0;
+
+fail1:
+	pci_unregister_driver(&i82443bxgx_edacmc_driver);
+
+fail0:
+	if (mci_pdev != NULL)
+		pci_dev_put(mci_pdev);
+
+	return pci_rc;
 }
 
 static void __exit i82443bxgx_edacmc_exit(void)
 {
 	pci_unregister_driver(&i82443bxgx_edacmc_driver);
+
+	if (!i82443bxgx_registered)
+		i82443bxgx_edacmc_remove_one(mci_pdev);
+
+	if (mci_pdev)
+		pci_dev_put(mci_pdev);
 }
 
 module_init(i82443bxgx_edacmc_init);
_

Patches currently in -mm which might be from slava_reg@nsys.by are

origin.patch

