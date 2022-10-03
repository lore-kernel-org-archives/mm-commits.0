Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B617FC4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJCVOR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EECD52090
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 191B4B811BF
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD21AC433D7;
        Mon,  3 Oct 2022 21:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831250;
        bh=+U5zH8fntqfLfaM8WRWMLQakqUmeG1apq3vGQZSUfPs=;
        h=Date:To:From:Subject:From;
        b=jGHT9kR5Im+v35BbGKk1GMOE40NP/y6emxeGpTUUQNENqWBC34gTe8CmKfZYfhb8G
         PYKgvldVK2M+r+SQJW9Nxhndhmbym54B3iBxch1Tf+mV9fbgZkAa6ipSPxAHizq3bQ
         GNNeJWiJBxtkcbJCEd/pAwTREpmY76XRMfROfFrU=
Date:   Mon, 03 Oct 2022 14:07:30 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-stat-generator.patch removed from -mm tree
Message-Id: <20221003210730.BD21AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: use stat generator
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-stat-generator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use stat generator
Date: Tue, 13 Sep 2022 17:44:44 +0000

This commit makes DAMON_LRU_SORT to generate the module parameters for
DAMOS statistics using the generator macro to simplify the code and reduce
duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-18-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   85 ++++++------------------------------------
 1 file changed, 13 insertions(+), 72 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-stat-generator
+++ a/mm/damon/lru_sort.c
@@ -135,65 +135,15 @@ module_param(monitor_region_end, ulong,
 static int kdamond_pid __read_mostly = -1;
 module_param(kdamond_pid, int, 0400);
 
-/*
- * Number of hot memory regions that tried to be LRU-sorted.
- */
-static unsigned long nr_lru_sort_tried_hot_regions __read_mostly;
-module_param(nr_lru_sort_tried_hot_regions, ulong, 0400);
-
-/*
- * Total bytes of hot memory regions that tried to be LRU-sorted.
- */
-static unsigned long bytes_lru_sort_tried_hot_regions __read_mostly;
-module_param(bytes_lru_sort_tried_hot_regions, ulong, 0400);
-
-/*
- * Number of hot memory regions that successfully be LRU-sorted.
- */
-static unsigned long nr_lru_sorted_hot_regions __read_mostly;
-module_param(nr_lru_sorted_hot_regions, ulong, 0400);
-
-/*
- * Total bytes of hot memory regions that successfully be LRU-sorted.
- */
-static unsigned long bytes_lru_sorted_hot_regions __read_mostly;
-module_param(bytes_lru_sorted_hot_regions, ulong, 0400);
-
-/*
- * Number of times that the time quota limit for hot regions have exceeded
- */
-static unsigned long nr_hot_quota_exceeds __read_mostly;
-module_param(nr_hot_quota_exceeds, ulong, 0400);
-
-/*
- * Number of cold memory regions that tried to be LRU-sorted.
- */
-static unsigned long nr_lru_sort_tried_cold_regions __read_mostly;
-module_param(nr_lru_sort_tried_cold_regions, ulong, 0400);
-
-/*
- * Total bytes of cold memory regions that tried to be LRU-sorted.
- */
-static unsigned long bytes_lru_sort_tried_cold_regions __read_mostly;
-module_param(bytes_lru_sort_tried_cold_regions, ulong, 0400);
-
-/*
- * Number of cold memory regions that successfully be LRU-sorted.
- */
-static unsigned long nr_lru_sorted_cold_regions __read_mostly;
-module_param(nr_lru_sorted_cold_regions, ulong, 0400);
-
-/*
- * Total bytes of cold memory regions that successfully be LRU-sorted.
- */
-static unsigned long bytes_lru_sorted_cold_regions __read_mostly;
-module_param(bytes_lru_sorted_cold_regions, ulong, 0400);
-
-/*
- * Number of times that the time quota limit for cold regions have exceeded
- */
-static unsigned long nr_cold_quota_exceeds __read_mostly;
-module_param(nr_cold_quota_exceeds, ulong, 0400);
+static struct damos_stat damon_lru_sort_hot_stat;
+DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_lru_sort_hot_stat,
+		lru_sort_tried_hot_regions, lru_sorted_hot_regions,
+		hot_quota_exceeds);
+
+static struct damos_stat damon_lru_sort_cold_stat;
+DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_lru_sort_cold_stat,
+		lru_sort_tried_cold_regions, lru_sorted_cold_regions,
+		cold_quota_exceeds);
 
 static struct damon_ctx *ctx;
 static struct damon_target *target;
@@ -397,19 +347,10 @@ static int damon_lru_sort_after_aggregat
 
 	/* update the stats parameter */
 	damon_for_each_scheme(s, c) {
-		if (s->action == DAMOS_LRU_PRIO) {
-			nr_lru_sort_tried_hot_regions = s->stat.nr_tried;
-			bytes_lru_sort_tried_hot_regions = s->stat.sz_tried;
-			nr_lru_sorted_hot_regions = s->stat.nr_applied;
-			bytes_lru_sorted_hot_regions = s->stat.sz_applied;
-			nr_hot_quota_exceeds = s->stat.qt_exceeds;
-		} else if (s->action == DAMOS_LRU_DEPRIO) {
-			nr_lru_sort_tried_cold_regions = s->stat.nr_tried;
-			bytes_lru_sort_tried_cold_regions = s->stat.sz_tried;
-			nr_lru_sorted_cold_regions = s->stat.nr_applied;
-			bytes_lru_sorted_cold_regions = s->stat.sz_applied;
-			nr_cold_quota_exceeds = s->stat.qt_exceeds;
-		}
+		if (s->action == DAMOS_LRU_PRIO)
+			damon_lru_sort_hot_stat = s->stat;
+		else if (s->action == DAMOS_LRU_DEPRIO)
+			damon_lru_sort_cold_stat = s->stat;
 	}
 
 	return damon_lru_sort_handle_commit_inputs();
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

