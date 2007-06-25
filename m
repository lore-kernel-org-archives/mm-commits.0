From: akpm@linux-foundation.org
Subject: + ioatdma-fix-section-mismatches.patch added to -mm tree
Date: Mon, 25 Jun 2007 15:06:13 -0700
Message-ID: <200706252206.l5PM6DwB012116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47347 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375AbXFYWGt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 18:06:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, akpm@linux-foundation.org, christopher.leech@intel.com, sam@ravnborg.org


The patch titled
     IOATDMA: fix section mismatches
has been added to the -mm tree.  Its filename is
     ioatdma-fix-section-mismatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IOATDMA: fix section mismatches
From: Randy Dunlap <randy.dunlap@oracle.com>

Rename struct pci_driver data so that false section mismatch warnings won't
be produced.

Sam, ISTM that depending on variable names is the weakest & worst part of
modpost section checking.  Should __init_refok work here?  I got build
errors when I tried to use it, probably because the struct pci_driver probe
and remove methods are not marked "__init_refok".

WARNING: drivers/dma/ioatdma.o(.data+0x10): Section mismatch: reference to .init.text: (between 'ioat_pci_drv' and 'ioat_pci_tbl')
WARNING: drivers/dma/ioatdma.o(.data+0x14): Section mismatch: reference to .exit.text: (between 'ioat_pci_drv' and 'ioat_pci_tbl')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Chris Leech <christopher.leech@intel.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/dma/ioatdma.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/dma/ioatdma.c~ioatdma-fix-section-mismatches drivers/dma/ioatdma.c
--- a/drivers/dma/ioatdma.c~ioatdma-fix-section-mismatches
+++ a/drivers/dma/ioatdma.c
@@ -556,7 +556,7 @@ static struct pci_device_id ioat_pci_tbl
 	{ 0, }
 };
 
-static struct pci_driver ioat_pci_drv = {
+static struct pci_driver ioat_pci_driver = {
 	.name 	= "ioatdma",
 	.id_table = ioat_pci_tbl,
 	.probe	= ioat_probe,
@@ -699,7 +699,7 @@ static int __devinit ioat_probe(struct p
 	if (err)
 		goto err_set_dma_mask;
 
-	err = pci_request_regions(pdev, ioat_pci_drv.name);
+	err = pci_request_regions(pdev, ioat_pci_driver.name);
 	if (err)
 		goto err_request_regions;
 
@@ -828,14 +828,14 @@ static int __init ioat_init_module(void)
 	/* if forced, worst case is that rmmod hangs */
 	__unsafe(THIS_MODULE);
 
-	return pci_register_driver(&ioat_pci_drv);
+	return pci_register_driver(&ioat_pci_driver);
 }
 
 module_init(ioat_init_module);
 
 static void __exit ioat_exit_module(void)
 {
-	pci_unregister_driver(&ioat_pci_drv);
+	pci_unregister_driver(&ioat_pci_driver);
 }
 
 module_exit(ioat_exit_module);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

eventfd-clean-compile-when-config_eventfd=n.patch
mtrr-cyrix-fix-sections.patch
ioatdma-fix-section-mismatches.patch
git-acpi.patch
romfs-printk-format-warnings.patch
mtd-use-null-for-pointer.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
kconfig-no-strange-misc-devices.patch
afs-drop-explicit-extern.patch
add-printktime-option-deprecate-time.patch
fs-clarify-dummy-member-in-struct.patch
sony-laptop-use-null-for-pointer.patch
hugetlbfs-use-lib-parser-fix-docs.patch
report-that-kernel-is-tainted-if-there-were-an-oops-before.patch
doc-oops-tracing-add-code-decode-info.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
