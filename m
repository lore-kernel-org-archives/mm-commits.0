From: akpm@linux-foundation.org
Subject: - fbdev-hecuba-framebuffer-driver-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:06:58 -0800
Message-ID: <200703060206.l2626wLo008910@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46882 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965711AbXCFCHB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:07:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adaplas@gmail.com, jayakumar.lkml@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fbdev-hecuba-framebuffer-driver-fix
has been removed from the -mm tree.  Its filename was
     fbdev-hecuba-framebuffer-driver-fix.patch

This patch was dropped because it was folded into fbdev-hecuba-framebuffer-driver.patch

------------------------------------------------------
Subject: fbdev-hecuba-framebuffer-driver-fix
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: drivers/video/hecubafb.o - Section mismatch: reference to .init.data:hecubafb_var from .text between 'hecubafb_probe' (at offset 0x19e) and 'hecubafb_dpy_update'
WARNING: drivers/video/hecubafb.o - Section mismatch: reference to .init.data: from .text between 'hecubafb_probe' (at offset 0x1c8) and 'hecubafb_dpy_update'

I assume these things were supposed to be copied by value?  If not, the rhs of
those assignemnts will need to be moved into .data.

Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/hecubafb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix drivers/video/hecubafb.c
--- a/drivers/video/hecubafb.c~fbdev-hecuba-framebuffer-driver-fix
+++ a/drivers/video/hecubafb.c
@@ -75,7 +75,7 @@ struct hecubafb_par {
 	unsigned int irq;
 };
 
-static struct fb_fix_screeninfo hecubafb_fix __initdata = {
+static struct fb_fix_screeninfo hecubafb_fix __devinitdata = {
 	.id =		"hecubafb",
 	.type =		FB_TYPE_PACKED_PIXELS,
 	.visual =	FB_VISUAL_MONO01,
@@ -85,7 +85,7 @@ static struct fb_fix_screeninfo hecubafb
 	.accel =	FB_ACCEL_NONE,
 };
 
-static struct fb_var_screeninfo hecubafb_var __initdata = {
+static struct fb_var_screeninfo hecubafb_var __devinitdata = {
 	.xres		= DPY_W,
 	.yres		= DPY_H,
 	.xres_virtual	= DPY_W,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
sony-laptop-fix-uninitialised-variable.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ia64-kexec-use-efi_loader_data-for-elf-core-header-tidy.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-md-accel-fixup.patch
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
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
