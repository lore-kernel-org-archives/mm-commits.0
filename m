From: akpm@linux-foundation.org
Subject: - cciss-fix-debug-printk-formats.patch removed from -mm tree
Date: Thu, 20 Nov 2008 12:43:36 -0800
Message-ID: <200811202043.mAKKha4X007579@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755436AbYKTUoO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Nov 2008 15:44:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mike.miller@hp.com, mm-commits@vger.kernel.org


The patch titled
     cciss: fix DEBUG printk formats
has been removed from the -mm tree.  Its filename was
     cciss-fix-debug-printk-formats.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cciss: fix DEBUG printk formats
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix printk format warnings when CCISS_DEBUG is defined.

drivers/block/cciss.c:2856: warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3205: warning: format '%x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
drivers/block/cciss.c:3236: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'
drivers/block/cciss.c:3246: warning: format '%x' expects type 'unsigned int', but argument 2 has type '__u64'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/cciss.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/block/cciss.c~cciss-fix-debug-printk-formats drivers/block/cciss.c
--- a/drivers/block/cciss.c~cciss-fix-debug-printk-formats
+++ a/drivers/block/cciss.c
@@ -2847,7 +2847,7 @@ static void do_cciss_request(struct requ
 		h->maxSG = seg;
 
 #ifdef CCISS_DEBUG
-	printk(KERN_DEBUG "cciss: Submitting %d sectors in %d segments\n",
+	printk(KERN_DEBUG "cciss: Submitting %lu sectors in %d segments\n",
 	       creq->nr_sectors, seg);
 #endif				/* CCISS_DEBUG */
 
@@ -3197,7 +3197,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	c->paddr = pci_resource_start(pdev, 0);	/* addressing mode bits already removed */
 #ifdef CCISS_DEBUG
-	printk("address 0 = %x\n", c->paddr);
+	printk("address 0 = %lx\n", c->paddr);
 #endif				/* CCISS_DEBUG */
 	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 
@@ -3224,7 +3224,8 @@ static int __devinit cciss_pci_init(ctlr
 #endif				/* CCISS_DEBUG */
 	cfg_base_addr_index = find_PCI_BAR_index(pdev, cfg_base_addr);
 #ifdef CCISS_DEBUG
-	printk("cfg base address index = %x\n", cfg_base_addr_index);
+	printk("cfg base address index = %llx\n",
+		(unsigned long long)cfg_base_addr_index);
 #endif				/* CCISS_DEBUG */
 	if (cfg_base_addr_index == -1) {
 		printk(KERN_WARNING "cciss: Cannot find cfg_base_addr_index\n");
@@ -3234,7 +3235,7 @@ static int __devinit cciss_pci_init(ctlr
 
 	cfg_offset = readl(c->vaddr + SA5_CTMEM_OFFSET);
 #ifdef CCISS_DEBUG
-	printk("cfg offset = %x\n", cfg_offset);
+	printk("cfg offset = %llx\n", (unsigned long long)cfg_offset);
 #endif				/* CCISS_DEBUG */
 	c->cfgtable = remap_pci_mem(pci_resource_start(pdev,
 						       cfg_base_addr_index) +
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
drivers-ata-pata_radisysc-cleanup-kernel-doc.patch
drivers-ata-libata-corec-cleanup-kernel-doc.patch
drivers-ata-pata_oldpiixc-cleanup-kernel-doc.patch
drivers-ata-pata_pdc2027xc-cleanup-kernel-doc.patch
drivers-ata-pata_legacyc-cleanup-kernel-doc.patch
drivers-ata-pata_sisc-cleanup-kernel-doc.patch
drivers-ata-pata_c-the-rest-remove-redundant-comments.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
fusion-remove-excess-kernel-doc-notation.patch
block-remove-excess-kernel-doc.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
drivers-message-i2o-iopc-cleanup-kerneldoc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
profile-likely-unlikely-macros.patch

