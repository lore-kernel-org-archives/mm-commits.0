From: akpm@linux-foundation.org
Subject: + mm-clean-up-and-kernelify-shrinker-registration.patch added to -mm tree
Date: Tue, 03 Apr 2007 18:20:01 -0700
Message-ID: <200704040120.l341K1wu008763@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51707 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966226AbXDDBUN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 3 Apr 2007 21:20:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rusty@rustcorp.com.au, dgc@sgi.com


The patch titled
     mm: clean up and kernelify shrinker registration
has been added to the -mm tree.  Its filename is
     mm-clean-up-and-kernelify-shrinker-registration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: clean up and kernelify shrinker registration
From: Rusty Russell <rusty@rustcorp.com.au>

I can never remember what the function to register to receive VM pressure
is called.  I have to trace down from __alloc_pages() to find it.

It's called "set_shrinker()", and it needs Your Help.

1) Don't hide struct shrinker.  It contains no magic.
2) Don't allocate "struct shrinker".  It's not helpful.
3) Call them "register_shrinker" and "unregister_shrinker".
4) Call the function "shrink" not "shrinker".
5) Reduce the 17 lines of waffly comments to 13, but document it properly.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Chinner <dgc@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/functionlist |    1 
 fs/dcache.c                     |    9 +++++-
 fs/dquot.c                      |    7 ++++-
 fs/inode.c                      |    7 ++++-
 fs/mbcache.c                    |    9 ++++--
 fs/nfs/super.c                  |   10 ++++---
 fs/xfs/linux-2.6/xfs_buf.c      |   14 ++++------
 fs/xfs/quota/xfs_qm.c           |   10 +++++--
 include/linux/mm.h              |   40 +++++++++++++++-------------
 mm/vmscan.c                     |   42 +++++++-----------------------
 10 files changed, 77 insertions(+), 72 deletions(-)

diff -puN arch/x86_64/kernel/functionlist~mm-clean-up-and-kernelify-shrinker-registration arch/x86_64/kernel/functionlist
--- a/arch/x86_64/kernel/functionlist~mm-clean-up-and-kernelify-shrinker-registration
+++ a/arch/x86_64/kernel/functionlist
@@ -1118,7 +1118,6 @@
 *(.text.simple_strtoll)
 *(.text.set_termios)
 *(.text.set_task_comm)
-*(.text.set_shrinker)
 *(.text.set_normalized_timespec)
 *(.text.set_brk)
 *(.text.serial_in)
diff -puN fs/dcache.c~mm-clean-up-and-kernelify-shrinker-registration fs/dcache.c
--- a/fs/dcache.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/dcache.c
@@ -854,6 +854,11 @@ static int shrink_dcache_memory(int nr, 
 	return (dentry_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
+static struct shrinker dcache_shrinker = {
+	.shrink = shrink_dcache_memory,
+	.seeks = DEFAULT_SEEKS,
+};
+
 /**
  * d_alloc	-	allocate a dcache entry
  * @parent: parent of entry to allocate
@@ -2058,8 +2063,8 @@ static void __init dcache_init(unsigned 
 					 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
 					 SLAB_MEM_SPREAD),
 					 NULL, NULL);
-	
-	set_shrinker(DEFAULT_SEEKS, shrink_dcache_memory);
+
+	register_shrinker(&dcache_shrinker);
 
 	/* Hash may have been set up in dcache_init_early */
 	if (!hashdist)
diff -puN fs/dquot.c~mm-clean-up-and-kernelify-shrinker-registration fs/dquot.c
--- a/fs/dquot.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/dquot.c
@@ -539,6 +539,11 @@ static int shrink_dqcache_memory(int nr,
 	return (dqstats.free_dquots / 100) * sysctl_vfs_cache_pressure;
 }
 
+static struct shrinker dqcache_shrinker = {
+	.shrink = shrink_dqcache_memory,
+	.seeks = DEFAULT_SEEKS,
+};
+
 /*
  * Put reference to dquot
  * NOTE: If you change this function please check whether dqput_blocks() works right...
@@ -1870,7 +1875,7 @@ static int __init dquot_init(void)
 	printk("Dquot-cache hash table entries: %ld (order %ld, %ld bytes)\n",
 			nr_hash, order, (PAGE_SIZE << order));
 
-	set_shrinker(DEFAULT_SEEKS, shrink_dqcache_memory);
+	register_shrinker(&dqcache_shrinker);
 
 	return 0;
 }
diff -puN fs/inode.c~mm-clean-up-and-kernelify-shrinker-registration fs/inode.c
--- a/fs/inode.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/inode.c
@@ -464,6 +464,11 @@ static int shrink_icache_memory(int nr, 
 	return (inodes_stat.nr_unused / 100) * sysctl_vfs_cache_pressure;
 }
 
+static struct shrinker icache_shrinker = {
+	.shrink = shrink_icache_memory,
+	.seeks = DEFAULT_SEEKS,
+};
+
 static void __wait_on_freeing_inode(struct inode *inode);
 /*
  * Called with the inode lock held.
@@ -1381,7 +1386,7 @@ void __init inode_init(unsigned long mem
 					 SLAB_MEM_SPREAD),
 					 init_once,
 					 NULL);
-	set_shrinker(DEFAULT_SEEKS, shrink_icache_memory);
+	register_shrinker(&icache_shrinker);
 
 	/* Hash may have been set up in inode_init_early */
 	if (!hashdist)
diff -puN fs/mbcache.c~mm-clean-up-and-kernelify-shrinker-registration fs/mbcache.c
--- a/fs/mbcache.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/mbcache.c
@@ -100,7 +100,6 @@ struct mb_cache {
 static LIST_HEAD(mb_cache_list);
 static LIST_HEAD(mb_cache_lru_list);
 static DEFINE_SPINLOCK(mb_cache_spinlock);
-static struct shrinker *mb_shrinker;
 
 static inline int
 mb_cache_indexes(struct mb_cache *cache)
@@ -118,6 +117,10 @@ mb_cache_indexes(struct mb_cache *cache)
 
 static int mb_cache_shrink_fn(int nr_to_scan, gfp_t gfp_mask);
 
+static struct shrinker mb_cache_shrinker = {
+	.shrink = mb_cache_shrink_fn,
+	.seeks = DEFAULT_SEEKS,
+};
 
 static inline int
 __mb_cache_entry_is_hashed(struct mb_cache_entry *ce)
@@ -662,13 +665,13 @@ mb_cache_entry_find_next(struct mb_cache
 
 static int __init init_mbcache(void)
 {
-	mb_shrinker = set_shrinker(DEFAULT_SEEKS, mb_cache_shrink_fn);
+	register_shrinker(&mb_cache_shrinker);
 	return 0;
 }
 
 static void __exit exit_mbcache(void)
 {
-	remove_shrinker(mb_shrinker);
+	unregister_shrinker(&mb_cache_shrinker);
 }
 
 module_init(init_mbcache)
diff -puN fs/nfs/super.c~mm-clean-up-and-kernelify-shrinker-registration fs/nfs/super.c
--- a/fs/nfs/super.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/nfs/super.c
@@ -138,7 +138,10 @@ static const struct super_operations nfs
 };
 #endif
 
-static struct shrinker *acl_shrinker;
+static struct shrinker acl_shrinker = {
+	.shrink		= nfs_access_cache_shrinker,
+	.seeks		= DEFAULT_SEEKS,
+};
 
 /*
  * Register the NFS filesystems
@@ -159,7 +162,7 @@ int __init register_nfs_fs(void)
 	if (ret < 0)
 		goto error_2;
 #endif
-	acl_shrinker = set_shrinker(DEFAULT_SEEKS, nfs_access_cache_shrinker);
+	register_shrinker(&acl_shrinker);
 	return 0;
 
 #ifdef CONFIG_NFS_V4
@@ -177,8 +180,7 @@ error_0:
  */
 void __exit unregister_nfs_fs(void)
 {
-	if (acl_shrinker != NULL)
-		remove_shrinker(acl_shrinker);
+	unregister_shrinker(&acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
 	nfs_unregister_sysctl();
diff -puN fs/xfs/linux-2.6/xfs_buf.c~mm-clean-up-and-kernelify-shrinker-registration fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/xfs/linux-2.6/xfs_buf.c
@@ -35,10 +35,13 @@
 #include <linux/freezer.h>
 
 static kmem_zone_t *xfs_buf_zone;
-static struct shrinker *xfs_buf_shake;
 STATIC int xfsbufd(void *);
 STATIC int xfsbufd_wakeup(int, gfp_t);
 STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
+static struct shrinker xfs_buf_shake = {
+	.shrink = xfsbufd_wakeup,
+	.seeks = DEFAULT_SEEKS,
+};
 
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
@@ -1837,14 +1840,9 @@ xfs_buf_init(void)
 	if (!xfsdatad_workqueue)
 		goto out_destroy_xfslogd_workqueue;
 
-	xfs_buf_shake = set_shrinker(DEFAULT_SEEKS, xfsbufd_wakeup);
-	if (!xfs_buf_shake)
-		goto out_destroy_xfsdatad_workqueue;
-
+	register_shrinker(&xfs_buf_shake);
 	return 0;
 
- out_destroy_xfsdatad_workqueue:
-	destroy_workqueue(xfsdatad_workqueue);
  out_destroy_xfslogd_workqueue:
 	destroy_workqueue(xfslogd_workqueue);
  out_free_buf_zone:
@@ -1859,7 +1857,7 @@ xfs_buf_init(void)
 void
 xfs_buf_terminate(void)
 {
-	remove_shrinker(xfs_buf_shake);
+	unregister_shrinker(&xfs_buf_shake);
 	destroy_workqueue(xfsdatad_workqueue);
 	destroy_workqueue(xfslogd_workqueue);
 	kmem_zone_destroy(xfs_buf_zone);
diff -puN fs/xfs/quota/xfs_qm.c~mm-clean-up-and-kernelify-shrinker-registration fs/xfs/quota/xfs_qm.c
--- a/fs/xfs/quota/xfs_qm.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/fs/xfs/quota/xfs_qm.c
@@ -62,7 +62,6 @@ uint		ndquot;
 
 kmem_zone_t	*qm_dqzone;
 kmem_zone_t	*qm_dqtrxzone;
-static struct shrinker *xfs_qm_shaker;
 
 static cred_t	xfs_zerocr;
 static xfs_inode_t	xfs_zeroino;
@@ -79,6 +78,11 @@ STATIC int	xfs_qm_init_quotainos(xfs_mou
 STATIC int	xfs_qm_init_quotainfo(xfs_mount_t *);
 STATIC int	xfs_qm_shake(int, gfp_t);
 
+static struct shrinker xfs_qm_shaker = {
+	.shrink = xfs_qm_shake,
+	.seeks = DEFAULT_SEEKS,
+};
+
 #ifdef DEBUG
 extern mutex_t	qcheck_lock;
 #endif
@@ -150,7 +154,7 @@ xfs_Gqm_init(void)
 	} else
 		xqm->qm_dqzone = qm_dqzone;
 
-	xfs_qm_shaker = set_shrinker(DEFAULT_SEEKS, xfs_qm_shake);
+	register_shrinker(&xfs_qm_shaker);
 
 	/*
 	 * The t_dqinfo portion of transactions.
@@ -182,7 +186,7 @@ xfs_qm_destroy(
 
 	ASSERT(xqm != NULL);
 	ASSERT(xqm->qm_nrefs == 0);
-	remove_shrinker(xfs_qm_shaker);
+	unregister_shrinker(&xfs_qm_shaker);
 	hsize = xqm->qm_dqhashmask + 1;
 	for (i = 0; i < hsize; i++) {
 		xfs_qm_list_destroy(&(xqm->qm_usr_dqhtable[i]));
diff -puN include/linux/mm.h~mm-clean-up-and-kernelify-shrinker-registration include/linux/mm.h
--- a/include/linux/mm.h~mm-clean-up-and-kernelify-shrinker-registration
+++ a/include/linux/mm.h
@@ -810,27 +810,31 @@ extern unsigned long do_mremap(unsigned 
 			       unsigned long flags, unsigned long new_addr);
 
 /*
- * Prototype to add a shrinker callback for ageable caches.
- * 
- * These functions are passed a count `nr_to_scan' and a gfpmask.  They should
- * scan `nr_to_scan' objects, attempting to free them.
+ * A callback you can register to apply pressure to ageable caches.
  *
- * The callback must return the number of objects which remain in the cache.
+ * 'shrink' is passed a count 'nr_to_scan' and a 'gfpmask'.  It should
+ * look through the least-recently-used 'nr_to_scan' entries and
+ * attempt to free them up.  It should return the number of objects
+ * which remain in the cache.  If it returns -1, it means it cannot do
+ * any scanning at this time (eg. there is a risk of deadlock).
  *
- * The callback will be passed nr_to_scan == 0 when the VM is querying the
- * cache size, so a fastpath for that case is appropriate.
- */
-typedef int (*shrinker_t)(int nr_to_scan, gfp_t gfp_mask);
-
-/*
- * Add an aging callback.  The int is the number of 'seeks' it takes
- * to recreate one of the objects that these functions age.
+ * The 'gfpmask' refers to the allocation we are currently trying to
+ * fulfil.
+ *
+ * Note that 'shrink' will be passed nr_to_scan == 0 when the VM is
+ * querying the cache size, so a fastpath for that case is appropriate.
  */
-
-#define DEFAULT_SEEKS 2
-struct shrinker;
-extern struct shrinker *set_shrinker(int, shrinker_t);
-extern void remove_shrinker(struct shrinker *shrinker);
+struct shrinker {
+	int (*shrink)(int nr_to_scan, gfp_t gfp_mask);
+	int seeks;	/* seeks to recreate an obj */
+
+	/* These are for internal use */
+	struct list_head list;
+	long nr;	/* objs pending delete */
+};
+#define DEFAULT_SEEKS 2 /* A good number if you don't know better. */
+extern void register_shrinker(struct shrinker *);
+extern void unregister_shrinker(struct shrinker *);
 
 /*
  * Some shared mappigns will want the pages marked read-only
diff -puN mm/vmscan.c~mm-clean-up-and-kernelify-shrinker-registration mm/vmscan.c
--- a/mm/vmscan.c~mm-clean-up-and-kernelify-shrinker-registration
+++ a/mm/vmscan.c
@@ -70,17 +70,6 @@ struct scan_control {
 	int order;
 };
 
-/*
- * The list of shrinker callbacks used by to apply pressure to
- * ageable caches.
- */
-struct shrinker {
-	shrinker_t		shrinker;
-	struct list_head	list;
-	int			seeks;	/* seeks to recreate an obj */
-	long			nr;	/* objs pending delete */
-};
-
 #define lru_to_page(_head) (list_entry((_head)->prev, struct page, lru))
 
 #ifdef ARCH_HAS_PREFETCH
@@ -123,34 +112,25 @@ static DECLARE_RWSEM(shrinker_rwsem);
 /*
  * Add a shrinker callback to be called from the vm
  */
-struct shrinker *set_shrinker(int seeks, shrinker_t theshrinker)
+void register_shrinker(struct shrinker *shrinker)
 {
-        struct shrinker *shrinker;
-
-        shrinker = kmalloc(sizeof(*shrinker), GFP_KERNEL);
-        if (shrinker) {
-	        shrinker->shrinker = theshrinker;
-	        shrinker->seeks = seeks;
-	        shrinker->nr = 0;
-	        down_write(&shrinker_rwsem);
-	        list_add_tail(&shrinker->list, &shrinker_list);
-	        up_write(&shrinker_rwsem);
-	}
-	return shrinker;
+	shrinker->nr = 0;
+	down_write(&shrinker_rwsem);
+	list_add_tail(&shrinker->list, &shrinker_list);
+	up_write(&shrinker_rwsem);
 }
-EXPORT_SYMBOL(set_shrinker);
+EXPORT_SYMBOL(register_shrinker);
 
 /*
  * Remove one
  */
-void remove_shrinker(struct shrinker *shrinker)
+void unregister_shrinker(struct shrinker *shrinker)
 {
 	down_write(&shrinker_rwsem);
 	list_del(&shrinker->list);
 	up_write(&shrinker_rwsem);
-	kfree(shrinker);
 }
-EXPORT_SYMBOL(remove_shrinker);
+EXPORT_SYMBOL(unregister_shrinker);
 
 #define SHRINK_BATCH 128
 /*
@@ -187,7 +167,7 @@ unsigned long shrink_slab(unsigned long 
 	list_for_each_entry(shrinker, &shrinker_list, list) {
 		unsigned long long delta;
 		unsigned long total_scan;
-		unsigned long max_pass = (*shrinker->shrinker)(0, gfp_mask);
+		unsigned long max_pass = (*shrinker->shrink)(0, gfp_mask);
 
 		delta = (4 * scanned) / shrinker->seeks;
 		delta *= max_pass;
@@ -215,8 +195,8 @@ unsigned long shrink_slab(unsigned long 
 			int shrink_ret;
 			int nr_before;
 
-			nr_before = (*shrinker->shrinker)(0, gfp_mask);
-			shrink_ret = (*shrinker->shrinker)(this_scan, gfp_mask);
+			nr_before = (*shrinker->shrink)(0, gfp_mask);
+			shrink_ret = (*shrinker->shrink)(this_scan, gfp_mask);
 			if (shrink_ret == -1)
 				break;
 			if (shrink_ret < nr_before)
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

vmi-paravirt-ops-bugfix-for-2621.patch
git-kbuild.patch
git-net.patch
allow-per-cpu-variables-to-be-page-aligned.patch
xfs-clean-up-shrinker-games.patch
mm-clean-up-and-kernelify-shrinker-registration.patch
array_size-check-for-type.patch
array_size-check-for-type-uml-fix.patch
module-use-krealloc.patch
extend-print_symbol-capability.patch
extend-print_symbol-capability-fix.patch
futex-restartable-futex_wait.patch
futex-restartable-futex_wait-fix.patch
add-ability-to-keep-track-of-callers-of-symbol_getput.patch
add-ability-to-keep-track-of-callers-of-symbol_getput-update.patch
update-mtd-use-of-symbol_getput.patch
update-dvb-use-of-symbol_getput.patch
simplify-module_get_kallsym-by-dropping-length-arg.patch
fix-race-between-rmmod-and-cat-proc-kallsyms.patch
simplify-kallsyms_lookup.patch
fix-race-between-cat-proc-wchan-and-rmmod-et-al.patch
fix-race-between-cat-proc-slab_allocators-and-rmmod.patch
____call_usermodehelper-dont-flush_signals.patch
