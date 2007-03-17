From: akpm@linux-foundation.org
Subject: + machzwd-warning-fix.patch added to -mm tree
Date: Fri, 16 Mar 2007 18:04:14 -0700
Message-ID: <200703170106.l2H167GV025917@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45610 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbXCQBGN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 21:06:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, wim@iguana.be


The patch titled
     machzwd warning fix
has been added to the -mm tree.  Its filename is
     machzwd-warning-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: machzwd warning fix
From: Andrew Morton <akpm@linux-foundation.org>

drivers/char/watchdog/machzwd.c: In function 'zf_ioctl':
drivers/char/watchdog/machzwd.c:327: warning: passing argument 1 of 'zf_ping' makes integer from pointer without a cast

Also some coding-style repairs.

Cc: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/watchdog/machzwd.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN drivers/char/watchdog/machzwd.c~machzwd-warning-fix drivers/char/watchdog/machzwd.c
--- a/drivers/char/watchdog/machzwd.c~machzwd-warning-fix
+++ a/drivers/char/watchdog/machzwd.c
@@ -314,21 +314,21 @@ static int zf_ioctl(struct inode *inode,
 {
 	void __user *argp = (void __user *)arg;
 	int __user *p = argp;
-	switch(cmd){
-		case WDIOC_GETSUPPORT:
-			if (copy_to_user(argp, &zf_info, sizeof(zf_info)))
-				return -EFAULT;
-			break;
-
-		case WDIOC_GETSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			zf_ping(NULL);
-			break;
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		if (copy_to_user(argp, &zf_info, sizeof(zf_info)))
+			return -EFAULT;
+		break;
+
+	case WDIOC_GETSTATUS:
+		return put_user(0, p);
+
+	case WDIOC_KEEPALIVE:
+		zf_ping(0);
+		break;
 
-		default:
-			return -ENOTTY;
+	default:
+		return -ENOTTY;
 	}
 
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

software-suspend-fix-suspend-when-console-is-in.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa.patch
git-drm.patch
git-dvb.patch
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
rtc-add-rtc-rs5c313-driver-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
revoke-core-code-fix-shared-mapping-revoke.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
machzwd-warning-fix.patch
