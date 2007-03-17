From: akpm@linux-foundation.org
Subject: + git-drm-warning-fix.patch added to -mm tree
Date: Fri, 16 Mar 2007 18:50:19 -0700
Message-ID: <200703170152.l2H1qC5G026561@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46786 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933622AbXCQBwT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 21:52:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie


The patch titled
     git-drm-warning-fix
has been added to the -mm tree.  Its filename is
     git-drm-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-drm-warning-fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/char/drm/drm_fops.c: In function 'drm_setup':
drivers/char/drm/drm_fops.c:60: warning: comparison of distinct pointer types lacks a cast

Unfortunately PAGE_SIZE has different types on different architectures.

Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_fops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/drm/drm_fops.c~git-drm-warning-fix drivers/char/drm/drm_fops.c
--- a/drivers/char/drm/drm_fops.c~git-drm-warning-fix
+++ a/drivers/char/drm/drm_fops.c
@@ -57,7 +57,7 @@ static int drm_setup(drm_device_t * dev)
 	dev->magicfree.next = NULL;
 
 	/* prebuild the SAREA */
-	sareapage = max(SAREA_MAX, PAGE_SIZE);
+	sareapage = max_t(unsigned, SAREA_MAX, PAGE_SIZE);
 	i = drm_addmap(dev, 0, sareapage, _DRM_SHM, _DRM_CONTAINS_LOCK, &map);
 	if (i != 0)
 		return i;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

software-suspend-fix-suspend-when-console-is-in.patch
machzwd-warning-fix.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
git-hid-fix.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fix.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-scsi-rc-fixes.patch
git-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
allow-i386-crash-kernels-to-handle-x86_64-dumps-fix.patch
revert-ac97-fix-microphone-and-line_in-selection-logic.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated-fix.patch
mm-debug-check-for-the-fault-vs-invalidate-race-tidy.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-tidy.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
driver_bfin_serial_core-update.patch
blackfin-blackfin-i2c-driver-update-2.patch
uml-driver-formatting-fixes-fix.patch
reduce-size-of-task_struct-on-64-bit-machines.patch
mm-shrink-parent-dentries-when-shrinking-slab.patch
add-an-anonymous-inode-source-tidy.patch
virtual_eisa_root_init-should-be-__init.patch
proc-maps-protection-fix.patch
proc-maps-protection-tidy.patch
proc-maps-protection-fix-2.patch
fix-cycladesh-for-x86_64-and-probably-others-fix.patch
rtc-add-rtc-rs5c313-driver-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
proc-maps-protection-vs-utrace.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
utrace-printk-borkage.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
git-drm-warning-fix.patch
