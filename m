From: akpm@linux-foundation.org
Subject: + proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch added to -mm tree
Date: Thu, 29 Nov 2007 16:37:30 -0800
Message-ID: <200711300037.lAU0bVU4015316@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46524 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758430AbXK3AjH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Nov 2007 19:39:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, clg@fr.ibm.com, ebiederm@xmission.com, heiko.carstens@de.ibm.com, menage@google.com, morgan@kernel.org, pj@sgi.com, rientjes@google.com, schwidefsky@de.ibm.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#203: FILE: fs/proc/array.c:207:
+static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)

WARNING: line over 80 characters
#264: FILE: fs/proc/array.c:281:
+static void render_cap_t(struct seq_file *m, const char *header, kernel_cap_t *a)

WARNING: line over 80 characters
#307: FILE: fs/proc/array.c:309:
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,

WARNING: line over 80 characters
#443: FILE: include/linux/cpuset.h:61:
+extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);

total: 0 errors, 4 warnings, 416 lines checked

Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andrew Morgan <morgan@kernel.org>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c        |   10 ++++++----
 include/linux/cpuset.h |    3 ++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff -puN fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes fs/proc/array.c
--- a/fs/proc/array.c~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
+++ a/fs/proc/array.c
@@ -204,7 +204,8 @@ static inline void task_state(struct seq
 	seq_printf(m, "\n");
 }
 
-static void render_sigset_t(struct seq_file *m, const char *header, sigset_t *set)
+static void render_sigset_t(struct seq_file *m, const char *header,
+				sigset_t *set)
 {
 	int i;
 
@@ -278,7 +279,8 @@ static inline void task_sig(struct seq_f
 	render_sigset_t(m, "SigCgt:\t", &caught);
 }
 
-static void render_cap_t(struct seq_file *m, const char *header, kernel_cap_t *a)
+static void render_cap_t(struct seq_file *m, const char *header,
+			kernel_cap_t *a)
 {
 	unsigned __capi;
 
@@ -306,8 +308,8 @@ static inline void task_context_switch_c
 			p->nivcsw);
 }
 
-int proc_pid_status(struct seq_file *m, struct pid_namespace *ns, struct pid *pid,
-			struct task_struct *task)
+int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
+			struct pid *pid, struct task_struct *task)
 {
 	struct mm_struct *mm = get_task_mm(task);
 
diff -puN include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes include/linux/cpuset.h
--- a/include/linux/cpuset.h~proc-seqfile-convert-proc_pid_status-to-properly-handle-pid-namespaces-checkpatch-fixes
+++ a/include/linux/cpuset.h
@@ -58,7 +58,8 @@ extern void __cpuset_memory_pressure_bum
 
 extern const struct file_operations proc_cpuset_operations;
 struct seq_file;
-extern void cpuset_task_status_allowed(struct seq_file *m, struct task_struct *task);
+extern void cpuset_task_status_allowed(struct seq_file *m,
+					struct task_struct *task);
 
 extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
pnp-increase-the-maximum-number-of-resources.patch
fix-linux-kdh-usage-in-userspace.patch
imacfb-remove-reference-to-otherwise-unused-non-existent-screen_infoimacpm_seg.patch
revert-keyspan-init-termios-properly.patch
get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
git-acpi-ia64-build-fix.patch
acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
acpi-add-reboot-mechanism.patch
small-acpica-extension-to-be-able-to-store-the-name-of.patch
git-alsa.patch
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
git-drm-oops-fix.patch
git-drm-warning-fix.patch
intel-agp-enable-i915-recognition.patch
git-dvb.patch
fix-jdelvare-i2c-i2c-constify-client-address-data.patch
revert-git-hrt.patch
ia64-slim-down-__clear_bit_unlock.patch
git-infiniband.patch
git-kvm.patch
git-libata-all.patch
drivers-ata-libata-ehc-fix-printk-warning.patch
pata_hpt37x-fix-outstanding-bug-reports-on-the-hpt374-and-37x-cable-detect-checkpatch-fixes.patch
libata-set-proper-ata-udma-mode-for-bf548-according-to-system-clock-checkpatch-fixes.patch
git-mmc.patch
git-mtd.patch
sysctl-add-register_sysctl_paths-function-checkpatch-fixes.patch
sysctl-infrastructure-for-per-namespace-sysctls-checkpatch-fixes.patch
git-netdev-all.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-battery.patch
bluetooth-uninlining.patch
git-nfsd.patch
quirk-enable-msi-mapping-on-ht1000.patch
git-sh.patch
git-sh-fixup.patch
git-scsi-misc-fixup.patch
ips-trim-trailing-whitespace.patch
scsi-gdth-kill-unneeded-irq-argument.patch
libsas-convert-ata-bridge-to-use-new-eh-checkpatch-fixes.patch
git-unionfs.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names-fix.patch
mct232-speed-new-termios-and-compliance-cleanups-fix.patch
git-watchdog.patch
git-wireless.patch
git-ipwireless_cs.patch
git-x86.patch
git-x86-build-fix.patch
git-cryptodev.patch
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
deprecate-smbfs-in-favour-of-cifs.patch
kernel-printkc-concerns-about-the-console-handover.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
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
sync_sb_inodes-propagate-errors.patch
rtc-ds1302-rtc-support-checkpatch-fixes.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
fbmon-cleanup-trailing-whitespaces-checkpatch-fixes.patch
64-bit-i_version-afs-fixes.patch
ext4-add-block-bitmap-validation.patch
ext4-fix-up-ext4fs_debug-builds.patch
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
intel-iommu-fault_reason_index_cleanuppatch-fix.patch
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
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
w1-build-fix.patch
