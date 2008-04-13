From: akpm@linux-foundation.org
Subject: - git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5.patch removed from -mm tree
Date: Sat, 12 Apr 2008 19:25:30 -0700
Message-ID: <200804130225.m3D2PU5a031903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56862 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752635AbYDMC00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 12 Apr 2008 22:26:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@linux.intel.com, joe@perches.com, mingo@elte.hu, suresh.b.siddha@intel.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     git-x86: revert "x86, fpu: lazy allocation of FPU area - v5"
has been removed from the -mm tree.  Its filename was
     git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86: revert "x86, fpu: lazy allocation of FPU area - v5"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

commit 34e43535bb289dd5a4222a4e33c3b4e75f580744
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Mon Mar 10 15:28:05 2008 -0700

    x86, fpu: lazy allocation of FPU area - v5
    
    Only allocate the FPU area when the application actually uses FPU, i.e., in the
    first lazy FPU trap. This could save memory for non-fpu using apps.
    
    for example: on my system after boot, there are around 300 processes, with
    only 17 using FPU.
    
    Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
    Cc: Arjan van de Ven <arjan@linux.intel.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

To make way for the reversion of "x86, fpu: split FPU state from task struct -
v5".

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joe Perches <joe@perches.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/i387.c       |   38 ++++++---------------------------
 arch/x86/kernel/process.c    |   28 +++++++-----------------
 arch/x86/kernel/process_32.c |    4 ---
 arch/x86/kernel/process_64.c |    4 ---
 arch/x86/kernel/traps_32.c   |   17 +-------------
 arch/x86/kernel/traps_64.c   |   19 ++--------------
 include/asm-x86/i387.h       |    2 -
 include/asm-x86/processor.h  |    2 -
 8 files changed, 23 insertions(+), 91 deletions(-)

diff -puN arch/x86/kernel/i387.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/i387.c
--- a/arch/x86/kernel/i387.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/i387.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/regset.h>
 #include <linux/sched.h>
+#include <linux/bootmem.h>
 
 #include <asm/sigcontext.h>
 #include <asm/processor.h>
@@ -62,6 +63,7 @@ void __init init_thread_xstate(void)
 	else
 		xstate_size = sizeof(struct i387_fsave_struct);
 #endif
+	init_task.thread.xstate = alloc_bootmem(xstate_size);
 }
 
 #ifdef CONFIG_X86_64
@@ -91,22 +93,12 @@ void __cpuinit fpu_init(void)
  * value at reset if we support XMM instructions and then
  * remeber the current task has used the FPU.
  */
-int init_fpu(struct task_struct *tsk)
+void init_fpu(struct task_struct *tsk)
 {
 	if (tsk_used_math(tsk)) {
 		if (tsk == current)
 			unlazy_fpu(tsk);
-		return 0;
-	}
-
-	/*
-	 * Memory allocation at the first usage of the FPU and other state.
-	 */
-	if (!tsk->thread.xstate) {
-		tsk->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!tsk->thread.xstate)
-			return -ENOMEM;
+		return;
 	}
 
 	if (cpu_has_fxsr) {
@@ -128,7 +120,6 @@ int init_fpu(struct task_struct *tsk)
 	 * Only the device not available exception or ptrace can call init_fpu.
 	 */
 	set_stopped_child_used_math(tsk);
-	return 0;
 }
 
 int fpregs_active(struct task_struct *target, const struct user_regset *regset)
@@ -145,14 +136,10 @@ int xfpregs_get(struct task_struct *targ
 		unsigned int pos, unsigned int count,
 		void *kbuf, void __user *ubuf)
 {
-	int ret;
-
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
 				   &target->thread.xstate->fxsave, 0, -1);
@@ -167,10 +154,7 @@ int xfpregs_set(struct task_struct *targ
 	if (!cpu_has_fxsr)
 		return -ENODEV;
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf,
@@ -328,14 +312,11 @@ int fpregs_get(struct task_struct *targe
 	       void *kbuf, void __user *ubuf)
 {
 	struct user_i387_ia32_struct env;
-	int ret;
 
 	if (!HAVE_HWFP)
 		return fpregs_soft_get(target, regset, pos, count, kbuf, ubuf);
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
+	init_fpu(target);
 
 	if (!cpu_has_fxsr) {
 		return user_regset_copyout(&pos, &count, &kbuf, &ubuf,
@@ -363,10 +344,7 @@ int fpregs_set(struct task_struct *targe
 	if (!HAVE_HWFP)
 		return fpregs_soft_set(target, regset, pos, count, kbuf, ubuf);
 
-	ret = init_fpu(target);
-	if (ret)
-		return ret;
-
+	init_fpu(target);
 	set_stopped_child_used_math(target);
 
 	if (!cpu_has_fxsr) {
diff -puN arch/x86/kernel/process.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/process.c
--- a/arch/x86/kernel/process.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/process.c
@@ -5,34 +5,24 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 
-struct kmem_cache *task_xstate_cachep;
+static struct kmem_cache *task_xstate_cachep;
 
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
-	if (src->thread.xstate) {
-		dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep,
-						      GFP_KERNEL);
-		if (!dst->thread.xstate)
-			return -ENOMEM;
-		WARN_ON((unsigned long)dst->thread.xstate & 15);
-		memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
-	}
+	dst->thread.xstate = kmem_cache_alloc(task_xstate_cachep, GFP_KERNEL);
+	if (!dst->thread.xstate)
+		return -ENOMEM;
+	WARN_ON((unsigned long)dst->thread.xstate & 15);
+	memcpy(dst->thread.xstate, src->thread.xstate, xstate_size);
 	return 0;
 }
 
-void free_thread_xstate(struct task_struct *tsk)
-{
-	if (tsk->thread.xstate) {
-		kmem_cache_free(task_xstate_cachep, tsk->thread.xstate);
-		tsk->thread.xstate = NULL;
-	}
-}
-
-
 void free_thread_info(struct thread_info *ti)
 {
-	free_thread_xstate(ti->task);
+	kmem_cache_free(task_xstate_cachep, ti->task->thread.xstate);
+	ti->task->thread.xstate = NULL;
+
 	free_pages((unsigned long)(ti), get_order(THREAD_SIZE));
 }
 
diff -puN arch/x86/kernel/process_32.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/process_32.c
@@ -521,10 +521,6 @@ start_thread(struct pt_regs *regs, unsig
 	regs->cs		= __USER_CS;
 	regs->ip		= new_ip;
 	regs->sp		= new_sp;
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff -puN arch/x86/kernel/process_64.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/process_64.c
--- a/arch/x86/kernel/process_64.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/process_64.c
@@ -544,10 +544,6 @@ start_thread(struct pt_regs *regs, unsig
 	regs->ss		= __USER_DS;
 	regs->flags		= 0x200;
 	set_fs(USER_DS);
-	/*
-	 * Free the old FP and other extended state
-	 */
-	free_thread_xstate(current);
 }
 EXPORT_SYMBOL_GPL(start_thread);
 
diff -puN arch/x86/kernel/traps_32.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/traps_32.c
@@ -1146,22 +1146,9 @@ asmlinkage void math_state_restore(void)
 	struct thread_info *thread = current_thread_info();
 	struct task_struct *tsk = thread->task;
 
-	if (!tsk_used_math(tsk)) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(tsk)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
 	clts();				/* Allow maths ops (or we recurse) */
+	if (!tsk_used_math(tsk))
+		init_fpu(tsk);
 	restore_fpu(tsk);
 	thread->status |= TS_USEDFPU;	/* So we fnsave on switch_to() */
 	tsk->fpu_counter++;
diff -puN arch/x86/kernel/traps_64.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 arch/x86/kernel/traps_64.c
--- a/arch/x86/kernel/traps_64.c~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/arch/x86/kernel/traps_64.c
@@ -1116,23 +1116,10 @@ asmlinkage void __attribute__((weak)) mc
 asmlinkage void math_state_restore(void)
 {
 	struct task_struct *me = current;
-
-	if (!used_math()) {
-		local_irq_enable();
-		/*
-		 * does a slab alloc which can sleep
-		 */
-		if (init_fpu(me)) {
-			/*
-			 * ran out of memory!
-			 */
-			do_group_exit(SIGKILL);
-			return;
-		}
-		local_irq_disable();
-	}
-
 	clts();			/* Allow maths ops (or we recurse) */
+
+	if (!used_math())
+		init_fpu(me);
 	restore_fpu_checking(&me->thread.xstate->fxsave);
 	task_thread_info(me)->status |= TS_USEDFPU;
 	me->fpu_counter++;
diff -puN include/asm-x86/i387.h~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 include/asm-x86/i387.h
--- a/include/asm-x86/i387.h~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/include/asm-x86/i387.h
@@ -21,7 +21,7 @@
 
 extern void fpu_init(void);
 extern void mxcsr_feature_mask_init(void);
-extern int init_fpu(struct task_struct *child);
+extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void init_thread_xstate(void);
 
diff -puN include/asm-x86/processor.h~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5 include/asm-x86/processor.h
--- a/include/asm-x86/processor.h~git-x86-revert-x86-fpu-lazy-allocation-of-fpu-area-v5
+++ a/include/asm-x86/processor.h
@@ -366,8 +366,6 @@ DECLARE_PER_CPU(struct orig_ist, orig_is
 
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern unsigned int xstate_size;
-extern void free_thread_xstate(struct task_struct *);
-extern struct kmem_cache *task_xstate_cachep;
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

revert-set-relay-file-can-not-be-read-by-pread2.patch
git-acpi.patch
git-acpi-revert-suspend-wakeup-code-in-c.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
git-x86.patch
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

