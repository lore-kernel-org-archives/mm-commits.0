From: akpm@linux-foundation.org
Subject: - read_current_time-cleanups.patch removed from -mm tree
Date: Wed, 06 Feb 2008 16:21:43 -0800
Message-ID: <200802070021.m170LO1W006335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35546 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935151AbYBGAqB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 19:46:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@suse.de, davem@davemloft.net, hskinnemoen@atmel.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     read_current_timer() cleanups
has been removed from the -mm tree.  Its filename was
     read_current_time-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: read_current_timer() cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- All implementations can be __devinit

- The function prototypes were in asm/timex.h but they all must be the same,
  so create a single declaration in linux/timex.h.

- uninline the sparc64 version to match the other architectures

- Don't bother #defining ARCH_HAS_READ_CURRENT_TIMER to a particular value.

[ezk@cs.sunysb.edu: fix build]
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/lib/delay.c      |    4 +++-
 arch/sparc64/kernel/time.c  |    5 +++++
 arch/x86/lib/delay_32.c     |    4 +++-
 arch/x86/lib/delay_64.c     |    4 +++-
 include/asm-avr32/timex.h   |    3 +--
 include/asm-sparc64/timex.h |    6 +-----
 include/asm-x86/timex.h     |    3 +--
 include/linux/timex.h       |    2 ++
 init/calibrate.c            |    3 +--
 9 files changed, 20 insertions(+), 14 deletions(-)

diff -puN arch/avr32/lib/delay.c~read_current_time-cleanups arch/avr32/lib/delay.c
--- a/arch/avr32/lib/delay.c~read_current_time-cleanups
+++ a/arch/avr32/lib/delay.c
@@ -12,13 +12,15 @@
 
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/timex.h>
 #include <linux/param.h>
 #include <linux/types.h>
+#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/sysreg.h>
 
-int read_current_timer(unsigned long *timer_value)
+int __devinit read_current_timer(unsigned long *timer_value)
 {
 	*timer_value = sysreg_read(COUNT);
 	return 0;
diff -puN arch/sparc64/kernel/time.c~read_current_time-cleanups arch/sparc64/kernel/time.c
--- a/arch/sparc64/kernel/time.c~read_current_time-cleanups
+++ a/arch/sparc64/kernel/time.c
@@ -1707,6 +1707,11 @@ static void __exit rtc_mini_exit(void)
 	misc_deregister(&rtc_mini_dev);
 }
 
+int __devinit read_current_timer(unsigned long *timer_val)
+{
+	*timer_val = tick_ops->get_tick();
+	return 0;
+}
 
 module_init(rtc_mini_init);
 module_exit(rtc_mini_exit);
diff -puN arch/x86/lib/delay_32.c~read_current_time-cleanups arch/x86/lib/delay_32.c
--- a/arch/x86/lib/delay_32.c~read_current_time-cleanups
+++ a/arch/x86/lib/delay_32.c
@@ -12,8 +12,10 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/timex.h>
 #include <linux/preempt.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -63,7 +65,7 @@ void use_tsc_delay(void)
 	delay_fn = delay_tsc;
 }
 
-int read_current_timer(unsigned long *timer_val)
+int __devinit read_current_timer(unsigned long *timer_val)
 {
 	if (delay_fn == delay_tsc) {
 		rdtscl(*timer_val);
diff -puN arch/x86/lib/delay_64.c~read_current_time-cleanups arch/x86/lib/delay_64.c
--- a/arch/x86/lib/delay_64.c~read_current_time-cleanups
+++ a/arch/x86/lib/delay_64.c
@@ -10,8 +10,10 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
+#include <linux/timex.h>
 #include <linux/preempt.h>
 #include <linux/delay.h>
+#include <linux/init.h>
 
 #include <asm/delay.h>
 #include <asm/msr.h>
@@ -20,7 +22,7 @@
 #include <asm/smp.h>
 #endif
 
-int read_current_timer(unsigned long *timer_value)
+int __devinit read_current_timer(unsigned long *timer_value)
 {
 	rdtscll(*timer_value);
 	return 0;
diff -puN include/asm-avr32/timex.h~read_current_time-cleanups include/asm-avr32/timex.h
--- a/include/asm-avr32/timex.h~read_current_time-cleanups
+++ a/include/asm-avr32/timex.h
@@ -34,7 +34,6 @@ static inline cycles_t get_cycles (void)
 	return 0;
 }
 
-extern int read_current_timer(unsigned long *timer_value);
-#define ARCH_HAS_READ_CURRENT_TIMER	1
+#define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif /* __ASM_AVR32_TIMEX_H */
diff -puN include/asm-sparc64/timex.h~read_current_time-cleanups include/asm-sparc64/timex.h
--- a/include/asm-sparc64/timex.h~read_current_time-cleanups
+++ a/include/asm-sparc64/timex.h
@@ -14,10 +14,6 @@
 typedef unsigned long cycles_t;
 #define get_cycles()	tick_ops->get_tick()
 
-#define ARCH_HAS_READ_CURRENT_TIMER	1
-#define read_current_timer(timer_val_p) 	\
-({	*timer_val_p = tick_ops->get_tick();	\
-	0;					\
-})
+#define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
diff -puN include/asm-x86/timex.h~read_current_time-cleanups include/asm-x86/timex.h
--- a/include/asm-x86/timex.h~read_current_time-cleanups
+++ a/include/asm-x86/timex.h
@@ -14,7 +14,6 @@
 #endif
 #define CLOCK_TICK_RATE	PIT_TICK_RATE
 
-extern int read_current_timer(unsigned long *timer_value);
-#define ARCH_HAS_READ_CURRENT_TIMER	1
+#define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
diff -puN include/linux/timex.h~read_current_time-cleanups include/linux/timex.h
--- a/include/linux/timex.h~read_current_time-cleanups
+++ a/include/linux/timex.h
@@ -244,6 +244,8 @@ extern int do_adjtimex(struct timex *);
 /* Don't use! Compatibility define for existing users. */
 #define tickadj	(500/HZ ? : 1)
 
+int read_current_timer(unsigned long *timer_val);
+
 #endif /* KERNEL */
 
 #endif /* LINUX_TIMEX_H */
diff -puN init/calibrate.c~read_current_time-cleanups init/calibrate.c
--- a/init/calibrate.c~read_current_time-cleanups
+++ a/init/calibrate.c
@@ -7,8 +7,7 @@
 #include <linux/jiffies.h>
 #include <linux/delay.h>
 #include <linux/init.h>
-
-#include <asm/timex.h>
+#include <linux/timex.h>
 
 unsigned long preset_lpj;
 static int __init lpj_setup(char *str)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
acpi-backlight-reset-brightness-on-resume.patch
git-audit-printk-warning-fix.patch
git-cifs.patch
git-cpufreq.patch
revert-agk-dm-dm-loop.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
git-drm-fix.patch
drm-convert-from-nopage-to-fault.patch
drivers-media-video-em28xx-em28xx-corec-fix-use-of-potentially-uninitialized-variable.patch
adt7473-new-driver-for-analog-devices-adt7473-sensor-chip.patch
revert-git-hrt.patch
git-input.patch
drivers-input-touchscreen-ads7846c-fix-uninitialized-var-warning.patch
git-kvm.patch
memstick-initial-commit-for-sony-memorystick-support-fix-2.patch
memstick-disable-busted-code.patch
git-mmc.patch
git-mtd.patch
drivers-mtd-maps-physmapc-fix-compile-remove-ifdef.patch
drivers-net-dm9000c-vague-probably-wrong-build-fix.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform.patch
x86-validate-against-acpi-motherboard-resources.patch
git-sched.patch
git-sched-fix-git-conflicts.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
drivers-usb-storage-sddr55c-fix-uninitialized-var-warnings.patch
usb-ohci-sm501-driver-v2-fix.patch
drivers-usb-serial-io_tic-remove-pointless-eye-candy-in-debug-statements.patch
9p-fix-p9_printfcall-export.patch
git-watchdog.patch
git-watchdog-fixup.patch
git-ipwireless_cs.patch
git-x86.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
x86-amd-thermal-interrupt-support.patch
x86-mmconf-enable-mcfg-early.patch
git-xtensa.patch
git-slub.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
kill-filp_open.patch
rename-open_namei-to-open_pathname.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls.patch
r-o-bind-mounts-elevate-write-count-opened-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly.patch
r-o-bind-mounts-track-number-of-mount-writers.patch
keep-track-of-mnt_writer-state-of-struct-file.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file-fix.patch
memcontrol-move-mm_cgroup-to-header-file-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-cleanup.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup-checkpatch-fixes.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent-checkpatch-fixes.patch
cpusets-update_cpumask-revision-fix.patch
cpusets-update_cpumask-revision-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
introduce-flags-for-reserve_bootmem-powerpc-fix.patch
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-unionfs-from-using-iget-and-read_inode-fix-2.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-vs-git-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-cifs-fix.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-smack-fix.patch
introduce-path_put-cifs-fix.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
d_path-make-d_path-use-a-struct-path-fix.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-nommu-fix.patch
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
modules-make-module_address_lookup-safe-fix.patch
wait_task_stopped-simplify-and-fix-races-with-sigcont-sigkill-untrace-fix.patch
pid-sys_wait-fixes-v2-checkpatch-fixes.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
fs-remove-fastcall-it-is-always-empty-checkpatch-fixes.patch
kernel-remove-fastcall-in-kernel-checkpatch-fixes.patch
lib-remove-fastcall-from-lib-checkpatch-fixes.patch
remove-fastcall-from-linux-include-checkpatch-fixes.patch
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
xfs-convert-bex_add-to-bex_add_cpu-new-common-api-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
libfs-allow-error-return-from-simple-attributes-fix.patch
fs-hfsplus-unicodec-fix-uninitialized-var-warning.patch
fs-afs-securityc-fix-uninitialized-var-warning.patch
mount-options-fix-tmpfs-fix.patch
char-applicom-use-pci_match_id-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
