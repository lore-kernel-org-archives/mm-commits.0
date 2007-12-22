From: akpm@linux-foundation.org
Subject: + arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch added to -mm tree
Date: Fri, 21 Dec 2007 16:04:48 -0800
Message-ID: <200712220004.lBM04mNL005798@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32967 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755720AbXLVAFx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 19:05:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu, mzhang@mvista.com, tglx@linutronix.de


The patch titled
     arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: no space between function name and open parenthesis '('
#40: FILE: arch/x86/kernel/cpu/mcheck/k7.c:46:
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);

WARNING: line over 80 characters
#45: FILE: arch/x86/kernel/cpu/mcheck/k7.c:50:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#45: FILE: arch/x86/kernel/cpu/mcheck/k7.c:50:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#48: FILE: arch/x86/kernel/cpu/mcheck/k7.c:52:
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",

WARNING: no space between function name and open parenthesis '('
#65: FILE: arch/x86/kernel/cpu/mcheck/p4.c:161:
+		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"

WARNING: no space between function name and open parenthesis '('
#88: FILE: arch/x86/kernel/cpu/mcheck/p4.c:182:
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);

WARNING: line over 80 characters
#93: FILE: arch/x86/kernel/cpu/mcheck/p4.c:186:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#93: FILE: arch/x86/kernel/cpu/mcheck/p4.c:186:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#96: FILE: arch/x86/kernel/cpu/mcheck/p4.c:188:
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",

WARNING: no space between function name and open parenthesis '('
#120: FILE: arch/x86/kernel/cpu/mcheck/p6.c:46:
+				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);

WARNING: line over 80 characters
#125: FILE: arch/x86/kernel/cpu/mcheck/p6.c:50:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#125: FILE: arch/x86/kernel/cpu/mcheck/p6.c:50:
+				snprintf (addr, 24, " at %08x%08x", ahigh, alow);

WARNING: no space between function name and open parenthesis '('
#128: FILE: arch/x86/kernel/cpu/mcheck/p6.c:52:
+			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",

total: 0 errors, 13 warnings, 100 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Min Zhang <mzhang@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/mcheck/k7.c |   18 +++++++++---------
 arch/x86/kernel/cpu/mcheck/p4.c |   18 +++++++++---------
 arch/x86/kernel/cpu/mcheck/p6.c |   16 ++++++++--------
 3 files changed, 26 insertions(+), 26 deletions(-)

diff -puN arch/x86/kernel/cpu/mcheck/k7.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes arch/x86/kernel/cpu/mcheck/k7.c
--- a/arch/x86/kernel/cpu/mcheck/k7.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
+++ a/arch/x86/kernel/cpu/mcheck/k7.c
@@ -27,11 +27,11 @@ static void k7_machine_check(struct pt_r
 	if (mcgstl & (1<<0))	/* Recoverable ? */
 		recover=0;
 
-	printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
+	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
 
-	for (i=1; i<nr_mce_banks; i++) {
-		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
+	for (i = 1; i < nr_mce_banks; i++) {
+		rdmsr(MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high&(1<<31)) {
 			char misc[20];
 			char addr[24];
@@ -42,17 +42,17 @@ static void k7_machine_check(struct pt_r
 				recover |= 2;
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
-				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
+				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
-				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
+				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
 				smp_processor_id(), i, high, low, misc, addr);
 			/* Clear it */
-			wrmsr (MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
+			wrmsr(MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
 			/* Serialize */
 			wmb();
 			add_taint(TAINT_MACHINE_CHECK);
diff -puN arch/x86/kernel/cpu/mcheck/p4.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes arch/x86/kernel/cpu/mcheck/p4.c
--- a/arch/x86/kernel/cpu/mcheck/p4.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
+++ a/arch/x86/kernel/cpu/mcheck/p4.c
@@ -152,13 +152,13 @@ static void intel_machine_check(struct p
 	if (mcgstl & (1<<0))	/* Recoverable ? */
 		recover=0;
 
-	printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
+	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
 
 	if (mce_num_extended_msrs > 0) {
 		struct intel_mce_extended_msrs dbg;
 		intel_get_extended_msrs(&dbg);
-		printk (KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"
+		printk(KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"
 			"\teax: %08x ebx: %08x ecx: %08x edx: %08x\n"
 			"\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
 			smp_processor_id(), dbg.eip, dbg.eflags,
@@ -166,8 +166,8 @@ static void intel_machine_check(struct p
 			dbg.esi, dbg.edi, dbg.ebp, dbg.esp);
 	}
 
-	for (i=0; i<nr_mce_banks; i++) {
-		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
+	for (i = 0; i < nr_mce_banks; i++) {
+		rdmsr(MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
 			char misc[20];
 			char addr[24];
@@ -178,14 +178,14 @@ static void intel_machine_check(struct p
 				recover |= 2;
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
-				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
+				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
-				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
+				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
 				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
diff -puN arch/x86/kernel/cpu/mcheck/p6.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes arch/x86/kernel/cpu/mcheck/p6.c
--- a/arch/x86/kernel/cpu/mcheck/p6.c~arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes
+++ a/arch/x86/kernel/cpu/mcheck/p6.c
@@ -27,11 +27,11 @@ static void intel_machine_check(struct p
 	if (mcgstl & (1<<0))	/* Recoverable ? */
 		recover=0;
 
-	printk (KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
+	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
 		smp_processor_id(), mcgsth, mcgstl);
 
-	for (i=0; i<nr_mce_banks; i++) {
-		rdmsr (MSR_IA32_MC0_STATUS+i*4,low, high);
+	for (i = 0; i < nr_mce_banks; i++) {
+		rdmsr(MSR_IA32_MC0_STATUS+i*4,low, high);
 		if (high & (1<<31)) {
 			char misc[20];
 			char addr[24];
@@ -42,14 +42,14 @@ static void intel_machine_check(struct p
 				recover |= 2;
 			high &= ~(1<<31);
 			if (high & (1<<27)) {
-				rdmsr (MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf (misc, 20, "[%08x%08x]", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
+				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
 			}
 			if (high & (1<<26)) {
-				rdmsr (MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf (addr, 24, " at %08x%08x", ahigh, alow);
+				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
+				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
 			}
-			printk (KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
+			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
 				smp_processor_id(), i, high, low, misc, addr);
 		}
 	}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

lib-proportion-fix-underflow-in-prop_norm_percpu-checkpatch-fixes.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-alsa-fixup.patch
git-agpgart.patch
git-agpgart-intel-agp-dont-zero-an-already-registered-resource-during-resume.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-powerpc.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
git-dvb-one-videobuf_read_start-is-enough.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
backlight-omap1-backlight-driver.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
add-support-for-sb1-hardware-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-fixup.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
arch-x86-kernel-cpu-mcheck-p4c-kernel-2624-rc5-checkpatch-fixes.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
git-kgdb-fixup.patch
bonding-locking-fix.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work-checkpatch-fixes.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-add-proc-kpagecount-interface-fix.patch
maps4-add-proc-kpageflags-interface-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
page-allocator-clean-up-pcp-draining-functions-swsusp-fix-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
mm-remove-fastcall-from-mm-checkpatch-fixes.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
alpha-fix-warning-by-fixing-flush_tlb_kernel_range.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
riscom8-fix-smp-brokenness-fix.patch
use-macros-instead-of-task_-flags-checkpatch-fixes.patch
sound-oss-pss-set_io_base-always-returns-success-mark-it-void-checkpatch-fixes.patch
remove-warnings-for-longstanding-conditions-fix.patch
genericizing-iova-fix.patch
parallel-port-convert-port_mutex-to-the-mutex-api-checkpatch-fixes.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
allow-auto-destruction-of-loop-devices-checkpatch-fixes.patch
remove-__attribute_used__-checkpatch-fixes.patch
read_current_time-cleanups.patch
read_current_time-cleanups-build-fix-fix.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
quota-improve-inode-list-scanning-in-add_dquot_ref-fix.patch
tty-enable-the-echoing-of-c-in-the-n_tty-discipline-checkpatch-fixes.patch
stopmachine-semaphore-to-mutex-fix.patch
parport-add-support-for-the-quatech-sppxp-100-parallel-port-pci-expresscard-fix.patch
debug_smp_processor_id-fixlets.patch
use-ilog2-in-fs-namespacec-fix.patch
sync_sb_inodes-propagate-errors.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip-fix.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
logo-move-declarations-of-logos-to-linux_logoh-fix.patch
neofb-avoid-overwriting-fb_info-fields.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
kill-filp_open-checkpatch-fixes.patch
rename-open_namei-to-open_pathname-fix.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
r-o-bind-mounts-elevate-write-count-for-do_utimes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files.patch
r-o-bind-mounts-elevate-write-count-opened-files-oops-fix.patch
r-o-bind-mounts-nfs-check-mnt-instead-of-superblock-directly-checkpatch-fixes.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
cgroup-simplify-space-stripping-fix.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page-warning-fix.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup-fix-2.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity-fix.patch
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
embed-a-struct-path-into-struct-nameidata-instead-of-nd-dentrymnt-checkpatch-fixes.patch
one-less-parameter-to-__d_path-checkpatch-fixes.patch
d_path-use-struct-path-in-struct-avc_audit_data-checkpatch-fixes.patch
d_path-make-get_dcookie-use-a-struct-path-argument-checkpatch-fixes.patch
use-struct-path-in-struct-svc_export-checkpatch-fixes.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
proc-detect-duplicate-names-on-registration-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-2.patch
proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-fix-3.patch
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
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
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
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
