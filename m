From: akpm@linux-foundation.org
Subject: + usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:50:47 -0800
Message-ID: <200702272050.l1RKopuk028103@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51331 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXB0UvK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:51:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, duncan.sands@math.u-psud.fr, greg@kroah.com, simon@arlott.org


The patch titled
     usbatm-create-sysfs-link-device-from-atm-class-device-tidy
has been added to the -mm tree.  Its filename is
     usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

rename-pg_checked-page-flag-to-pg_owner_priv_1.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-agpgart.patch
git-cpufreq.patch
git-drm.patch
git-dvb.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-libata-all.patch
acpi-driver-support-for-pata-fix.patch
git-md-accel-vs-md.patch
dmaengine-uninline-large-functions.patch
git-mips-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
Fabric7-VIOC-driver-fixes.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
git-parisc.patch
git-parisc-fixup.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
after-before-x86_64-mm-mmconfig-share.patch
throttle_vm_writeout-dont-loop-on-gfp_nofs-and-gfp_noio-allocations.patch
ext-ea-block-reference-count-racing-fix-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
kvm-add-internal-filesystem-for-generating-inodes-tweak.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
