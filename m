From: akpm@linux-foundation.org
Subject: + containersv10-basic-container-framework-fix.patch added to -mm tree
Date: Wed, 30 May 2007 00:14:50 -0700
Message-ID: <200705300714.l4U7Entr021300@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbXE3HPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 May 2007 03:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com


The patch titled
     containersv10-basic-container-framework-fix
has been added to the -mm tree.  Its filename is
     containersv10-basic-container-framework-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: containersv10-basic-container-framework-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Paul Jackson <pj@sgi.com>
Cc: Paul Menage <menage@google.com>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/container.h |    7 +--
 include/linux/magic.h     |    1 
 kernel/container.c        |   83 +++++++++++++++++-------------------
 3 files changed, 45 insertions(+), 46 deletions(-)

diff -puN include/linux/container.h~containersv10-basic-container-framework-fix include/linux/container.h
--- a/include/linux/container.h~containersv10-basic-container-framework-fix
+++ a/include/linux/container.h
@@ -12,17 +12,19 @@
 #include <linux/kref.h>
 #include <linux/cpumask.h>
 #include <linux/nodemask.h>
+#include <linux/rcupdate.h>
 
 #ifdef CONFIG_CONTAINERS
 
+struct containerfs_root;
+struct inode;
+
 extern int container_init_early(void);
 extern int container_init(void);
 extern void container_init_smp(void);
 extern void container_lock(void);
 extern void container_unlock(void);
 
-struct containerfs_root;
-
 /* Per-subsystem/per-container state maintained by the system. */
 struct container_subsys_state {
 	/* The container that this subsystem is attached to. Useful
@@ -94,7 +96,6 @@ struct container {
  *	- the 'cftype' of the file is file->f_dentry->d_fsdata
  */
 
-struct inode;
 #define MAX_CFTYPE_NAME 64
 struct cftype {
 	/* By convention, the name should begin with the name of the
diff -puN include/linux/magic.h~containersv10-basic-container-framework-fix include/linux/magic.h
--- a/include/linux/magic.h~containersv10-basic-container-framework-fix
+++ a/include/linux/magic.h
@@ -41,5 +41,6 @@
 
 #define SMB_SUPER_MAGIC		0x517B
 #define USBDEVICE_SUPER_MAGIC	0x9fa2
+#define CONTAINER_SUPER_MAGIC	0x27e0eb
 
 #endif /* __LINUX_MAGIC_H__ */
diff -puN kernel/container.c~containersv10-basic-container-framework-fix kernel/container.c
--- a/kernel/container.c~containersv10-basic-container-framework-fix
+++ a/kernel/container.c
@@ -38,16 +38,19 @@
 #include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/pagemap.h>
 #include <linux/proc_fs.h>
 #include <linux/rcupdate.h>
+#include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/security.h>
 #include <linux/slab.h>
+#include <linux/magic.h>
 #include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/stat.h>
@@ -56,11 +59,7 @@
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
 
-#include <asm/uaccess.h>
 #include <asm/atomic.h>
-#include <linux/mutex.h>
-
-#define CONTAINER_SUPER_MAGIC		0x27e0eb
 
 /* Generate an array of container subsystem pointers */
 #define SUBSYS(_x) &_x ## _subsys,
@@ -110,12 +109,12 @@ static LIST_HEAD(roots);
  * avoids us having to do extra work in the fork/exit path if none of the
  * subsystems need to be called.
  */
-static int need_forkexit_callback = 0;
+static int need_forkexit_callback;
 
 /* bits in struct container flags field */
-typedef enum {
+enum {
 	CONT_REMOVED,
-} container_flagbits_t;
+};
 
 /* convenient tests for these bits */
 inline int container_is_removed(const struct container *cont)
@@ -211,8 +210,9 @@ void container_unlock(void)
 
 /*
  * A couple of forward declarations required, due to cyclic reference loop:
- *  container_mkdir -> container_create -> container_populate_dir -> container_add_file
- *  -> container_create_file -> container_dir_inode_operations -> container_mkdir.
+ * container_mkdir -> container_create -> container_populate_dir ->
+ * container_add_file -> container_create_file -> container_dir_inode_operations
+ * -> container_mkdir.
  */
 
 static int container_mkdir(struct inode *dir, struct dentry *dentry, int mode);
@@ -220,14 +220,12 @@ static int container_rmdir(struct inode 
 static int container_populate_dir(struct container *cont);
 static struct inode_operations container_dir_inode_operations;
 
-static struct backing_dev_info container_backing_dev_info = {
-	.ra_pages = 0,		/* No readahead */
-	.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
-};
-
 static struct inode *container_new_inode(mode_t mode, struct super_block *sb)
 {
 	struct inode *inode = new_inode(sb);
+	static struct backing_dev_info container_backing_dev_info = {
+		.capabilities	= BDI_CAP_NO_ACCT_DIRTY | BDI_CAP_NO_WRITEBACK,
+	};
 
 	if (inode) {
 		inode->i_mode = mode;
@@ -251,14 +249,14 @@ static void container_diput(struct dentr
 	iput(inode);
 }
 
-static struct dentry_operations container_dops = {
-	.d_iput = container_diput,
-};
-
 static struct dentry *container_get_dentry(struct dentry *parent,
 					   const char *name)
 {
 	struct dentry *d = lookup_one_len(name, parent, strlen(name));
+	static struct dentry_operations container_dops = {
+		.d_iput = container_diput,
+	};
+
 	if (!IS_ERR(d))
 		d->d_op = &container_dops;
 	return d;
@@ -276,6 +274,7 @@ static void remove_dir(struct dentry *d)
 static void container_clear_directory(struct dentry *dentry)
 {
 	struct list_head *node;
+
 	BUG_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
 	spin_lock(&dcache_lock);
 	node = dentry->d_subdirs.next;
@@ -334,11 +333,10 @@ static int rebind_subsystems(struct cont
 
 	/* Currently we don't handle adding/removing subsystems when
 	 * any subcontainers exist. This is theoretically supportable
-	 * but involves complex erro r handling, so it's being left until
+	 * but involves complex error handling, so it's being left until
 	 * later */
-	if (!list_empty(&cont->children)) {
+	if (!list_empty(&cont->children))
 		return -EBUSY;
-	}
 
 	/* Process each subsystem */
 	for (i = 0; i < CONTAINER_SUBSYS_COUNT; i++) {
@@ -385,10 +383,8 @@ static int rebind_subsystems(struct cont
  * there are active subcontainers since each subcontainer bumps the
  * value of sb->s_active.
  */
-
 static void container_put_super(struct super_block *sb)
 {
-
 	struct containerfs_root *root = sb->s_fs_info;
 	struct container *cont = &root->top_container;
 	int ret;
@@ -416,9 +412,9 @@ static int container_show_options(struct
 {
 	struct containerfs_root *root = vfs->mnt_sb->s_fs_info;
 	struct container_subsys *ss;
-	for_each_subsys(root, ss) {
+
+	for_each_subsys(root, ss)
 		seq_printf(seq, ",%s", ss->name);
-	}
 	return 0;
 }
 
@@ -604,7 +600,6 @@ static int container_get_sb(struct file_
 		container_populate_dir(cont);
 		mutex_unlock(&cont->dentry->d_inode->i_mutex);
 		BUG_ON(ret);
-
 	} else {
 		/* Reuse the existing superblock */
 		ret = simple_set_mnt(mnt, root->sb);
@@ -634,10 +629,9 @@ static inline struct cftype *__d_cft(str
 }
 
 /*
- * Call with container_mutex held.  Writes path of container into buf.
+ * Called with container_mutex held.  Writes path of container into buf.
  * Returns 0 on success, -errno on error.
  */
-
 int container_path(const struct container *cont, char *buf, int buflen)
 {
 	char *start;
@@ -663,9 +657,9 @@ int container_path(const struct containe
 	return 0;
 }
 
-static inline void get_first_subsys(const struct container *cont,
-				    struct container_subsys_state **css,
-				    int *subsys_id) {
+static void get_first_subsys(const struct container *cont,
+			struct container_subsys_state **css, int *subsys_id)
+{
 	const struct containerfs_root *root = cont->root;
 	const struct container_subsys *test_ss;
 	BUG_ON(list_empty(&root->subsys_list));
@@ -681,17 +675,18 @@ static inline void get_first_subsys(cons
 
 /* The various types of files and directories in a container file system */
 
-typedef enum {
+enum container_filetype {
 	FILE_ROOT,
 	FILE_DIR,
 	FILE_TASKLIST,
-} container_filetype_t;
+};
 
 static ssize_t container_file_write(struct file *file, const char __user *buf,
 						size_t nbytes, loff_t *ppos)
 {
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct container *cont = __d_cont(file->f_dentry->d_parent);
+
 	if (!cft)
 		return -ENODEV;
 	if (!cft->write)
@@ -708,6 +703,7 @@ static ssize_t container_read_uint(struc
 	char tmp[64];
 	u64 val = cft->read_uint(cont, cft);
 	int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
+
 	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
 }
 
@@ -716,6 +712,7 @@ static ssize_t container_file_read(struc
 {
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct container *cont = __d_cont(file->f_dentry->d_parent);
+
 	if (!cft)
 		return -ENODEV;
 
@@ -784,7 +781,8 @@ static struct inode_operations container
 	.rename = container_rename,
 };
 
-static int container_create_file(struct dentry *dentry, int mode, struct super_block *sb)
+static int container_create_file(struct dentry *dentry, int mode,
+				struct super_block *sb)
 {
 	struct inode *inode;
 
@@ -825,7 +823,6 @@ static int container_create_file(struct 
  *	name:	The name to give to the container directory. Will be copied.
  *	mode:	mode to set on new directory.
  */
-
 static int container_create_dir(struct container *cont, struct dentry *dentry,
 				int mode)
 {
@@ -855,7 +852,8 @@ int container_add_file(struct container 
 	BUG_ON(!mutex_is_locked(&dir->d_inode->i_mutex));
 	dentry = container_get_dentry(dir, cft->name);
 	if (!IS_ERR(dentry)) {
-		error = container_create_file(dentry, 0644 | S_IFREG, cont->root->sb);
+		error = container_create_file(dentry, 0644 | S_IFREG,
+						cont->root->sb);
 		if (!error)
 			dentry->d_fsdata = (void *)cft;
 		dput(dentry);
@@ -869,7 +867,8 @@ int container_add_files(struct container
 {
 	int i, err;
 	for (i = 0; i < count; i++) {
-		if ((err = container_add_file(cont, &cft[i])))
+		err = container_add_file(cont, &cft[i]);
+		if (err)
 			return err;
 	}
 	return 0;
@@ -940,7 +939,8 @@ static long container_create(struct cont
 
 	for_each_subsys(root, ss) {
 		err = ss->create(ss, cont);
-		if (err) goto err_destroy;
+		if (err)
+			goto err_destroy;
 		init_container_css(ss, cont);
 	}
 
@@ -1103,9 +1103,7 @@ static void container_init_subsys(struct
 /**
  * container_init_early - initialize containers at system boot, and
  * initialize any subsystems that request early init.
- *
- **/
-
+ */
 int __init container_init_early(void)
 {
 	int i;
@@ -1133,8 +1131,7 @@ int __init container_init_early(void)
 /**
  * container_init - register container filesystem and /proc file, and
  * initialize any subsystems that didn't request early init.
- **/
-
+ */
 int __init container_init(void)
 {
 	int err;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

slub-more-documentation-fix.patch
ntfs_init_locked_inode-fix-array-indexing.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-merge-nopfn-into-fault.patch
invalidate_mapping_pages-add-cond_resched.patch
git-acpi-export-acpi_set_cstate_limit.patch
git-alsa-fixup.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-arm-master.patch
git-cpufreq-fix.patch
8xx-mpc885ads-pcmcia-support.patch
fix-gregkh-driver-dmi-based-module-autoloading.patch
fix-gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
driver-core-check-return-code-of-sysfs_create_link.patch
git-drm.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-leds.patch
git-leds-fixup.patch
git-mips-fixup.patch
git-mtd.patch
use-mutex-instead-of-semaphore-in-the-mtd-st-m25pxx-driver.patch
git-ubi.patch
wrong-timeout-value-in-sk_wait_data-v2-fix.patch
git-battery.patch
git-nfs-server-cluster-locking-api-fixup.patch
git-parisc.patch
pci-x-pci-express-read-control-interfaces-fix.patch
git-pciseg.patch
sh-support-older-gccs.patch
git-scsi-misc.patch
scsi-fix-config_scsi_wait_scan=m.patch
git-unionfs.patch
fix-gregkh-usb-usb-ehci-cpufreq-fix.patch
git-watchdog.patch
git-wireless.patch
x86_64-mm-xen-attempt-to-patch-inline-versions-of-common-operations.patch
fix-x86_64-numa-fake-apicid_to_node-mapping-for-fake-numa-2.patch
i386-add-support-for-picopower-irq-router.patch
x86_64-extract-helper-function-from-e820_register_active_regions.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
x86_64-fix-smp_call_function_single-return-value.patch
git-xfs.patch
git-cryptodev.patch
fix-possible-leakage-of-blocks-in-udf-tidy.patch
potential-parse-error-in-ifdef.patch
e1000-restore-netif_poll_enable-call-but-make-sure-irqs-are-off.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
change-zonelist-order-v6-zonelist-fix.patch
add-__gfp_movable-for-callers-to-flag-allocations-from-high-memory-that-may-be-migrated.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
create-the-zone_movable-zone-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix.patch
allow-huge-page-allocations-to-use-gfp_high_movable-fix-2.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-move-the-page-walker-code-to-lib-fix.patch
maps2-add-proc-pid-pagemap-interface.patch
fs-introduce-some-page-buffer-invariants-obnoxiousness.patch
alpha-support-graphics-on-non-zero-pci-domains-fix.patch
alpha-support-graphics-on-non-zero-pci-domains-fix-2.patch
freezer-run-show_state-when-freezing-times-out.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
use-write_trylock_irqsave-in-ptrace_attach-fix.patch
use-no_pci_devices-in-pci-searchc.patch
introduce-boot-based-time-fix.patch
use-boot-based-time-for-process-start-time-and-boot-time-fix.patch
add-argv_split-fix.patch
add-common-orderly_poweroff-fix.patch
cpu-hotplug-fix-ksoftirqd-termination-on-cpu-hotplug-with-naughty-realtime-process-fix.patch
fuse-warning-fix.patch
vxfs-warning-fixes.patch
percpu_counters-use-cpu-notifiers.patch
percpu_counters-use-for_each_online_cpu.patch
rd-mark-ramdisk-buffer-heads-dirty-in-ramdisk_set_page_dirty-fix.patch
mpu401-warning-fixes.patch
procfs-directory-entry-cleanup-fix.patch
vdso-print-fatal-signals.patch
reduce-cpusetc-write_lock_irq-to-read_lock-fix.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
crc7-support-fix.patch
i2o_cfg_passthru-cleanup-fix.patch
knfsd-exportfs-add-exportfsh-header-fix.patch
knfsd-exportfs-remove-iget-abuse-fix.patch
nfsd-warning-fix.patch
revoke-wire-up-i386-system-calls.patch
lguest-the-host-code.patch
lguest-the-host-code-borkages.patch
cfs-scheduler-vs-detach-schedh-from-mmh.patch
cfs-scheduler-warning-fixes.patch
kernel-doc-fix-leading-dot-in-man-mode-output-fix.patch
containersv10-basic-container-framework-fix.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
reiser4.patch
reiser4-fix.patch
check_dirty_inode_list.patch
w1-build-fix.patch
