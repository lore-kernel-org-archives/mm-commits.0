From: akpm@linux-foundation.org
Subject: + git-x86-fixup.patch added to -mm tree
Date: Fri, 19 Oct 2007 00:14:17 -0700
Message-ID: <200710190714.l9J7EHIA021934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52641 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbXJSHOT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 03:14:19 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [207.189.120.55])
	by smtp2.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l9J7EHkl011297
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <mm-commits@vger.kernel.org>; Fri, 19 Oct 2007 00:14:18 -0700
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org


The patch titled
     git-x86-fixup
has been added to the -mm tree.  Its filename is
     git-x86-fixup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: git-x86-fixup
From: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/process_32.c |   48 ++++++++++++++++++++++-----------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff -puN arch/x86/kernel/process_32.c~git-x86-fixup arch/x86/kernel/process_32.c
--- a/arch/x86/kernel/process_32.c~git-x86-fixup
+++ a/arch/x86/kernel/process_32.c
@@ -295,34 +295,52 @@ static int __init idle_setup(char *str)
 }
 early_param("idle", idle_setup);
 
-void show_regs(struct pt_regs * regs)
+void __show_registers(struct pt_regs *regs, int all)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
 	unsigned long d0, d1, d2, d3, d6, d7;
+	unsigned long esp;
+	unsigned short ss, gs;
+
+	if (user_mode_vm(regs)) {
+		esp = regs->esp;
+		ss = regs->xss & 0xffff;
+		savesegment(gs, gs);
+	} else {
+		esp = (unsigned long) (&regs->esp);
+		savesegment(ss, ss);
+		savesegment(gs, gs);
+	}
 
 	printk("\n");
-	printk("Pid: %d, comm: %20s\n", task_pid_nr(current), current->comm);
-	printk("EIP: %04x:[<%08lx>] CPU: %d\n",0xffff & regs->xcs,regs->eip, smp_processor_id());
+	printk("Pid: %d, comm: %.*s %s (%s %.*s)\n",
+			task_pid_nr(current), TASK_COMM_LEN, current->comm,
+			print_tainted(), init_utsname()->release,
+			(int)strcspn(init_utsname()->version, " "),
+			init_utsname()->version);
+
+	printk("EIP: %04x:[<%08lx>] EFLAGS: %08lx CPU: %d\n",
+			0xffff & regs->xcs, regs->eip, regs->eflags,
+			smp_processor_id());
 	print_symbol("EIP is at %s\n", regs->eip);
 
-	if (user_mode_vm(regs))
-		printk(" ESP: %04x:%08lx",0xffff & regs->xss,regs->esp);
-	printk(" EFLAGS: %08lx    %s  (%s %.*s)\n",
-	       regs->eflags, print_tainted(), init_utsname()->release,
-	       (int)strcspn(init_utsname()->version, " "),
-	       init_utsname()->version);
 	printk("EAX: %08lx EBX: %08lx ECX: %08lx EDX: %08lx\n",
-		regs->eax,regs->ebx,regs->ecx,regs->edx);
-	printk("ESI: %08lx EDI: %08lx EBP: %08lx",
-		regs->esi, regs->edi, regs->ebp);
-	printk(" DS: %04x ES: %04x FS: %04x\n",
-	       0xffff & regs->xds,0xffff & regs->xes, 0xffff & regs->xfs);
+		regs->eax, regs->ebx, regs->ecx, regs->edx);
+	printk("ESI: %08lx EDI: %08lx EBP: %08lx ESP: %08lx\n",
+		regs->esi, regs->edi, regs->ebp, esp);
+	printk(" DS: %04x ES: %04x FS: %04x GS: %04x SS: %04x\n",
+	       regs->xds & 0xffff, regs->xes & 0xffff,
+	       regs->xfs & 0xffff, gs, ss);
+
+	if (!all)
+		return;
 
 	cr0 = read_cr0();
 	cr2 = read_cr2();
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
-	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
+	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n",
+			cr0, cr2, cr3, cr4);
 
 	get_debugreg(d0, 0);
 	get_debugreg(d1, 1);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
try-this.patch
advansys-depends-on-virt_to_bus.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
hook-up-group-scheduler-with-control-groups.patch
linux-kernel-markers.patch
linux-kernel-markers-samples.patch
uninline-forkc-exitc.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
git-parisc.patch
fix-build-breakage-if-sysfs-fix.patch
git-scsi-misc.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
git-x86-fixup.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
git-xfs.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
procfs-detect-duplicate-names.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
kexec-add-bss-to-resource-tree-checkpatch-fixes.patch
kexec-introduce-bootmem_exclusive-checkpatch-fixes.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
git-block-vs-reiser4.patch
git-nfsd-broke-reiser4.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
nr_blockdev_pages-in_interrupt-warning.patch
slab-leaks3-default-y.patch
profile-likely-unlikely-macros-fix.patch
put_bh-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
w1-build-fix.patch
