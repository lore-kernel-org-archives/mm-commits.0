Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 970D4EEDD
	for <mm-commits@vger.kernel.org>; Tue, 27 Feb 2024 18:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709057057; cv=none; b=TMIyxdlL6YEfimXiPg38Y5V19mFI8FXOMHxfgpNd8ujvPuMezx7W0JotGDEUvqXH6j2oV8dh0e4qBzuVNeTnLsHyQmuXjx0dXQD12HzaS2NL4fZAFPiqvGD1CZATAikR9htS0sydgkl969+m+PXs9y26uXyVVqZNrrGfDIEel04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709057057; c=relaxed/simple;
	bh=gSSCb2J1kVJSbJYIx7D+ijVui2EskH5lFKR66gIlfYU=;
	h=Date:To:From:Subject:Message-Id; b=nIwS+QuYIMWa1G9yyQqtLmtzf7MsxywpIzgbRmt9MiPag5yVG9qVZa7d8CtqsLmE0FJbZTna0ZUXLhzwu6cNE6wt07EYMiBVJ8FzX+ow/a3MDqv4ViDopUr9q0r38nGBg/JzhOjs10GHnQaA8pTXKEWz/DeX64G1nK8q0Wkrp/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=afIP2Nzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="afIP2Nzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FA1C433C7;
	Tue, 27 Feb 2024 18:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1709057057;
	bh=gSSCb2J1kVJSbJYIx7D+ijVui2EskH5lFKR66gIlfYU=;
	h=Date:To:From:Subject:From;
	b=afIP2NzbV2pCGp577yGIuSZc1ZgP9RhJEscOkfWR5tVveqhre9mgty3j2nbMm2N1Q
	 tYCotjGvlSYV5gxaQgDKT3gdplWNYiYQ/IiHKsMXd0bzNgc43b4L+UkR5gzKPk8a5H
	 ibvXRQKFikARVgsGCAR1KlV5mturxUaOn8wpC8T8=
Date: Tue, 27 Feb 2024 10:04:16 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zsmalloc-remove-the-deferred-free-mechanism.patch added to mm-unstable branch
Message-Id: <20240227180416.F1FA1C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zsmalloc: remove the deferred free mechanism
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zsmalloc-remove-the-deferred-free-mechanism.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zsmalloc-remove-the-deferred-free-mechanism.patch

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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zsmalloc: remove the deferred free mechanism
Date: Tue, 27 Feb 2024 03:02:55 +0000

Since the only user of kick_deferred_free() has gone, remove all the
deferred mechanism related code.

Link: https://lkml.kernel.org/r/20240226-zsmalloc-zspage-rcu-v1-2-456b0ef1a89d@bytedance.com
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  109 ------------------------------------------------
 1 file changed, 109 deletions(-)

--- a/mm/zsmalloc.c~mm-zsmalloc-remove-the-deferred-free-mechanism
+++ a/mm/zsmalloc.c
@@ -233,9 +233,6 @@ struct zs_pool {
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
-#ifdef CONFIG_COMPACTION
-	struct work_struct free_work;
-#endif
 	spinlock_t lock;
 	atomic_t compaction_in_progress;
 };
@@ -281,12 +278,8 @@ static void migrate_write_lock(struct zs
 static void migrate_write_unlock(struct zspage *zspage);
 
 #ifdef CONFIG_COMPACTION
-static void kick_deferred_free(struct zs_pool *pool);
-static void init_deferred_free(struct zs_pool *pool);
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage);
 #else
-static void kick_deferred_free(struct zs_pool *pool) {}
-static void init_deferred_free(struct zs_pool *pool) {}
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage) {}
 #endif
 
@@ -1632,50 +1625,6 @@ static int putback_zspage(struct size_cl
 	return fullness;
 }
 
-#ifdef CONFIG_COMPACTION
-/*
- * To prevent zspage destroy during migration, zspage freeing should
- * hold locks of all pages in the zspage.
- */
-static void lock_zspage(struct zspage *zspage)
-{
-	struct page *curr_page, *page;
-
-	/*
-	 * Pages we haven't locked yet can be migrated off the list while we're
-	 * trying to lock them, so we need to be careful and only attempt to
-	 * lock each page under migrate_read_lock(). Otherwise, the page we lock
-	 * may no longer belong to the zspage. This means that we may wait for
-	 * the wrong page to unlock, so we must take a reference to the page
-	 * prior to waiting for it to unlock outside migrate_read_lock().
-	 */
-	while (1) {
-		migrate_read_lock(zspage);
-		page = get_first_page(zspage);
-		if (trylock_page(page))
-			break;
-		get_page(page);
-		migrate_read_unlock(zspage);
-		wait_on_page_locked(page);
-		put_page(page);
-	}
-
-	curr_page = page;
-	while ((page = get_next_page(curr_page))) {
-		if (trylock_page(page)) {
-			curr_page = page;
-		} else {
-			get_page(page);
-			migrate_read_unlock(zspage);
-			wait_on_page_locked(page);
-			put_page(page);
-			migrate_read_lock(zspage);
-		}
-	}
-	migrate_read_unlock(zspage);
-}
-#endif /* CONFIG_COMPACTION */
-
 static void migrate_lock_init(struct zspage *zspage)
 {
 	rwlock_init(&zspage->lock);
@@ -1730,10 +1679,6 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
-	/*
-	 * Page is locked so zspage couldn't be destroyed. For detail, look at
-	 * lock_zspage in free_zspage.
-	 */
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	return true;
@@ -1848,56 +1793,6 @@ static const struct movable_operations z
 	.putback_page = zs_page_putback,
 };
 
-/*
- * Caller should hold page_lock of all pages in the zspage
- * In here, we cannot use zspage meta data.
- */
-static void async_free_zspage(struct work_struct *work)
-{
-	int i;
-	struct size_class *class;
-	struct zspage *zspage, *tmp;
-	LIST_HEAD(free_pages);
-	struct zs_pool *pool = container_of(work, struct zs_pool,
-					free_work);
-
-	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
-		class = pool->size_class[i];
-		if (class->index != i)
-			continue;
-
-		spin_lock(&pool->lock);
-		list_splice_init(&class->fullness_list[ZS_INUSE_RATIO_0],
-				 &free_pages);
-		spin_unlock(&pool->lock);
-	}
-
-	list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
-		list_del(&zspage->list);
-		lock_zspage(zspage);
-
-		spin_lock(&pool->lock);
-		class = zspage_class(pool, zspage);
-		__free_zspage(pool, class, zspage);
-		spin_unlock(&pool->lock);
-	}
-};
-
-static void kick_deferred_free(struct zs_pool *pool)
-{
-	schedule_work(&pool->free_work);
-}
-
-static void zs_flush_migration(struct zs_pool *pool)
-{
-	flush_work(&pool->free_work);
-}
-
-static void init_deferred_free(struct zs_pool *pool)
-{
-	INIT_WORK(&pool->free_work, async_free_zspage);
-}
-
 static void SetZsPageMovable(struct zs_pool *pool, struct zspage *zspage)
 {
 	struct page *page = get_first_page(zspage);
@@ -1908,8 +1803,6 @@ static void SetZsPageMovable(struct zs_p
 		unlock_page(page);
 	} while ((page = get_next_page(page)) != NULL);
 }
-#else
-static inline void zs_flush_migration(struct zs_pool *pool) { }
 #endif
 
 /*
@@ -2121,7 +2014,6 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool)
 		return NULL;
 
-	init_deferred_free(pool);
 	spin_lock_init(&pool->lock);
 	atomic_set(&pool->compaction_in_progress, 0);
 
@@ -2229,7 +2121,6 @@ void zs_destroy_pool(struct zs_pool *poo
 	int i;
 
 	zs_unregister_shrinker(pool);
-	zs_flush_migration(pool);
 	zs_pool_stat_destroy(pool);
 
 	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-global-lru-and-shrinker-shared-by-all-zswap_pools.patch
mm-zswap-change-zswap_pool-kref-to-percpu_ref.patch
mm-zsmalloc-dont-hold-locks-of-all-pages-when-free_zspage.patch
mm-zsmalloc-remove-the-deferred-free-mechanism.patch

