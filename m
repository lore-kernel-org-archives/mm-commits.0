From: akpm@linux-foundation.org
Subject: + read_current_time-cleanups.patch added to -mm tree
Date: Wed, 07 Nov 2007 15:56:17 -0800
Message-ID: <200711072356.lA7NuJZk002032@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51021 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107AbXKGX5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Nov 2007 18:57:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, ak@suse.de, davem@davemloft.net, hskinnemoen@atmel.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     read_current_time() cleanups
has been added to the -mm tree.  Its filename is
     read_current_time-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: read_current_time() cleanups
From: Andrew Morton <akpm@linux-foundation.org>

- All implementations can be __devinit

- The function prototypes were in asm/timex.h but they all must be the same,
  so create a single declaration in linux/times.h.

- uninline the sparc64 version to match the other architectures

- Don't bother #defining ARCH_HAS_READ_CURRENT_TIMER to a particular value.

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
@@ -243,6 +243,8 @@ extern int do_adjtimex(struct timex *);
 /* Don't use! Compatibility define for existing users. */
 #define tickadj	(500/HZ ? : 1)
 
+int __devinit read_current_timer(unsigned long *timer_val);
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
proc-fix-proc_kill_inodes-to-kill-dentries-on-all-proc-superblocks-checkpatch-fixes.patch
acpi-make-acpi_procfs-default-to-y.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200-fix.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of-fix.patch
git-alsa.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
git-arm-fixup.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
git-hwmon.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
elantech-touchpad-driver-fix.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
ide-arm-hack.patch
git-mtd-fix.patch
lmc_ioctl-dont-return-with-locks-held-fix.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
bluetooth-uninlining.patch
git-nfsd-fixup.patch
quirk_vialatency-omit-reading-pci-revision-id-checkpatch-fixes.patch
fix-build-breakage-if-sysfs-fix.patch
wd7000-broke.patch
ips-trim-trailing-whitespace-checkpatch-fixes.patch
scsi-gdth-kill-unneeded-irq-argument-checkpatch-fixes.patch
scsi-fix-bugs-and-canonicalize-ncr5380_intr-drivers-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
git-wireless.patch
jiffies_round-jiffies_round_relative-conversion-rt2x00-checkpatch-fixes.patch
git-ipwireless-ipwireless_cs_tty-warning-fix.patch
git-x86.patch
git-x86-fixup.patch
oprofile-op_model_athalonc-support-for-amd-family10h-barcelona-performance-counters-checkpatch-fixes.patch
i386-and-x86_64-randomize-brk-fix.patch
x86-arch_register_cpu-section-fix.patch
mips-undo-locking-on-error-path-returns-checkpatch-fixes.patch
pidns-place-under-config_experimental-checkpatch-fixes.patch
fix-64kb-blocksize-in-ext3-directories-checkpatch-fixes.patch
file-capabilities-allow-sigcont-within-session-v2-checkpatch-fixes.patch
x86-disable-preemption-in-delay_tsc.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
hugetlb-split-alloc_huge_page-into-private-and-shared-components-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
cris-build-fixes-atomich-needs-compilerh-fix.patch
cris-build-fixes-update-eth_v10c-ethernet-driver-fix.patch
cris-build-fixes-fix-mtdramh-checkpatch-fixes.patch
cris-build-fixes-fixes-in-arch-cris-kernel-timec-checkpatch-fixes.patch
cris-remove-mtd_amstd-and-mtd_obsolete_chips-take-two-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
fix-versus-precedence-in-various-places-checkpatch-fixes.patch
pie-executable-randomization.patch
pie-executable-randomization-checkpatch-fixes.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
sync_sb_inodes-propagate-errors.patch
64-bit-i_version-afs-fixes.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
drivers-edac-add-marvell-mv64x60-driver-fix.patch
introduce-flags-for-reserve_bootmem-checkpatch-fixes.patch
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
dhowells-broke-unionfs.patch
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
jens-broke-reiser4patch-added-to-mm-tree.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
