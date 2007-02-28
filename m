From: akpm@linux-foundation.org
Subject: + aer-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 27 Feb 2007 22:29:56 -0800
Message-ID: <200702280630.l1S6U0ap008818@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXB1GaE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Feb 2007 01:30:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, greg@kroah.com


The patch titled
     aer: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     aer-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aer: fix section mismatch warning
From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning (when compiled with CONFIG_HOTPLUG=n):

WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:aer_probe from .data between 'aerdrv' (at offset 0x1608) and 'aer_error_handlers'

Warning was fixed by renaming aerdrv to aerdriver so we pass the whitelist.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/pcie/aer/aerdrv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/pci/pcie/aer/aerdrv.c~aer-fix-section-mismatch-warning drivers/pci/pcie/aer/aerdrv.c
--- a/drivers/pci/pcie/aer/aerdrv.c~aer-fix-section-mismatch-warning
+++ a/drivers/pci/pcie/aer/aerdrv.c
@@ -66,7 +66,7 @@ static struct pci_error_handlers aer_err
 	.resume = aer_error_resume,
 };
 
-static struct pcie_port_service_driver aerdrv = {
+static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
 	.id_table	= &aer_id[0],
 
@@ -328,7 +328,7 @@ static void aer_error_resume(struct pci_
  **/
 static int __init aer_service_init(void)
 {
-	return pcie_port_service_register(&aerdrv);
+	return pcie_port_service_register(&aerdriver);
 }
 
 /**
@@ -338,7 +338,7 @@ static int __init aer_service_init(void)
  **/
 static void __exit aer_service_exit(void)
 {
-	pcie_port_service_unregister(&aerdrv);
+	pcie_port_service_unregister(&aerdriver);
 }
 
 module_init(aer_service_init);
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
