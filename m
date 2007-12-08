From: akpm@linux-foundation.org
Subject: - pie-executable-randomization-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 07 Dec 2007 17:26:32 -0800
Message-ID: <200712080126.lB81QWis013280@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752670AbXLHB20 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 7 Dec 2007 20:28:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, arjan@infradead.org, jakub@redhat.com, jkosina@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, mingo@elte.hu, roland@redhat.com, tglx@linutronix.de, tony.luck@intel


The patch titled
     pie-executable-randomization-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     pie-executable-randomization-checkpatch-fixes.patch

This patch was dropped because of ongoing git-x86 churn

------------------------------------------------------
Subject: pie-executable-randomization-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#39: FILE: arch/ia64/ia32/binfmt_elf32.c:229:
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)

WARNING: no space between function name and open parenthesis '('
#39: FILE: arch/ia64/ia32/binfmt_elf32.c:229:
+elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)

WARNING: line over 80 characters
#67: FILE: arch/x86/kernel/sys_x86_64.c:80:
+			new_begin = randomize_range(*begin, *begin + 0x02000000, 0);

ERROR: use tabs not spaces
#110: FILE: arch/x86/kernel/sys_x86_64.c:185:
+ ^I        mm->cached_hole_size = 0;$

ERROR: use tabs not spaces
#111: FILE: arch/x86/kernel/sys_x86_64.c:186:
+ ^I^Imm->free_area_cache = mm->mmap_base;$

ERROR: use tabs not spaces
#112: FILE: arch/x86/kernel/sys_x86_64.c:187:
+ ^I}$

ERROR: use tabs not spaces
#141: FILE: arch/x86/kernel/sys_x86_64.c:216:
+ ^I^I/* remember the largest hole we saw so far */$

ERROR: use tabs not spaces
#142: FILE: arch/x86/kernel/sys_x86_64.c:217:
+ ^I^Iif (addr + mm->cached_hole_size < vma->vm_start)$

ERROR: use tabs not spaces
#143: FILE: arch/x86/kernel/sys_x86_64.c:218:
+ ^I^I        mm->cached_hole_size = vma->vm_start - addr;$

ERROR: use tabs not spaces
#157: FILE: arch/x86/kernel/sys_x86_64.c:232:
+  ^Imm->free_area_cache = TASK_UNMAPPED_BASE;$

ERROR: need a space before the open parenthesis '('
#291: FILE: arch/x86/mm/mmap_64.c:101:
+	} else if(mmap_is_legacy()) {

WARNING: braces {} are not necessary for single statement blocks
#302: FILE: arch/x86/mm/mmap_64.c:112:
+	if (current->flags & PF_RANDOMIZE) {
+		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
+	}

WARNING: line over 80 characters
#314: FILE: fs/binfmt_elf.c:48:
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

WARNING: no space between function name and open parenthesis '('
#314: FILE: fs/binfmt_elf.c:48:
+static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);

WARNING: line over 80 characters
#429: FILE: fs/binfmt_elf.c:438:
+					   eppnt, elf_prot, elf_type, total_size);

ERROR: need space after that ',' (ctx:VxV)
#480: FILE: fs/binfmt_elf.c:939:
+				elf_prot, elf_flags,0);
 				                   ^

total: 9 errors, 7 warnings, 461 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jakub Jelinek <jakub@redhat.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/ia32/binfmt_elf32.c |    3 ++-
 arch/x86/kernel/sys_x86_64.c  |   14 +++++++-------
 arch/x86/mm/mmap_64.c         |    5 ++---
 fs/binfmt_elf.c               |    7 ++++---
 4 files changed, 15 insertions(+), 14 deletions(-)

diff -puN arch/ia64/ia32/binfmt_elf32.c~pie-executable-randomization-checkpatch-fixes arch/ia64/ia32/binfmt_elf32.c
--- a/arch/ia64/ia32/binfmt_elf32.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/ia64/ia32/binfmt_elf32.c
@@ -226,7 +226,8 @@ elf32_set_personality (void)
 }
 
 static unsigned long
-elf32_map (struct file *filep, unsigned long addr, struct elf_phdr *eppnt, int prot, int type, unsigned long unused)
+elf32_map(struct file *filep, unsigned long addr, struct elf_phdr *eppnt,
+		int prot, int type, unsigned long unused)
 {
 	unsigned long pgoff = (eppnt->p_vaddr) & ~IA32_PAGE_MASK;
 
diff -puN arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-checkpatch-fixes arch/x86/kernel/sys_x86_64.c
--- a/arch/x86/kernel/sys_x86_64.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/x86/kernel/sys_x86_64.c
@@ -182,9 +182,9 @@ arch_get_unmapped_area_topdown(struct fi
 
 	/* check if free_area_cache is useful for us */
 	if (len <= mm->cached_hole_size) {
- 	        mm->cached_hole_size = 0;
- 		mm->free_area_cache = mm->mmap_base;
- 	}
+		mm->cached_hole_size = 0;
+		mm->free_area_cache = mm->mmap_base;
+	}
 
 	/* either no address requested or can't fit in requested address hole */
 	addr = mm->free_area_cache;
@@ -213,9 +213,9 @@ arch_get_unmapped_area_topdown(struct fi
 			/* remember the address as a hint for next time */
 			return (mm->free_area_cache = addr);
 
- 		/* remember the largest hole we saw so far */
- 		if (addr + mm->cached_hole_size < vma->vm_start)
- 		        mm->cached_hole_size = vma->vm_start - addr;
+		/* remember the largest hole we saw so far */
+		if (addr + mm->cached_hole_size < vma->vm_start)
+			mm->cached_hole_size = vma->vm_start - addr;
 
 		/* try just below the current vma->vm_start */
 		addr = vma->vm_start-len;
@@ -229,7 +229,7 @@ bottomup:
 	 * allocations.
 	 */
 	mm->cached_hole_size = ~0UL;
-  	mm->free_area_cache = TASK_UNMAPPED_BASE;
+	mm->free_area_cache = TASK_UNMAPPED_BASE;
 	addr = arch_get_unmapped_area(filp, addr0, len, pgoff, flags);
 	/*
 	 * Restore the topdown base:
diff -puN arch/x86/mm/mmap_64.c~pie-executable-randomization-checkpatch-fixes arch/x86/mm/mmap_64.c
--- a/arch/x86/mm/mmap_64.c~pie-executable-randomization-checkpatch-fixes
+++ a/arch/x86/mm/mmap_64.c
@@ -100,7 +100,7 @@ void arch_pick_mmap_layout(struct mm_str
 		/* ia32_pick_mmap_layout has its own. */
 		return ia32_pick_mmap_layout(mm);
 #endif
-	} else if(mmap_is_legacy()) {
+	} else if (mmap_is_legacy()) {
 		mm->mmap_base = TASK_UNMAPPED_BASE;
 		mm->get_unmapped_area = arch_get_unmapped_area;
 		mm->unmap_area = arch_unmap_area;
@@ -111,7 +111,6 @@ void arch_pick_mmap_layout(struct mm_str
 		if (current->flags & PF_RANDOMIZE)
 			rnd = -rnd;
 	}
-	if (current->flags & PF_RANDOMIZE) {
+	if (current->flags & PF_RANDOMIZE)
 		mm->mmap_base += ((long)rnd) << PAGE_SHIFT;
-	}
 }
diff -puN fs/binfmt_elf.c~pie-executable-randomization-checkpatch-fixes fs/binfmt_elf.c
--- a/fs/binfmt_elf.c~pie-executable-randomization-checkpatch-fixes
+++ a/fs/binfmt_elf.c
@@ -45,7 +45,8 @@
 
 static int load_elf_binary(struct linux_binprm *bprm, struct pt_regs *regs);
 static int load_elf_library(struct file *);
-static unsigned long elf_map (struct file *, unsigned long, struct elf_phdr *, int, int, unsigned long);
+static unsigned long elf_map(struct file *, unsigned long, struct elf_phdr *,
+				int, int, unsigned long);
 
 /*
  * If we don't support core dumping, then supply a NULL so we
@@ -435,7 +436,7 @@ static unsigned long load_elf_interp(str
 				load_addr = -vaddr;
 
 			map_addr = elf_map(interpreter, load_addr + vaddr,
-					   eppnt, elf_prot, elf_type, total_size);
+					eppnt, elf_prot, elf_type, total_size);
 			total_size = 0;
 			if (!*interp_map_addr)
 				*interp_map_addr = map_addr;
@@ -936,7 +937,7 @@ static int load_elf_binary(struct linux_
 		}
 
 		error = elf_map(bprm->file, load_bias + vaddr, elf_ppnt,
-				elf_prot, elf_flags,0);
+				elf_prot, elf_flags, 0);
 		if (BAD_ADDR(error)) {
 			send_sig(SIGKILL, current, 0);
 			retval = IS_ERR((void *)error) ?
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
aoe-properly-initialise-the-request_queues-backing_dev_info.patch
revert-dpt_i2o-convert-to-scsi-hotplug-model.patch
revert-fix-proc-net-breakage.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
git-acpi-ia64-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
acpi-fix-autloading-of-dock-video-bay-and-all-linux-specific-hid-drivers-checkpatch-fixes.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
git-agpgart.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm.patch
kernel-auditc-warning-fix.patch
git-cpufreq.patch
git-cpufreq-query_current_values_with_pending_wait-build-fix.patch
agk-dm-dm-ioctl-move-compat-code-fix.patch
dm-persistent_read_metadata-warning-fix.patch
ppc-chrp-fix-possible-null-pointer-dereference-checkpatch-fixes.patch
gregkh-driver-kset-convert-to-kobj_sysfs_ops-vs-git-acpi.patch
unbork-gregkh-driver-kset-convert-sys-devices-to-use-kset_create-vioc.patch
git-drm.patch
git-drm-oops-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
v4l-nopage-fix.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-kvm-fixup.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-xfer_mask-is-unsigned-int-not-unsigned-long-fix.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
libata-fix-early-use-of-port-printk-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
git-net.patch
git-net-vs-git-lblnet.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
kernel-time-make-tick_do_broadcast-static.patch
git-sh.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
drivers-scsi-sgiwd93c-export-sgiwd93_reset.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
usb-testing-driver-dont-free-a-locked-mutex.patch
git-watchdog.patch
add-support-for-sb1-hardware-watchdog-fix.patch
git-wireless.patch
bcm43xx_debugfs-sscanf-fix.patch
git-ipwireless_cs.patch
git-x86.patch
revert-revert-git-kvm-changes-in-arch-x86-kconfig.patch
git-x86-__vdso_getcpu-warning-fix.patch
git-cryptodev.patch
git-cryptodev-fixup.patch
git-xtensa.patch
ia64-increase-datapatch-offset.patch
ia64-dont-assume-that-unwcheckpy-is-executable.patch
ia64-export-copy_page-to-modules.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
vmalloc-add-const-to-void-parameters-fix.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
maps4-rework-task_size-macros-mips-fix.patch
maps4-make-page-monitoring-proc-file-optional-fix.patch
mm-page-writeback-highmem_is_dirtyable-option-fix.patch
shmem-factor-out-sbi-free_inodes-manipulations-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
revert-capabilities-clean-up-file-capability-reading.patch
revert-capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-checkpatch-fixes.patch
add-64-bit-capability-support-to-the-kernel-fix-modify-old-libcap-warning-message-fix.patch
alpha-atomic_add_return-should-return-int.patch
pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers.patch
dio-array_size-cleanup-update-checkpatch-fixes.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-improve-detection-of-host-cmov-checkpatch-fixes.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
kernel-printkc-concerns-about-the-console-handover.patch
pie-executable-randomization-checkpatch-fixes.patch
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
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
declare-pnp-option-parsing-functions-as-__init-checkpatch-fixes.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
ext4-check-for-the-correct-error-return-from-ext4_ext_get_blocks-fix.patch
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
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-sanitize-the-type-of-struct-useru_ar0.patch
aout-remove-unnecessary-inclusions-of-asm-linux-aouth-alpha-fix.patch
mn10300-add-the-mn10300-am33-architecture-to-the-kernel-fix.patch
rewrite-rd-fixes.patch
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
