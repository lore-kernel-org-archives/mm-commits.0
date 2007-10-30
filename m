From: akpm@linux-foundation.org
Subject: + aic94-fix-section-mismatches.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:56:17 -0700
Message-ID: <200710302056.l9UKuHsR027709@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43838 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753477AbXJ3U5K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:57:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, James.Bottomley@steeleye.com


The patch titled
     aic94: fix section mismatches
has been added to the -mm tree.  Its filename is
     aic94-fix-section-mismatches.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -134,7 +134,7 @@ Err:
 	return err;
 }
 
-static void __devexit asd_unmap_memio(struct asd_ha_struct *asd_ha)
+static void asd_unmap_memio(struct asd_ha_struct *asd_ha)
 {
 	struct asd_ha_addrspace *io_handle;
 
@@ -171,7 +171,7 @@ static int __devinit asd_map_ioport(stru
 	return err;
 }
 
-static void __devexit asd_unmap_ioport(struct asd_ha_struct *asd_ha)
+static void asd_unmap_ioport(struct asd_ha_struct *asd_ha)
 {
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
@@ -208,7 +208,7 @@ Err:
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
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-watchdog.patch
hostap-fix-section-mismatch-warning.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
