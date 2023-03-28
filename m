Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CABF1C77B6D
	for <mm-commits@archiver.kernel.org>; Tue, 28 Mar 2023 23:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjC1XWL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Mar 2023 19:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjC1XVw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 28 Mar 2023 19:21:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356372D51
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 16:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1C49B81F55
        for <mm-commits@vger.kernel.org>; Tue, 28 Mar 2023 23:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B228C433EF;
        Tue, 28 Mar 2023 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680045700;
        bh=MQUgPHdcvFekClQGzsOTQySj79aWP7fZV9AowARjiB8=;
        h=Date:To:From:Subject:From;
        b=G/bGdZQ2BmmWzD/mmrUx2UYmg80MVjv0LiLdLsBkT0gNGih+z1DPXkT2c8SG84mUR
         vC88r6G8G76eKdq5EE82VMk0eOsasnRIbThhhmgbTppC4Mn99bRarBbQC5UWu2W3Da
         TE+J33WiOohmYEorc3dNBUI/GeFRXZf5vctY5ggY=
Date:   Tue, 28 Mar 2023 16:21:39 -0700
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-show-per-fullness-group-class-stats.patch removed from -mm tree
Message-Id: <20230328232140.3B228C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: zsmalloc: show per fullness group class stats
has been removed from the -mm tree.  Its filename was
     zsmalloc-show-per-fullness-group-class-stats.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zsmalloc: show per fullness group class stats
Date: Sat, 4 Mar 2023 12:48:35 +0900

We keep the old fullness (3/4 threshold) reporting in
zs_stats_size_show().  Switch from allmost full/empty stats to
fine-grained per inuse ratio (fullness group) reporting, which gives
signicantly more data on classes fragmentation.

Link: https://lkml.kernel.org/r/20230304034835.2082479-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   53 ++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-show-per-fullness-group-class-stats
+++ a/mm/zsmalloc.c
@@ -172,9 +172,7 @@
 enum fullness_group {
 	ZS_INUSE_RATIO_0,
 	ZS_INUSE_RATIO_10,
-	/* NOTE: 5 more fullness groups here */
-	ZS_INUSE_RATIO_70	= 7,
-	/* NOTE: 2 more fullness groups here */
+	/* NOTE: 8 more fullness groups here */
 	ZS_INUSE_RATIO_99       = 10,
 	ZS_INUSE_RATIO_100,
 	NR_FULLNESS_GROUPS,
@@ -621,23 +619,22 @@ static unsigned long zs_can_compact(stru
 
 static int zs_stats_size_show(struct seq_file *s, void *v)
 {
-	int i;
+	int i, fg;
 	struct zs_pool *pool = s->private;
 	struct size_class *class;
 	int objs_per_zspage;
-	unsigned long class_almost_full, class_almost_empty;
 	unsigned long obj_allocated, obj_used, pages_used, freeable;
-	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
 	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
 	unsigned long total_freeable = 0;
+	unsigned long inuse_totals[NR_FULLNESS_GROUPS] = {0, };
 
-	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s %8s\n",
-			"class", "size", "almost_full", "almost_empty",
+	seq_printf(s, " %5s %5s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %9s %13s %10s %10s %16s %8s\n",
+			"class", "size", "10%", "20%", "30%", "40%",
+			"50%", "60%", "70%", "80%", "90%", "99%", "100%",
 			"obj_allocated", "obj_used", "pages_used",
 			"pages_per_zspage", "freeable");
 
 	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
-		int fg;
 
 		class = pool->size_class[i];
 
@@ -645,16 +642,12 @@ static int zs_stats_size_show(struct seq
 			continue;
 
 		spin_lock(&pool->lock);
-		class_almost_full = 0;
-		class_almost_empty = 0;
-		/*
-		 * Replicate old behaviour for almost_full and almost_empty
-		 * stats.
-		 */
-		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
-			class_almost_full += zs_stat_get(class, fg);
-		for (fg = ZS_INUSE_RATIO_10; fg < ZS_INUSE_RATIO_70; fg++)
-			class_almost_empty += zs_stat_get(class, fg);
+
+		seq_printf(s, " %5u %5u ", i, class->size);
+		for (fg = ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++) {
+			inuse_totals[fg] += zs_stat_get(class, fg);
+			seq_printf(s, "%9lu ", zs_stat_get(class, fg));
+		}
 
 		obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
 		obj_used = zs_stat_get(class, ZS_OBJS_INUSE);
@@ -665,14 +658,10 @@ static int zs_stats_size_show(struct seq
 		pages_used = obj_allocated / objs_per_zspage *
 				class->pages_per_zspage;
 
-		seq_printf(s, " %5u %5u %11lu %12lu %13lu"
-				" %10lu %10lu %16d %8lu\n",
-			i, class->size, class_almost_full, class_almost_empty,
-			obj_allocated, obj_used, pages_used,
-			class->pages_per_zspage, freeable);
+		seq_printf(s, "%13lu %10lu %10lu %16d %8lu\n",
+			   obj_allocated, obj_used, pages_used,
+			   class->pages_per_zspage, freeable);
 
-		total_class_almost_full += class_almost_full;
-		total_class_almost_empty += class_almost_empty;
 		total_objs += obj_allocated;
 		total_used_objs += obj_used;
 		total_pages += pages_used;
@@ -680,10 +669,14 @@ static int zs_stats_size_show(struct seq
 	}
 
 	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu %16s %8lu\n",
-			"Total", "", total_class_almost_full,
-			total_class_almost_empty, total_objs,
-			total_used_objs, total_pages, "", total_freeable);
+	seq_printf(s, " %5s %5s ", "Total", "");
+
+	for (fg = ZS_INUSE_RATIO_10; fg < NR_FULLNESS_GROUPS; fg++)
+		seq_printf(s, "%9lu ", inuse_totals[fg]);
+
+	seq_printf(s, "%13lu %10lu %10lu %16s %8lu\n",
+		   total_objs, total_used_objs, total_pages, "",
+		   total_freeable);
 
 	return 0;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-document-new-fullness-grouping.patch
zsmalloc-document-freeable-stats.patch

