From: akpm@linux-foundation.org
Subject: - rtc-driver-for-ds1216-chips-fix.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:49:26 -0700
Message-ID: <200707170849.l6H8nQmB008397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760016AbXGQIuK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:50:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, tsbogend@alpha.franken.de, mm-commits@vger.kernel.org


The patch titled
     rtc-driver-for-ds1216-chips-fix
has been removed from the -mm tree.  Its filename was
     rtc-driver-for-ds1216-chips-fix.patch

This patch was dropped because it was folded into rtc-driver-for-ds1216-chips.patch

------------------------------------------------------
Subject: rtc-driver-for-ds1216-chips-fix
From: Andrew Morton <akpm@linux-foundation.org>

- some constification

- whitespace fixes

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1216.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/rtc/rtc-ds1216.c~rtc-driver-for-ds1216-chips-fix drivers/rtc/rtc-ds1216.c
--- a/drivers/rtc/rtc-ds1216.c~rtc-driver-for-ds1216-chips-fix
+++ a/drivers/rtc/rtc-ds1216.c
@@ -23,8 +23,8 @@ struct ds1216_regs {
 	u8 year;
 };
 
-#define DS1216_HOUR_1224       (1 << 7)
-#define DS1216_HOUR_AMPM       (1 << 5)
+#define DS1216_HOUR_1224	(1 << 7)
+#define DS1216_HOUR_AMPM	(1 << 5)
 
 struct ds1216_priv {
 	struct rtc_device *rtc;
@@ -33,7 +33,7 @@ struct ds1216_priv {
 	unsigned long baseaddr;
 };
 
-static u8 magic[] = {
+static const u8 magic[] = {
 	0xc5, 0x3a, 0xa3, 0x5c, 0xc5, 0x3a, 0xa3, 0x5c
 };
 
@@ -55,7 +55,7 @@ static void ds1216_read(u8 __iomem *ioad
 	}
 }
 
-static void ds1216_write(u8 __iomem *ioaddr, u8 *buf)
+static void ds1216_write(u8 __iomem *ioaddr, const u8 *buf)
 {
 	unsigned char c;
 	int i, j;
@@ -63,7 +63,7 @@ static void ds1216_write(u8 __iomem *ioa
 	for (i = 0; i < 8; i++) {
 		c = buf[i];
 		for (j = 0; j < 8; j++) {
-			writeb (c, ioaddr);
+			writeb(c, ioaddr);
 			c = c >> 1;
 		}
 	}
@@ -173,7 +173,7 @@ static int __devinit ds1216_rtc_probe(st
 	platform_set_drvdata(pdev, priv);
 
 	/* dummy read to get clock into a known state */
-	ds1216_read (priv->ioaddr, dummy);
+	ds1216_read(priv->ioaddr, dummy);
 	return 0;
 
 out:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
sysctlc-add-text-telling-people-to-use-ctl_unnumbered-fix.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
create-the-zone_movable-zone.patch
allow-huge-page-allocations-to-use-gfp_high_movable.patch
slub-change-error-reporting-format-to-follow-lockdep-loosely.patch
freezer-make-kernel-threads-nonfreezable-by-default.patch
i386-speedup-touch_nmi_watchdog.patch
x86_64-speedup-touch_nmi_watchdog.patch
crc7-support.patch
spi-master-driver-for-xilinx-virtex.patch
isdn-capi-warning-fixes.patch
i2o_cfg_passthru-cleanup.patch
knfsd-exportfs-add-exportfsh-header.patch
knfsd-exportfs-remove-iget-abuse.patch
nfsd-warning-fix.patch
knfsd-nfsd4-vary-maximum-delegation-limit-based-on-ram-size.patch
driver-for-the-atmel-on-chip-rtc-on-at32ap700x-devices.patch
rtc-add-rtc-m41t80-driver-take-2.patch
rtc-add-support-for-the-st-m48t59-rtc.patch
rtc-driver-for-ds1216-chips.patch
rtc-driver-for-ds1216-chips-fix.patch
lguest-the-host-code.patch
lguest-the-net-driver.patch
fbcon-allow-fbcon-to-use-the-primary-display-driver.patch
fbdev-fbcon-console-unregistration-from-unregister_framebuffer.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
coredump-masking-reimplementation-of-dumpable-using-two-flags.patch
drivers-edac-new-i82443bxgz-mc-driver-broken.patch
drivers-edac-fix-e752x-reversed-csrows-fix.patch
drivers-edac-new-pasemi-driver-fix.patch
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
lockstat-core-infrastructure.patch
lockdep-various-fixes.patch
lockstat-measure-lock-bouncing.patch
some-kmalloc-memset-kzalloc-tree-wide.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
