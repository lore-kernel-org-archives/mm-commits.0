From: akpm@linux-foundation.org
Subject: +
 cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch added to -mm tree
Date: Wed, 25 Feb 2015 14:41:22 -0800
Message-ID: <54ee4f92.9ELHVJow6vw07JB+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38805 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbbBYWlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:41:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cleancache: remove limit on the number of cleancache enabled filesystems
has been added to the -mm tree.  Its filename is
     cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: cleancache: remove limit on the number of cleancache enabled filesystems

The limit equals 32 and is imposed by the number of entries in the
fs_poolid_map and shared_fs_poolid_map.  Nowadays it is insufficient,
because with containers on board a Linux host can have hundreds of active
fs mounts.

These maps were introduced by commit 49a9ab815acb8 ("mm: cleancache: lazy
initialization to allow tmem backends to build/run as modules") in order
to allow compiling cleancache drivers as modules.  Real pool ids are
stored in these maps while super_block->cleancache_poolid points to an
entry in the map, so that on cleancache registration we can walk over all
(if there are <= 32 of them, of course) cleancache-enabled super blocks
and assign real pool ids.

Actually, there is absolutely no need in these maps, because we can
iterate over all super blocks immediately using iterate_supers.  This is
not racy, because cleancache_init_ops is called from mount_fs with
super_block->s_umount held for writing, while iterate_supers takes this
semaphore for reading, so if we call iterate_supers after setting
cleancache_ops, all super blocks that had been created before
cleancache_register_ops was called will be assigned pool ids by the action
function of iterate_supers while all newer super blocks will receive it in
cleancache_init_fs.

This patch therefore removes the maps and hence the artificial limit on
the number of cleancache enabled filesystems.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c                 |    2 
 include/linux/cleancache.h |    4 
 mm/cleancache.c            |  225 ++++++-----------------------------
 3 files changed, 46 insertions(+), 185 deletions(-)

diff -puN fs/super.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems fs/super.c
--- a/fs/super.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems
+++ a/fs/super.c
@@ -224,7 +224,7 @@ static struct super_block *alloc_super(s
 	s->s_maxbytes = MAX_NON_LFS;
 	s->s_op = &default_op;
 	s->s_time_gran = 1000000000;
-	s->cleancache_poolid = -1;
+	s->cleancache_poolid = CLEANCACHE_NO_POOL;
 
 	s->s_shrink.seeks = DEFAULT_SEEKS;
 	s->s_shrink.scan_objects = super_cache_scan;
diff -puN include/linux/cleancache.h~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems include/linux/cleancache.h
--- a/include/linux/cleancache.h~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems
+++ a/include/linux/cleancache.h
@@ -5,6 +5,10 @@
 #include <linux/exportfs.h>
 #include <linux/mm.h>
 
+#define CLEANCACHE_NO_POOL		-1
+#define CLEANCACHE_NO_BACKEND		-2
+#define CLEANCACHE_NO_BACKEND_SHARED	-3
+
 #define CLEANCACHE_KEY_MAX 6
 
 /*
diff -puN mm/cleancache.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems mm/cleancache.c
--- a/mm/cleancache.c~cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems
+++ a/mm/cleancache.c
@@ -19,7 +19,7 @@
 #include <linux/cleancache.h>
 
 /*
- * cleancache_ops is set by cleancache_ops_register to contain the pointers
+ * cleancache_ops is set by cleancache_register_ops to contain the pointers
  * to the cleancache "backend" implementation functions.
  */
 static struct cleancache_ops *cleancache_ops __read_mostly;
@@ -34,104 +34,27 @@ static u64 cleancache_failed_gets;
 static u64 cleancache_puts;
 static u64 cleancache_invalidates;
 
-/*
- * When no backend is registered all calls to init_fs and init_shared_fs
- * are registered and fake poolids (FAKE_FS_POOLID_OFFSET or
- * FAKE_SHARED_FS_POOLID_OFFSET, plus offset in the respective array
- * [shared_|]fs_poolid_map) are given to the respective super block
- * (sb->cleancache_poolid) and no tmem_pools are created. When a backend
- * registers with cleancache the previous calls to init_fs and init_shared_fs
- * are executed to create tmem_pools and set the respective poolids. While no
- * backend is registered all "puts", "gets" and "flushes" are ignored or failed.
- */
-#define MAX_INITIALIZABLE_FS 32
-#define FAKE_FS_POOLID_OFFSET 1000
-#define FAKE_SHARED_FS_POOLID_OFFSET 2000
-
-#define FS_NO_BACKEND (-1)
-#define FS_UNKNOWN (-2)
-static int fs_poolid_map[MAX_INITIALIZABLE_FS];
-static int shared_fs_poolid_map[MAX_INITIALIZABLE_FS];
-static char *uuids[MAX_INITIALIZABLE_FS];
-/*
- * Mutex for the [shared_|]fs_poolid_map to guard against multiple threads
- * invoking umount (and ending in __cleancache_invalidate_fs) and also multiple
- * threads calling mount (and ending up in __cleancache_init_[shared|]fs).
- */
-static DEFINE_MUTEX(poolid_mutex);
-/*
- * When set to false (default) all calls to the cleancache functions, except
- * the __cleancache_invalidate_fs and __cleancache_init_[shared|]fs are guarded
- * by the if (!cleancache_ops) return. This means multiple threads (from
- * different filesystems) will be checking cleancache_ops. The usage of a
- * bool instead of a atomic_t or a bool guarded by a spinlock is OK - we are
- * OK if the time between the backend's have been initialized (and
- * cleancache_ops has been set to not NULL) and when the filesystems start
- * actually calling the backends. The inverse (when unloading) is obviously
- * not good - but this shim does not do that (yet).
- */
-
-/*
- * The backends and filesystems work all asynchronously. This is b/c the
- * backends can be built as modules.
- * The usual sequence of events is:
- *	a) mount /	-> __cleancache_init_fs is called. We set the
- *		[shared_|]fs_poolid_map and uuids for.
- *
- *	b). user does I/Os -> we call the rest of __cleancache_* functions
- *		which return immediately as cleancache_ops is false.
- *
- *	c). modprobe zcache -> cleancache_register_ops. We init the backend
- *		and set cleancache_ops to true, and for any fs_poolid_map
- *		(which is set by __cleancache_init_fs) we initialize the poolid.
- *
- *	d). user does I/Os -> now that cleancache_ops is true all the
- *		__cleancache_* functions can call the backend. They all check
- *		that fs_poolid_map is valid and if so invoke the backend.
- *
- *	e). umount /	-> __cleancache_invalidate_fs, the fs_poolid_map is
- *		reset (which is the second check in the __cleancache_* ops
- *		to call the backend).
- *
- * The sequence of event could also be c), followed by a), and d). and e). The
- * c) would not happen anymore. There is also the chance of c), and one thread
- * doing a) + d), and another doing e). For that case we depend on the
- * filesystem calling __cleancache_invalidate_fs in the proper sequence (so
- * that it handles all I/Os before it invalidates the fs (which is last part
- * of unmounting process).
- *
- * Note: The acute reader will notice that there is no "rmmod zcache" case.
- * This is b/c the functionality for that is not yet implemented and when
- * done, will require some extra locking not yet devised.
- */
+static void cleancache_register_ops_sb(struct super_block *sb, void *unused)
+{
+	switch (sb->cleancache_poolid) {
+	case CLEANCACHE_NO_BACKEND:
+		__cleancache_init_fs(sb);
+		break;
+	case CLEANCACHE_NO_BACKEND_SHARED:
+		__cleancache_init_shared_fs(sb);
+		break;
+	}
+}
 
 /*
  * Register operations for cleancache. Returns 0 on success.
  */
 int cleancache_register_ops(struct cleancache_ops *ops)
 {
-	int i;
-
-	mutex_lock(&poolid_mutex);
-	if (cleancache_ops) {
-		mutex_unlock(&poolid_mutex);
+	if (cmpxchg(&cleancache_ops, NULL, ops))
 		return -EBUSY;
-	}
-	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
-		if (fs_poolid_map[i] == FS_NO_BACKEND)
-			fs_poolid_map[i] = ops->init_fs(PAGE_SIZE);
-		if (shared_fs_poolid_map[i] == FS_NO_BACKEND)
-			shared_fs_poolid_map[i] = ops->init_shared_fs
-					(uuids[i], PAGE_SIZE);
-	}
-	/*
-	 * We MUST set cleancache_ops _after_ we have called the backends
-	 * init_fs or init_shared_fs functions. Otherwise the compiler might
-	 * re-order where cleancache_ops is set in this function.
-	 */
-	barrier();
-	cleancache_ops = ops;
-	mutex_unlock(&poolid_mutex);
+
+	iterate_supers(cleancache_register_ops_sb, NULL);
 	return 0;
 }
 EXPORT_SYMBOL(cleancache_register_ops);
@@ -139,42 +62,28 @@ EXPORT_SYMBOL(cleancache_register_ops);
 /* Called by a cleancache-enabled filesystem at time of mount */
 void __cleancache_init_fs(struct super_block *sb)
 {
-	int i;
+	int pool_id = CLEANCACHE_NO_BACKEND;
 
-	mutex_lock(&poolid_mutex);
-	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
-		if (fs_poolid_map[i] == FS_UNKNOWN) {
-			sb->cleancache_poolid = i + FAKE_FS_POOLID_OFFSET;
-			if (cleancache_ops)
-				fs_poolid_map[i] = cleancache_ops->init_fs(PAGE_SIZE);
-			else
-				fs_poolid_map[i] = FS_NO_BACKEND;
-			break;
-		}
+	if (cleancache_ops) {
+		pool_id = cleancache_ops->init_fs(PAGE_SIZE);
+		if (pool_id < 0)
+			pool_id = CLEANCACHE_NO_POOL;
 	}
-	mutex_unlock(&poolid_mutex);
+	sb->cleancache_poolid = pool_id;
 }
 EXPORT_SYMBOL(__cleancache_init_fs);
 
 /* Called by a cleancache-enabled clustered filesystem at time of mount */
 void __cleancache_init_shared_fs(struct super_block *sb)
 {
-	int i;
+	int pool_id = CLEANCACHE_NO_BACKEND_SHARED;
 
-	mutex_lock(&poolid_mutex);
-	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
-		if (shared_fs_poolid_map[i] == FS_UNKNOWN) {
-			sb->cleancache_poolid = i + FAKE_SHARED_FS_POOLID_OFFSET;
-			uuids[i] = sb->s_uuid;
-			if (cleancache_ops)
-				shared_fs_poolid_map[i] = cleancache_ops->init_shared_fs
-						(sb->s_uuid, PAGE_SIZE);
-			else
-				shared_fs_poolid_map[i] = FS_NO_BACKEND;
-			break;
-		}
+	if (cleancache_ops) {
+		pool_id = cleancache_ops->init_shared_fs(sb->s_uuid, PAGE_SIZE);
+		if (pool_id < 0)
+			pool_id = CLEANCACHE_NO_POOL;
 	}
-	mutex_unlock(&poolid_mutex);
+	sb->cleancache_poolid = pool_id;
 }
 EXPORT_SYMBOL(__cleancache_init_shared_fs);
 
@@ -204,19 +113,6 @@ static int cleancache_get_key(struct ino
 }
 
 /*
- * Returns a pool_id that is associated with a given fake poolid.
- */
-static int get_poolid_from_fake(int fake_pool_id)
-{
-	if (fake_pool_id >= FAKE_SHARED_FS_POOLID_OFFSET)
-		return shared_fs_poolid_map[fake_pool_id -
-			FAKE_SHARED_FS_POOLID_OFFSET];
-	else if (fake_pool_id >= FAKE_FS_POOLID_OFFSET)
-		return fs_poolid_map[fake_pool_id - FAKE_FS_POOLID_OFFSET];
-	return FS_NO_BACKEND;
-}
-
-/*
  * "Get" data from cleancache associated with the poolid/inode/index
  * that were specified when the data was put to cleanache and, if
  * successful, use it to fill the specified page with data and return 0.
@@ -231,7 +127,6 @@ int __cleancache_get_page(struct page *p
 {
 	int ret = -1;
 	int pool_id;
-	int fake_pool_id;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
 	if (!cleancache_ops) {
@@ -240,17 +135,14 @@ int __cleancache_get_page(struct page *p
 	}
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	fake_pool_id = page->mapping->host->i_sb->cleancache_poolid;
-	if (fake_pool_id < 0)
+	pool_id = page->mapping->host->i_sb->cleancache_poolid;
+	if (pool_id < 0)
 		goto out;
-	pool_id = get_poolid_from_fake(fake_pool_id);
 
 	if (cleancache_get_key(page->mapping->host, &key) < 0)
 		goto out;
 
-	if (pool_id >= 0)
-		ret = cleancache_ops->get_page(pool_id,
-				key, page->index, page);
+	ret = cleancache_ops->get_page(pool_id, key, page->index, page);
 	if (ret == 0)
 		cleancache_succ_gets++;
 	else
@@ -273,7 +165,6 @@ EXPORT_SYMBOL(__cleancache_get_page);
 void __cleancache_put_page(struct page *page)
 {
 	int pool_id;
-	int fake_pool_id;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
 	if (!cleancache_ops) {
@@ -282,12 +173,7 @@ void __cleancache_put_page(struct page *
 	}
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
-	fake_pool_id = page->mapping->host->i_sb->cleancache_poolid;
-	if (fake_pool_id < 0)
-		return;
-
-	pool_id = get_poolid_from_fake(fake_pool_id);
-
+	pool_id = page->mapping->host->i_sb->cleancache_poolid;
 	if (pool_id >= 0 &&
 		cleancache_get_key(page->mapping->host, &key) >= 0) {
 		cleancache_ops->put_page(pool_id, key, page->index, page);
@@ -308,18 +194,13 @@ void __cleancache_invalidate_page(struct
 					struct page *page)
 {
 	/* careful... page->mapping is NULL sometimes when this is called */
-	int pool_id;
-	int fake_pool_id = mapping->host->i_sb->cleancache_poolid;
+	int pool_id = mapping->host->i_sb->cleancache_poolid;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
 	if (!cleancache_ops)
 		return;
 
-	if (fake_pool_id >= 0) {
-		pool_id = get_poolid_from_fake(fake_pool_id);
-		if (pool_id < 0)
-			return;
-
+	if (pool_id >= 0) {
 		VM_BUG_ON_PAGE(!PageLocked(page), page);
 		if (cleancache_get_key(mapping->host, &key) >= 0) {
 			cleancache_ops->invalidate_page(pool_id,
@@ -341,18 +222,12 @@ EXPORT_SYMBOL(__cleancache_invalidate_pa
  */
 void __cleancache_invalidate_inode(struct address_space *mapping)
 {
-	int pool_id;
-	int fake_pool_id = mapping->host->i_sb->cleancache_poolid;
+	int pool_id = mapping->host->i_sb->cleancache_poolid;
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
 	if (!cleancache_ops)
 		return;
 
-	if (fake_pool_id < 0)
-		return;
-
-	pool_id = get_poolid_from_fake(fake_pool_id);
-
 	if (pool_id >= 0 && cleancache_get_key(mapping->host, &key) >= 0)
 		cleancache_ops->invalidate_inode(pool_id, key);
 }
@@ -365,32 +240,18 @@ EXPORT_SYMBOL(__cleancache_invalidate_in
  */
 void __cleancache_invalidate_fs(struct super_block *sb)
 {
-	int index;
-	int fake_pool_id = sb->cleancache_poolid;
-	int old_poolid = fake_pool_id;
-
-	mutex_lock(&poolid_mutex);
-	if (fake_pool_id >= FAKE_SHARED_FS_POOLID_OFFSET) {
-		index = fake_pool_id - FAKE_SHARED_FS_POOLID_OFFSET;
-		old_poolid = shared_fs_poolid_map[index];
-		shared_fs_poolid_map[index] = FS_UNKNOWN;
-		uuids[index] = NULL;
-	} else if (fake_pool_id >= FAKE_FS_POOLID_OFFSET) {
-		index = fake_pool_id - FAKE_FS_POOLID_OFFSET;
-		old_poolid = fs_poolid_map[index];
-		fs_poolid_map[index] = FS_UNKNOWN;
-	}
-	sb->cleancache_poolid = -1;
-	if (cleancache_ops)
-		cleancache_ops->invalidate_fs(old_poolid);
-	mutex_unlock(&poolid_mutex);
+	int pool_id;
+
+	pool_id = sb->cleancache_poolid;
+	sb->cleancache_poolid = CLEANCACHE_NO_POOL;
+
+	if (cleancache_ops && pool_id >= 0)
+		cleancache_ops->invalidate_fs(pool_id);
 }
 EXPORT_SYMBOL(__cleancache_invalidate_fs);
 
 static int __init init_cleancache(void)
 {
-	int i;
-
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *root = debugfs_create_dir("cleancache", NULL);
 	if (root == NULL)
@@ -402,10 +263,6 @@ static int __init init_cleancache(void)
 	debugfs_create_u64("invalidates", S_IRUGO,
 				root, &cleancache_invalidates);
 #endif
-	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
-		fs_poolid_map[i] = FS_UNKNOWN;
-		shared_fs_poolid_map[i] = FS_UNKNOWN;
-	}
 	return 0;
 }
 module_init(init_cleancache)
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

