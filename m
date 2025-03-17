Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D87217709
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 05:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742188425; cv=none; b=dbY+1V7eO3mauGahFQbJkASqwus55sc1Y5fN7swoUbSRv6QZmlBVQfubTTei/N5C7m6SQiucafGJq+JTkBb92eQ6D99dOqz1FodyUDj26SyD29DJFM/Kx3Le3QtUdNHjIxqukW7BEOydgdDEE+4InCibSTOOqDlb50jVB9msRQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742188425; c=relaxed/simple;
	bh=5+rjaCw2GvRDKW1sAxDr3cyMjgLpNqd7SfUAWAhlzvA=;
	h=Date:To:From:Subject:Message-Id; b=GJFsK5P0m6AKk6otJVng1bjyshMLU4Dwfe8OYSHE8JX7pU61JwYqZ3EBOe3xYQes478qNDMbbTM08CbDHmzBgvDhoSpcVelb87UQSpK/OyotVToDSdCqYwvabvC9yOf4X9pc72NuO57geSpYtMCK5+ZsPCa1jAvMGlYtvfxenEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q4HPvfS/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q4HPvfS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DCA1C4CEEC;
	Mon, 17 Mar 2025 05:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742188425;
	bh=5+rjaCw2GvRDKW1sAxDr3cyMjgLpNqd7SfUAWAhlzvA=;
	h=Date:To:From:Subject:From;
	b=Q4HPvfS/44VvjkC3xViTZwF4iGB8YDten502ssC/ifngBS5zDiegJb8mt0VceLH12
	 wHw6GyRHj/9PyKLC3sb7SJHEY7GRAdpDRWH0TCklQ5wNi/9A2MsDIdIDV68YFtyQ8L
	 TsWY3Gt/O8DNyeerkLwqvkiD5IViNjxSi/oFiSRM=
Date: Sun, 16 Mar 2025 22:13:44 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,ryncsn@gmail.com,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-rename-pool-lock.patch removed from -mm tree
Message-Id: <20250317051345.3DCA1C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: rename pool lock
has been removed from the -mm tree.  Its filename was
     zsmalloc-rename-pool-lock.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: rename pool lock
Date: Mon, 3 Mar 2025 11:03:21 +0900

The old name comes from the times when the pool did not have compaction
(defragmentation).  Rename it to ->lock because these days it synchronizes
not only migration.

Link: https://lkml.kernel.org/r/20250303022425.285971-13-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Kairui Song <ryncsn@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-rename-pool-lock
+++ a/mm/zsmalloc.c
@@ -18,7 +18,7 @@
 /*
  * lock ordering:
  *	page_lock
- *	pool->migrate_lock
+ *	pool->lock
  *	class->lock
  *	zspage->lock
  */
@@ -223,8 +223,8 @@ struct zs_pool {
 #ifdef CONFIG_COMPACTION
 	struct work_struct free_work;
 #endif
-	/* protect page/zspage migration */
-	rwlock_t migrate_lock;
+	/* protect zspage migration/compaction */
+	rwlock_t lock;
 	atomic_t compaction_in_progress;
 };
 
@@ -1206,7 +1206,7 @@ void *zs_map_object(struct zs_pool *pool
 	BUG_ON(in_interrupt());
 
 	/* It guarantees it can get zspage from handle safely */
-	read_lock(&pool->migrate_lock);
+	read_lock(&pool->lock);
 	obj = handle_to_obj(handle);
 	obj_to_location(obj, &zpdesc, &obj_idx);
 	zspage = get_zspage(zpdesc);
@@ -1218,7 +1218,7 @@ void *zs_map_object(struct zs_pool *pool
 	 * which is smaller granularity.
 	 */
 	migrate_read_lock(zspage);
-	read_unlock(&pool->migrate_lock);
+	read_unlock(&pool->lock);
 
 	class = zspage_class(pool, zspage);
 	off = offset_in_page(class->size * obj_idx);
@@ -1450,16 +1450,16 @@ void zs_free(struct zs_pool *pool, unsig
 		return;
 
 	/*
-	 * The pool->migrate_lock protects the race with zpage's migration
+	 * The pool->lock protects the race with zpage's migration
 	 * so it's safe to get the page from handle.
 	 */
-	read_lock(&pool->migrate_lock);
+	read_lock(&pool->lock);
 	obj = handle_to_obj(handle);
 	obj_to_zpdesc(obj, &f_zpdesc);
 	zspage = get_zspage(f_zpdesc);
 	class = zspage_class(pool, zspage);
 	spin_lock(&class->lock);
-	read_unlock(&pool->migrate_lock);
+	read_unlock(&pool->lock);
 
 	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
@@ -1796,7 +1796,7 @@ static int zs_page_migrate(struct page *
 	 * The pool migrate_lock protects the race between zpage migration
 	 * and zs_free.
 	 */
-	write_lock(&pool->migrate_lock);
+	write_lock(&pool->lock);
 	class = zspage_class(pool, zspage);
 
 	/*
@@ -1833,7 +1833,7 @@ static int zs_page_migrate(struct page *
 	 * Since we complete the data copy and set up new zspage structure,
 	 * it's okay to release migration_lock.
 	 */
-	write_unlock(&pool->migrate_lock);
+	write_unlock(&pool->lock);
 	spin_unlock(&class->lock);
 	migrate_write_unlock(zspage);
 
@@ -1956,7 +1956,7 @@ static unsigned long __zs_compact(struct
 	 * protect the race between zpage migration and zs_free
 	 * as well as zpage allocation/free
 	 */
-	write_lock(&pool->migrate_lock);
+	write_lock(&pool->lock);
 	spin_lock(&class->lock);
 	while (zs_can_compact(class)) {
 		int fg;
@@ -1983,14 +1983,14 @@ static unsigned long __zs_compact(struct
 		src_zspage = NULL;
 
 		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
-		    || rwlock_is_contended(&pool->migrate_lock)) {
+		    || rwlock_is_contended(&pool->lock)) {
 			putback_zspage(class, dst_zspage);
 			dst_zspage = NULL;
 
 			spin_unlock(&class->lock);
-			write_unlock(&pool->migrate_lock);
+			write_unlock(&pool->lock);
 			cond_resched();
-			write_lock(&pool->migrate_lock);
+			write_lock(&pool->lock);
 			spin_lock(&class->lock);
 		}
 	}
@@ -2002,7 +2002,7 @@ static unsigned long __zs_compact(struct
 		putback_zspage(class, dst_zspage);
 
 	spin_unlock(&class->lock);
-	write_unlock(&pool->migrate_lock);
+	write_unlock(&pool->lock);
 
 	return pages_freed;
 }
@@ -2014,10 +2014,10 @@ unsigned long zs_compact(struct zs_pool
 	unsigned long pages_freed = 0;
 
 	/*
-	 * Pool compaction is performed under pool->migrate_lock so it is basically
+	 * Pool compaction is performed under pool->lock so it is basically
 	 * single-threaded. Having more than one thread in __zs_compact()
-	 * will increase pool->migrate_lock contention, which will impact other
-	 * zsmalloc operations that need pool->migrate_lock.
+	 * will increase pool->lock contention, which will impact other
+	 * zsmalloc operations that need pool->lock.
 	 */
 	if (atomic_xchg(&pool->compaction_in_progress, 1))
 		return 0;
@@ -2139,7 +2139,7 @@ struct zs_pool *zs_create_pool(const cha
 		return NULL;
 
 	init_deferred_free(pool);
-	rwlock_init(&pool->migrate_lock);
+	rwlock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
 
 	pool->name = kstrdup(name, GFP_KERNEL);
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


