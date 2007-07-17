From: akpm@linux-foundation.org
Subject: - rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch removed from -mm tree
Date: Tue, 17 Jul 2007 01:48:47 -0700
Message-ID: <200707170848.l6H8mlqN008385@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42724 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757316AbXGQItJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 17 Jul 2007 04:49:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, lenb@kernel.org, rongkai.zhan@windriver.com, mm-commits@vger.kernel.org


The patch titled
     rtc-add-support-for-the-st-m48t59-rtc vs git-acpi
has been removed from the -mm tree.  Its filename was
     rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch

This patch was dropped because it was folded into rtc-add-support-for-the-st-m48t59-rtc.patch

------------------------------------------------------
Subject: rtc-add-support-for-the-st-m48t59-rtc vs git-acpi
From: Andrew Morton <akpm@linux-foundation.org>

drivers/rtc/rtc-m48t59.c:357: warning: initialization from incompatible pointer type
drivers/rtc/rtc-m48t59.c:358: warning: initialization from incompatible pointer type

The acpi guys changed the bin_attribute code.

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m48t59.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi
+++ a/drivers/rtc/rtc-m48t59.c
@@ -310,8 +310,9 @@ static const struct rtc_class_ops m48t59
 	.proc		= m48t59_rtc_proc,
 };
 
-static ssize_t m48t59_nvram_read(struct kobject *kobj, char *buf,
-				 loff_t pos, size_t size)
+static ssize_t m48t59_nvram_read(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
@@ -329,8 +330,9 @@ static ssize_t m48t59_nvram_read(struct 
 	return cnt;
 }
 
-static ssize_t m48t59_nvram_write(struct kobject *kobj, char *buf,
-				  loff_t pos, size_t size)
+static ssize_t m48t59_nvram_write(struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t pos, size_t size)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
 	struct platform_device *pdev = to_platform_device(dev);
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
rtc-add-support-for-the-st-m48t59-rtc-vs-git-acpi.patch
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
