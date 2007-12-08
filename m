From: akpm@linux-foundation.org
Subject: - revert-fix-proc-net-breakage.patch removed from -mm tree
Date: Sat, 08 Dec 2007 01:56:01 -0800
Message-ID: <200712080956.lB89u1AG029471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43997 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXLHJ5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 8 Dec 2007 04:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, davem@davemloft.net, den@openvz.org, ebiederm@xmission.com, herbert@gondor.apana.org.au, mingo@elte.hu, pavel@ucw.cz, rjw@sisk.pl, tron


The patch titled
     revert "[NETNS]: Fix /proc/net breakage"
has been removed from the -mm tree.  Its filename was
     revert-fix-proc-net-breakage.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: revert "[NETNS]: Fix /proc/net breakage"
From: Andrew Morton <akpm@linux-foundation.org>

Revert

    commit 2b1e300a9dfc3196ccddf6f1d74b91b7af55e416
    Author: Eric W. Biederman <ebiederm@xmission.com>
    Date:   Sun Dec 2 00:33:17 2007 +1100

        [NETNS]: Fix /proc/net breakage

It has caused all sorts of procfs mayhem.

Reverting this will reintroduce

    "Currently things work but there are odd details visible to user
     space, even when we have a single network namespace."

Where "details" was never elaborated upon.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Denis V. Lunev" <den@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/generic.c       |   12 -----
 fs/proc/proc_net.c      |   86 +++++++++++++++++++++++++++++++++++---
 include/linux/proc_fs.h |    3 -
 3 files changed, 82 insertions(+), 19 deletions(-)

diff -puN fs/proc/generic.c~revert-fix-proc-net-breakage fs/proc/generic.c
--- a/fs/proc/generic.c~revert-fix-proc-net-breakage
+++ a/fs/proc/generic.c
@@ -374,16 +374,9 @@ static int proc_delete_dentry(struct den
 	return 1;
 }
 
-static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
-{
-	d_drop(dentry);
-	return 0;
-}
-
 static struct dentry_operations proc_dentry_operations =
 {
 	.d_delete	= proc_delete_dentry,
-	.d_revalidate	= proc_revalidate_dentry,
 };
 
 /*
@@ -404,11 +397,8 @@ struct dentry *proc_lookup(struct inode 
 			if (de->namelen != dentry->d_name.len)
 				continue;
 			if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
-				unsigned int ino;
+				unsigned int ino = de->low_ino;
 
-				if (de->shadow_proc)
-					de = de->shadow_proc(current, de);
-				ino = de->low_ino;
 				de_get(de);
 				spin_unlock(&proc_subdir_lock);
 				error = -EINVAL;
diff -puN fs/proc/proc_net.c~revert-fix-proc-net-breakage fs/proc/proc_net.c
--- a/fs/proc/proc_net.c~revert-fix-proc-net-breakage
+++ a/fs/proc/proc_net.c
@@ -50,14 +50,89 @@ struct net *get_proc_net(const struct in
 }
 EXPORT_SYMBOL_GPL(get_proc_net);
 
-static struct proc_dir_entry *shadow_pde;
+static struct proc_dir_entry *proc_net_shadow;
 
-static struct proc_dir_entry *proc_net_shadow(struct task_struct *task,
+static struct dentry *proc_net_shadow_dentry(struct dentry *parent,
 						struct proc_dir_entry *de)
 {
-	return task->nsproxy->net_ns->proc_net;
+	struct dentry *shadow = NULL;
+	struct inode *inode;
+	if (!de)
+		goto out;
+	de_get(de);
+	inode = proc_get_inode(parent->d_inode->i_sb, de->low_ino, de);
+	if (!inode)
+		goto out_de_put;
+	shadow = d_alloc_name(parent, de->name);
+	if (!shadow)
+		goto out_iput;
+	shadow->d_op = parent->d_op; /* proc_dentry_operations */
+	d_instantiate(shadow, inode);
+out:
+	return shadow;
+out_iput:
+	iput(inode);
+out_de_put:
+	de_put(de);
+	goto out;
+}
+
+static void *proc_net_follow_link(struct dentry *parent, struct nameidata *nd)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct dentry *shadow;
+	shadow = proc_net_shadow_dentry(parent, net->proc_net);
+	if (!shadow)
+		return ERR_PTR(-ENOENT);
+
+	dput(nd->dentry);
+	/* My dentry count is 1 and that should be enough as the
+	 * shadow dentry is thrown away immediately.
+	 */
+	nd->dentry = shadow;
+	return NULL;
 }
 
+static struct dentry *proc_net_lookup(struct inode *dir, struct dentry *dentry,
+				      struct nameidata *nd)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct dentry *shadow;
+
+	shadow = proc_net_shadow_dentry(nd->dentry, net->proc_net);
+	if (!shadow)
+		return ERR_PTR(-ENOENT);
+
+	dput(nd->dentry);
+	nd->dentry = shadow;
+
+	return shadow->d_inode->i_op->lookup(shadow->d_inode, dentry, nd);
+}
+
+static int proc_net_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct net *net = current->nsproxy->net_ns;
+	struct dentry *shadow;
+	int ret;
+
+	shadow = proc_net_shadow_dentry(dentry->d_parent, net->proc_net);
+	if (!shadow)
+		return -ENOENT;
+	ret = shadow->d_inode->i_op->setattr(shadow, iattr);
+	dput(shadow);
+	return ret;
+}
+
+static const struct file_operations proc_net_dir_operations = {
+	.read			= generic_read_dir,
+};
+
+static struct inode_operations proc_net_dir_inode_operations = {
+	.follow_link	= proc_net_follow_link,
+	.lookup		= proc_net_lookup,
+	.setattr	= proc_net_setattr,
+};
+
 static __net_init int proc_net_ns_init(struct net *net)
 {
 	struct proc_dir_entry *root, *netd, *net_statd;
@@ -110,8 +185,9 @@ static struct pernet_operations __net_in
 
 int __init proc_net_init(void)
 {
-	shadow_pde = proc_mkdir("net", NULL);
-	shadow_pde->shadow_proc = proc_net_shadow;
+	proc_net_shadow = proc_mkdir("net", NULL);
+	proc_net_shadow->proc_iops = &proc_net_dir_inode_operations;
+	proc_net_shadow->proc_fops = &proc_net_dir_operations;
 
 	return register_pernet_subsys(&proc_net_ns_ops);
 }
diff -puN include/linux/proc_fs.h~revert-fix-proc-net-breakage include/linux/proc_fs.h
--- a/include/linux/proc_fs.h~revert-fix-proc-net-breakage
+++ a/include/linux/proc_fs.h
@@ -48,8 +48,6 @@ typedef	int (read_proc_t)(char *page, ch
 typedef	int (write_proc_t)(struct file *file, const char __user *buffer,
 			   unsigned long count, void *data);
 typedef int (get_info_t)(char *, char **, off_t, int);
-typedef struct proc_dir_entry *(shadow_proc_t)(struct task_struct *task,
-						struct proc_dir_entry *pde);
 
 struct proc_dir_entry {
 	unsigned int low_ino;
@@ -80,7 +78,6 @@ struct proc_dir_entry {
 	int pde_users;	/* number of callers into module in progress */
 	spinlock_t pde_unload_lock; /* proc_fops checks and pde_users bumps */
 	struct completion *pde_unload_completion;
-	shadow_proc_t *shadow_proc;
 };
 
 struct kcore_list {
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
