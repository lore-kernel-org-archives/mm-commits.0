From: akpm@linux-foundation.org
Subject: - profile-likely-unlikely-macros-fix.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:38:11 -0700
Message-ID: <200804300538.m3U5cBHp028745@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbYD3Fik (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:38:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andi@firstfloor.org, dwalker@mvista.com, hzhong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     profile-likely-unlikely-macros-fix
has been removed from the -mm tree.  Its filename was
     profile-likely-unlikely-macros-fix.patch

This patch was dropped because it was folded into profile-likely-unlikely-macros.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: profile-likely-unlikely-macros-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andi Kleen <andi@firstfloor.org>
Cc: Daniel Walker <dwalker@mvista.com>
Cc: Hua Zhong <hzhong@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/vsyscall_64.c  |   11 ++---------
 arch/x86/vdso/vclock_gettime.c |   11 ++---------
 include/linux/compiler.h       |    3 ++-
 3 files changed, 6 insertions(+), 19 deletions(-)

diff -puN arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -17,6 +17,8 @@
  *  want per guest time just set the kernel.vsyscall64 sysctl to 0.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -46,15 +48,6 @@
 #define __syscall_clobber "r11","cx","memory"
 
 /*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
-/*
  * vsyscall_gtod_data contains data that is :
  * - readonly from vsyscalls
  * - written by timer interrupt or systcl (/proc/sys/kernel/vsyscall64)
diff -puN arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix arch/x86/vdso/vclock_gettime.c
--- a/arch/x86/vdso/vclock_gettime.c~profile-likely-unlikely-macros-fix
+++ a/arch/x86/vdso/vclock_gettime.c
@@ -9,6 +9,8 @@
  * Also alternative() doesn't work.
  */
 
+#define SUPPRESS_LIKELY_PROFILING
+
 #include <linux/kernel.h>
 #include <linux/posix-timers.h>
 #include <linux/time.h>
@@ -23,15 +25,6 @@
 
 #define gtod vdso_vsyscall_gtod_data
 
-/*
- * likely and unlikely explode when used in vdso in combination with
- * profile-likely-unlikely-macros.patch
- */
-#undef likely
-#define likely(x) (x)
-#undef unlikely
-#define unlikely(x) (x)
-
 static long vdso_fallback_gettime(long clock, struct timespec *ts)
 {
 	long ret;
diff -puN include/linux/compiler.h~profile-likely-unlikely-macros-fix include/linux/compiler.h
--- a/include/linux/compiler.h~profile-likely-unlikely-macros-fix
+++ a/include/linux/compiler.h
@@ -51,7 +51,8 @@ extern void __chk_io_ptr(const volatile 
 # include <linux/compiler-intel.h>
 #endif
 
-#if defined(CONFIG_PROFILE_LIKELY) && !(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
+#if defined(CONFIG_PROFILE_LIKELY) && !defined(SUPPRESS_LIKELY_PROFILING) && \
+	!(defined(CONFIG_MODULE_UNLOAD) && defined(MODULE))
 struct likeliness {
 	const char *func;
 	char *file;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
blackfin-serial-driver-this-driver-enable-sports-on-blackfin-emulate-uart-fix.patch
pci-export-resource_wc-in-pci-sysfs-fix.patch
disable-the-memory-controller-by-default-v3.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
x86-ptrace-pebs-support-warning-fix.patch
rtc-remove-unneeded-declarations-of-hpet_rtc_interrupt.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
cifs-suppress-warning.patch
devres-support-addresses-greater-than-an-unsigned-long-via-dev_ioremap-checkpatch-fixes.patch
sysfs-provide-a-clue-about-the-effects-of-config_usb_device_class=y.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
touch-screen-driver-for-the-superh-migor-board.patch
git-kvm.patch
pata_atiixp-simplex-clear.patch
git-m32r.patch
git-mips.patch
git-mips-git-rejects.patch
git-mmc.patch
sundance-set-carrier-status-on-link-change-events.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch
sched-add-debug-checks-to-idle-functions.patch
drivers-base-topologyc-add-conditionals-around-show_cpumap.patch
add-rcu_assign_index-if-ever-needed.patch
git-scsi-misc.patch
scsi-fix-section-mismatch-in-aic94xx.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
aic79xx_core-remove-ascii-art.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
git-v9fs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-xtensa.patch
revert-rusty-misc-timer-typesafe.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
ext4-is-busted-on-m68k.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
utimensat-non-conformances-and-fixes-checkpatch-fixes.patch
add-warn_on_secs-macro.patch
rtc-class-driver-for-ppc_md-rtc-functions-fix.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
sxc-fix-printk-warnings-on-sparc32.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
isicom-bring-into-coding-style-fix.patch
tty-the-big-operations-rework-fix-2.patch
tty-the-big-operations-rework-isicom-fix.patch
tty-the-big-operations-rework-simserial-fix.patch
tty-the-big-operations-rework-vs-git-kgdb-light.patch
tty-the-big-operations-rework-vs-kgdb-2.patch
devpts-factor-out-pty-index-allocation-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
fuse-fix-race-in-llseek-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
x86-ioremap-add-checks-for-virtual-addresses-fix.patch
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

