From: akpm@linux-foundation.org
Subject: + pcie-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:29:52 -0800
Message-ID: <200702280629.l1S6TuZG008815@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41992 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967AbXB1GaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:30:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, greg@kroah.com


The patch titled
     pcie: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     pcie-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pcie: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning (when compiled with
CONFIG_HOTPLUG=n):

WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:pcie_portdrv_probe from .data between 'pcie_portdrv' (at offset 0xe40) and 'pcie_portdrv_err_handler'

This warning was fixed by renaming pcie_portdrv to pcie_portdriver so we
pass the whitelist.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/portdrv_pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pci/pcie/portdrv_pci.c~pcie-fix-section-mismatch-warning drivers/pci/pcie/portdrv_pci.c
--- a/drivers/pci/pcie/portdrv_pci.c~pcie-fix-section-mismatch-warning
+++ a/drivers/pci/pcie/portdrv_pci.c
@@ -276,7 +276,7 @@ static struct pci_error_handlers pcie_po
 		.resume = pcie_portdrv_err_resume,
 };
 
-static struct pci_driver pcie_portdrv = {
+static struct pci_driver pcie_portdriver = {
 	.name		= (char *)device_name,
 	.id_table	= &port_pci_ids[0],
 
@@ -298,7 +298,7 @@ static int __init pcie_portdrv_init(void
 		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
 		goto out;
 	}
-	retval = pci_register_driver(&pcie_portdrv);
+	retval = pci_register_driver(&pcie_portdriver);
 	if (retval)
 		pcie_port_bus_unregister();
  out:
@@ -307,7 +307,7 @@ static int __init pcie_portdrv_init(void
 
 static void __exit pcie_portdrv_exit(void) 
 {
-	pci_unregister_driver(&pcie_portdrv);
+	pci_unregister_driver(&pcie_portdriver);
 	pcie_port_bus_unregister();
 }
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

fix-section-mismatch-warning-in-lockdep.patch
kbuild-override-build-timestamp.patch
kbuild-add-the-code-maturity-levels-deprecated-and-obsolete.patch
kconfig-abort-configuration-with-recursive-dependencies.patch
allow-kernel-to-build-on-cygwin.patch
git-lxdialog.patch
git-parisc.patch
pcie-fix-section-mismatch-warning.patch
aer-fix-section-mismatch-warning.patch
pci-do-not-mark-exported-functions-as-__devinit.patch
x86_64-fix-section-mismatch-warnings.patch
fix-section-mismatch-warning-in-lib-swiotlbc.patch
