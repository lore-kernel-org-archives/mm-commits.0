From: akpm@linux-foundation.org
Subject: - drivers-net-tlanc-compilation-warning-fix.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:31:09 -0800
Message-ID: <200802070030.m170Uon2007425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51176 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934416AbYBGAs3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:48:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lpotenza@inwind.it, mm-commits@vger.kernel.org


The patch titled
     drivers/net/tlan.c: compilation warning fix
has been removed from the -mm tree.  Its filename was
     drivers-net-tlanc-compilation-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/net/tlan.c: compilation warning fix
From: Leonardo Potenza <lpotenza@inwind.it>

Add a check for the pci_register_driver() return value.  Removed unused
variable pad_allocated.

The aim of this patch is to remove the following warning messages:
drivers/net/tlan.c: In function 'tlan_probe':
drivers/net/tlan.c:486: warning: ignoring return value of 'pci_register_driver', declared with attribute warn_unused_result

Signed-off-by: Leonardo Potenza <lpotenza@inwind.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/tlan.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff -puN drivers/net/tlan.c~drivers-net-tlanc-compilation-warning-fix drivers/net/tlan.c
--- a/drivers/net/tlan.c~drivers-net-tlanc-compilation-warning-fix
+++ a/drivers/net/tlan.c
@@ -465,7 +465,7 @@ static struct pci_driver tlan_driver = {
 
 static int __init tlan_probe(void)
 {
-	static int	pad_allocated;
+	int rc = -ENODEV;
 
 	printk(KERN_INFO "%s", tlan_banner);
 
@@ -473,17 +473,22 @@ static int __init tlan_probe(void)
 
 	if (TLanPadBuffer == NULL) {
 		printk(KERN_ERR "TLAN: Could not allocate memory for pad buffer.\n");
-		return -ENOMEM;
+		rc = -ENOMEM;
+		goto err_out;
 	}
 
 	memset(TLanPadBuffer, 0, TLAN_MIN_FRAME_SIZE);
-	pad_allocated = 1;
 
 	TLAN_DBG(TLAN_DEBUG_PROBE, "Starting PCI Probe....\n");
 
 	/* Use new style PCI probing. Now the kernel will
 	   do most of this for us */
-	pci_register_driver(&tlan_driver);
+	rc = pci_register_driver(&tlan_driver);
+
+	if (rc != 0) {
+		printk(KERN_ERR "TLAN: Could not register pci driver.\n");
+		goto err_out_pci_free;
+	}
 
 	TLAN_DBG(TLAN_DEBUG_PROBE, "Starting EISA Probe....\n");
 	TLan_EisaProbe();
@@ -493,11 +498,17 @@ static int __init tlan_probe(void)
 		 tlan_have_pci, tlan_have_eisa);
 
 	if (TLanDevicesInstalled == 0) {
-		pci_unregister_driver(&tlan_driver);
-		pci_free_consistent(NULL, TLAN_MIN_FRAME_SIZE, TLanPadBuffer, TLanPadBufferDMA);
-		return -ENODEV;
+		rc = -ENODEV;
+		goto  err_out_pci_unreg;
 	}
 	return 0;
+
+err_out_pci_unreg:
+	pci_unregister_driver(&tlan_driver);
+err_out_pci_free:
+	pci_free_consistent(NULL, TLAN_MIN_FRAME_SIZE, TLanPadBuffer, TLanPadBufferDMA);
+err_out:
+	return rc;
 }
 
 
_

Patches currently in -mm which might be from lpotenza@inwind.it are

origin.patch
