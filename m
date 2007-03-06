From: akpm@linux-foundation.org
Subject: - reiser4-kmem_cache_t-removal.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:04:37 -0800
Message-ID: <200703060204.l2624bsf008820@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965713AbXCFCEj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:04:39 -0500
Received: from shell0.pdx.osdl.net (fw.osdl.org [65.172.181.6])
	by smtp.osdl.org (8.12.8/8.12.8) with ESMTP id l2624bq8018955
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <mm-commits@vger.kernel.org>; Mon, 5 Mar 2007 18:04:38 -0800
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     reiser4-kmem_cache_t-removal
has been removed from the -mm tree.  Its filename was
     reiser4-kmem_cache_t-removal.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4-kmem_cache_t-removal
From: Andrew Morton <akpm@osdl.org>

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/flush_queue.c       |    2 +-
 fs/reiser4/fsdata.c            |    6 +++---
 fs/reiser4/jnode.c             |    2 +-
 fs/reiser4/plugin/plugin_set.c |    2 +-
 fs/reiser4/super.h             |    2 +-
 fs/reiser4/super_ops.c         |    6 +++---
 fs/reiser4/txnmgr.c            |    6 +++---
 fs/reiser4/znode.c             |    2 +-
 8 files changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/reiser4/jnode.c~reiser4-kmem_cache_t-removal fs/reiser4/jnode.c
--- a/fs/reiser4/jnode.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/jnode.c
@@ -123,7 +123,7 @@
 #include <linux/fs.h>		/* for struct address_space  */
 #include <linux/writeback.h>	/* for inode_lock */
 
-static kmem_cache_t *_jnode_slab = NULL;
+static struct kmem_cache *_jnode_slab = NULL;
 
 static void jnode_set_type(jnode * node, jnode_type type);
 static int jdelete(jnode * node);
diff -puN fs/reiser4/flush_queue.c~reiser4-kmem_cache_t-removal fs/reiser4/flush_queue.c
--- a/fs/reiser4/flush_queue.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/flush_queue.c
@@ -107,7 +107,7 @@ static void init_fq(flush_queue_t * fq)
 }
 
 /* slab for flush queues */
-static kmem_cache_t *fq_slab;
+static struct kmem_cache *fq_slab;
 
 /**
  * reiser4_init_fqs - create flush queue cache
diff -puN fs/reiser4/super.h~reiser4-kmem_cache_t-removal fs/reiser4/super.h
--- a/fs/reiser4/super.h~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/super.h
@@ -444,7 +444,7 @@ long oids_used(const struct super_block 
 void print_fs_info(const char *prefix, const struct super_block *);
 #endif
 
-extern void destroy_reiser4_cache(kmem_cache_t **);
+extern void destroy_reiser4_cache(struct kmem_cache **);
 
 extern struct super_operations reiser4_super_operations;
 extern struct export_operations reiser4_export_operations;
diff -puN fs/reiser4/txnmgr.c~reiser4-kmem_cache_t-removal fs/reiser4/txnmgr.c
--- a/fs/reiser4/txnmgr.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/txnmgr.c
@@ -90,7 +90,7 @@ year old --- define all technical terms 
    For actually implementing these out-of-system-call-scopped transcrashes, the
    reiser4_context has a "txn_handle *trans" pointer that may be set to an open
    transcrash.  Currently there are no dynamically-allocated transcrashes, but there is a
-   "kmem_cache_t *_txnh_slab" created for that purpose in this file.
+   "struct kmem_cache *_txnh_slab" created for that purpose in this file.
 */
 
 /* Extending the other system call interfaces for future transaction features:
@@ -279,9 +279,9 @@ struct _txn_wait_links {
 
 /* FIXME: In theory, we should be using the slab cache init & destructor
    methods instead of, e.g., jnode_init, etc. */
-static kmem_cache_t *_atom_slab = NULL;
+static struct kmem_cache *_atom_slab = NULL;
 /* this is for user-visible, cross system-call transactions. */
-static kmem_cache_t *_txnh_slab = NULL;
+static struct kmem_cache *_txnh_slab = NULL;
 
 /**
  * init_txnmgr_static - create transaction manager slab caches
diff -puN fs/reiser4/super_ops.c~reiser4-kmem_cache_t-removal fs/reiser4/super_ops.c
--- a/fs/reiser4/super_ops.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/super_ops.c
@@ -14,7 +14,7 @@
 #include <linux/debugfs.h>
 
 /* slab cache for inodes */
-static kmem_cache_t *inode_cache;
+static struct kmem_cache *inode_cache;
 
 static struct dentry *reiser4_debugfs_root = NULL;
 
@@ -27,7 +27,7 @@ static struct dentry *reiser4_debugfs_ro
  * Initialization function to be called when new page is allocated by reiser4
  * inode cache. It is set on inode cache creation.
  */
-static void init_once(void *obj, kmem_cache_t *cache, unsigned long flags)
+static void init_once(void *obj, struct kmem_cache *cache, unsigned long flags)
 {
 	reiser4_inode_object *info;
 
@@ -595,7 +595,7 @@ static struct file_system_type reiser4_f
 	.next = NULL
 };
 
-void destroy_reiser4_cache(kmem_cache_t **cachep)
+void destroy_reiser4_cache(struct kmem_cache **cachep)
 {
 	BUG_ON(*cachep == NULL);
 	kmem_cache_destroy(*cachep);
diff -puN fs/reiser4/znode.c~reiser4-kmem_cache_t-removal fs/reiser4/znode.c
--- a/fs/reiser4/znode.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/znode.c
@@ -196,7 +196,7 @@ TYPE_SAFE_HASH_DEFINE(z, znode, reiser4_
 #undef KMALLOC
 
 /* slab for znodes */
-static kmem_cache_t *znode_cache;
+static struct kmem_cache *znode_cache;
 
 int znode_shift_order;
 
diff -puN fs/reiser4/plugin/plugin_set.c~reiser4-kmem_cache_t-removal fs/reiser4/plugin/plugin_set.c
--- a/fs/reiser4/plugin/plugin_set.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/plugin/plugin_set.c
@@ -31,7 +31,7 @@
 #include <linux/stddef.h>
 
 /* slab for plugin sets */
-static kmem_cache_t *plugin_set_slab;
+static struct kmem_cache *plugin_set_slab;
 
 static spinlock_t plugin_set_lock[8] __cacheline_aligned_in_smp = {
 	[0 ... 7] = SPIN_LOCK_UNLOCKED
diff -puN fs/reiser4/fsdata.c~reiser4-kmem_cache_t-removal fs/reiser4/fsdata.c
--- a/fs/reiser4/fsdata.c~reiser4-kmem_cache_t-removal
+++ a/fs/reiser4/fsdata.c
@@ -6,7 +6,7 @@
 
 
 /* cache or dir_cursors */
-static kmem_cache_t *d_cursor_cache;
+static struct kmem_cache *d_cursor_cache;
 static struct shrinker *d_cursor_shrinker;
 
 /* list of unused cursors */
@@ -595,7 +595,7 @@ void reiser4_detach_fsdata(struct file *
 }
 
 /* slab for reiser4_dentry_fsdata */
-static kmem_cache_t *dentry_fsdata_cache;
+static struct kmem_cache *dentry_fsdata_cache;
 
 /**
  * reiser4_init_dentry_fsdata - create cache of dentry_fsdata
@@ -662,7 +662,7 @@ void reiser4_free_dentry_fsdata(struct d
 }
 
 /* slab for reiser4_file_fsdata */
-static kmem_cache_t *file_fsdata_cache;
+static struct kmem_cache *file_fsdata_cache;
 
 /**
  * reiser4_init_file_fsdata - create cache of reiser4_file_fsdata
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
macintosh-mangle-caps-lock-events-on-adb-keyboards.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
rcu-preemptible-rcu.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
reiser4-kmem_cache_t-removal.patch
reiser4-test_clear_page_dirty.patch
statistics-infrastructure-fix-buffer-overflow-in-histogram-with-linear-tidy.patch
slim-main-include-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
add-debugging-aid-for-memory-initialisation-problems-fix.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
ia64-enable-config_debug_spinlock_sleep.patch
squash-ipc-warnings.patch
squash-udf-warnings.patch
