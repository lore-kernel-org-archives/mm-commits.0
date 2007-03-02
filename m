From: akpm@linux-foundation.org
Subject: + fbdev-hecuba-framebuffer-driver-fix.patch added to -mm tree
Date: Thu, 01 Mar 2007 23:58:28 -0800
Message-ID: <200703020800.l22802Fg003739@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47603 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161319AbXCBIAN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 03:00:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adaplas@gmail.com, jayakumar.lkml@gmail.com


The patch titled
     fbdev-hecuba-framebuffer-driver-fix
has been added to the -mm tree.  Its filename is
     fbdev-hecuba-framebuffer-driver-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
cyclades-return-closing_wait.patch
md-fix-for-raid6-reshape-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi-fix-cpuidle-borkage.patch
sony-laptop-fix-uninitialised-variable.patch
git-drm.patch
git-dvb.patch
git-dvb-fixup.patch
pvrusb-warning-fix.patch
git-input.patch
setstream-param-for-psmouse-tweak.patch
git-kvm.patch
git-leds-fixup.patch
git-leds-make-it-compile.patch
ide-ide-fix-pmac-breakage-fix.patch
git-md-accel-fixup.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
git-ubi.patch
git-netdev-all.patch
revert-drivers-net-tulip-dmfe-support-basic-carrier-detection.patch
dmfe-add-support-for-suspend-resume-fix.patch
sis900-warning-fixes.patch
cisco_ioctl-initialise-header_cache_update.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
revert-md-avoid-possible-bug_on-in-md-bitmap-handling-for-git-block.patch
git-block-fixup.patch
git-block-another-md-fix.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device-tidy.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
after-before-x86_64-mm-mmconfig-share.patch
linux-sysdevh-needs-to-include-linux-moduleh-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-up-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial-tweak.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace-fix-2.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler-up-fix.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
