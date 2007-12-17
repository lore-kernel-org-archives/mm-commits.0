From: akpm@linux-foundation.org
Subject: - aic94-fix-section-mismatches.patch removed from -mm tree
Date: Mon, 17 Dec 2007 15:40:16 -0800
Message-ID: <200712172340.lBHNeGB5008277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60843 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932398AbXLQXwG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 17 Dec 2007 18:52:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@steeleye.com, mm-commits@vger.kernel.org


The patch titled
     aic94: fix section mismatches
has been removed from the -mm tree.  Its filename was
     aic94-fix-section-mismatches.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: aic94: fix section mismatches
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix section mismatch warning:

WARNING: vmlinux.o(.init.text+0x23be6): Section mismatch: reference to .exit.text:asd_unmap_ha (between 'asd_pci_probe' and 'qla4xxx_module_init')
+
WARNING: vmlinux.o(.text+0x1ec8a8): Section mismatch: reference to .exit.text:as
d_unmap_ioport (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')
WARNING: vmlinux.o(.text+0x1ec8b1): Section mismatch: reference to .exit.text:as
d_unmap_memio (between 'asd_unmap_ha' and 'asd_remove_dev_attrs')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~aic94-fix-section-mismatches drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~aic94-fix-section-mismatches
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -136,7 +136,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_memio(struct asd_ha_struct *asd_ha)
+static void asd_unmap_memio(struct asd_ha_struct *asd_ha)
 {
 	struct asd_ha_addrspace *io_handle;
 
@@ -173,7 +173,7 @@ static int __devinit asd_map_ioport(stru
 	return err;
 }
 
-static void __devexit asd_unmap_ioport(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ioport(struct asd_ha_struct *asd_ha)
 {
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
@@ -210,7 +210,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_ha(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ha(struct asd_ha_struct *asd_ha)
 {
 	if (asd_ha->iospace)
 		asd_unmap_ioport(asd_ha);
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
pcmcia-include-bad-cis-filename-in-error-message.patch
git-scsi-misc.patch
git-unionfs.patch
git-ipwireless_cs.patch
git-x86.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
dio-fix-kernel-doc-notation.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
