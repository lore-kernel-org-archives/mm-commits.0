Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFAA7D3E8
	for <mm-commits@vger.kernel.org>; Fri, 12 Jul 2024 22:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720824859; cv=none; b=Y4QQnW4IlqfuP80d2yDMZB9aUTkT17cu7U5gihE47lg2qsPJuO/kDPYH6jCaeNoE3+NOm0l1ptS+/K4w0/DJe+4YHP5j7L5eGTJj16iUTIkpGdM+cfk+7Q+TRQ+Dz9sajJF7u+rT6hnhuNrY7hYSkhcCcjke71UANpwJjMrhzjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720824859; c=relaxed/simple;
	bh=+dNzL4JPEdT4PJttNquH5UCQTbTksM4DL2ruL4WE3lQ=;
	h=Date:To:From:Subject:Message-Id; b=FNxFuSlhKjFMf7KA/MfE1660wudEhLNoZ9u9Iej4UfaFlBDSyDNfVNHxvgQgePuRD/BGfD6oWVG0PrUeVH1xAcvpRf6Q6rSBWFA9h2M7/Esvv44eE52uclG/bBf1/8zZ4eC3MGOAxrjDlLmqwWPri96L9pFNTYyktyLcIA/YMqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lZimKM4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lZimKM4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537FDC32782;
	Fri, 12 Jul 2024 22:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1720824859;
	bh=+dNzL4JPEdT4PJttNquH5UCQTbTksM4DL2ruL4WE3lQ=;
	h=Date:To:From:Subject:From;
	b=lZimKM4EMtCP5QEqetuINFfkorNnW/vVFmL5Iu7R0ctFhCZJ2lK+wyvFslGejWTMc
	 b8Jf5aVchAyc0UXJkJtwlO0X1C2RCeqVc3/GQldhWD5jilUXYxBYRzm4wxc59q2qRn
	 qURkWzZeVmj+mKDUi3A3my4XW71RND+SDg72iVhg=
Date: Fri, 12 Jul 2024 15:54:18 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,chengming.zhou@linux.dev,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-rename-class-stat-mutators.patch removed from -mm tree
Message-Id: <20240712225419.537FDC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: rename class stat mutators
has been removed from the -mm tree.  Its filename was
     zsmalloc-rename-class-stat-mutators.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: rename class stat mutators
Date: Mon, 1 Jul 2024 12:11:37 +0900

A cosmetic change.

o Rename class_stat_inc() and class_stat_dec() to class_stat_add()
  and class_stat_sub() correspondingly. inc/dec are usually associated
  with +1/-1 modifications, while zsmlloc can modify stats by up
  to ->objs_per_zspage. Use add/sub (follow atomics naming).

o Rename zs_stat_get() to class_stat_read()
  get() is usually associated with ref-counting and is paired with put().
  zs_stat_get() simply reads class stat so rename to reflect it.
  (This also follows atomics naming).

Link: https://lkml.kernel.org/r/20240701031140.3756345-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-rename-class-stat-mutators
+++ a/mm/zsmalloc.c
@@ -512,19 +512,19 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
-static inline void class_stat_inc(struct size_class *class,
-				int type, unsigned long cnt)
+static inline void class_stat_add(struct size_class *class, int type,
+				  unsigned long cnt)
 {
 	class->stats.objs[type] += cnt;
 }
 
-static inline void class_stat_dec(struct size_class *class,
-				int type, unsigned long cnt)
+static inline void class_stat_sub(struct size_class *class, int type,
+				  unsigned long cnt)
 {
 	class->stats.objs[type] -= cnt;
 }
 
-static inline unsigned long zs_stat_get(struct size_class *class, int type)
+static inline unsigned long class_stat_read(struct size_class *class, int type)
 {
 	return class->stats.objs[type];
 }
@@ -576,12 +576,12 @@ static int zs_stats_size_show(struct seq
 
 		seq_printf(s, " %5u %5u ", i, class->size);
 		for (fg = ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++) {
-			inuse_totals[fg] += zs_stat_get(class, fg);
-			seq_printf(s, "%9lu ", zs_stat_get(class, fg));
+			inuse_totals[fg] += class_stat_read(class, fg);
+			seq_printf(s, "%9lu ", class_stat_read(class, fg));
 		}
 
-		obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
-		obj_used = zs_stat_get(class, ZS_OBJS_INUSE);
+		obj_allocated = class_stat_read(class, ZS_OBJS_ALLOCATED);
+		obj_used = class_stat_read(class, ZS_OBJS_INUSE);
 		freeable = zs_can_compact(class);
 		spin_unlock(&class->lock);
 
@@ -686,7 +686,7 @@ static void insert_zspage(struct size_cl
 				struct zspage *zspage,
 				int fullness)
 {
-	class_stat_inc(class, fullness, 1);
+	class_stat_add(class, fullness, 1);
 	list_add(&zspage->list, &class->fullness_list[fullness]);
 	zspage->fullness = fullness;
 }
@@ -702,7 +702,7 @@ static void remove_zspage(struct size_cl
 	VM_BUG_ON(list_empty(&class->fullness_list[fullness]));
 
 	list_del_init(&zspage->list);
-	class_stat_dec(class, fullness, 1);
+	class_stat_sub(class, fullness, 1);
 }
 
 /*
@@ -858,7 +858,7 @@ static void __free_zspage(struct zs_pool
 
 	cache_free_zspage(pool, zspage);
 
-	class_stat_dec(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
+	class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
 	atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
 }
 
@@ -1374,7 +1374,7 @@ unsigned long zs_malloc(struct zs_pool *
 		obj_malloc(pool, zspage, handle);
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
-		class_stat_inc(class, ZS_OBJS_INUSE, 1);
+		class_stat_add(class, ZS_OBJS_INUSE, 1);
 
 		goto out;
 	}
@@ -1392,8 +1392,8 @@ unsigned long zs_malloc(struct zs_pool *
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
-	class_stat_inc(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
-	class_stat_inc(class, ZS_OBJS_INUSE, 1);
+	class_stat_add(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
+	class_stat_add(class, ZS_OBJS_INUSE, 1);
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
@@ -1454,7 +1454,7 @@ void zs_free(struct zs_pool *pool, unsig
 	spin_lock(&class->lock);
 	read_unlock(&pool->migrate_lock);
 
-	class_stat_dec(class, ZS_OBJS_INUSE, 1);
+	class_stat_sub(class, ZS_OBJS_INUSE, 1);
 	obj_free(class->size, obj);
 
 	fullness = fix_fullness_group(class, zspage);
@@ -1880,7 +1880,7 @@ static void async_free_zspage(struct wor
 
 		class = zspage_class(pool, zspage);
 		spin_lock(&class->lock);
-		class_stat_dec(class, ZS_INUSE_RATIO_0, 1);
+		class_stat_sub(class, ZS_INUSE_RATIO_0, 1);
 		__free_zspage(pool, class, zspage);
 		spin_unlock(&class->lock);
 	}
@@ -1923,8 +1923,8 @@ static inline void zs_flush_migration(st
 static unsigned long zs_can_compact(struct size_class *class)
 {
 	unsigned long obj_wasted;
-	unsigned long obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
-	unsigned long obj_used = zs_stat_get(class, ZS_OBJS_INUSE);
+	unsigned long obj_allocated = class_stat_read(class, ZS_OBJS_ALLOCATED);
+	unsigned long obj_used = class_stat_read(class, ZS_OBJS_INUSE);
 
 	if (obj_allocated <= obj_used)
 		return 0;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are


