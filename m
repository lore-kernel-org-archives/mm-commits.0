Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F61C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14AFC61BF8
	for <mm-commits@archiver.kernel.org>; Mon, 15 Nov 2021 21:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245616AbhKOVgg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Nov 2021 16:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353001AbhKOVKn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Nov 2021 16:10:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED4C761B3F;
        Mon, 15 Nov 2021 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1637010410;
        bh=LpEVQAFuF9JfNEjBx7kM/ilJuVf6SnukB/tDGVUBIrU=;
        h=Date:From:To:Subject:From;
        b=YoOrWDX4ezGjk7xczYCh0wttw8zhhxgR8gPm/g9jeW5WvaIINzDIIyMR3W4sdTUEG
         cTV6vC68NSuPWQ6B//XSbMjtsMlVrswkDVCzl1jbuzC8tq+tNphfjKyrlVnFj+uoo+
         rqpWhfF4zUXFMzYJdlyaLZO2nNq4qWkl2GOEirlU=
Date:   Mon, 15 Nov 2021 13:06:49 -0800
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, minchan@kernel.org,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        senozhatsky@chromium.org, tglx@linutronix.de,
        umgwanakikbuti@gmail.com
Subject:  + zsmalloc-remove-zspage-isolation-for-migration.patch
 added to -mm tree
Message-ID: <20211115210649.1bP-FQXV2%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: remove zspage isolation for migration
has been added to the -mm tree.  Its filename is
     zsmalloc-remove-zspage-isolation-for-migration.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-remove-zspage-isolation-for-migration.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-remove-zspage-isolation-for-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: zsmalloc: remove zspage isolation for migration

zspage isolation for migration introduced additional exceptions to be
dealt with since the zspage was isolated from class list.  The reason why
I isolated zspage from class list was to prevent race between obj_malloc
and page migration via allocating zpage from the zspage further.  However,
it couldn't prevent object freeing from zspage so it needed corner case
handling.

This patch removes the whole mess.  Now, we are fine since class->lock and
zspage->lock can prevent the race.

Link: https://lkml.kernel.org/r/20211115185909.3949505-7-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |  157 ++----------------------------------------------
 1 file changed, 8 insertions(+), 149 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-remove-zspage-isolation-for-migration
+++ a/mm/zsmalloc.c
@@ -254,10 +254,6 @@ struct zs_pool {
 #ifdef CONFIG_COMPACTION
 	struct inode *inode;
 	struct work_struct free_work;
-	/* A wait queue for when migration races with async_free_zspage() */
-	struct wait_queue_head migration_wait;
-	atomic_long_t isolated_pages;
-	bool destroying;
 #endif
 };
 
@@ -454,11 +450,6 @@ MODULE_ALIAS("zpool-zsmalloc");
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
-static bool is_zspage_isolated(struct zspage *zspage)
-{
-	return zspage->isolated;
-}
-
 static __maybe_unused int is_first_page(struct page *page)
 {
 	return PagePrivate(page);
@@ -744,7 +735,6 @@ static void remove_zspage(struct size_cl
 				enum fullness_group fullness)
 {
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
-	VM_BUG_ON(is_zspage_isolated(zspage));
 
 	list_del_init(&zspage->list);
 	class_stat_dec(class, fullness, 1);
@@ -770,13 +760,9 @@ static enum fullness_group fix_fullness_
 	if (newfg == currfg)
 		goto out;
 
-	if (!is_zspage_isolated(zspage)) {
-		remove_zspage(class, zspage, currfg);
-		insert_zspage(class, zspage, newfg);
-	}
-
+	remove_zspage(class, zspage, currfg);
+	insert_zspage(class, zspage, newfg);
 	set_zspage_mapping(zspage, class_idx, newfg);
-
 out:
 	return newfg;
 }
@@ -1511,7 +1497,6 @@ void zs_free(struct zs_pool *pool, unsig
 	unsigned long obj;
 	struct size_class *class;
 	enum fullness_group fullness;
-	bool isolated;
 
 	if (unlikely(!handle))
 		return;
@@ -1533,11 +1518,9 @@ void zs_free(struct zs_pool *pool, unsig
 		goto out;
 	}
 
-	isolated = is_zspage_isolated(zspage);
 	migrate_read_unlock(zspage);
 	/* If zspage is isolated, zs_page_putback will free the zspage */
-	if (likely(!isolated))
-		free_zspage(pool, class, zspage);
+	free_zspage(pool, class, zspage);
 out:
 
 	spin_unlock(&class->lock);
@@ -1718,7 +1701,6 @@ static struct zspage *isolate_zspage(str
 		zspage = list_first_entry_or_null(&class->fullness_list[fg[i]],
 							struct zspage, list);
 		if (zspage) {
-			VM_BUG_ON(is_zspage_isolated(zspage));
 			remove_zspage(class, zspage, fg[i]);
 			return zspage;
 		}
@@ -1739,8 +1721,6 @@ static enum fullness_group putback_zspag
 {
 	enum fullness_group fullness;
 
-	VM_BUG_ON(is_zspage_isolated(zspage));
-
 	fullness = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, fullness);
 	set_zspage_mapping(zspage, class->index, fullness);
@@ -1822,35 +1802,10 @@ static void inc_zspage_isolation(struct
 
 static void dec_zspage_isolation(struct zspage *zspage)
 {
+	VM_BUG_ON(zspage->isolated == 0);
 	zspage->isolated--;
 }
 
-static void putback_zspage_deferred(struct zs_pool *pool,
-				    struct size_class *class,
-				    struct zspage *zspage)
-{
-	enum fullness_group fg;
-
-	fg = putback_zspage(class, zspage);
-	if (fg == ZS_EMPTY)
-		schedule_work(&pool->free_work);
-
-}
-
-static inline void zs_pool_dec_isolated(struct zs_pool *pool)
-{
-	VM_BUG_ON(atomic_long_read(&pool->isolated_pages) <= 0);
-	atomic_long_dec(&pool->isolated_pages);
-	/*
-	 * Checking pool->destroying must happen after atomic_long_dec()
-	 * for pool->isolated_pages above. Paired with the smp_mb() in
-	 * zs_unregister_migration().
-	 */
-	smp_mb__after_atomic();
-	if (atomic_long_read(&pool->isolated_pages) == 0 && pool->destroying)
-		wake_up_all(&pool->migration_wait);
-}
-
 static void replace_sub_page(struct size_class *class, struct zspage *zspage,
 				struct page *newpage, struct page *oldpage)
 {
@@ -1876,10 +1831,7 @@ static void replace_sub_page(struct size
 
 static bool zs_page_isolate(struct page *page, isolate_mode_t mode)
 {
-	struct zs_pool *pool;
-	struct size_class *class;
 	struct zspage *zspage;
-	struct address_space *mapping;
 
 	/*
 	 * Page is locked so zspage couldn't be destroyed. For detail, look at
@@ -1889,39 +1841,9 @@ static bool zs_page_isolate(struct page
 	VM_BUG_ON_PAGE(PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-
-	mapping = page_mapping(page);
-	pool = mapping->private_data;
-
-	class = zspage_class(pool, zspage);
-
-	spin_lock(&class->lock);
-	if (get_zspage_inuse(zspage) == 0) {
-		spin_unlock(&class->lock);
-		return false;
-	}
-
-	/* zspage is isolated for object migration */
-	if (list_empty(&zspage->list) && !is_zspage_isolated(zspage)) {
-		spin_unlock(&class->lock);
-		return false;
-	}
-
-	/*
-	 * If this is first time isolation for the zspage, isolate zspage from
-	 * size_class to prevent further object allocation from the zspage.
-	 */
-	if (!list_empty(&zspage->list) && !is_zspage_isolated(zspage)) {
-		enum fullness_group fullness;
-		unsigned int class_idx;
-
-		get_zspage_mapping(zspage, &class_idx, &fullness);
-		atomic_long_inc(&pool->isolated_pages);
-		remove_zspage(class, zspage, fullness);
-	}
-
+	migrate_write_lock(zspage);
 	inc_zspage_isolation(zspage);
-	spin_unlock(&class->lock);
+	migrate_write_unlock(zspage);
 
 	return true;
 }
@@ -2004,21 +1926,6 @@ static int zs_page_migrate(struct addres
 
 	dec_zspage_isolation(zspage);
 
-	/*
-	 * Page migration is done so let's putback isolated zspage to
-	 * the list if @page is final isolated subpage in the zspage.
-	 */
-	if (!is_zspage_isolated(zspage)) {
-		/*
-		 * We cannot race with zs_destroy_pool() here because we wait
-		 * for isolation to hit zero before we start destroying.
-		 * Also, we ensure that everyone can see pool->destroying before
-		 * we start waiting.
-		 */
-		putback_zspage_deferred(pool, class, zspage);
-		zs_pool_dec_isolated(pool);
-	}
-
 	if (page_zone(newpage) != page_zone(page)) {
 		dec_zone_page_state(page, NR_ZSPAGES);
 		inc_zone_page_state(newpage, NR_ZSPAGES);
@@ -2046,30 +1953,15 @@ unpin_objects:
 
 static void zs_page_putback(struct page *page)
 {
-	struct zs_pool *pool;
-	struct size_class *class;
-	struct address_space *mapping;
 	struct zspage *zspage;
 
 	VM_BUG_ON_PAGE(!PageMovable(page), page);
 	VM_BUG_ON_PAGE(!PageIsolated(page), page);
 
 	zspage = get_zspage(page);
-	mapping = page_mapping(page);
-	pool = mapping->private_data;
-	class = zspage_class(pool, zspage);
-
-	spin_lock(&class->lock);
+	migrate_write_lock(zspage);
 	dec_zspage_isolation(zspage);
-	if (!is_zspage_isolated(zspage)) {
-		/*
-		 * Due to page_lock, we cannot free zspage immediately
-		 * so let's defer.
-		 */
-		putback_zspage_deferred(pool, class, zspage);
-		zs_pool_dec_isolated(pool);
-	}
-	spin_unlock(&class->lock);
+	migrate_write_unlock(zspage);
 }
 
 static const struct address_space_operations zsmalloc_aops = {
@@ -2091,36 +1983,8 @@ static int zs_register_migration(struct
 	return 0;
 }
 
-static bool pool_isolated_are_drained(struct zs_pool *pool)
-{
-	return atomic_long_read(&pool->isolated_pages) == 0;
-}
-
-/* Function for resolving migration */
-static void wait_for_isolated_drain(struct zs_pool *pool)
-{
-
-	/*
-	 * We're in the process of destroying the pool, so there are no
-	 * active allocations. zs_page_isolate() fails for completely free
-	 * zspages, so we need only wait for the zs_pool's isolated
-	 * count to hit zero.
-	 */
-	wait_event(pool->migration_wait,
-		   pool_isolated_are_drained(pool));
-}
-
 static void zs_unregister_migration(struct zs_pool *pool)
 {
-	pool->destroying = true;
-	/*
-	 * We need a memory barrier here to ensure global visibility of
-	 * pool->destroying. Thus pool->isolated pages will either be 0 in which
-	 * case we don't care, or it will be > 0 and pool->destroying will
-	 * ensure that we wake up once isolation hits 0.
-	 */
-	smp_mb();
-	wait_for_isolated_drain(pool); /* This can block */
 	flush_work(&pool->free_work);
 	iput(pool->inode);
 }
@@ -2150,7 +2014,6 @@ static void async_free_zspage(struct wor
 		spin_unlock(&class->lock);
 	}
 
-
 	list_for_each_entry_safe(zspage, tmp, &free_pages, list) {
 		list_del(&zspage->list);
 		lock_zspage(zspage);
@@ -2363,10 +2226,6 @@ struct zs_pool *zs_create_pool(const cha
 	if (!pool->name)
 		goto err;
 
-#ifdef CONFIG_COMPACTION
-	init_waitqueue_head(&pool->migration_wait);
-#endif
-
 	if (create_cache(pool))
 		goto err;
 
_

Patches currently in -mm which might be from minchan@kernel.org are

zsmalloc-introduce-some-helper-functions.patch
zsmalloc-rename-zs_stat_type-to-class_stat_type.patch
zsmalloc-decouple-class-actions-from-zspage-works.patch
zsmalloc-introduce-obj_allocated.patch
zsmalloc-move-huge-compressed-obj-from-page-to-zspage.patch
zsmalloc-remove-zspage-isolation-for-migration.patch
locking-rwlocks-introduce-write_lock_nested.patch
zsmalloc-replace-per-zpage-lock-with-pool-migrate_lock.patch

