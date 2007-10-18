From: akpm@linux-foundation.org
Subject: - binfmt_flat-warning-fixes.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:56:55 -0700
Message-ID: <200710180656.l9I6utcr030741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39915 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763447AbXJRHQR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:16:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     binfmt_flat: warning fixes
has been removed from the -mm tree.  Its filename was
     binfmt_flat-warning-fixes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: binfmt_flat: warning fixes
From: Andrew Morton <akpm@linux-foundation.org>

Fix this lot:

fs/binfmt_flat.c: In function `decompress_exec':
fs/binfmt_flat.c:293: warning: label `out' defined but not used
fs/binfmt_flat.c: In function `load_flat_file':
fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 3)
fs/binfmt_flat.c:462: warning: unsigned int format, long int arg (arg 4)
fs/binfmt_flat.c:518: warning: comparison of distinct pointer types lacks a cast
fs/binfmt_flat.c:549: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
fs/binfmt_flat.c:601: warning: passing arg 1 of `ksize' makes pointer from integer without a cast
fs/binfmt_flat.c: In function `load_flat_binary':
fs/binfmt_flat.c:116: warning: 'dummy' might be used uninitialized in this function

Acked-by: Greg Ungerer <gerg@uclinux.org>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/binfmt_flat.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff -puN fs/binfmt_flat.c~binfmt_flat-warning-fixes fs/binfmt_flat.c
--- a/fs/binfmt_flat.c~binfmt_flat-warning-fixes
+++ a/fs/binfmt_flat.c
@@ -113,7 +113,7 @@ static unsigned long create_flat_tables(
 	char * p = (char*)pp;
 	int argc = bprm->argc;
 	int envc = bprm->envc;
-	char dummy;
+	char uninitialized_var(dummy);
 
 	sp = (unsigned long *) ((-(unsigned long)sizeof(char *))&(unsigned long) p);
 
@@ -290,7 +290,6 @@ out_free_buf:
 	kfree(buf);
 out_free:
 	kfree(strm.workspace);
-out:
 	return retval;
 }
 
@@ -459,7 +458,9 @@ static int load_flat_file(struct linux_b
 		printk("BINFMT_FLAT: Loading file: %s\n", bprm->filename);
 
 	if (rev != FLAT_VERSION && rev != OLD_FLAT_VERSION) {
-		printk("BINFMT_FLAT: bad flat file version 0x%x (supported 0x%x and 0x%x)\n", rev, FLAT_VERSION, OLD_FLAT_VERSION);
+		printk("BINFMT_FLAT: bad flat file version 0x%x (supported "
+			"0x%lx and 0x%lx)\n",
+			rev, FLAT_VERSION, OLD_FLAT_VERSION);
 		ret = -ENOEXEC;
 		goto err;
 	}
@@ -515,7 +516,8 @@ static int load_flat_file(struct linux_b
 	/*
 	 * calculate the extra space we need to map in
 	 */
-	extra = max(bss_len + stack_len, relocs * sizeof(unsigned long));
+	extra = max_t(unsigned long, bss_len + stack_len,
+			relocs * sizeof(unsigned long));
 
 	/*
 	 * there are a couple of cases here,  the separate code/data
@@ -546,7 +548,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (realdatastart && (realdatastart < (unsigned long)-4096)) {
-			reallen = ksize(realdatastart);
+			reallen = ksize((void *)realdatastart);
 			if (reallen > len) {
 				realdatastart = do_mremap(realdatastart, len,
 					reallen, MREMAP_FIXED, realdatastart);
@@ -598,7 +600,7 @@ static int load_flat_file(struct linux_b
 			PROT_READ | PROT_EXEC | PROT_WRITE, MAP_PRIVATE, 0);
 		/* Remap to use all availabe slack region space */
 		if (textpos && (textpos < (unsigned long) -4096)) {
-			reallen = ksize(textpos);
+			reallen = ksize((void *)textpos);
 			if (reallen > len) {
 				textpos = do_mremap(textpos, len, reallen,
 					MREMAP_FIXED, textpos);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
git-acpi.patch
git-acpi-fixup.patch
acpi-add-reboot-mechanism.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-cifs.patch
console-keyboard-events-and-accessibility.patch
first-stab-at-elantech-touchpad-driver-for-26226-testers.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
ide-arm-hack.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-nfsd-fixup.patch
fix-build-breakage-if-sysfs-fix.patch
qla2xxx-printk-fixes.patch
advansys-depends-on-virt_to_bus.patch
sparc-support-for-new-termios.patch
git-unionfs.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-unionfs.patch
git-nfs-vs-git-unionfs.patch
git-watchdog-fixup.patch
git-wireless.patch
git-wireless-fixup.patch
git-x86.patch
revert-x86_64-mm-cpa-einval.patch
fix-x86_64-mm-sched-clock-share.patch
x86_64-check-and-enable-mmconfig-for-amd-family-10h-opteron.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-checkpatch-fixes.patch
memory-hotplug-make-kmem_cache_node-for-slub-on-memory-online-avoid-panic-fix.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch
capabilities-clean-up-file-capability-reading-checkpatch-fixes.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
revert-x86-save-registers-in-saved_context-during-suspend-and-hibernation.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
pm-qos-infrastructure-and-interface-static-initialization-with-blocking-notifiers-checkpatch-fixes.patch
deprecate-smbfs-in-favour-of-cifs.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2-fix-3.patch
console-events-and-accessibility-fix.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch
stop-using-dma_xxbit_mask.patch
stop-using-dma_xxbit_mask-fix.patch
kernel-printkc-concerns-about-the-console-handover.patch
ext2-avoid-rec_len-overflow-with-64kb-block-size-checkpatch-fixes.patch
sync_sb_inodes-propagate-errors.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
jbd-config_jbd_debug-cannot-create-proc-entry-fix.patch
peterz-vs-ext4-mballoc-core.patch
64-bit-i_version-afs-fixes.patch
reiserfs-fix-up-lockdep-warnings-checkpatch-fixes.patch
reiserfs-use-is_reusable-to-catch-corruption-checkpatch-fixes.patch
reiserfs-fix-usage-of-signed-ints-for-block-numbers-checkpatch-fixes.patch
reiserfs-remove-first_zero_hint-checkpatch-fixes.patch
reiserfs-ignore-on-disk-s_bmap_nr-value-checkpatch-fixes.patch
r-o-bind-mounts-elevate-write-count-during-entire-ncp_ioctl-fix.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-memory-accounting-v7-fix.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
powerpc-lock-bitops-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
ftd_sio-clean-ups-and-updates-for-new-termios-work-checkpatch-fixes.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
fuse-fix-race-between-getattr-and-write-checkpatch-fixes.patch
fuse-add-file-handle-to-getattr-operation-checkpatch-fixes.patch
sparse-pointer-use-of-zero-as-null-checkpatch-fixes.patch
i-oat-tighten-descriptor-setup-performance-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix.patch
i-oat-add-completion-callback-for-async_tx-interface-use-fix-fix.patch
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
