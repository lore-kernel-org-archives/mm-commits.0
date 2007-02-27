From: akpm@linux-foundation.org
Subject: + lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch added to -mm tree
Date: Tue, 27 Feb 2007 13:02:26 -0800
Message-ID: <200702272102.l1RL2Uu9028537@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52097 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617AbXB0VCk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 16:02:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, adobriyan@openvz.org, ak@suse.de, sfr@canb.auug.org.au


The patch titled
     lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy
has been added to the -mm tree.  Its filename is
     lutimesat-compat-syscall-and-wire-up-on-x86_64-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -116,10 +116,8 @@ asmlinkage long compat_sys_lutimesat(int
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
