From: akpm@linux-foundation.org
Subject: - fix-rmmod-read-write-races-in-proc-entries-fix.patch removed from -mm tree
Date: Mon, 05 Mar 2007 16:56:18 -0800
Message-ID: <200703060056.l260uJVB006866@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43594 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbXCFA4h (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 19:56:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, ebiederm@xmission.com, oleg@tv-sign.ru, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     fix-rmmod-read-write-races-in-proc-entries-fix
has been removed from the -mm tree.  Its filename was
     fix-rmmod-read-write-races-in-proc-entries-fix.patch

This patch was dropped because it was folded into fix-rmmod-read-write-races-in-proc-entries.patch

------------------------------------------------------
Subject: fix-rmmod-read-write-races-in-proc-entries-fix
From: Andrew Morton <akpm@linux-foundation.org>

Make lockdep happy.

Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN fs/proc/generic.c~fix-rmmod-read-write-races-in-proc-entries-fix fs/proc/generic.c
--- a/fs/proc/generic.c~fix-rmmod-read-write-races-in-proc-entries-fix
+++ a/fs/proc/generic.c
@@ -790,9 +790,8 @@ void remove_proc_entry(const char *name,
 		de->proc_fops = NULL;
 		/* Wait until all existing readers/writers are done. */
 		if (de->pde_users > 0) {
-			struct completion c;
+			DECLARE_COMPLETION_ONSTACK(c);
 
-			init_completion(&c);
 			if (!de->pde_unload_completion)
 				de->pde_unload_completion = &c;
 
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
fix-rmmod-read-write-races-in-proc-entries.patch
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
mm-only-free-swap-space-of-reactivated-pages-debug.patch
