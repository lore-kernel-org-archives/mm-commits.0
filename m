From: akpm@linux-foundation.org
Subject: + zsmalloc-use-shrinker-to-trigger-auto-compaction.patch added to -mm tree
Date: Wed, 08 Jul 2015 15:38:02 -0700
Message-ID: <559da64a.TN03iKS9HvmZwOed%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbbGHWiD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jul 2015 18:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sergey.senozhatsky@gmail.com, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: use shrinker to trigger auto-compaction
has been added to the -mm tree.  Its filename is
     zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/zsmalloc-use-shrinker-to-trigger-auto-compaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: zsmalloc: use shrinker to trigger auto-compaction

Perform automatic pool compaction by a shrinker when system is getting
tight on memory.

User-space has a very little knowledge regarding zsmalloc fragmentation
and basically has no mechanism to tell whether compaction will result in
any memory gain.  Another issue is that user space is not always aware of
the fact that system is getting tight on memory.  Which leads to very
uncomfortable scenarios when user space may start issuing compaction
'randomly' or from crontab (for example).  Fragmentation is not always
necessarily bad, allocated and unused objects, after all, may be filled
with the data later, w/o the need of allocating a new zspage.  On the
other hand, we obviously don't want to waste memory when the system needs
it.

Compaction now has a relatively quick pool scan so we are able to estimate
the number of pages that will be freed easily, which makes it possible to
call this function from a shrinker->count_objects() callback.  We also
abort compaction as soon as we detect that we can't free any pages any
more, preventing wasteful objects migrations.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Suggested-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff -puN mm/zsmalloc.c~zsmalloc-use-shrinker-to-trigger-auto-compaction mm/zsmalloc.c
--- a/mm/zsmalloc.c~zsmalloc-use-shrinker-to-trigger-auto-compaction
+++ a/mm/zsmalloc.c
@@ -246,6 +246,14 @@ struct zs_pool {
 	atomic_long_t pages_allocated;
 
 	struct zs_pool_stats stats;
+
+	/* Compact classes */
+	struct shrinker shrinker;
+	/*
+	 * To signify that register_shrinker() was successful
+	 * and unregister_shrinker() will not Oops.
+	 */
+	bool shrinker_enabled;
 #ifdef CONFIG_ZSMALLOC_STAT
 	struct dentry *stat_dentry;
 #endif
@@ -1778,6 +1786,69 @@ void zs_pool_stats(struct zs_pool *pool,
 }
 EXPORT_SYMBOL_GPL(zs_pool_stats);
 
+static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
+		struct shrink_control *sc)
+{
+	unsigned long pages_freed;
+	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
+			shrinker);
+
+	pages_freed = pool->stats.pages_compacted;
+	/*
+	 * Compact classes and calculate compaction delta.
+	 * Can run concurrently with a manually triggered
+	 * (by user) compaction.
+	 */
+	pages_freed = zs_compact(pool) - pages_freed;
+
+	return pages_freed ? pages_freed : SHRINK_STOP;
+}
+
+static unsigned long zs_shrinker_count(struct shrinker *shrinker,
+		struct shrink_control *sc)
+{
+	int i;
+	struct size_class *class;
+	unsigned long pages_to_free = 0;
+	struct zs_pool *pool = container_of(shrinker, struct zs_pool,
+			shrinker);
+
+	if (!pool->shrinker_enabled)
+		return 0;
+
+	for (i = zs_size_classes - 1; i >= 0; i--) {
+		class = pool->size_class[i];
+		if (!class)
+			continue;
+		if (class->index != i)
+			continue;
+
+		spin_lock(&class->lock);
+		pages_to_free += zs_can_compact(class);
+		spin_unlock(&class->lock);
+	}
+
+	return pages_to_free;
+}
+
+static void zs_unregister_shrinker(struct zs_pool *pool)
+{
+	if (pool->shrinker_enabled) {
+		unregister_shrinker(&pool->shrinker);
+		pool->shrinker_enabled = false;
+	}
+}
+
+static int zs_register_shrinker(struct zs_pool *pool)
+{
+	pool->shrinker.scan_objects = zs_shrinker_scan;
+	pool->shrinker.count_objects = zs_shrinker_count;
+	pool->shrinker.batch = 0;
+	pool->shrinker.seeks = DEFAULT_SEEKS;
+
+	return register_shrinker(&pool->shrinker);
+}
+
 /**
  * zs_create_pool - Creates an allocation pool to work from.
  * @flags: allocation flags used to allocate pool metadata
@@ -1863,6 +1934,12 @@ struct zs_pool *zs_create_pool(char *nam
 	if (zs_pool_stat_create(name, pool))
 		goto err;
 
+	/*
+	 * Not critical, we still can use the pool
+	 * and user can trigger compaction manually.
+	 */
+	if (zs_register_shrinker(pool) == 0)
+		pool->shrinker_enabled = true;
 	return pool;
 
 err:
@@ -1875,6 +1952,7 @@ void zs_destroy_pool(struct zs_pool *poo
 {
 	int i;
 
+	zs_unregister_shrinker(pool);
 	zs_pool_stat_destroy(pool);
 
 	for (i = 0; i < zs_size_classes; i++) {
_

Patches currently in -mm which might be from sergey.senozhatsky@gmail.com are

zsmalloc-drop-unused-variable-nr_to_migrate.patch
zsmalloc-always-keep-per-class-stats.patch
zsmalloc-introduce-zs_can_compact-function.patch
zsmalloc-cosmetic-compaction-code-adjustments.patch
zsmalloc-zram-introduce-zs_pool_stats-api.patch
zsmalloc-account-the-number-of-compacted-pages.patch
zsmalloc-use-shrinker-to-trigger-auto-compaction.patch

