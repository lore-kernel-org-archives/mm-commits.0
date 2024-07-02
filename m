Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B95171BA
	for <mm-commits@vger.kernel.org>; Tue,  2 Jul 2024 03:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719892704; cv=none; b=MN2ABzhKjSmZEDKjIxZkMN+q0369TUi+3EgxaGgu3+QH7a59ghZue3VU/eBTOXjhHHh1yD4OE3payGp/icMYkscyVDdE2IRccK5K9h9wdMuuUY5XEDL8x/WcgBXrU5Y0HbJToQ1tbg3IPEAkKYp2gk6K+xCUhmScgInEaCs0i7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719892704; c=relaxed/simple;
	bh=vppDaIfYEC4oJPFWINc4pNjmBKNBPprqdwez20Pv2Ow=;
	h=Date:To:From:Subject:Message-Id; b=Lw/K10dtQaMJ2Y9I5JHs9d8bMQfYcCkSsKmg5I31v+62jpcCOLkVRzbVEoJFbKy/tCFQ66sLXKPp1ea4idZBmQuHRDwVzy7C194tflBhciEtD7Cgvnyf/eUb64zMdUS1q0i3St+xglcdKFMifFQ8lS+fB7ZnGsOrK8fQV5VZ3LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YREybxd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YREybxd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E6CC4AF0A;
	Tue,  2 Jul 2024 03:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719892703;
	bh=vppDaIfYEC4oJPFWINc4pNjmBKNBPprqdwez20Pv2Ow=;
	h=Date:To:From:Subject:From;
	b=YREybxd3c2Cj4c7fJ2bdnUvh+JLei1PIuxYSzRxZJdz/7RGPeTEnYo15sYWE8rZ+L
	 uei8nQeA7A7LlTDiabVmq5dB3Pa4Dq0addkI/Txyt80DsE9/Q3UVYOcPT2HZ9PIRcv
	 gjOsAbwXAqOc32MJq/9g4xDArALoXw3eYWQMNq24=
Date: Mon, 01 Jul 2024 20:58:23 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,chengming.zhou@linux.dev,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-rename-class-stat-mutators.patch added to mm-unstable branch
Message-Id: <20240702035823.C3E6CC4AF0A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zsmalloc: rename class stat mutators
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-rename-class-stat-mutators.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-rename-class-stat-mutators.patch

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

zsmalloc-rename-class-stat-mutators.patch

