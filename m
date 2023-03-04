Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45598C64EC4
	for <mm-commits@archiver.kernel.org>; Sat,  4 Mar 2023 19:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbjCDTfM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 4 Mar 2023 14:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCDTfK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 4 Mar 2023 14:35:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272771B56D
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 11:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09FA60A58
        for <mm-commits@vger.kernel.org>; Sat,  4 Mar 2023 19:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D611C433EF;
        Sat,  4 Mar 2023 19:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677958508;
        bh=93jYJnMr7NGz2lX6G6HXaM+HPrBF82Lm2T4k2mZKd2w=;
        h=Date:To:From:Subject:From;
        b=NS6AU0ImonoSQ1WxW7AnnMzwVKLl+nyJZ/P+3F5Uxj/+irAQHexXfDGayq66kpFbY
         2mbB4IOM0zv7RitO6j4UB7AWvCdESklaCvcyUsLcfR/IrYF1e2D28q1NG72PQUdk9S
         m9330i2O7JWR6cDbSpbwDPSewyzhOJ7grYBNX+0Q=
Date:   Sat, 04 Mar 2023 11:35:07 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-rework-compaction-algorithm.patch added to mm-unstable branch
Message-Id: <20230304193508.0D611C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: rework compaction algorithm
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-rework-compaction-algorithm.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-rework-compaction-algorithm.patch

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
Subject: zsmalloc: rework compaction algorithm
Date: Sat, 4 Mar 2023 12:48:34 +0900

The zsmalloc compaction algorithm has the potential to waste some CPU
cycles, particularly when compacting pages within the same fullness group.
This is due to the way it selects the head page of the fullness list for
source and destination pages, and how it reinserts those pages during each
iteration.  The algorithm may first use a page as a migration destination
and then as a migration source, leading to an unnecessary back-and-forth
movement of objects.

Consider the following fullness list:

PageA PageB PageC PageD PageE

During the first iteration, the compaction algorithm will select PageA as
the source and PageB as the destination.  All of PageA's objects will be
moved to PageB, and then PageA will be released while PageB is reinserted
into the fullness list.

PageB PageC PageD PageE

During the next iteration, the compaction algorithm will again select the
head of the list as the source and destination, meaning that PageB will
now serve as the source and PageC as the destination.  This will result in
the objects being moved away from PageB, the same objects that were just
moved to PageB in the previous iteration.

To prevent this avalanche effect, the compaction algorithm should not
reinsert the destination page between iterations.  By doing so, the most
optimal page will continue to be used and its usage ratio will increase,
reducing internal fragmentation.  The destination page should only be
reinserted into the fullness list if:
- It becomes full
- No source page is available.

TEST
====

It's very challenging to reliably test this series.  I ended up developing
my own synthetic test that has 100% reproducibility.  The test generates
significan fragmentation (for each size class) and then performs
compaction for each class individually and tracks the number of memcpy()
in zs_object_copy(), so that we can compare the amount work compaction
does on per-class basis.

Total amount of work (zram mm_stat objs_moved)
----------------------------------------------

Old fullness grouping, old compaction algorithm:
323977 memcpy() in zs_object_copy().

Old fullness grouping, new compaction algorithm:
262944 memcpy() in zs_object_copy().

New fullness grouping, new compaction algorithm:
213978 memcpy() in zs_object_copy().

Per-class compaction memcpy() comparison (T-test)
-------------------------------------------------

x Old fullness grouping, old compaction algorithm
+ Old fullness grouping, new compaction algorithm

    N           Min           Max        Median           Avg        Stddev
x 140           349          3513          2461     2314.1214     806.03271
+ 140           289          2778          2006     1878.1714     641.02073
Difference at 95.0% confidence
        -435.95 +/- 170.595
        -18.8387% +/- 7.37193%
        (Student's t, pooled s = 728.216)

x Old fullness grouping, old compaction algorithm
+ New fullness grouping, new compaction algorithm

    N           Min           Max        Median           Avg        Stddev
x 140           349          3513          2461     2314.1214     806.03271
+ 140           226          2279          1644     1528.4143     524.85268
Difference at 95.0% confidence
        -785.707 +/- 159.331
        -33.9527% +/- 6.88516%
        (Student's t, pooled s = 680.132)

Link: https://lkml.kernel.org/r/20230304034835.2082479-4-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/zsmalloc.c~zsmalloc-rework-compaction-algorithm
+++ a/mm/zsmalloc.c
@@ -1782,15 +1782,14 @@ struct zs_compact_control {
 	int obj_idx;
 };
 
-static int migrate_zspage(struct zs_pool *pool, struct size_class *class,
-				struct zs_compact_control *cc)
+static void migrate_zspage(struct zs_pool *pool, struct size_class *class,
+			   struct zs_compact_control *cc)
 {
 	unsigned long used_obj, free_obj;
 	unsigned long handle;
 	struct page *s_page = cc->s_page;
 	struct page *d_page = cc->d_page;
 	int obj_idx = cc->obj_idx;
-	int ret = 0;
 
 	while (1) {
 		handle = find_alloced_obj(class, s_page, &obj_idx);
@@ -1803,10 +1802,8 @@ static int migrate_zspage(struct zs_pool
 		}
 
 		/* Stop if there is no more space */
-		if (zspage_full(class, get_zspage(d_page))) {
-			ret = -ENOMEM;
+		if (zspage_full(class, get_zspage(d_page)))
 			break;
-		}
 
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, get_zspage(d_page), handle);
@@ -1819,8 +1816,6 @@ static int migrate_zspage(struct zs_pool
 	/* Remember last position in this iteration */
 	cc->s_page = s_page;
 	cc->obj_idx = obj_idx;
-
-	return ret;
 }
 
 static struct zspage *isolate_src_zspage(struct size_class *class)
@@ -2216,7 +2211,7 @@ static unsigned long __zs_compact(struct
 				  struct size_class *class)
 {
 	struct zs_compact_control cc;
-	struct zspage *src_zspage;
+	struct zspage *src_zspage = NULL;
 	struct zspage *dst_zspage = NULL;
 	unsigned long pages_freed = 0;
 
@@ -2225,50 +2220,45 @@ static unsigned long __zs_compact(struct
 	 * as well as zpage allocation/free
 	 */
 	spin_lock(&pool->lock);
-	while ((src_zspage = isolate_src_zspage(class))) {
-		/* protect someone accessing the zspage(i.e., zs_map_object) */
-		migrate_write_lock(src_zspage);
+	while (zs_can_compact(class)) {
+		int fg;
+
+		if (!dst_zspage) {
+			dst_zspage = isolate_dst_zspage(class);
+			if (!dst_zspage)
+				break;
+			migrate_write_lock(dst_zspage);
+			cc.d_page = get_first_page(dst_zspage);
+		}
 
-		if (!zs_can_compact(class))
+		src_zspage = isolate_src_zspage(class);
+		if (!src_zspage)
 			break;
 
+		migrate_write_lock_nested(src_zspage);
+
 		cc.obj_idx = 0;
 		cc.s_page = get_first_page(src_zspage);
+		migrate_zspage(pool, class, &cc);
+		fg = putback_zspage(class, src_zspage);
+		migrate_write_unlock(src_zspage);
 
-		while ((dst_zspage = isolate_dst_zspage(class))) {
-			migrate_write_lock_nested(dst_zspage);
-
-			cc.d_page = get_first_page(dst_zspage);
-			/*
-			 * If there is no more space in dst_page, resched
-			 * and see if anyone had allocated another zspage.
-			 */
-			if (!migrate_zspage(pool, class, &cc))
-				break;
+		if (fg == ZS_INUSE_RATIO_0) {
+			free_zspage(pool, class, src_zspage);
+			pages_freed += class->pages_per_zspage;
+			src_zspage = NULL;
+		}
 
+		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
+		    || spin_is_contended(&pool->lock)) {
 			putback_zspage(class, dst_zspage);
 			migrate_write_unlock(dst_zspage);
 			dst_zspage = NULL;
-			if (spin_is_contended(&pool->lock))
-				break;
-		}
-
-		/* Stop if we couldn't find slot */
-		if (dst_zspage == NULL)
-			break;
 
-		putback_zspage(class, dst_zspage);
-		migrate_write_unlock(dst_zspage);
-
-		if (putback_zspage(class, src_zspage) == ZS_INUSE_RATIO_0) {
-			migrate_write_unlock(src_zspage);
-			free_zspage(pool, class, src_zspage);
-			pages_freed += class->pages_per_zspage;
-		} else
-			migrate_write_unlock(src_zspage);
-		spin_unlock(&pool->lock);
-		cond_resched();
-		spin_lock(&pool->lock);
+			spin_unlock(&pool->lock);
+			cond_resched();
+			spin_lock(&pool->lock);
+		}
 	}
 
 	if (src_zspage) {
@@ -2276,6 +2266,10 @@ static unsigned long __zs_compact(struct
 		migrate_write_unlock(src_zspage);
 	}
 
+	if (dst_zspage) {
+		putback_zspage(class, dst_zspage);
+		migrate_write_unlock(dst_zspage);
+	}
 	spin_unlock(&pool->lock);
 
 	return pages_freed;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-show-per-fullness-group-class-stats.patch

