From: akpm@linux-foundation.org
Subject: + git-x86-git-rejects.patch added to -mm tree
Date: Wed, 01 Oct 2008 15:12:38 -0700
Message-ID: <200810012212.m91MCcoa006851@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37953 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856AbYJAWNI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Oct 2008 18:13:08 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m91MCc0i032537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Wed, 1 Oct 2008 15:12:39 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-x86-git-rejects
has been added to the -mm tree.  Its filename is
     git-x86-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86-git-rejects
From: Andrew Morton <akpm@linux-foundation.org>


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/common.c |    6 ------
 arch/x86/kernel/process_32.c |    7 -------
 arch/x86/kernel/process_64.c |    4 ----
 arch/x86/kernel/setup.c      |    3 ---
 include/asm-x86/cpufeature.h |    3 ---
 include/asm-x86/idle.h       |    4 ----
 6 files changed, 27 deletions(-)

diff -puN arch/x86/kernel/cpu/common.c~git-x86-git-rejects arch/x86/kernel/cpu/common.c
--- a/arch/x86/kernel/cpu/common.c~git-x86-git-rejects
+++ a/arch/x86/kernel/cpu/common.c
@@ -552,18 +552,12 @@ void __init early_cpu_init(void)
  * The NOPL instruction is supposed to exist on all CPUs with
  * family >= 6; unfortunately, that's not true in practice because
  * of early VIA chips and (more importantly) broken virtualizers that
-<<<<<<< HEAD:arch/x86/kernel/cpu/common.c
- * are not easy to detect.  In the latter case it doesn't even *fail*
- * reliably, so probing for it doesn't even work.  Disable it completely
- * unless we can find a reliable way to detect all the broken cases.
-=======
  * are not easy to detect.  Hence, probe for it based on first
  * principles.
  *
  * Note: no 64-bit chip is known to lack these, but put the code here
  * for consistency with 32 bits, and to make it utterly trivial to
  * diagnose the problem should it ever surface.
->>>>>>> FETCH_HEAD:arch/x86/kernel/cpu/common.c
  */
 static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 {
diff -puN arch/x86/kernel/process_32.c~git-x86-git-rejects arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~git-x86-git-rejects
+++ a/arch/x86/kernel/process_32.c
@@ -55,12 +55,9 @@
 #include <asm/tlbflush.h>
 #include <asm/cpu.h>
 #include <asm/kdebug.h>
-<<<<<<< HEAD:arch/x86/kernel/process_32.c
 #include <asm/idle.h>
-=======
 #include <asm/syscalls.h>
 #include <asm/smp.h>
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_32.c
 
 asmlinkage void ret_from_fork(void) __asm__("ret_from_fork");
 
@@ -78,7 +75,6 @@ unsigned long thread_saved_pc(struct tas
 	return ((unsigned long *)tsk->thread.sp)[3];
 }
 
-<<<<<<< HEAD:arch/x86/kernel/process_32.c
 #ifdef CONFIG_HOTPLUG_CPU
 #include <asm/nmi.h>
 
@@ -115,9 +111,6 @@ static inline void play_dead(void)
 	wbinvd_halt();
 }
 #else
-=======
-#ifndef CONFIG_SMP
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_32.c
 static inline void play_dead(void)
 {
 	BUG();
diff -puN arch/x86/kernel/process_64.c~git-x86-git-rejects arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~git-x86-git-rejects
+++ a/arch/x86/kernel/process_64.c
@@ -86,7 +86,6 @@ void exit_idle(void)
 	__exit_idle();
 }
 
-<<<<<<< HEAD:arch/x86/kernel/process_64.c
 #ifdef CONFIG_HOTPLUG_CPU
 DECLARE_PER_CPU(int, cpu_state);
 
@@ -106,9 +105,6 @@ static inline void play_dead(void)
 	wbinvd_halt();
 }
 #else
-=======
-#ifndef CONFIG_SMP
->>>>>>> FETCH_HEAD:arch/x86/kernel/process_64.c
 static inline void play_dead(void)
 {
 	BUG();
diff -puN arch/x86/kernel/setup.c~git-x86-git-rejects arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~git-x86-git-rejects
+++ a/arch/x86/kernel/setup.c
@@ -909,12 +909,9 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
-<<<<<<< HEAD:arch/x86/kernel/setup.c
-=======
 	check_efer();
  	if (cpu_has_x2apic)
  		check_x2apic();
->>>>>>> FETCH_HEAD:arch/x86/kernel/setup.c
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
diff -puN include/asm-x86/cpufeature.h~git-x86-git-rejects include/asm-x86/cpufeature.h
--- a/include/asm-x86/cpufeature.h~git-x86-git-rejects
+++ a/include/asm-x86/cpufeature.h
@@ -89,11 +89,8 @@
 #define X86_FEATURE_LFENCE_RDTSC (3*32+18) /* "" Lfence synchronizes RDTSC */
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
-<<<<<<< HEAD:include/asm-x86/cpufeature.h
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
-=======
 #define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
->>>>>>> FETCH_HEAD:include/asm-x86/cpufeature.h
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
diff -puN include/asm-x86/idle.h~git-x86-git-rejects include/asm-x86/idle.h
--- a/include/asm-x86/idle.h~git-x86-git-rejects
+++ a/include/asm-x86/idle.h
@@ -10,10 +10,6 @@ void idle_notifier_register(struct notif
 void enter_idle(void);
 void exit_idle(void);
 
-<<<<<<< HEAD:include/asm-x86/idle.h
 void c1e_remove_cpu(int cpu);
 
-#endif
-=======
 #endif /* ASM_X86__IDLE_H */
->>>>>>> FETCH_HEAD:include/asm-x86/idle.h
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

git-powerpc.patch
git-sparc.patch
git-x86.patch
git-x86-git-rejects.patch
git-xtensa.patch
git-ftrace.patch
git-pci.patch
git-hid.patch
git-v4l-dvb.patch
git-nfsd.patch
git-dlm.patch
git-async_tx.patch
git-net.patch
git-mtd.patch
git-sound.patch
git-sound-rejects.patch
git-input.patch
git-block.patch
git-battery.patch
git-mfd.patch
git-drm.patch
drivers-mfd-ucb1400_corec-needs-gpio.patch
drivers-mfd-ucb1400_corec-further-unbork.patch
arch-x86-kernel-early_printkc-remove-unused-enable_debug_console.patch
drivers-media-video-tda9840c-unbreak.patch
tick-schedc-suppress-needless-timer-reprogramming.patch
drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
led-driver-for-leds-on-pcengines-alix2-and-alix3-boards.patch
libata-blackfin-pata-driver-add-proper-pm-operation-into-atapi-driver.patch
misdn-misc-timerdev-fixes-fix.patch
drivers-net-sfc-falconc-fix-min-warnings.patch
backlight-driver-for-tabletkiosk-sahara-touchit-213-tablet-pc.patch
drivers-scsi-device_handler-scsi_dh_emcc-suppress-warning.patch
drivers-scsi-sdh-use-inlined-c-functions-not-macros.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
acpi-cope-with-pnpacpi-tables-missing-an-rtc-entry.patch
drivers-media-video-cafe_ccicc-needs-mmh.patch
mm-page_allocc-free_area_init_nodes-fix-inappropriate-use-of-enum.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix.patch
mm-cleanup-to-make-remove_memory-arch-neutral-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mlock-mlocked-pages-are-unevictable-fix.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
mmap-handle-mlocked-pages-during-map-remap-unmap-mlock-resubmit-locked_vm-adjustment-as-separate-patch-fix.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct-fix.patch
mm-rewrite-vmap-layer-fix.patch
mm-rewrite-vmap-layer-fix-fix.patch
mm-rewrite-vmap-layer-fix-fix-fix.patch
h8300-generic_bug-support-checkpatch-fixes.patch
pm-rework-disabling-of-user-mode-helpers-during-suspend-hibernation-cleanup.patch
container-freezer-add-tif_freeze-flag-to-all-architectures-fix.patch
container-freezer-implement-freezer-cgroup-subsystem-checkpatch-fixes.patch
container-freezer-implement-freezer-cgroup-subsystem-uninline-thaw_process-fix.patch
eeepc-laptop-use-standard-interfaces-fix-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix.patch
separate-atomic_t-declaration-from-asm-atomich-into-asm-atomic_defh-fix-fix.patch
make-taint-bit-reliable-v3-fix.patch
kernel-sysc-improve-code-generation.patch
compat-generic-compat-get-settimeofday-checkpatch-fixes.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms-cleanup.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms-cleanup.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
allow-recursion-in-binfmt_script-and-binfmt_misc-fix.patch
serial-make-uart_ports-ioport-unsigned-long-fix.patch
autofs4-track-uid-and-gid-of-last-mount-requester-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-2.patch
autofs4-add-miscellaneous-device-for-ioctls-fix-fix-3.patch
rtc-add-device-driver-for-dallas-ds3234-spi-rtc-chip-fix.patch
fb-push-down-the-bkl-in-the-ioctl-handler-checkpatch-fixes.patch
viafb-viafbmodes-viafbtxt-fix-fix.patch
viafb-accelc-accelh-checkpatch-fixes.patch
viafb-dvic-dvih-globalc-and-globalh-checkpatch-fixes.patch
viafb-hwc-hwh-checkpatch-fixes.patch
viafb-viafbdevc-viafbdevh-checkpatch-fixes.patch
fbdev-kconfig-update-fix.patch
ext2-avoid-printk-floods-in-the-face-of-directory-corruption-checkpatch-fixes.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
memrlimit-add-memrlimit-controller-accounting-and-control-mm_owner-fix-checkpatch-fixes.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
tty-fix-echo-tab-erase-and-locking-fix.patch
applicomc-fix-apparently-broken-code-in-do_ac_read.patch
drivers-char-tpm-tpmc-fix-error-patch-memory-leak.patch
w1-be-able-to-manually-add-and-remove-slaves-fix.patch
w1-new-driver-ds2431-chip-fix.patch
gru-driver-minor-updates-fix.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch
nilfs2-inode-operations-fix.patch
nilfs2-pathname-operations-fix.patch
reiser4.patch
reiser4-tree_lock-fixes.patch
reiser4-tree_lock-fixes-fix.patch
reiser4-semaphore-fix.patch
slb-drop-kmem-cache-argument-from-constructor-reiser4.patch
reiser4-suid.patch
reiser4-track-upstream-changes.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch
profile-likely-unlikely-macros.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
w1-build-fix.patch

