Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2290142A95
	for <mm-commits@vger.kernel.org>; Fri, 21 Feb 2025 23:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740181369; cv=none; b=rvsgiDsSA4BlY9hplpigvD0eaZjBgQXYlIfZoW7WwZdHTm0I535F0fjwg189RvcmP7qdKUhN+kycEcVqVCebyzqK7ABoGHP9l1s6Em1ZctE3PspnVAZM2e1cnMJrWaC3DAzv/FmMC09+G3qxSWO/G8idyDDih6POIQG+QNyiDc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740181369; c=relaxed/simple;
	bh=PSE1BFRFnWCF+cUpQ01y2ULUdw8dNQleI6NDpudQnF4=;
	h=Date:To:From:Subject:Message-Id; b=D+Z5PZmZI7kFaWmzBpnwBcIB9cfsSNsrlKAL4t6Cpfc2xggVcBCUXyTc5lOOnmMYO9Zl8AgJauTyJjTe0Hx+AWLYW5rlHiLX3D7oz7/U19GUvrcK54wBrhNKshbDFjQi6Fz8cXRHlejsuQN7muLDt10vRTNwlr3ixtsNilvIB4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bNa5x44Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bNa5x44Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A1BC4CED6;
	Fri, 21 Feb 2025 23:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740181368;
	bh=PSE1BFRFnWCF+cUpQ01y2ULUdw8dNQleI6NDpudQnF4=;
	h=Date:To:From:Subject:From;
	b=bNa5x44Ysyy60Bo6knVw6oOMVasagGjJ4tRVoOP4ElRVuVrvhzejZV2CFfh8GTlKz
	 +9cVChUHVPN4kmaps4RfvW2oGbGdy9VeSmUqrdYhpYU/YjV6dyTkZFUpzNElqALwvx
	 ZCzh3uo5IbdXgNheIX/GbeNyXFgrHIv7Ve/vYLHM=
Date: Fri, 21 Feb 2025 15:42:48 -0800
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,minchan@kernel.org,hdanton@sina.com,bigeasy@linutronix.de,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-rename-pool-lock.patch added to mm-unstable branch
Message-Id: <20250221234248.C5A1BC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: rename pool lock
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-rename-pool-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-rename-pool-lock.patch

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
Subject: zsmalloc: rename pool lock
Date: Sat, 22 Feb 2025 07:25:41 +0900

The old name comes from the times when the pool did not have compaction
(defragmentation).  Rename it to ->lock because these days it synchronizes
not only migration.

Link: https://lkml.kernel.org/r/20250221222958.2225035-11-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Hillf Danton <hdanton@sina.com>
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

