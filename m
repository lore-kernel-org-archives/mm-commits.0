From: akpm@linux-foundation.org
Subject: - containersv10-basic-container-framework-fix.patch removed from -mm tree
Date: Fri, 20 Jul 2007 13:28:49 -0700
Message-ID: <200707202028.l6KKSnZJ014811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49581 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763670AbXGTUa3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 16:30:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, balbir@in.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, menage@google.com, pj@sgi.com, serue@us.ibm.com, vatsa@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     containersv10-basic-container-framework-fix
has been removed from the -mm tree.  Its filename was
     containersv10-basic-container-framework-fix.patch

This patch was dropped because an updated version will be merged

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
@@ -40,5 +40,6 @@
 
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

origin.patch
slow-down-printk-during-boot.patch
slow-down-printk-during-boot-fix-2.patch
git-acpi.patch
git-acpi-fix-git-rejects.patch
acpi-add-reboot-mechanism-fix.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
revert-gregkh-driver-block-device.patch
git-dvb.patch
adbhid-produce-all-capslock-key-events-fix.patch
git-kvm.patch
git-leds.patch
libata-add-irq_flags-to-struct-pata_platform_info-fix.patch
git-mtd.patch
mtd-potential-leak-in-rfd_ftl_add_mtd-fix.patch
e1000new-build-fix.patch
e1000new-build-fix-2.patch
serial-8250-handle-saving-the-clear-on-read-bits-from-the-lsr-fix.patch
add-blacklisting-capability-to-serial_pci-to-avoid-misdetection-fix.patch
revert-gregkh-pci-pci_bridge-device.patch
i386-add-support-for-picopower-irq-router.patch
try-parent-numa_node-at-first-before-using-default-v2-fix.patch
git-scsi-misc.patch
aacraid-rename-check_reset.patch
git-unionfs.patch
git-block-vs-git-unionfs.patch
x86_64-clean-up-apicid_to_node-declaration.patch
clockevents-fix-resume-logic-xen-fix.patch
ntp-move-the-cmos-update-code-into-ntpc.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
mmconfig-validate-against-acpi-motherboard-resources.patch
git-xfs.patch
git-xfs-fixup.patch
git-kgdb-fixup-2.patch
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sparsemem-record-when-a-section-has-a-valid-mem_map-fix.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
bias-the-location-of-pages-freed-for-min_free_kbytes-in-the-same-max_order_nr_pages-blocks.patch
maps2-move-the-page-walker-code-to-lib.patch
maps2-add-proc-pid-pagemap-interface.patch
maps2-make-proc-pid-smaps-optional-under-config_embeddedpatch-fix.patch
slub-slab-validation-move-tracking-information-alloc-outside-of-melstuff.patch
hugetlbfs-read-support-fix.patch
security-convert-lsm-into-a-static-interface-fix.patch
file-capabilities-clear-caps-cleanup-fix.patch
capabilityh-remove-include-of-currenth.patch
cache-pipe-buf-page-address-for-non-highmem-arch.patch
force-erroneous-inclusions-of-compiler-h-files-to-be-errors-fix.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91-fix.patch
add-kernel-notifierc-fix.patch
fs-9p-convc-error-path-fix.patch
loop-use-unlocked_ioctl.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-2.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-3.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-4.patch
writeback-fix-comment-use-helper-function.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-5.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-6.patch
writeback-fix-time-ordering-of-the-per-superblock-dirty-inode-lists-7.patch
revert-faster-ext2_clear_inode.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-iommu-floppy-workaround.patch
revoke-wire-up-i386-system-calls.patch
revoke-vs-git-block.patch
containersv10-basic-container-framework-fix.patch
containersv10-basic-container-framework-fix-2.patch
containersv10-example-cpu-accounting-subsystem-fix.patch
containersv10-add-tasks-file-interface-fix.patch
containersv10-add-fork-exit-hooks-fix.patch
containersv10-add-container_clone-interface-fix.patch
containersv10-add-procfs-interface-fix.patch
containersv10-share-css_group-arrays-between-tasks-with-same-container-memberships-fix.patch
containersv10-simple-debug-info-subsystem-fix.patch
containersv10-simple-debug-info-subsystem-fix-2.patch
add-containerstats-v3-fix.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
reiser4.patch
git-block-vs-reiser4.patch
page-owner-tracking-leak-detector.patch
check_dirty_inode_list.patch
alloc_pages-debug.patch
w1-build-fix.patch
