Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C0BC43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiJCVOM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A7F52086
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E97116118C
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4C6C433D7;
        Mon,  3 Oct 2022 21:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831246;
        bh=FSdtv8OQesGvaNp8X5cEJuD3Ns1Xo0O36ClQONY2LYY=;
        h=Date:To:From:Subject:From;
        b=gqvQ16/WYLiYSTIYbYSyeyJG4dUiMpmQMRXQNwOZgISy2ttx1uBgi9us11EIlmMRk
         LNaQEtqTLch4idr9Mg/o8Jil+oBzFk0nTBTKNadGW+0wZUO7eX2Ckncs7BtLQkI6i0
         tkiJw1F0w7F/AA9vZHk1BXjodyENF5uf7kRZLlcs=
Date:   Mon, 03 Oct 2022 14:07:25 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch removed from -mm tree
Message-Id: <20221003210726.4D4C6C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: use watermarks parameters generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use watermarks parameters generator macro
Date: Tue, 13 Sep 2022 17:44:40 +0000

This commit makes DAMON_LRU_SORT to generate the module parameters for
DAMOS watermarks using the generator macro to simplify the code and reduce
duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c       |   64 +++++-------------------------------
 mm/damon/modules-common.h |    4 +-
 2 files changed, 12 insertions(+), 56 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-watermarks-parameters-generator-macro
+++ a/mm/damon/lru_sort.c
@@ -90,44 +90,14 @@ module_param(quota_ms, ulong, 0600);
 static unsigned long quota_reset_interval_ms __read_mostly = 1000;
 module_param(quota_reset_interval_ms, ulong, 0600);
 
-/*
- * The watermarks check time interval in microseconds.
- *
- * Minimal time to wait before checking the watermarks, when DAMON_LRU_SORT is
- * enabled but inactive due to its watermarks rule.  5 seconds by default.
- */
-static unsigned long wmarks_interval __read_mostly = 5000000;
-module_param(wmarks_interval, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the high watermark.
- *
- * If free memory of the system in bytes per thousand bytes is higher than
- * this, DAMON_LRU_SORT becomes inactive, so it does nothing but periodically
- * checks the watermarks.  200 (20%) by default.
- */
-static unsigned long wmarks_high __read_mostly = 200;
-module_param(wmarks_high, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the middle watermark.
- *
- * If free memory of the system in bytes per thousand bytes is between this and
- * the low watermark, DAMON_LRU_SORT becomes active, so starts the monitoring
- * and the LRU-lists sorting.  150 (15%) by default.
- */
-static unsigned long wmarks_mid __read_mostly = 150;
-module_param(wmarks_mid, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the low watermark.
- *
- * If free memory of the system in bytes per thousand bytes is lower than this,
- * DAMON_LRU_SORT becomes inactive, so it does nothing but periodically checks
- * the watermarks.  50 (5%) by default.
- */
-static unsigned long wmarks_low __read_mostly = 50;
-module_param(wmarks_low, ulong, 0600);
+struct damos_watermarks damon_lru_sort_wmarks = {
+	.metric = DAMOS_WMARK_FREE_MEM_RATE,
+	.interval = 5000000,	/* 5 seconds */
+	.high = 200,		/* 20 percent */
+	.mid = 150,		/* 15 percent */
+	.low = 50,		/* 5 percent */
+};
+DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_lru_sort_wmarks);
 
 static struct damon_attrs damon_lru_sort_mon_attrs = {
 	.sample_interval = 5000,	/* 5 ms */
@@ -242,13 +212,6 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = 0,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_watermarks wmarks = {
-		.metric = DAMOS_WMARK_FREE_MEM_RATE,
-		.interval = wmarks_interval,
-		.high = wmarks_high,
-		.mid = wmarks_mid,
-		.low = wmarks_low,
-	};
 	struct damos_quota quota = {
 		/*
 		 * Do not try LRU-lists sorting of hot pages for more than half
@@ -270,7 +233,7 @@ static struct damos *damon_lru_sort_new_
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
-			&wmarks);
+			&damon_lru_sort_wmarks);
 }
 
 /* Create a DAMON-based operation scheme for cold memory regions */
@@ -287,13 +250,6 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = cold_thres,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_watermarks wmarks = {
-		.metric = DAMOS_WMARK_FREE_MEM_RATE,
-		.interval = wmarks_interval,
-		.high = wmarks_high,
-		.mid = wmarks_mid,
-		.low = wmarks_low,
-	};
 	struct damos_quota quota = {
 		/*
 		 * Do not try LRU-lists sorting of cold pages for more than
@@ -316,7 +272,7 @@ static struct damos *damon_lru_sort_new_
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
-			&wmarks);
+			&damon_lru_sort_wmarks);
 }
 
 static int damon_lru_sort_apply_parameters(void)
--- a/mm/damon/modules-common.h~mm-damon-lru_sort-use-watermarks-parameters-generator-macro
+++ a/mm/damon/modules-common.h
@@ -18,8 +18,8 @@
 			0600);
 
 #define DEFINE_DAMON_MODULES_WMARKS_PARAMS(wmarks)			\
-	module_param_named(wmarks_interval, wmarks->interval, ulong,	\
+	module_param_named(wmarks_interval, wmarks.interval, ulong,	\
 			0600);						\
 	module_param_named(wmarks_high, wmarks.high, ulong, 0600);	\
 	module_param_named(wmarks_mid, wmarks.mid, ulong, 0600);	\
-	module_param_named(wmarks_low, wmarks.lowulong, 0600);
+	module_param_named(wmarks_low, wmarks.low, ulong, 0600);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

