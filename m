Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B664C64EC4
	for <mm-commits@archiver.kernel.org>; Fri,  3 Mar 2023 23:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjCCX3Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Mar 2023 18:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjCCX3P (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2023 18:29:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A435CC29
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 15:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE355B819FF
        for <mm-commits@vger.kernel.org>; Fri,  3 Mar 2023 23:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1CAC433EF;
        Fri,  3 Mar 2023 23:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1677886145;
        bh=GLMGLw0hYVcIdcklIV+LDZBHvZ1A2idDKiknKq1jPyo=;
        h=Date:To:From:Subject:From;
        b=M/+NCvlfjfEkoStUleDUN3lPrfdJtjJGp50Od11d55EuYldwlEIasW03hiw/qwT6w
         YlnpnRNCN2q0TwOHWk1ZL2a31crBuqL5DGVfBcR/x7dTh5kxWZHa+fL+PujCKmJGlj
         Veb6zRQQmD5z+STcrOZbSRXzAyt5R4Q61+IJYJxg=
Date:   Fri, 03 Mar 2023 15:29:05 -0800
To:     mm-commits@vger.kernel.org, yosryahmed@google.com,
        minchan@kernel.org, senozhatsky@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + zsmalloc-show-per-fullness-group-class-stats.patch added to mm-unstable branch
Message-Id: <20230303232905.AC1CAC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: show per fullness group class stats
has been added to the -mm mm-unstable branch.  Its filename is
     zsmalloc-show-per-fullness-group-class-stats.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zsmalloc-show-per-fullness-group-class-stats.patch

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
Subject: zsmalloc: show per fullness group class stats
Date: Fri, 3 Mar 2023 16:31:30 +0900

We keep the old fullness (3/4 threshold) reporting in
zs_stats_size_show().  Switch from allmost full/empty stats to
fine-grained per inuse ratio (fullness group) reporting, which gives
signicantly more data on classes fragmentation.

Link: https://lkml.kernel.org/r/20230303073130.1950714-5-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -625,19 +623,19 @@ static int zs_stats_size_show(struct seq
 	struct zs_pool *pool = s->private;
 	struct size_class *class;
 	int objs_per_zspage;
-	unsigned long class_almost_full, class_almost_empty;
 	unsigned long obj_allocated, obj_used, pages_used, freeable;
-	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
 	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
 	unsigned long total_freeable = 0;
+	unsigned long inuse_totals[NR_FULLNESS_GROUPS] = {0, };
+	int fg;
 
-	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s %8s\n",
-			"class", "size", "almost_full", "almost_empty",
+	seq_printf(s, " %5s %5s %8s %8s %8s %8s %8s %8s %8s %8s %8s %8s %8s %13s %10s %10s %16s %8s\n",
+			"class", "size", "10%", "20%", "30%", "40%",
+			"50%", "60%", "70%", "80%", "90%", "99%", "100%",
 			"obj_allocated", "obj_used", "pages_used",
 			"pages_per_zspage", "freeable");
 
 	for (i = 0; i < ZS_SIZE_CLASSES; i++) {
-		int fg;
 
 		class = pool->size_class[i];
 
@@ -646,14 +644,12 @@ static int zs_stats_size_show(struct seq
 
 		spin_lock(&pool->lock);
 
-		/*
-		 * Replicate old behaviour for almost_full and almost_empty
-		 * stats.
-		 */
-		for (fg = ZS_INUSE_RATIO_70; fg <= ZS_INUSE_RATIO_99; fg++)
-			class_almost_full += zs_stat_get(class, fg);
-		for (fg = ZS_INUSE_RATIO_10; fg < ZS_INUSE_RATIO_70; fg++)
-			class_almost_empty += zs_stat_get(class, fg);
+		seq_printf(s, " %5u %5u ", i, class->size);
+
+		for (fg = ZS_INUSE_RATIO_10; fg <= ZS_INUSE_RATIO_100; fg++) {
+			inuse_totals[fg] += zs_stat_get(class, fg);
+			seq_printf(s, "%8lu ", zs_stat_get(class, fg));
+		}
 
 		obj_allocated = zs_stat_get(class, ZS_OBJS_ALLOCATED);
 		obj_used = zs_stat_get(class, ZS_OBJS_INUSE);
@@ -664,14 +660,10 @@ static int zs_stats_size_show(struct seq
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
@@ -679,10 +671,14 @@ static int zs_stats_size_show(struct seq
 	}
 
 	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu %16s %8lu\n",
-			"Total", "", total_class_almost_full,
-			total_class_almost_empty, total_objs,
-			total_used_objs, total_pages, "", total_freeable);
+	seq_printf(s, " %5s %5s ", "Total", "");
+
+	for (fg = ZS_INUSE_RATIO_10; fg <= ZS_INUSE_RATIO_100; fg++)
+		seq_printf(s, "%8lu ", inuse_totals[fg]);
+
+	seq_printf(s, "%13lu %10lu %10lu %16s %8lu\n",
+		   total_objs, total_used_objs, total_pages, "",
+		   total_freeable);
 
 	return 0;
 }
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zsmalloc-remove-insert_zspage-inuse-optimization.patch
zsmalloc-fine-grained-inuse-ratio-based-fullness-grouping.patch
zsmalloc-rework-compaction-algorithm.patch
zsmalloc-show-per-fullness-group-class-stats.patch

