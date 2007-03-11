From: akpm@linux-foundation.org
Subject: + proc-maps-protection-tidy.patch added to -mm tree
Date: Sat, 10 Mar 2007 23:00:02 -0800
Message-ID: <200703110700.l2B7036H006629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38253 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbXCKHDC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 11 Mar 2007 03:03:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, arjan@infradead.org, kees@outflux.net


The patch titled
     proc-maps-protection-tidy
has been added to the -mm tree.  Its filename is
     proc-maps-protection-tidy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc-maps-protection-tidy
From: Andrew Morton <akpm@linux-foundation.org>

New sysctl numbers are old hat.

Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Kees Cook <kees@outflux.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c         |    2 +-
 include/linux/sysctl.h |    1 -
 kernel/sysctl.c        |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/proc/base.c~proc-maps-protection-tidy fs/proc/base.c
--- a/fs/proc/base.c~proc-maps-protection-tidy
+++ a/fs/proc/base.c
@@ -123,7 +123,7 @@ struct pid_entry {
 		NULL, &proc_info_file_operations,	\
 		{ .proc_read = &proc_##OTYPE } )
 
-int maps_protect = 0;
+int maps_protect;
 EXPORT_SYMBOL(maps_protect);
 
 static struct fs_struct *get_fs_struct(struct task_struct *task)
diff -puN include/linux/sysctl.h~proc-maps-protection-tidy include/linux/sysctl.h
--- a/include/linux/sysctl.h~proc-maps-protection-tidy
+++ a/include/linux/sysctl.h
@@ -165,7 +165,6 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
-	KERN_MAPS_PROTECT=77, /* int: whether we protect maps from public visibility */
 };
 
 
diff -puN kernel/sysctl.c~proc-maps-protection-tidy kernel/sysctl.c
--- a/kernel/sysctl.c~proc-maps-protection-tidy
+++ a/kernel/sysctl.c
@@ -605,7 +605,7 @@ static ctl_table kern_table[] = {
 	},
 #endif
 	{,
-		.ctl_name       = KERN_MAPS_PROTECT,
+		.ctl_name       = CTL_UNNUMBERED,
 		.procname       = "maps_protect",
 		.data           = &maps_protect,
 		.maxlen         = sizeof(int),
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slab-introduce-krealloc-fix.patch
make-aout-executables-work-again-fix.patch
git-acpi.patch
git-alsa-oops-fix.patch
git-drm.patch
git-dvb.patch
ivtv-warning-fix.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-kvm.patch
git-libata-all.patch
revert-rm-pointless-dmaengine-exports.patch
git-md-accel-fixup.patch
git-mmc-versus-uevent-use-add_uevent_var-instead-of-open-coding-it.patch
git-ubi.patch
git-netdev-all.patch
git-netdev-all-ipw2200-fix.patch
bonding-replace-system-timer-with-work-queue-tidy.patch
git-parisc.patch
rm9000-serial-driver-tidy.patch
git-pciseg.patch
git-s390.patch
git-unionfs.patch
usbatm-create-sysfs-link-device-from-atm-class-device.patch
git-wireless.patch
git-wireless-fixup.patch
revert-x86_64-mm-change-sysenter_setup-to-__cpuinit-improve-__init-__initdata.patch
linux-sysdevh-needs-to-include-linux-moduleh.patch
i386-vdso_prelink-warning-fix.patch
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
proc-maps-protection-tidy.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
speedup-divides-by-cpu_power-in-scheduler.patch
sched-document-rsdl-cpu-scheduler.patch
lutimesat-compat-syscall-and-wire-up-on-x86_64.patch
utrace-prep.patch
utrace-prep-2.patch
revert-utrace-prep-2.patch
utrace-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
local_t-powerpc-extension.patch
fbdev-hecuba-framebuffer-driver.patch
mm-only-free-swap-space-of-reactivated-pages-debug.patch
