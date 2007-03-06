From: akpm@linux-foundation.org
Subject: - nommu-present-backing-device-capabilities-for-mtd-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:38:29 -0800
Message-ID: <200703061038.l26AcTFL019582@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34505 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934058AbXCFKio (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:38:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     nommu-present-backing-device-capabilities-for-mtd-fix
has been removed from the -mm tree.  Its filename was
     nommu-present-backing-device-capabilities-for-mtd-fix.patch

This patch was dropped because it was folded into nommu-present-backing-device-capabilities-for-mtd.patch

------------------------------------------------------
Subject: nommu-present-backing-device-capabilities-for-mtd-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/mtd/mtdbdi.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN drivers/mtd/mtdbdi.c~nommu-present-backing-device-capabilities-for-mtd-fix drivers/mtd/mtdbdi.c
--- a/drivers/mtd/mtdbdi.c~nommu-present-backing-device-capabilities-for-mtd-fix
+++ a/drivers/mtd/mtdbdi.c
@@ -11,6 +11,8 @@
 
 #include <linux/backing-dev.h>
 #include <linux/mtd/mtd.h>
+#include <linux/module.h>
+
 #include "internal.h"
 
 /*
@@ -20,6 +22,7 @@
 struct backing_dev_info mtd_bdi_unmappable = {
 	.capabilities	= BDI_CAP_MAP_COPY,
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_unmappable);
 
 /*
  * backing device capabilities for R/O mappable devices (such as ROM)
@@ -30,6 +33,7 @@ struct backing_dev_info mtd_bdi_ro_mappa
 	.capabilities	= (BDI_CAP_MAP_COPY | BDI_CAP_MAP_DIRECT |
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP),
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_ro_mappable);
 
 /*
  * backing device capabilities for writable mappable devices (such as RAM)
@@ -41,3 +45,4 @@ struct backing_dev_info mtd_bdi_rw_mappa
 			   BDI_CAP_EXEC_MAP | BDI_CAP_READ_MAP |
 			   BDI_CAP_WRITE_MAP),
 };
+EXPORT_SYMBOL_GPL(mtd_bdi_rw_mappable);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
gfs2-build-fix.patch
git-input.patch
git-md-accel-fixup.patch
git-mmc-fix-99.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
div64_64-common-code-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix-2.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode-tidy.patch
i386-vdso_prelink-warning-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
