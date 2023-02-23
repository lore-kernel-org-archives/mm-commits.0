Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB10C61DA4
	for <mm-commits@archiver.kernel.org>; Thu, 23 Feb 2023 19:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBWT4s (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Feb 2023 14:56:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjBWT4n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2023 14:56:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6021159434
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 11:56:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13398B81AE7
        for <mm-commits@vger.kernel.org>; Thu, 23 Feb 2023 19:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3429C433D2;
        Thu, 23 Feb 2023 19:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677182198;
        bh=Ig3yX2ERrp2CM9gDoYR/ltZw++Fmil3n3iq2c3c+A5s=;
        h=Date:To:From:Subject:From;
        b=vfme499OphTPOBWoqvNgi1VFStiVtXSdumnNNNatiJiCC74c+7hbEqi+Z0qQnSL9P
         n58AejwWc9Tndec9wm8QWrItMcx2Bv/uvCtlDW2gX3fs1DJBBUCFjApucx9+K8q/oJ
         VAiLMpSOp9EdfuW/XTedOYOUev/3ttFsn6Q2KG7Q=
Date:   Thu, 23 Feb 2023 11:56:38 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-rework-compaction-algorithm.patch added to mm-unstable branch
Message-Id: <20230223195638.C3429C433D2@smtp.kernel.org>
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
Date: Thu, 23 Feb 2023 12:04:49 +0900

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

Link: https://lkml.kernel.org/r/20230223030451.543162-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   82 ++++++++++++++++++++++--------------------------
 1 file changed, 38 insertions(+), 44 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-rework-compaction-algorithm
+++ a/mm/zsmalloc.c
@@ -1786,15 +1786,14 @@ struct zs_compact_control {
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
@@ -1807,10 +1806,8 @@ static int migrate_zspage(struct zs_pool
 		}
 
 		/* Stop if there is no more space */
-		if (zspage_full(class, get_zspage(d_page))) {
-			ret = -ENOMEM;
+		if (zspage_full(class, get_zspage(d_page)))
 			break;
-		}
 
 		used_obj = handle_to_obj(handle);
 		free_obj = obj_malloc(pool, get_zspage(d_page), handle);
@@ -1823,8 +1820,6 @@ static int migrate_zspage(struct zs_pool
 	/* Remember last position in this iteration */
 	cc->s_page = s_page;
 	cc->obj_idx = obj_idx;
-
-	return ret;
 }
 
 static struct zspage *isolate_src_zspage(struct size_class *class)
@@ -2228,57 +2223,56 @@ static unsigned long __zs_compact(struct
 	 * as well as zpage allocation/free
 	 */
 	spin_lock(&pool->lock);
-	while ((src_zspage = isolate_src_zspage(class))) {
-		/* protect someone accessing the zspage(i.e., zs_map_object) */
-		migrate_write_lock(src_zspage);
-
-		if (!zs_can_compact(class))
-			break;
-
-		cc.obj_idx = 0;
-		cc.s_page = get_first_page(src_zspage);
-
-		while ((dst_zspage = isolate_dst_zspage(class))) {
-			migrate_write_lock_nested(dst_zspage);
-
+	while (1) {
+		if (!dst_zspage) {
+			dst_zspage = isolate_dst_zspage(class);
+			if (!dst_zspage)
+				goto out;
+			migrate_write_lock(dst_zspage);
 			cc.d_page = get_first_page(dst_zspage);
-			/*
-			 * If there is no more space in dst_page, resched
-			 * and see if anyone had allocated another zspage.
-			 */
-			if (!migrate_zspage(pool, class, &cc))
-				break;
+		}
 
+		if (!zs_can_compact(class)) {
 			putback_zspage(class, dst_zspage);
 			migrate_write_unlock(dst_zspage);
-			dst_zspage = NULL;
-			if (spin_is_contended(&pool->lock))
-				break;
+			goto out;
 		}
 
-		/* Stop if we couldn't find slot */
-		if (dst_zspage == NULL)
-			break;
+		src_zspage = isolate_src_zspage(class);
+		if (!src_zspage) {
+			putback_zspage(class, dst_zspage);
+			migrate_write_unlock(dst_zspage);
+			goto out;
+		}
+
+		migrate_write_lock_nested(src_zspage);
 
-		putback_zspage(class, dst_zspage);
-		migrate_write_unlock(dst_zspage);
+		cc.obj_idx = 0;
+		cc.s_page = get_first_page(src_zspage);
+		migrate_zspage(pool, class, &cc);
 
 		if (putback_zspage(class, src_zspage) == ZS_INUSE_RATIO_0) {
 			migrate_write_unlock(src_zspage);
 			free_zspage(pool, class, src_zspage);
 			pages_freed += class->pages_per_zspage;
-		} else
+		} else {
 			migrate_write_unlock(src_zspage);
-		spin_unlock(&pool->lock);
-		cond_resched();
-		spin_lock(&pool->lock);
-	}
+		}
 
-	if (src_zspage) {
-		putback_zspage(class, src_zspage);
-		migrate_write_unlock(src_zspage);
-	}
+		if (get_fullness_group(class, dst_zspage) == ZS_INUSE_RATIO_100
+		    || spin_is_contended(&pool->lock)) {
+			putback_zspage(class, dst_zspage);
+			migrate_write_unlock(dst_zspage);
+			dst_zspage = NULL;
+		}
 
+		if (!dst_zspage) {
+			spin_unlock(&pool->lock);
+			cond_resched();
+			spin_lock(&pool->lock);
+		}
+	}
+out:
 	spin_unlock(&pool->lock);
 
 	return pages_freed;
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-remove-stat-and-fullness-enums.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-extend-compaction-statistics.patch
zram-show-zsmalloc-objs_moved-stat-in-mm_stat.patch

