From: akpm@linux-foundation.org
Subject: - revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:25:21 -0700
Message-ID: <200804130225.m3D2PMi4031900@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752624AbYDMC0V (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:26:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, joe@perches.com, mingo@elte.hu, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     revert "include/asm-x86/i387.h: checkpatch cleanups - formatting only"
has been removed from the -mm tree.  Its filename was
     revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: revert "include/asm-x86/i387.h: checkpatch cleanups - formatting only"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit ae8be98cf0ab0ec484891fbe876d76a96a37b0ca
Author: Joe Perches <joe@perches.com>
Date:   Sun Mar 23 01:02:18 2008 -0700

    include/asm-x86/i387.h: checkpatch cleanups - formatting only
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

To make way for the reversion of "x86, fpu: lazy allocation of FPU area - v5"
and "x86, fpu: split FPU state from task struct - v5".

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/i387.h |   94 ++++++++++++++++++++-------------------
 1 file changed, 50 insertions(+), 44 deletions(-)

diff -puN include/asm-x86/i387.h~revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only include/asm-x86/i387.h
--- a/include/asm-x86/i387.h~revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only
+++ a/include/asm-x86/i387.h
@@ -42,7 +42,7 @@ static inline void tolerant_fwait(void)
 {
 	asm volatile("1: fwait\n"
 		     "2:\n"
-		     _ASM_EXTABLE(1b, 2b));
+		     _ASM_EXTABLE(1b,2b));
 }
 
 static inline int restore_fpu_checking(struct i387_fxsave_struct *fx)
@@ -55,7 +55,7 @@ static inline int restore_fpu_checking(s
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
 		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
+		     _ASM_EXTABLE(1b,3b)
 		     : [err] "=r" (err)
 #if 0 /* See comment in __save_init_fpu() below. */
 		     : [fx] "r" (fx), "m" (*fx), "0" (0));
@@ -77,11 +77,11 @@ static inline int restore_fpu_checking(s
 static inline void clear_fpu_state(struct i387_fxsave_struct *fx)
 {
 	if (unlikely(fx->swd & X87_FSW_ES))
-		asm volatile("fnclex");
+		 asm volatile("fnclex");
 	alternative_input(ASM_NOP8 ASM_NOP2,
-			  "    emms\n"		/* clear stack tags */
-			  "    fildl %%gs:0",	/* load to clear state */
-			  X86_FEATURE_FXSAVE_LEAK);
+		     "    emms\n"		/* clear stack tags */
+		     "    fildl %%gs:0",	/* load to clear state */
+		     X86_FEATURE_FXSAVE_LEAK);
 }
 
 static inline int save_i387_checking(struct i387_fxsave_struct __user *fx)
@@ -94,15 +94,14 @@ static inline int save_i387_checking(str
 		     "3:  movl $-1,%[err]\n"
 		     "    jmp  2b\n"
 		     ".previous\n"
-		     _ASM_EXTABLE(1b, 3b)
+		     _ASM_EXTABLE(1b,3b)
 		     : [err] "=r" (err), "=m" (*fx)
 #if 0 /* See comment in __fxsave_clear() below. */
 		     : [fx] "r" (fx), "0" (0));
 #else
 		     : [fx] "cdaSDb" (fx), "0" (0));
 #endif
-	if (unlikely(err) &&
-	    __clear_user(fx, sizeof(struct i387_fxsave_struct)))
+	if (unlikely(err) && __clear_user(fx, sizeof(struct i387_fxsave_struct)))
 		err = -EFAULT;
 	/* No need to clear here because the caller clears USED_MATH */
 	return err;
@@ -117,21 +116,21 @@ static inline void __save_init_fpu(struc
 #if 0
 	/* Using "fxsaveq %0" would be the ideal choice, but is only supported
 	   starting with gas 2.16. */
-	asm volatile("fxsaveq %0"
-		     : "=m" (tsk->thread.xstate->fxsave));
+	__asm__ __volatile__("fxsaveq %0"
+			     : "=m" (tsk->thread.xstate->fxsave));
 #elif 0
 	/* Using, as a workaround, the properly prefixed form below isn't
 	   accepted by any binutils version so far released, complaining that
 	   the same type of prefix is used twice if an extended register is
 	   needed for addressing (fix submitted to mainline 2005-11-21). */
-	asm volatile("rex64/fxsave %0"
-		     : "=m" (tsk->thread.xstate->fxsave));
+	__asm__ __volatile__("rex64/fxsave %0"
+			     : "=m" (tsk->thread.xstate->fxsave));
 #else
 	/* This, however, we can work around by forcing the compiler to select
 	   an addressing mode that doesn't require extended registers. */
-	asm volatile("rex64/fxsave (%1)"
-		     : "=m" (tsk->thread.xstate->fxsave)
-		     : "cdaSDb" (&tsk->thread.xstate->fxsave));
+	__asm__ __volatile__("rex64/fxsave (%1)"
+			     : "=m" (tsk->thread.xstate->fxsave)
+			     : "cdaSDb" (&tsk->thread.xstate->fxsave));
 #endif
 	clear_fpu_state(&tsk->thread.xstate->fxsave);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
@@ -147,7 +146,7 @@ static inline int save_i387(struct _fpst
 	int err = 0;
 
 	BUILD_BUG_ON(sizeof(struct user_i387_struct) !=
-		     sizeof(tsk->thread.xstate->fxsave));
+			sizeof(tsk->thread.xstate->fxsave));
 
 	if ((unsigned long)buf % 16)
 		printk("save_i387: bad fpstate %p\n", buf);
@@ -156,10 +155,8 @@ static inline int save_i387(struct _fpst
 		return 0;
 	clear_used_math(); /* trigger finit */
 	if (task_thread_info(tsk)->status & TS_USEDFPU) {
-		err = save_i387_checking((struct i387_fxsave_struct __user *)
-					 buf);
-		if (err)
-			return err;
+		err = save_i387_checking((struct i387_fxsave_struct __user *)buf);
+		if (err) return err;
 		task_thread_info(tsk)->status &= ~TS_USEDFPU;
 		stts();
 	} else {
@@ -193,12 +190,14 @@ static inline void tolerant_fwait(void)
 static inline void restore_fpu(struct task_struct *tsk)
 {
 	/*
-	 * The "nop" is needed to make the instructions the same length.
+	 * The "nop" is needed to make the instructions the same
+	 * length.
 	 */
-	alternative_input("nop ; frstor %1",
-			  "fxrstor %1",
-			  X86_FEATURE_FXSR,
-			  "m" (tsk->thread.xstate->fxsave));
+	alternative_input(
+		"nop ; frstor %1",
+		"fxrstor %1",
+		X86_FEATURE_FXSR,
+		"m" (tsk->thread.xstate->fxsave));
 }
 
 /* We need a safe address that is cheap to find and that is already
@@ -217,21 +216,22 @@ static inline void __save_init_fpu(struc
 {
 	/* Use more nops than strictly needed in case the compiler
 	   varies code */
-	alternative_input("fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
-			  "fxsave %[fx]\n"
-			  "bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
-			  X86_FEATURE_FXSR,
-			  [fx] "m" (tsk->thread.xstate->fxsave),
-			  [fsw] "m" (tsk->thread.xstate->fxsave.swd)
-			  : "memory");
+	alternative_input(
+		"fnsave %[fx] ;fwait;" GENERIC_NOP8 GENERIC_NOP4,
+		"fxsave %[fx]\n"
+		"bt $7,%[fsw] ; jnc 1f ; fnclex\n1:",
+		X86_FEATURE_FXSR,
+		[fx] "m" (tsk->thread.xstate->fxsave),
+		[fsw] "m" (tsk->thread.xstate->fxsave.swd) : "memory");
 	/* AMD K7/K8 CPUs don't save/restore FDP/FIP/FOP unless an exception
 	   is pending.  Clear the x87 state here by setting it to fixed
 	   values. safe_address is a random variable that should be in L1 */
-	alternative_input(GENERIC_NOP8 GENERIC_NOP2,
-			  "emms\n\t"	  	/* clear stack tags */
-			  "fildl %[addr]", 	/* set F?P to defined value */
-			  X86_FEATURE_FXSAVE_LEAK,
-			  [addr] "m" (safe_address));
+	alternative_input(
+		GENERIC_NOP8 GENERIC_NOP2,
+		"emms\n\t"	  	/* clear stack tags */
+		"fildl %[addr]", 	/* set F?P to defined value */
+		X86_FEATURE_FXSAVE_LEAK,
+		[addr] "m" (safe_address));
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
@@ -322,23 +322,29 @@ static inline void clear_fpu(struct task
  */
 static inline unsigned short get_fpu_cwd(struct task_struct *tsk)
 {
-	if (cpu_has_fxsr)
+	if (cpu_has_fxsr) {
 		return tsk->thread.xstate->fxsave.cwd;
-	return (unsigned short)tsk->thread.xstate->fsave.cwd;
+	} else {
+		return (unsigned short) tsk->thread.xstate->fsave.cwd;
+	}
 }
 
 static inline unsigned short get_fpu_swd(struct task_struct *tsk)
 {
-	if (cpu_has_fxsr)
+	if (cpu_has_fxsr) {
 		return tsk->thread.xstate->fxsave.swd;
-	return (unsigned short)tsk->thread.xstate->fsave.swd;
+	} else {
+		return (unsigned short) tsk->thread.xstate->fsave.swd;
+	}
 }
 
 static inline unsigned short get_fpu_mxcsr(struct task_struct *tsk)
 {
-	if (cpu_has_xmm)
+	if (cpu_has_xmm) {
 		return tsk->thread.xstate->fxsave.mxcsr;
-	return MXCSR_DEFAULT;
+	} else {
+		return MXCSR_DEFAULT;
+	}
 }
 
 #endif	/* _ASM_X86_I387_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
revert-include-asm-x86-i387h-checkpatch-cleanups-formatting-only.patch
git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5.patch
git-x86-revert-x86-fpu-split-fpu-state-from-task-struct-v5.patch
arch-x86-mm-ioremapc-fix-printk-warnings.patch
git-x86-fix-warning-in-arch-x86-kernel-vsmp_64c.patch
git-kgdb-light.patch
git-x86-hack-around-to-make-git-kgdb-build.patch
git-x86-vs-git-kgdb-lite.patch
git-alsa-tiwai.patch
es1968-fix-jitter-on-some-maestro-cards-checkpatch-fixes.patch
git-agpgart-export-agp_generic_alloc_pages.patch
git-agpgart-fix-type-confusion.patch
git-agpgart-drivers-char-agp-i460-agpc-hacks.patch
cifs-suppress-warning.patch
git-powerpc.patch
pm-remove-destroy_suspended_device.patch
pm-introduce-new-top-level-suspend-and-hibernation-callbacks-rev-7-fix.patch
pm-new-suspend-and-hibernation-callbacks-for-pci-bus-type-rev-3-fix.patch
git-drm.patch
revert-git-drm.patch
git-dvb.patch
git-hwmon.patch
git-gfs2-nmw.patch
git-dlm-vs-git-gfs2-nwm.patch
git-hid.patch
git-hrt.patch
time-close-small-window-for-vsyscall-time-inconsistencies-checkpatch-fixes.patch
git-ia64.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-vs-gregkh-driver-ib-convert-struct-class_device-to-struct-device.patch
gregkh-driver-ib-convert-struct-class_device-to-struct-device-vs-git-infiniband.patch
maple-add-driver-for-sega-dreamcast-controller.patch
touch-screen-driver-for-the-superh-migor-board-checkpatch-fixes.patch
git-kvm.patch
git-leds.patch
git-libata-all.patch
git-libata-all-unbork-drivers-ata-sata_sx4c.patch
pata_atiixp-simplex-clear-fix.patch
git-async-tx.patch
git-mips.patch
git-net.patch
drivers-atm-firestreamc-suppress-uninitialized-var-warning.patch
drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
ehea-fix-dlpar-memory-add-support-fix.patch
sundance-set-carrier-status-on-link-change-events-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
fs-nfs-callback_xdrc-suppress-uninitialiized-variable-warnings.patch
git-nfsd.patch
git-ocfs2.patch
arch-parisc-kernel-unalignedc-use-time_-macros.patch
drivers-pcmcia-soc_commonc-convert-soc_pcmcia_sockets_lock-into-a-mutex-and-make-it-static.patch
git-selinux.patch
revert-gregkh-pci-pci-arm-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-cris-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-frv-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mips-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-mn10300-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-parisc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-ppc-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sh-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-sparc64-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-v850-use-generic-pci_enable_resources.patch
revert-gregkh-pci-pci-xtensa-use-generic-pci_enable_resources.patch
pci-hotplug-introduce-pci_slot-fix.patch
pci-hotplug-introduce-pci_slot-fix-fix.patch
pci-hotplug-introduce-pci_slot-fix-2.patch
pci-hotplug-introduce-pci_slot-fix-99.patch
pci-hotplug-acpi-pci-slot-detection-driver-fix.patch
drivers-acpi-pci_slotc-fix-build-with-config_dmi=n.patch
git-s390.patch
git-sched.patch
git-sh.patch
sh-arch-sh-kernel-traps_32c-needs-asm-fpuh.patch
sh-export-empty_zero_page.patch
git-scsi-misc.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
scsi-fix-section-mismatch-in-aic94xx.patch
aacraid-fix-unchecked-down_interruptible.patch
drivers-scsi-mvsasc-fix-build-warnings.patch
git-block-git-rejects.patch
sparc32-export-empty_zero_page.patch
git-unionfs.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
git-v9fs.patch
git-vfs.patch
git-watchdog.patch
git-watchdog-git-rejects.patch
xfs-suppress-uninitialized-var-warnings.patch
git-cryptodev-misplaced-hunk.patch
git-cryptodev-fix-conflict.patch
git-cryptodev-fix-conflict-hack.patch
git-xtensa.patch
make-module_sect_attrs-private-to-kernel-modulec-checkpatch-fixes.patch
git-semaphore-vs-git-x86.patch
git-semaphore-git-rejects.patch
ext4-is-busted-on-m68k.patch
smc91x-driver-fix-bug-print-warning-only-in-interrupt-mode.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
fix-invalidate_inode_pages2_range-to-not-clear-ret-checkpatch-fixes.patch
mm-make-reserve_bootmem-can-crossed-the-nodes-checkpatch-fixes.patch
mm-make-early_pfn_to_nid-a-c-function.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-checkpatch-fixes.patch
vmalloc-show-vmalloced-areas-via-proc-vmallocinfo-fix-2.patch
vmallocinfo-add-caller-information-checkpatch-fixes.patch
page_mapping-add-ifdef-around-reference-to-swapper_space.patch
smaps-account-swap-entries-sneak-in-a-coding-style-fix.patch
mm-introduce-pte_special-pte-bit-fix.patch
hugetlb-vmstat-events-for-huge-page-allocations-cleanup.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix.patch
mempolicy-use-struct-mempolicy-pointer-in-shmem_sb_info-fix-fix-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-implement-per-process-securebits-warning-fix.patch
lsm-introduce-inode_getsecid-and-ipc_getsecid-hooks-checkpatch-fixes.patch
lsm-audit-introduce-generic-audit-lsm-hooks-checkpatch-fixes.patch
selinux-use-new-audit-hooks-remove-redundant-exports-checkpatch-fixes.patch
audit-final-renamings-and-cleanup-checkpatch-fixes.patch
arch-alpha-kernel-trapsc-use-time_-macros-fix.patch
alpha-teach-the-compiler-that-bug-doesnt-return.patch
make-dev-kmem-a-config-option-fix.patch
misc-phantom-add-compat-ioctl-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes.patch
sysrq-add-show-backtrace-on-all-cpus-function-checkpatch-fixes-cleanup.patch
codafs-fix-build-warning.patch
lists-add-const-qualifier-to-first-arg-of-list_splice-operations-checkpatch-fixes.patch
lib-swiotlbc-cleanups.patch
fs-inodec-use-hlist_for_each_entry-checkpatch-fixes.patch
add-rcu_assign_index-if-ever-needed-fix.patch
add-warn_on_secs-macro-simplification-fix.patch
add-warn_on_secs-macro-simplification-fix-fix.patch
uart_get_baud_rate-stop-mangling-termios-fix.patch
drivers-acpi-thermalc-fix-build-with-config_dmi=n.patch
oprofile-change-cpu_buffer-from-array-to-per_cpu-variable-checkpatch-fixes.patch
vt-notifier-extension-for-accessibility-checkpatch-fixes.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
quota-various-style-cleanups-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext3-make-ext3-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-quota-core-changes-for-quotaon-on-remount-quota-ext4-make-ext4-handle-quotaon-on-remount-checkpatch-fixes.patch
quota-convert-stub-functions-from-macros-into-inlines.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
gpiochip_reserve-fix.patch
fb-add-support-for-foreign-endianness-force-it-on.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
pm-gxfb-add-hook-to-pm-console-layer-that-allows-disabling-of-suspend-vt-switch-fix.patch
lxfb-add-power-management-functionality-fix.patch
pnp-use-dev_printk-for-quirk-messages-fix.patch
fat_valid_media-remove-pointless-test.patch
documentation-build-source-files-in-documentation-sub-dir-disable.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroups-implement-device-whitelist-v6-checkpatch-fixes.patch
cgroups-implement-device-whitelist-v6-cleanups.patch
cgroups-implement-device-whitelist-v6-fix.patch
add-a-document-describing-the-resource-counter-abstraction-v2-fix.patch
memcgroup-implement-failcounter-reset-checkpatch-fixes.patch
workqueues-shrink-cpu_populated_map-when-cpu-dies-fix.patch
ipc-use-ipc_buildid-directly-from-ipc_addid-cleanup.patch
ipc-add-definitions-of-ushort_max-and-others-checkpatch-fixes.patch
ipmi-run-to-completion-fixes-checkpatch-fixes.patch
ipmi-style-fixes-in-the-system-interface-code-checkpatch-fixes.patch
sxc-fix-printk-warnings-on-sparc32.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix.patch
sgi-altix-mmtimer-allow-larger-number-of-timers-per-node-fix-2.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
keys-add-keyctl-function-to-get-a-security-label-fix.patch
procfs-task-exe-symlink-fix.patch
proc-switch-to-proc_create.patch
edd-add-default-mode-config_edd_off=n-override-with-edd=onoff-fix.patch
mm-bdi-export-bdi-attributes-in-sysfs-ia64-fix.patch
basic-braille-screen-reader-support-ppc-fix.patch
hfs-fix-warning-with-64k-page_size.patch
hfsplus-fix-warning-with-64k-page_size.patch
alloc_uid-cleanup.patch
add-macros-similar-to-min-max-min_t-max_t.patch
rename-div64_64-to-div64_u64-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix.patch
idr-create-idr_layer_cache-at-boot-time-fix-fix.patch
edac-add-e752x-parameter-for-sysbus_parity-selection-checkpatch-fixes.patch
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
profile-likely-unlikely-macros.patch
profile-likely-unlikely-macros-fix.patch
w1-build-fix.patch

