From: akpm@linux-foundation.org
Subject: + git-x86-fixup.patch added to -mm tree
Date: Tue, 15 Jan 2008 17:07:09 -0800
Message-ID: <200801160107.m0G17ARg012806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544AbYAPBH3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 20:07:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mingo@elte.hu


The patch titled
     git-x86-fixup
has been added to the -mm tree.  Its filename is
     git-x86-fixup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: git-x86-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Repair some of the damage against various things.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/acpi/boot.c           |   11 +++++-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   14 ++++----
 arch/x86/kernel/entry_64.S            |    2 -
 arch/x86/kernel/traps_32.c            |   41 ++----------------------
 arch/x86/kernel/traps_64.c            |    8 ++--
 arch/x86/oprofile/nmi_int.c           |    4 +-
 arch/x86/pci/init.c                   |    4 --
 include/asm-x86/thread_info_64.h      |    3 +
 include/linux/acpi.h                  |    1 
 9 files changed, 35 insertions(+), 53 deletions(-)

diff -puN arch/x86/kernel/acpi/boot.c~git-x86-fixup arch/x86/kernel/acpi/boot.c
--- a/arch/x86/kernel/acpi/boot.c~git-x86-fixup
+++ a/arch/x86/kernel/acpi/boot.c
@@ -104,7 +104,6 @@ enum acpi_irq_model_id acpi_irq_model = 
 
 #ifdef	CONFIG_X86_64
 
-/* rely on all ACPI tables being in the direct mapping */
 char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
 {
 	if (!phys_addr || !size)
@@ -113,7 +112,15 @@ char *__init __acpi_map_table(unsigned l
 	if (phys_addr+size <= (end_pfn_map << PAGE_SHIFT) + PAGE_SIZE)
 		return __va(phys_addr);
 
-	return NULL;
+	return early_ioremap(phys_addr, size);
+}
+
+void __acpi_unmap_table(void * addr, unsigned long size)
+{
+	if (!addr || !size)
+		return;
+
+	early_iounmap(addr, size);
 }
 
 #else
diff -puN arch/x86/kernel/cpu/intel_cacheinfo.c~git-x86-fixup arch/x86/kernel/cpu/intel_cacheinfo.c
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c~git-x86-fixup
+++ a/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -734,8 +734,9 @@ static int __cpuinit cache_add_dev(struc
 	if (unlikely(retval < 0))
 		return retval;
 
-	retval = kobject_init_and_add(cache_kobject[cpu], &ktype_percpu_entry,
-				      &sys_dev->kobj, "%s", "cache");
+	retval = kobject_init_and_add(per_cpu(cache_kobject, cpu),
+				      &ktype_percpu_entry, &sys_dev->kobj,
+				      "%s", "cache");
 	if (retval < 0) {
 		cpuid4_cache_sysfs_exit(cpu);
 		return retval;
@@ -746,13 +747,14 @@ static int __cpuinit cache_add_dev(struc
 		this_object->cpu = cpu;
 		this_object->index = i;
 		retval = kobject_init_and_add(&(this_object->kobj),
-					      &ktype_cache, cache_kobject[cpu],
+					      &ktype_cache,
+					      per_cpu(cache_kobject, cpu),
 					      "index%1lu", i);
 		if (unlikely(retval)) {
 			for (j = 0; j < i; j++) {
 				kobject_put(&(INDEX_KOBJECT_PTR(cpu,j)->kobj));
 			}
-			kobject_put(cache_kobject[cpu]);
+			kobject_put(per_cpu(cache_kobject, cpu));
 			cpuid4_cache_sysfs_exit(cpu);
 			break;
 		}
@@ -761,7 +763,7 @@ static int __cpuinit cache_add_dev(struc
 	if (!retval)
 		cpu_set(cpu, cache_dev_map);
 
-	kobject_uevent(cache_kobject[cpu], KOBJ_ADD);
+	kobject_uevent(per_cpu(cache_kobject, cpu), KOBJ_ADD);
 	return retval;
 }
 
@@ -778,7 +780,7 @@ static void __cpuinit cache_remove_dev(s
 
 	for (i = 0; i < num_cache_leaves; i++)
 		kobject_put(&(INDEX_KOBJECT_PTR(cpu,i)->kobj));
-	kobject_put(cache_kobject[cpu]);
+	kobject_put(per_cpu(cache_kobject, cpu));
 	cpuid4_cache_sysfs_exit(cpu);
 }
 
diff -puN arch/x86/kernel/entry_64.S~git-x86-fixup arch/x86/kernel/entry_64.S
--- a/arch/x86/kernel/entry_64.S~git-x86-fixup
+++ a/arch/x86/kernel/entry_64.S
@@ -295,7 +295,7 @@ sysret_careful:
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	testl $_TIF_DO_NOTIFY_MASK,%edx
 	jz    1f
 
diff -puN arch/x86/kernel/traps_32.c~git-x86-fixup arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~git-x86-fixup
+++ a/arch/x86/kernel/traps_32.c
@@ -416,45 +416,14 @@ void die(const char * str, struct pt_reg
 		raw_local_irq_save(flags);
 
 	if (++die.lock_owner_depth < 3) {
-		unsigned long esp;
-		unsigned short ss;
-
-		report_bug(regs->eip, regs);
-
-		printk(KERN_EMERG "%s: %04lx [#%d] ", str, err & 0xffff,
-		       ++die_counter);
-#ifdef CONFIG_PREEMPT
-		printk("PREEMPT ");
-#endif
-#ifdef CONFIG_SMP
-		printk("SMP ");
-#endif
-#ifdef CONFIG_DEBUG_PAGEALLOC
-		printk("DEBUG_PAGEALLOC");
-#endif
-		printk("\n");
-
 		sysfs_printk_last_file();
-		if (notify_die(DIE_OOPS, str, regs, err,
-					current->thread.trap_no, SIGSEGV) !=
-				NOTIFY_STOP) {
-			show_registers(regs);
-			/* Executive summary in case the oops scrolled away */
-			esp = (unsigned long) (&regs->esp);
-			savesegment(ss, ss);
-			if (user_mode(regs)) {
-				esp = regs->esp;
-				ss = regs->xss & 0xffff;
-			}
-			printk(KERN_EMERG "EIP: [<%08lx>] ", regs->eip);
-			print_symbol("%s", regs->eip);
-			printk(" SS:ESP %04x:%08lx\n", ss, esp);
-		}
-		else
+		report_bug(regs->ip, regs);
+
+		if (__die(str, regs, err))
 			regs = NULL;
-  	} else
+	} else {
 		printk(KERN_EMERG "Recursive die() failure, output suppressed\n");
-
+	}
 	bust_spinlocks(0);
 	die.lock_owner = -1;
 	add_taint(TAINT_DIE);
diff -puN arch/x86/kernel/traps_64.c~git-x86-fixup arch/x86/kernel/traps_64.c
--- a/arch/x86/kernel/traps_64.c~git-x86-fixup
+++ a/arch/x86/kernel/traps_64.c
@@ -577,15 +577,17 @@ int __kprobes __die(const char * str, st
 #endif
 	printk("\n");
 	sysfs_printk_last_file();
-	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
+	if (notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
+		return 1;
 	show_registers(regs);
 	add_taint(TAINT_DIE);
 	/* Executive summary in case the oops scrolled away */
 	printk(KERN_ALERT "RIP ");
-	printk_address(regs->rip); 
-	printk(" RSP <%016lx>\n", regs->rsp); 
+	printk_address(regs->ip);
+	printk(" RSP <%016lx>\n", regs->sp);
 	if (kexec_should_crash(current))
 		crash_kexec(regs);
+	return 0;
 }
 
 void die(const char * str, struct pt_regs * regs, long err)
diff -puN arch/x86/oprofile/nmi_int.c~git-x86-fixup arch/x86/oprofile/nmi_int.c
--- a/arch/x86/oprofile/nmi_int.c~git-x86-fixup
+++ a/arch/x86/oprofile/nmi_int.c
@@ -65,7 +65,9 @@ static struct sys_device device_oprofile
 static int __init init_sysfs(void)
 {
 	int error;
-	if (!(error = sysdev_class_register(&oprofile_sysclass)))
+
+	error = sysdev_class_register(&oprofile_sysclass);
+	if (!error)
 		error = sysdev_register(&device_oprofile);
 	return error;
 }
diff -puN arch/x86/pci/init.c~git-x86-fixup arch/x86/pci/init.c
--- a/arch/x86/pci/init.c~git-x86-fixup
+++ a/arch/x86/pci/init.c
@@ -11,9 +11,7 @@ static __init int pci_access_init(void)
 #ifdef CONFIG_PCI_DIRECT
 	type = pci_direct_probe();
 #endif
-#ifdef CONFIG_PCI_MMCONFIG
-	pci_mmcfg_init(type);
-#endif
+	pci_mmcfg_early_init(type);
 	/* if we ONLY have MMCONFIG, we need to use it always */
 	if (!raw_pci_ops && raw_pci_ops_extcfg) {
 		printk(KERN_INFO "No direct PCI access, using MMCONFIG always\n");
diff -puN include/asm-x86/thread_info_64.h~git-x86-fixup include/asm-x86/thread_info_64.h
--- a/include/asm-x86/thread_info_64.h~git-x86-fixup
+++ a/include/asm-x86/thread_info_64.h
@@ -113,7 +113,7 @@ static inline struct thread_info *stack_
 #define TIF_RESTORE_SIGMASK	9	/* restore signal mask in do_signal */
 #define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
 #define TIF_HRTICK_RESCHED	11	/* reprogram hrtick timer */
-/* 16 free */
+#define TIF_FORCED_TF		16	/* true if TF in eflags artificially */
 #define TIF_IA32		17	/* 32bit process */ 
 #define TIF_FORK		18	/* ret_from_fork */
 #define TIF_ABI_PENDING		19
@@ -135,6 +135,7 @@ static inline struct thread_info *stack_
 #define _TIF_SECCOMP		(1<<TIF_SECCOMP)
 #define _TIF_RESTORE_SIGMASK	(1<<TIF_RESTORE_SIGMASK)
 #define _TIF_MCE_NOTIFY		(1<<TIF_MCE_NOTIFY)
+#define _TIF_FORCED_TF		(1<<TIF_FORCED_TF)
 #define _TIF_HRTICK_RESCHED	(1<<TIF_HRTICK_RESCHED)
 #define _TIF_IA32		(1<<TIF_IA32)
 #define _TIF_FORK		(1<<TIF_FORK)
diff -puN include/linux/acpi.h~git-x86-fixup include/linux/acpi.h
--- a/include/linux/acpi.h~git-x86-fixup
+++ a/include/linux/acpi.h
@@ -78,6 +78,7 @@ typedef int (*acpi_table_handler) (struc
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __acpi_unmap_table (void * addr, unsigned long size);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
 int acpi_numa_init (void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
address-hfs-on-disk-corruption-robustness-review-comments-checkpatch-fixes.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration-checkpatch-fixes.patch
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
intel_agp-add-new-chipset-ids-checkpatch-fixes.patch
git-arm.patch
git-audit-master.patch
git-cifs.patch
git-cpufreq.patch
git-powerpc.patch
git-powerpc-fixup.patch
revert-gregkh-driver-atm-convert-struct-class_device-to-struct-device.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
revert-gregkh-driver-pm-acquire-device-locks-prior-to-suspending.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes.patch
pm-acquire-device-locks-on-suspend-rev-3-checkpatch-fixes-2.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
drivers-pcmcia-i82092c-fix-up-after-pci_bus_region-changes.patch
git-drm.patch
intel-agp-enable-i915-recognition.patch
drm-convert-from-nopage-to-fault-checkpatch-fixes.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d.patch
hwmon-new-chip-driver-for-ti-ads7828-a-d-checkpatch-fixes.patch
git-hid.patch
revert-git-hrt.patch
git-ieee1394.patch
git-infiniband.patch
git-infiniband-versus-driver-tree.patch
git-kbuild.patch
git-kvm.patch
git-libata-all.patch
git-libata-all-wtf.patch
git-md-accel.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-fix-conflicts.patch
git-net-vs-git-lblnet.patch
git-net-vs-git-lblnet-2.patch
git-netdev-all.patch
git-netdev-all-fix-conflicts.patch
git-net-vs-git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-backlight.patch
git-battery.patch
bluetooth-uninlining.patch
net-sunrpc-schedc-revert-git-net-changes.patch
net-sunrpc-schedc-reapply-git-net-changes.patch
net-sunrpc-svcsockc-revert-git-nfs-changes.patch
serial-add-addi-data-gmbh-communication-cardsin8250_pcic-and-pci_idsh-checkpatch-fixes.patch
revert-gregkh-pci-pci-use-dev_printk-in-x86-quirk-messages.patch
cleanup-gregkh-pci-pci-fix-bus-resource-assignment-on-32-bits-with-64b-resources.patch
quirks-set-en-bit-of-msi-mapping-for-devices-onht-based-nvidia-platform-checkpatch-fixes.patch
git-sched.patch
git-sched-fixup.patch
git-sh.patch
git-scsi-misc.patch
git-scsi-misc-vs-git-libata-all.patch
scsi-aic94xx-cleanups-checkpatch-fixes.patch
scsi-aic94xx-cleanups-checkpatch-fixes-checkpatch-fixes.patch
libsas-convert-ata-bridge-to-use-new-eh.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
ehci-hcd-fix-sparse-warning-about-shadowing-status-symbol-checkpatch-fixes.patch
9p-util-fix-semaphore-handling.patch
git-watchdog.patch
git-watchdog-fixup.patch
wdt-fix-locking-checkpatch-fixes.patch
git-wireless.patch
git-ipwireless_cs.patch
revert-kvm-stuff-to-make-git-x86-apply.patch
git-x86.patch
git-x86-fix-conflicts.patch
git-x86-fixup.patch
git-x86-vs-pm-acquire-device-locks-on-suspend-rev-3.patch
git-x86-fix-doubly-merged-patch.patch
pci-dont-load-acpi_php-when-acpi-is-disabled.patch
git-newsetup.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
bonding-locking-fix.patch
usbtouchscreen-fix-buffer-overflow-make-more-egalax-work.patch
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
maps4-add-proc-kpageflags-interface-fix-2-fix.patch
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
avoid-overflows-in-kernel-timec-fix.patch
export-iov_shorten-for-ext4s-use-fix.patch
system-timer-fix-crash-in-100hz-system-timer-cleanup.patch
speed-up-jiffies-conversion-functions-if-hz==user_hz.patch
add-have_oprofile.patch
ecryptfs-make-show_options-reflect-actual-mount-options-fix.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
rtc-add-support-for-the-s-35390a-rtc-chip.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
neofb-avoid-overwriting-fb_info-fields.patch
vermilionc-use-align-not-__align_mask.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
ext4-mm-ext4_store_maxbytes_for_bitmaped_files-warning-fix.patch
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
proc-fix-openless-usage-due-to-proc_fops-flip-checkpatch-fixes.patch
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
constify-tables-in-kernel-sysctl_checkc-fix.patch
aoe-statically-initialise-devlist_lock.patch
provide-u64-version-of-jiffies_to_usecs-in-kernel-tsacctc-fix.patch
ufs-fix-symlink-creation-on-ufs2-fix.patch
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
