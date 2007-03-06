From: akpm@linux-foundation.org
Subject: - usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch removed from -mm tree
Date: Tue, 06 Mar 2007 02:46:59 -0800
Message-ID: <200703061047.l26Akxid020105@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35021 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964828AbXCFKrc (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 05:47:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, duncan.sands@math.u-psud.fr, greg@kroah.com, simon@arlott.org, mm-commits@vger.kernel.org


The patch titled
     usbatm-create-sysfs-link-device-from-atm-class-device-tidy
has been removed from the -mm tree.  Its filename was
     usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch

This patch was dropped because it was folded into usbatm-create-sysfs-link-device-from-atm-class-device.patch

------------------------------------------------------
Subject: usbatm-create-sysfs-link-device-from-atm-class-device-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Avoid going blind.

Cc: Duncan Sands <duncan.sands@math.u-psud.fr>
Cc: Greg KH <greg@kroah.com>
Cc: Simon Arlott <simon@arlott.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/atm/usbatm.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/usb/atm/usbatm.c~usbatm-create-sysfs-link-device-from-atm-class-device-tidy drivers/usb/atm/usbatm.c
--- a/drivers/usb/atm/usbatm.c~usbatm-create-sysfs-link-device-from-atm-class-device-tidy
+++ a/drivers/usb/atm/usbatm.c
@@ -966,9 +966,11 @@ static int usbatm_atm_init(struct usbatm
 	/* temp init ATM device, set to 128kbit */
 	atm_dev->link_rate = 128 * 1000 / 424;
 
-	ret = sysfs_create_link(&atm_dev->class_dev.kobj, &instance->usb_intf->dev.kobj, "device");
+	ret = sysfs_create_link(&atm_dev->class_dev.kobj,
+				&instance->usb_intf->dev.kobj, "device");
 	if (ret) {
-		atm_err(instance, "%s: sysfs_create_link failed: %d\n", __func__, ret);
+		atm_err(instance, "%s: sysfs_create_link failed: %d\n",
+					__func__, ret);
 		goto fail_sysfs;
 	}
 
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
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume.patch
sis900-warning-fixes.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
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
