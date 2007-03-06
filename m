From: akpm@linux-foundation.org
Subject: - lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:29:50 -0800
Message-ID: <200703060129.l261ToiG007704@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45280 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932879AbXCFBaI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:30:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@openvz.org, ak@suse.de, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy
has been removed from the -mm tree.  Its filename was
     lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch

This patch was dropped because it was folded into lutimesat-compat-syscall-and-wire-up-on-x86_64.patch

------------------------------------------------------
Subject: lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Andi Kleen <ak@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy fs/compat.c
--- a/fs/compat.c~lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy
+++ a/fs/compat.c
@@ -115,10 +115,8 @@ asmlinkage long compat_sys_lutimesat(int
 	struct timespec ts[2];
 
 	if (utimes) {
-		if (get_user(ts[0].tv_sec, &utimes[0].tv_sec) ||
-		    get_user(ts[0].tv_nsec, &utimes[0].tv_nsec) ||
-		    get_user(ts[1].tv_sec, &utimes[1].tv_sec) ||
-		    get_user(ts[1].tv_nsec, &utimes[1].tv_nsec))
+		if (get_compat_timespec(&ts[0], &utimes[0]) ||
+		    get_compat_timespec(&ts[1], &utimes[1]))
 			return -EFAULT;
 	}
 	return do_utimes_nsec(dfd, filename,
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
lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
local_t-mips-extension-shrink-duplicated-mips-32-64-bits-functions-from-localh-fix.patch
linux-kernel-markers-kconfig-menus-fix-4.patch
fbdev-hecuba-framebuffer-driver-fix.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
