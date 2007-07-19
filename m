From: akpm@linux-foundation.org
Subject: - git-kgdb-fixup.patch removed from -mm tree
Date: Thu, 19 Jul 2007 12:54:40 -0700
Message-ID: <200707191954.l6JJseae019148@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43719 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbXGSTyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 15:54:47 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l6JJsjPr012302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Thu, 19 Jul 2007 12:54:46 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     git-kgdb-fixup
has been removed from the -mm tree.  Its filename was
     git-kgdb-fixup.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: git-kgdb-fixup
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-ixp4xx/ixdp425-setup.c |    3 ++-
 arch/ppc/platforms/4xx/bamboo.c      |    1 +
 arch/ppc/platforms/4xx/bubinga.c     |    1 +
 arch/ppc/platforms/4xx/ebony.c       |    1 +
 arch/ppc/platforms/4xx/luan.c        |    1 +
 arch/ppc/platforms/4xx/ocotea.c      |    1 +
 arch/ppc/platforms/spruce.c          |    1 +
 7 files changed, 8 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-ixp4xx/ixdp425-setup.c~git-kgdb-fixup arch/arm/mach-ixp4xx/ixdp425-setup.c
--- a/arch/arm/mach-ixp4xx/ixdp425-setup.c~git-kgdb-fixup
+++ a/arch/arm/mach-ixp4xx/ixdp425-setup.c
@@ -29,6 +29,7 @@
 #include <asm/irq.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/flash.h>
+#include <asm/kgdb.h>
 #include <asm/delay.h>
 
 static struct flash_platform_data ixdp425_flash_data = {
@@ -263,7 +264,7 @@ MACHINE_START(IXCDP1100, "Intel IXCDP110
 	/* Maintainer: MontaVista Software, Inc. */
 	.phys_io	= IXP4XX_PERIPHERAL_BASE_PHYS,
 	.io_pg_offst	= ((IXP4XX_PERIPHERAL_BASE_VIRT) >> 18) & 0xfffc,
-	.map_io		= ixp4xx_map_io,
+	.map_io		= ixdp425_map_io,
 	.init_irq	= ixp4xx_init_irq,
 	.timer		= &ixp4xx_timer,
 	.boot_params	= 0x0100,
diff -puN arch/i386/kernel/Makefile~git-kgdb-fixup arch/i386/kernel/Makefile
diff -puN arch/mips/mips-boards/generic/Makefile~git-kgdb-fixup arch/mips/mips-boards/generic/Makefile
diff -puN Makefile~git-kgdb-fixup Makefile
diff -puN arch/sh/Kconfig.debug~git-kgdb-fixup arch/sh/Kconfig.debug
diff -puN arch/ppc/platforms/spruce.c~git-kgdb-fixup arch/ppc/platforms/spruce.c
--- a/arch/ppc/platforms/spruce.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/spruce.c
@@ -15,6 +15,7 @@
 #include <linux/errno.h>
 #include <linux/reboot.h>
 #include <linux/pci.h>
+#include <linux/kgdb.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
diff -puN arch/ppc/platforms/4xx/ocotea.c~git-kgdb-fixup arch/ppc/platforms/4xx/ocotea.c
--- a/arch/ppc/platforms/4xx/ocotea.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/4xx/ocotea.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/reboot.h>
 #include <linux/pci.h>
+#include <linux/kgdb.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
diff -puN arch/ppc/platforms/4xx/luan.c~git-kgdb-fixup arch/ppc/platforms/4xx/luan.c
--- a/arch/ppc/platforms/4xx/luan.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/4xx/luan.c
@@ -17,6 +17,7 @@
 #include <linux/errno.h>
 #include <linux/reboot.h>
 #include <linux/pci.h>
+#include <linux/kgdb.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
diff -puN arch/ppc/platforms/4xx/ebony.c~git-kgdb-fixup arch/ppc/platforms/4xx/ebony.c
--- a/arch/ppc/platforms/4xx/ebony.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/4xx/ebony.c
@@ -19,6 +19,7 @@
 #include <linux/errno.h>
 #include <linux/reboot.h>
 #include <linux/pci.h>
+#include <linux/kgdb.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
diff -puN arch/ppc/platforms/4xx/bubinga.c~git-kgdb-fixup arch/ppc/platforms/4xx/bubinga.c
--- a/arch/ppc/platforms/4xx/bubinga.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/4xx/bubinga.c
@@ -15,6 +15,7 @@
 #include <linux/threads.h>
 #include <linux/param.h>
 #include <linux/string.h>
+#include <linux/kgdb.h>
 #include <linux/blkdev.h>
 #include <linux/pci.h>
 #include <linux/rtc.h>
diff -puN arch/ppc/platforms/4xx/bamboo.c~git-kgdb-fixup arch/ppc/platforms/4xx/bamboo.c
--- a/arch/ppc/platforms/4xx/bamboo.c~git-kgdb-fixup
+++ a/arch/ppc/platforms/4xx/bamboo.c
@@ -16,6 +16,7 @@
 #include <linux/errno.h>
 #include <linux/reboot.h>
 #include <linux/pci.h>
+#include <linux/kgdb.h>
 #include <linux/kdev_t.h>
 #include <linux/types.h>
 #include <linux/major.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
git-input.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-kgdb-fixup-2.patch
git-kgdb-fixup.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
