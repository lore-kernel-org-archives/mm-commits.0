Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B63542A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181371; cv=none; b=jqYipp9QxmhDF+URlaskbFvZ8gqDHVpIpvcCgUdZVNnYYzNeHnNL65YkCPH2+3jO59LmONbQYTQUp4977+ul11m073+dWYK3RjMr45ZaBjM8pTGEWPykV9afoXlvLiHi4fYWVG3jleRx+ONrtR3nK7EfJMw2QfpQIYZIOUgY/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181371; c=relaxed/simple;
	bh=pHNT5K1slbRRiF3i7XPefH/hf+Y7tbk3Hfd/BqF2JCc=;
	h=Date:To:From:Subject:Message-Id; b=n+KJ2A9JBsYZFcEXiqCuCqgXRz+G1jn2Qhup88tIzffwGYelvdmkoCWi4X2sUkN1iMcUZow9oWsWi/oTJ4qLVgEnx94neKZloY0nWED6jCmHjKVsmA1kh+vh7qi6qssR3QBAykASnH+0Z/wGpYiokF/qWLQ0Gq/xqKTHvVN756I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cYUUkHmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cYUUkHmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19B2C4CED6;
	Fri, 21 Feb 2025 23:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181370;
	bh=pHNT5K1slbRRiF3i7XPefH/hf+Y7tbk3Hfd/BqF2JCc=;
	h=Date:To:From:Subject:From;
	b=cYUUkHmMBD6i7V+9IFr3EGe4eAk/VvlLHHhYAxY5F0demzQ7ih1ySTHAMgA7fB9cF
	 4nD/hX8sfrgM8tas55n4wJakstG3NlEkagzz2IYZbTEHCFQGoBklLoa+4e11A0BEJq
	 bs15qgz5ke5zwQQz+m+E4LePT5sWHZqrdFQpKs5I=
Date: Fri, 21 Feb 2025 15:42:50 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-make-zspage-lock-preemptible.patch added to mm-unstable branch
Message-Id: <20250221234250.C19B2C4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: make zspage lock preemptible
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-make-zspage-lock-preemptible.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-make-zspage-lock-preemptible.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: make zspage lock preemptible
Date: Sat, 22 Feb 2025 07:25:42 +0900

In order to implement preemptible object mapping we need a zspage lock
that satisfies several preconditions:
- it should be reader-write type of a lock
- it should be possible to hold it from any context, but also being
  preemptible if the context allows it
- we never sleep while acquiring but can sleep while holding in read
  mode

An rwsemaphore doesn't suffice, due to atomicity requirements, rwlock
doesn't satisfy due to reader-preemptability requirement.  It's also worth
to mention, that per-zspage rwsem is a little too memory heavy (we can
easily have double digits megabytes used only on rwsemaphores).

Switch over from rwlock_t to a atomic_t-based implementation of a
reader-writer semaphore that satisfies all of the preconditions.

The spin-lock based zspage_lock is suggested by Hillf Danton.

Link: https://lkml.kernel.org/r/20250221222958.2225035-12-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Suggested-by: Hillf Danton <hdanton@sina.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  184 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 131 insertions(+), 53 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-make-zspage-lock-preemptible
+++ a/mm/zsmalloc.c
@@ -226,6 +226,9 @@ struct zs_pool {
 	/* protect zspage migration/compaction */
 	rwlock_t lock;
 	atomic_t compaction_in_progress;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lock_class_key lock_class;
+#endif
 };
 
 static inline void zpdesc_set_first(struct zpdesc *zpdesc)
@@ -257,6 +260,18 @@ static inline void free_zpdesc(struct zp
 	__free_page(page);
 }
 
+#define ZS_PAGE_UNLOCKED	0
+#define ZS_PAGE_WRLOCKED	-1
+
+struct zspage_lock {
+	spinlock_t lock;
+	int cnt;
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
 struct zspage {
 	struct {
 		unsigned int huge:HUGE_BITS;
@@ -269,7 +284,7 @@ struct zspage {
 	struct zpdesc *first_zpdesc;
 	struct list_head list; /* fullness list */
 	struct zs_pool *pool;
-	rwlock_t lock;
+	struct zspage_lock zsl;
 };
 
 struct mapping_area {
@@ -279,6 +294,93 @@ struct mapping_area {
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define zsl_dep_map(zsl) (&(zsl)->dep_map)
+#define zspool_lock_class(pool) (&(pool)->lock_class)
+#else
+#define zsl_dep_map(zsl) NULL
+#define zspool_lock_class(pool) NULL
+#endif
+
+static void zspage_lock_init(struct zspage *zspage)
+{
+	struct zspage_lock *zsl = &zspage->zsl;
+
+	lockdep_init_map(zsl_dep_map(zsl), "zspage->lock",
+			 zspool_lock_class(zspage->pool), 0);
+	spin_lock_init(&zsl->lock);
+	zsl->cnt = ZS_PAGE_UNLOCKED;
+}
+
+/*
+ * The zspage lock can be held from atomic contexts, but it needs to remain
+ * preemptible when held for reading because it remains held outside of those
+ * atomic contexts, otherwise we unnecessarily lose preemptibility.
+ *
+ * To achieve this, the following rules are enforced on readers and writers:
+ *
+ * - Writers are blocked by both writers and readers, while readers are only
+ *   blocked by writers (i.e. normal rwlock semantics).
+ *
+ * - Writers are always atomic (to allow readers to spin waiting for them).
+ *
+ * - Writers always use trylock (as the lock may be held be sleeping readers).
+ *
+ * - Readers may spin on the lock (as they can only wait for atomic writers).
+ *
+ * - Readers may sleep while holding the lock (as writes only use trylock).
+ */
+static void zspage_read_lock(struct zspage *zspage)
+{
+	struct zspage_lock *zsl = &zspage->zsl;
+
+	rwsem_acquire_read(zsl_dep_map(zsl), 0, 0, _RET_IP_);
+
+	spin_lock(&zsl->lock);
+	zsl->cnt++;
+	spin_unlock(&zsl->lock);
+
+	lock_acquired(zsl_dep_map(zsl), _RET_IP_);
+}
+
+static void zspage_read_unlock(struct zspage *zspage)
+{
+	struct zspage_lock *zsl = &zspage->zsl;
+
+	rwsem_release(zsl_dep_map(zsl), _RET_IP_);
+
+	spin_lock(&zsl->lock);
+	zsl->cnt--;
+	spin_unlock(&zsl->lock);
+}
+
+static __must_check bool zspage_write_trylock(struct zspage *zspage)
+{
+	struct zspage_lock *zsl = &zspage->zsl;
+
+	spin_lock(&zsl->lock);
+	if (zsl->cnt == ZS_PAGE_UNLOCKED) {
+		zsl->cnt = ZS_PAGE_WRLOCKED;
+		rwsem_acquire(zsl_dep_map(zsl), 0, 1, _RET_IP_);
+		lock_acquired(zsl_dep_map(zsl), _RET_IP_);
+		return true;
+	}
+
+	lock_contended(zsl_dep_map(zsl), _RET_IP_);
+	spin_unlock(&zsl->lock);
+	return false;
+}
+
+static void zspage_write_unlock(struct zspage *zspage)
+{
+	struct zspage_lock *zsl = &zspage->zsl;
+
+	rwsem_release(zsl_dep_map(zsl), _RET_IP_);
+
+	zsl->cnt = ZS_PAGE_UNLOCKED;
+	spin_unlock(&zsl->lock);
+}
+
 /* huge object: pages_per_zspage == 1 && maxobj_per_zspage == 1 */
 static void SetZsHugePage(struct zspage *zspage)
 {
@@ -290,12 +392,6 @@ static bool ZsHugePage(struct zspage *zs
 	return zspage->huge;
 }
 
-static void migrate_lock_init(struct zspage *zspage);
-static void migrate_read_lock(struct zspage *zspage);
-static void migrate_read_unlock(struct zspage *zspage);
-static void migrate_write_lock(struct zspage *zspage);
-static void migrate_write_unlock(struct zspage *zspage);
-
 #ifdef CONFIG_COMPACTION
 static void kick_deferred_free(struct zs_pool *pool);
 static void init_deferred_free(struct zs_pool *pool);
@@ -992,7 +1088,9 @@ static struct zspage *alloc_zspage(struc
 		return NULL;
 
 	zspage->magic = ZSPAGE_MAGIC;
-	migrate_lock_init(zspage);
+	zspage->pool = pool;
+	zspage->class = class->index;
+	zspage_lock_init(zspage);
 
 	for (i = 0; i < class->pages_per_zspage; i++) {
 		struct zpdesc *zpdesc;
@@ -1015,8 +1113,6 @@ static struct zspage *alloc_zspage(struc
 
 	create_page_chain(class, zspage, zpdescs);
 	init_zspage(class, zspage);
-	zspage->pool = pool;
-	zspage->class = class->index;
 
 	return zspage;
 }
@@ -1217,7 +1313,7 @@ void *zs_map_object(struct zs_pool *pool
 	 * zs_unmap_object API so delegate the locking from class to zspage
 	 * which is smaller granularity.
 	 */
-	migrate_read_lock(zspage);
+	zspage_read_lock(zspage);
 	read_unlock(&pool->lock);
 
 	class = zspage_class(pool, zspage);
@@ -1277,7 +1373,7 @@ void zs_unmap_object(struct zs_pool *poo
 	}
 	local_unlock(&zs_map_area.lock);
 
-	migrate_read_unlock(zspage);
+	zspage_read_unlock(zspage);
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
 
@@ -1671,18 +1767,18 @@ static void lock_zspage(struct zspage *z
 	/*
 	 * Pages we haven't locked yet can be migrated off the list while we're
 	 * trying to lock them, so we need to be careful and only attempt to
-	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
+	 * lock each page under zspage_read_lock(). Otherwise, the page we lock
 	 * may no longer belong to the zspage. This means that we may wait for
 	 * the wrong page to unlock, so we must take a reference to the page
-	 * prior to waiting for it to unlock outside migrate_read_lock().
+	 * prior to waiting for it to unlock outside zspage_read_lock().
 	 */
 	while (1) {
-		migrate_read_lock(zspage);
+		zspage_read_lock(zspage);
 		zpdesc = get_first_zpdesc(zspage);
 		if (zpdesc_trylock(zpdesc))
 			break;
 		zpdesc_get(zpdesc);
-		migrate_read_unlock(zspage);
+		zspage_read_unlock(zspage);
 		zpdesc_wait_locked(zpdesc);
 		zpdesc_put(zpdesc);
 	}
@@ -1693,41 +1789,16 @@ static void lock_zspage(struct zspage *z
 			curr_zpdesc = zpdesc;
 		} else {
 			zpdesc_get(zpdesc);
-			migrate_read_unlock(zspage);
+			zspage_read_unlock(zspage);
 			zpdesc_wait_locked(zpdesc);
 			zpdesc_put(zpdesc);
-			migrate_read_lock(zspage);
+			zspage_read_lock(zspage);
 		}
 	}
-	migrate_read_unlock(zspage);
+	zspage_read_unlock(zspage);
 }
 #endif /* CONFIG_COMPACTION */
 
-static void migrate_lock_init(struct zspage *zspage)
-{
-	rwlock_init(&zspage->lock);
-}
-
-static void migrate_read_lock(struct zspage *zspage) __acquires(&zspage->lock)
-{
-	read_lock(&zspage->lock);
-}
-
-static void migrate_read_unlock(struct zspage *zspage) __releases(&zspage->lock)
-{
-	read_unlock(&zspage->lock);
-}
-
-static void migrate_write_lock(struct zspage *zspage)
-{
-	write_lock(&zspage->lock);
-}
-
-static void migrate_write_unlock(struct zspage *zspage)
-{
-	write_unlock(&zspage->lock);
-}
-
 #ifdef CONFIG_COMPACTION
 
 static const struct movable_operations zsmalloc_mops;
@@ -1785,9 +1856,6 @@ static int zs_page_migrate(struct page *
 
 	VM_BUG_ON_PAGE(!zpdesc_is_isolated(zpdesc), zpdesc_page(zpdesc));
 
-	/* We're committed, tell the world that this is a Zsmalloc page. */
-	__zpdesc_set_zsmalloc(newzpdesc);
-
 	/* The page is locked, so this pointer must remain valid */
 	zspage = get_zspage(zpdesc);
 	pool = zspage->pool;
@@ -1803,8 +1871,15 @@ static int zs_page_migrate(struct page *
 	 * the class lock protects zpage alloc/free in the zspage.
 	 */
 	spin_lock(&class->lock);
-	/* the migrate_write_lock protects zpage access via zs_map_object */
-	migrate_write_lock(zspage);
+	/* the zspage write_lock protects zpage access via zs_map_object */
+	if (!zspage_write_trylock(zspage)) {
+		spin_unlock(&class->lock);
+		write_unlock(&pool->lock);
+		return -EINVAL;
+	}
+
+	/* We're committed, tell the world that this is a Zsmalloc page. */
+	__zpdesc_set_zsmalloc(newzpdesc);
 
 	offset = get_first_obj_offset(zpdesc);
 	s_addr = kmap_local_zpdesc(zpdesc);
@@ -1835,7 +1910,7 @@ static int zs_page_migrate(struct page *
 	 */
 	write_unlock(&pool->lock);
 	spin_unlock(&class->lock);
-	migrate_write_unlock(zspage);
+	zspage_write_unlock(zspage);
 
 	zpdesc_get(newzpdesc);
 	if (zpdesc_zone(newzpdesc) != zpdesc_zone(zpdesc)) {
@@ -1971,9 +2046,11 @@ static unsigned long __zs_compact(struct
 		if (!src_zspage)
 			break;
 
-		migrate_write_lock(src_zspage);
+		if (!zspage_write_trylock(src_zspage))
+			break;
+
 		migrate_zspage(pool, src_zspage, dst_zspage);
-		migrate_write_unlock(src_zspage);
+		zspage_write_unlock(src_zspage);
 
 		fg = putback_zspage(class, src_zspage);
 		if (fg == ZS_INUSE_RATIO_0) {
@@ -2141,6 +2218,7 @@ struct zs_pool *zs_create_pool(const cha
 	init_deferred_free(pool);
 	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
+	lockdep_register_key(zspool_lock_class(pool));
 
 	pool->name = kstrdup(name, GFP_KERNEL);
 	if (!pool->name)
@@ -2233,7 +2311,6 @@ struct zs_pool *zs_create_pool(const cha
 	 * trigger compaction manually. Thus, ignore return code.
 	 */
 	zs_register_shrinker(pool);
-
 	return pool;
 
 err:
@@ -2270,6 +2347,7 @@ void zs_destroy_pool(struct zs_pool *poo
 		kfree(class);
 	}
 
+	lockdep_unregister_key(zspool_lock_class(pool));
 	destroy_cache(pool);
 	kfree(pool->name);
 	kfree(pool);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-sleepable-entry-locking.patch
zram-permit-preemption-with-active-compression-stream.patch
zram-remove-unused-crypto-include.patch
zram-remove-max_comp_streams-device-attr.patch
zram-remove-second-stage-of-handle-allocation.patch
zram-remove-writestall-zram_stats-member.patch
zram-limit-max-recompress-prio-to-num_active_comps.patch
zram-filter-out-recomp-targets-based-on-priority.patch
zram-rework-recompression-loop.patch
zsmalloc-rename-pool-lock.patch
zsmalloc-make-zspage-lock-preemptible.patch
zsmalloc-introduce-new-object-mapping-api.patch
zram-switch-to-new-zsmalloc-object-mapping-api.patch
zram-permit-reclaim-in-zstd-custom-allocator.patch
zram-do-not-leak-page-on-recompress_store-error-path.patch
zram-do-not-leak-page-on-writeback_store-error-path.patch
zram-add-might_sleep-to-zcomp-api.patch
zsmalloc-zram-there-be-preemption.patch

