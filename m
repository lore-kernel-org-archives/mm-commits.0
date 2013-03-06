From: akpm@linux-foundation.org
Subject: + cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch added to -mm tree
Date: Wed, 06 Mar 2013 13:10:07 -0800
Message-ID: <20130306211007.E88D95A403C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f201.google.com ([209.85.216.201]:45494 "EHLO
	mail-qc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab3CFVKJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Mar 2013 16:10:09 -0500
Received: by mail-qc0-f201.google.com with SMTP id o22so342813qcr.4
        for <mm-commits@vger.kernel.org>; Wed, 06 Mar 2013 13:10:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: konrad.wilk@oracle.com, andor.daam@googlemail.com, dan.magenheimer@oracle.com, fschmaus@gmail.com, ilendir@googlemail.com, liwanp@linux.vnet.ibm.com, lliubbo@gmail.com, minchan@kernel.org


The patch titled
     Subject: cleancache: Make cleancache_init use a pointer for the ops
has been added to the -mm tree.  Its filename is
     cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: cleancache: Make cleancache_init use a pointer for the ops

Instead of using a backend_registered to determine whether a backend is
enabled.  This allows us to remove the backend_register check and just do
'if (cleancache_ops)'

[v1: Rebase on top of b97c4b430b0a (ramster->zcache move]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Bob Liu <lliubbo@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/zcache/zcache-main.c |    8 +--
 drivers/xen/tmem.c                   |    6 +-
 include/linux/cleancache.h           |    2 
 mm/cleancache.c                      |   62 ++++++++++++-------------
 4 files changed, 40 insertions(+), 38 deletions(-)

diff -puN drivers/staging/zcache/zcache-main.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops drivers/staging/zcache/zcache-main.c
--- a/drivers/staging/zcache/zcache-main.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops
+++ a/drivers/staging/zcache/zcache-main.c
@@ -1482,9 +1482,9 @@ static struct cleancache_ops zcache_clea
 	.init_fs = zcache_cleancache_init_fs
 };
 
-struct cleancache_ops zcache_cleancache_register_ops(void)
+struct cleancache_ops *zcache_cleancache_register_ops(void)
 {
-	struct cleancache_ops old_ops =
+	struct cleancache_ops *old_ops =
 		cleancache_register_ops(&zcache_cleancache_ops);
 
 	return old_ops;
@@ -1768,7 +1768,7 @@ static int __init zcache_init(void)
 	}
 	zbud_init();
 	if (zcache_enabled && !disable_cleancache) {
-		struct cleancache_ops old_ops;
+		struct cleancache_ops *old_ops;
 
 		register_shrinker(&zcache_shrinker);
 		old_ops = zcache_cleancache_register_ops();
@@ -1778,7 +1778,7 @@ static int __init zcache_init(void)
 		pr_info("%s: cleancache: ignorenonactive = %d\n",
 			namestr, !disable_cleancache_ignore_nonactive);
 #endif
-		if (old_ops.init_fs != NULL)
+		if (old_ops != NULL)
 			pr_warn("%s: cleancache_ops overridden\n", namestr);
 	}
 	if (zcache_enabled && !disable_frontswap) {
diff -puN drivers/xen/tmem.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops
+++ a/drivers/xen/tmem.c
@@ -236,7 +236,7 @@ static int __init no_cleancache(char *s)
 }
 __setup("nocleancache", no_cleancache);
 
-static struct cleancache_ops __initdata tmem_cleancache_ops = {
+static struct cleancache_ops tmem_cleancache_ops = {
 	.put_page = tmem_cleancache_put_page,
 	.get_page = tmem_cleancache_get_page,
 	.invalidate_page = tmem_cleancache_flush_page,
@@ -392,9 +392,9 @@ static int __init xen_tmem_init(void)
 	BUG_ON(sizeof(struct cleancache_filekey) != sizeof(struct tmem_oid));
 	if (tmem_enabled && use_cleancache) {
 		char *s = "";
-		struct cleancache_ops old_ops =
+		struct cleancache_ops *old_ops =
 			cleancache_register_ops(&tmem_cleancache_ops);
-		if (old_ops.init_fs != NULL)
+		if (old_ops)
 			s = " (WARNING: cleancache_ops overridden)";
 		printk(KERN_INFO "cleancache enabled, RAM provided by "
 				 "Xen Transcendent Memory%s\n", s);
diff -puN include/linux/cleancache.h~cleancache-make-cleancache_init-use-a-pointer-for-the-ops include/linux/cleancache.h
--- a/include/linux/cleancache.h~cleancache-make-cleancache_init-use-a-pointer-for-the-ops
+++ a/include/linux/cleancache.h
@@ -33,7 +33,7 @@ struct cleancache_ops {
 	void (*invalidate_fs)(int);
 };
 
-extern struct cleancache_ops
+extern struct cleancache_ops *
 	cleancache_register_ops(struct cleancache_ops *ops);
 extern void __cleancache_init_fs(struct super_block *);
 extern void __cleancache_init_shared_fs(char *, struct super_block *);
diff -puN mm/cleancache.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops mm/cleancache.c
--- a/mm/cleancache.c~cleancache-make-cleancache_init-use-a-pointer-for-the-ops
+++ a/mm/cleancache.c
@@ -32,7 +32,7 @@ EXPORT_SYMBOL(cleancache_enabled);
  * cleancache_ops is set by cleancache_ops_register to contain the pointers
  * to the cleancache "backend" implementation functions.
  */
-static struct cleancache_ops cleancache_ops __read_mostly;
+static struct cleancache_ops *cleancache_ops __read_mostly;
 
 /*
  * Counters available via /sys/kernel/debug/frontswap (if debugfs is
@@ -72,15 +72,14 @@ static DEFINE_MUTEX(poolid_mutex);
 /*
  * When set to false (default) all calls to the cleancache functions, except
  * the __cleancache_invalidate_fs and __cleancache_init_[shared|]fs are guarded
- * by the if (!backend_registered) return. This means multiple threads (from
- * different filesystems) will be checking backend_registered. The usage of a
+ * by the if (!cleancache_ops) return. This means multiple threads (from
+ * different filesystems) will be checking cleancache_ops. The usage of a
  * bool instead of a atomic_t or a bool guarded by a spinlock is OK - we are
  * OK if the time between the backend's have been initialized (and
- * backend_registered has been set to true) and when the filesystems start
+ * cleancache_ops has been set to not NULL) and when the filesystems start
  * actually calling the backends. The inverse (when unloading) is obviously
  * not good - but this shim does not do that (yet).
  */
-static bool backend_registered __read_mostly;
 
 /*
  * The backends and filesystems work all asynchronously. This is b/c the
@@ -90,13 +89,13 @@ static bool backend_registered __read_mo
  *		[shared_|]fs_poolid_map and uuids for.
  *
  *	b). user does I/Os -> we call the rest of __cleancache_* functions
- *		which return immediately as backend_registered is false.
+ *		which return immediately as cleancache_ops is false.
  *
  *	c). modprobe zcache -> cleancache_register_ops. We init the backend
- *		and set backend_registered to true, and for any fs_poolid_map
+ *		and set cleancache_ops to true, and for any fs_poolid_map
  *		(which is set by __cleancache_init_fs) we initialize the poolid.
  *
- *	d). user does I/Os -> now that backend_registered is true all the
+ *	d). user does I/Os -> now that cleancache_ops is true all the
  *		__cleancache_* functions can call the backend. They all check
  *		that fs_poolid_map is valid and if so invoke the backend.
  *
@@ -120,23 +119,26 @@ static bool backend_registered __read_mo
  * Register operations for cleancache, returning previous thus allowing
  * detection of multiple backends and possible nesting.
  */
-struct cleancache_ops cleancache_register_ops(struct cleancache_ops *ops)
+struct cleancache_ops *cleancache_register_ops(struct cleancache_ops *ops)
 {
-	struct cleancache_ops old = cleancache_ops;
+	struct cleancache_ops *old = cleancache_ops;
 	int i;
 
 	mutex_lock(&poolid_mutex);
-	cleancache_ops = *ops;
-
-	backend_registered = true;
 	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
 		if (fs_poolid_map[i] == FS_NO_BACKEND)
-			fs_poolid_map[i] = (*cleancache_ops.init_fs)(PAGE_SIZE);
+			fs_poolid_map[i] = ops->init_fs(PAGE_SIZE);
 		if (shared_fs_poolid_map[i] == FS_NO_BACKEND)
-			shared_fs_poolid_map[i] = (*cleancache_ops.init_shared_fs)
+			shared_fs_poolid_map[i] = ops->init_shared_fs
 					(uuids[i], PAGE_SIZE);
 	}
-out:
+	/*
+	 * We MUST set cleancache_ops _after_ we have called the backends
+	 * init_fs or init_shared_fs functions. Otherwise the compiler might
+	 * re-order where cleancache_ops is set in this function.
+	 */
+	barrier();
+	cleancache_ops = ops;
 	mutex_unlock(&poolid_mutex);
 	return old;
 }
@@ -151,8 +153,8 @@ void __cleancache_init_fs(struct super_b
 	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
 		if (fs_poolid_map[i] == FS_UNKNOWN) {
 			sb->cleancache_poolid = i + FAKE_FS_POOLID_OFFSET;
-			if (backend_registered)
-				fs_poolid_map[i] = (*cleancache_ops.init_fs)(PAGE_SIZE);
+			if (cleancache_ops)
+				fs_poolid_map[i] = cleancache_ops->init_fs(PAGE_SIZE);
 			else
 				fs_poolid_map[i] = FS_NO_BACKEND;
 			break;
@@ -172,8 +174,8 @@ void __cleancache_init_shared_fs(char *u
 		if (shared_fs_poolid_map[i] == FS_UNKNOWN) {
 			sb->cleancache_poolid = i + FAKE_SHARED_FS_POOLID_OFFSET;
 			uuids[i] = uuid;
-			if (backend_registered)
-				shared_fs_poolid_map[i] = (*cleancache_ops.init_shared_fs)
+			if (cleancache_ops)
+				shared_fs_poolid_map[i] = cleancache_ops->init_shared_fs
 						(uuid, PAGE_SIZE);
 			else
 				shared_fs_poolid_map[i] = FS_NO_BACKEND;
@@ -240,7 +242,7 @@ int __cleancache_get_page(struct page *p
 	int fake_pool_id;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
-	if (!backend_registered) {
+	if (!cleancache_ops) {
 		cleancache_failed_gets++;
 		goto out;
 	}
@@ -255,7 +257,7 @@ int __cleancache_get_page(struct page *p
 		goto out;
 
 	if (pool_id >= 0)
-		ret = (*cleancache_ops.get_page)(pool_id,
+		ret = cleancache_ops->get_page(pool_id,
 				key, page->index, page);
 	if (ret == 0)
 		cleancache_succ_gets++;
@@ -282,7 +284,7 @@ void __cleancache_put_page(struct page *
 	int fake_pool_id;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
-	if (!backend_registered) {
+	if (!cleancache_ops) {
 		cleancache_puts++;
 		return;
 	}
@@ -296,7 +298,7 @@ void __cleancache_put_page(struct page *
 
 	if (pool_id >= 0 &&
 		cleancache_get_key(page->mapping->host, &key) >= 0) {
-		(*cleancache_ops.put_page)(pool_id, key, page->index, page);
+		cleancache_ops->put_page(pool_id, key, page->index, page);
 		cleancache_puts++;
 	}
 }
@@ -318,7 +320,7 @@ void __cleancache_invalidate_page(struct
 	int fake_pool_id = mapping->host->i_sb->cleancache_poolid;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
-	if (!backend_registered)
+	if (!cleancache_ops)
 		return;
 
 	if (fake_pool_id >= 0) {
@@ -328,7 +330,7 @@ void __cleancache_invalidate_page(struct
 
 		VM_BUG_ON(!PageLocked(page));
 		if (cleancache_get_key(mapping->host, &key) >= 0) {
-			(*cleancache_ops.invalidate_page)(pool_id,
+			cleancache_ops->invalidate_page(pool_id,
 					key, page->index);
 			cleancache_invalidates++;
 		}
@@ -351,7 +353,7 @@ void __cleancache_invalidate_inode(struc
 	int fake_pool_id = mapping->host->i_sb->cleancache_poolid;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
-	if (!backend_registered)
+	if (!cleancache_ops)
 		return;
 
 	if (fake_pool_id < 0)
@@ -360,7 +362,7 @@ void __cleancache_invalidate_inode(struc
 	pool_id = get_poolid_from_fake(fake_pool_id);
 
 	if (pool_id >= 0 && cleancache_get_key(mapping->host, &key) >= 0)
-		(*cleancache_ops.invalidate_inode)(pool_id, key);
+		cleancache_ops->invalidate_inode(pool_id, key);
 }
 EXPORT_SYMBOL(__cleancache_invalidate_inode);
 
@@ -387,8 +389,8 @@ void __cleancache_invalidate_fs(struct s
 		fs_poolid_map[index] = FS_UNKNOWN;
 	}
 	sb->cleancache_poolid = -1;
-	if (backend_registered)
-		(*cleancache_ops.invalidate_fs)(old_poolid);
+	if (cleancache_ops)
+		cleancache_ops->invalidate_fs(old_poolid);
 	mutex_unlock(&poolid_mutex);
 }
 EXPORT_SYMBOL(__cleancache_invalidate_fs);
_

Patches currently in -mm which might be from konrad.wilk@oracle.com are

origin.patch
linux-next.patch
mm-frontswap-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
frontswap-make-frontswap_init-use-a-pointer-for-the-ops.patch
mm-frontswap-cleanup-code.patch
mm-cleancache-lazy-initialization-to-allow-tmem-backends-to-build-run-as-modules.patch
cleancache-make-cleancache_init-use-a-pointer-for-the-ops.patch
mm-cleancache-clean-up-cleancache_enabled.patch
xen-tmem-enable-xen-tmem-shim-to-be-built-loaded-as-a-module.patch
zcache-tmem-better-error-checking-on-frontswap_register_ops-return-value.patch
staging-zcache-enable-ramster-to-be-built-loaded-as-a-module.patch
staging-zcache-enable-zcache-to-be-built-loaded-as-a-module.patch
mm-add-vm-event-counters-for-balloon-pages-compaction.patch

