From: akpm@linux-foundation.org
Subject: - gdth-fix-section-mismatch-warnings.patch removed from -mm tree
Date: Mon, 01 Dec 2008 11:21:00 -0800
Message-ID: <200812011921.mB1JL03G009365@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254AbYLATVW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 14:21:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, James.Bottomley@HansenPartnership.com, achim_leubner@adaptec.com, mm-commits@vger.kernel.org


The patch titled
     gdth: fix section mismatch warnings
has been removed from the -mm tree.  Its filename was
     gdth-fix-section-mismatch-warnings.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gdth: fix section mismatch warnings
From: Randy Dunlap <randy.dunlap@oracle.com>

Could fix a bug in a hotplug scenario.

WARNING: drivers/scsi/gdth.o(.text+0x3e6d): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_search_drives()
The function gdth_pci_probe_one() references
the function __init gdth_search_drives().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_search_drives is wrong.

WARNING: drivers/scsi/gdth.o(.text+0x3f78): Section mismatch in reference from the function gdth_pci_probe_one() to the function .init.text:gdth_enable_int()
The function gdth_pci_probe_one() references
the function __init gdth_enable_int().
This is often because gdth_pci_probe_one lacks a __init
annotation or the annotation of gdth_enable_int is wrong.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Achim Leubner <achim_leubner@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/gdth.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings drivers/scsi/gdth.c
--- a/drivers/scsi/gdth.c~gdth-fix-section-mismatch-warnings
+++ a/drivers/scsi/gdth.c
@@ -1238,7 +1238,7 @@ static int gdth_init_pci(struct pci_dev 
 
 /* controller protocol functions */
 
-static void __init gdth_enable_int(gdth_ha_str *ha)
+static void gdth_enable_int(gdth_ha_str *ha)
 {
     ulong flags;
     gdt2_dpram_str __iomem *dp2_ptr;
@@ -1554,7 +1554,7 @@ static int gdth_internal_cmd(gdth_ha_str
 
 /* search for devices */
 
-static int __init gdth_search_drives(gdth_ha_str *ha)
+static int gdth_search_drives(gdth_ha_str *ha)
 {
     ushort cdev_cnt, i;
     int ok;
@@ -4932,7 +4932,7 @@ static int __init gdth_eisa_probe_one(us
 #endif /* CONFIG_EISA */
 
 #ifdef CONFIG_PCI
-static int gdth_pci_probe_one(gdth_pci_str *pcistr,
+int gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kgdb-fix-kernel-doc-error.patch
arm-fix-kernel-doc-syntax.patch
audit-remove-excess-kernel-doc.patch
drivers-hwmon-f71882fgc-make-dev_attr_name-static.patch
genksyms-track-symbol-checksum-changes.patch
genksyms-allow-to-ignore-symbol-checksum-changes.patch
scripts-extract-ikconfig-remove-bashisms.patch
mtd-remove-excess-kernel-doc-notation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
backlight-catch-invalid-input-fix.patch
gdth-fix-section-mismatch-warnings.patch
esp-fix-section-mismatch-warning.patch
virtio_blk-fix-type-warning.patch
kernel-doc-handle-varargs-cleanly.patch
ntfs-dont-fool-kernel-doc.patch
ntfs-dont-fool-kernel-doc-checkpatch-fixes.patch
fs-use-menuconfig-to-control-the-misc-filesystems-menu.patch
fs-ncpfs-getoptc-cleanup-keneldoc.patch
max3100-spi-uart-driver-select-serial_core.patch
max3100-spi-uart-driver-select-serial_core-fix.patch
i2o-remove-extraneous-kernel-doc.patch
drivers-xen-xenbus-xenbus_clientc-cleanup-kerneldoc.patch
fs-ecryptfs-inodec-cleanup-kerneldoc.patch
kmod-fix-varargs-kernel-doc.patch
docs-document-how-to-write-varargs-in-kernel-doc.patch
rapidio-remove-excess-kernel-doc-notation.patch
documentation-update-header-file-paths.patch
documentation-update-s390-header-file-paths.patch
document-hadling-of-bad-memory.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
ldisc-n_tty-export-all-n_tty-ldisc-methods.patch
pps-serial-clients-support.patch
pps-parallel-port-clients-support.patch
pps-low-level-irq-timestamps-recording.patch
linuxpps-core-support-drivers-pps-sysfsc-make-dev_attr_name-static.patch
fix-similar-typos-to-successfull-v2.patch

