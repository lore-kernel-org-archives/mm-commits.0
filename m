From: akpm@linux-foundation.org
Subject: - ide-fix-pmac-breakage.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:38:03 -0800
Message-ID: <200703061038.l26Ac3eI019510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34489 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934053AbXCFKic (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:38:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, benh@kernel.crashing.org, bzolnier@gmail.com, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     ide: fix pmac breakage
has been removed from the -mm tree.  Its filename was
     ide-fix-pmac-breakage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ide: fix pmac breakage
From: Andrew Morton <akpm@osdl.org>

Fix breakage added int he IDE devel tree.

Add header, then fix

drivers/ide/ppc/pmac.c: In function `pmac_ide_setup_dma':
drivers/ide/ppc/pmac.c:2044: warning: assignment from incompatible pointer type
drivers/ide/ppc/pmac.c: In function `pmac_ide_dma_host_on':
drivers/ide/ppc/pmac.c:1989: warning: control reaches end of non-void function
include/linux/pci.h: In function `pmac_ide_init':
drivers/ide/ppc/pmac.c:1563: warning: ignoring return value of `pci_register_driver', declared with attribute warn_unused_result

Then add some apparently-long-missing error handling.

Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/ide/ppc/pmac.c |   37 +++++++++++++++++++++++++------------
 1 files changed, 25 insertions(+), 12 deletions(-)

diff -puN drivers/ide/ppc/pmac.c~ide-fix-pmac-breakage drivers/ide/ppc/pmac.c
--- a/drivers/ide/ppc/pmac.c~ide-fix-pmac-breakage
+++ a/drivers/ide/ppc/pmac.c
@@ -48,7 +48,7 @@
 #include <asm/mediabay.h>
 #endif
 
-#include "ide-timing.h"
+#include "../ide-timing.h"
 
 #undef IDE_PMAC_DEBUG
 
@@ -1553,19 +1553,34 @@ static struct pci_driver pmac_ide_pci_dr
 };
 MODULE_DEVICE_TABLE(pci, pmac_ide_pci_match);
 
-/* TODO: return error values */
-static void __init pmac_ide_probe(void)
+static int __init pmac_ide_probe(void)
 {
+	int error;
+
 	if (!machine_is(powermac))
-		return;
+		return -ENODEV;
 
 #ifdef CONFIG_BLK_DEV_IDE_PMAC_ATA100FIRST
-	pci_register_driver(&pmac_ide_pci_driver);
-	macio_register_driver(&pmac_ide_macio_driver);
+	error = pci_register_driver(&pmac_ide_pci_driver);
+	if (error)
+		goto out;
+	error = macio_register_driver(&pmac_ide_macio_driver);
+	if (error) {
+		pci_unregister_driver(&pmac_ide_pci_driver);
+		goto out;
+	}
 #else
-	macio_register_driver(&pmac_ide_macio_driver);
-	pci_register_driver(&pmac_ide_pci_driver);
+	error = macio_register_driver(&pmac_ide_macio_driver);
+	if (error)
+		goto out;
+	error = pci_register_driver(&pmac_ide_pci_driver);
+	if (error) {
+		macio_unregister_driver(&pmac_ide_macio_driver);
+		goto out;
+	}
 #endif
+out:
+	return error;
 }
 
 #ifdef CONFIG_BLK_DEV_IDEDMA_PMAC
@@ -1985,7 +2000,7 @@ static void pmac_ide_dma_host_off(ide_dr
 {
 }
 
-static int pmac_ide_dma_host_on(ide_drive_t *drive)
+static void pmac_ide_dma_host_on(ide_drive_t *drive)
 {
 }
 
@@ -2075,9 +2090,7 @@ pmac_ide_setup_dma(pmac_ide_hwif_t *pmif
 
 static int __init pmac_ide_init(void)
 {
-	pmac_ide_probe();
-
-	return 0;
+	return pmac_ide_probe();
 }
 
 module_init(pmac_ide_init);
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
rcu-preemptible-rcu.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
