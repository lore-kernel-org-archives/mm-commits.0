From: akpm@linux-foundation.org
Subject: - ioatdma-fix-section-mismatches.patch removed from -mm tree
Date: Fri, 29 Jun 2007 13:40:37 -0700
Message-ID: <200706292040.l5TKebhY022439@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41525 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754942AbXF2Uuf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 29 Jun 2007 16:50:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, akpm@linux-foundation.org, christopher.leech@intel.com, sam@ravnborg.org, mm-commits@vger.kernel.org


The patch titled
     IOATDMA: fix section mismatches
has been removed from the -mm tree.  Its filename was
     ioatdma-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Chris Leech <christopher.leech@intel.com>
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

origin.patch
alsa-more-section-mismatches.patch
pcih-stubs-for-edd-build-error.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
romfs-printk-format-warnings.patch
ubi-one-less-bug-usage.patch
add-pci_try_set_mwi.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
irda-fix-printk-format.patch
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
doc-oops-tracing-add-code-decode-info-fix.patch
schedstats-fix-printk-format.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
profile-likely-unlikely-macros.patch
