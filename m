Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AFEC4167B
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:14:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJCVON (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiJCVLj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D0F5209E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86324B811C4
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22971C433B5;
        Mon,  3 Oct 2022 21:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831255;
        bh=OfSJs7OKJ4y5Zf8X0+dYddr3BgQbeFOIVgv+tlxXQGg=;
        h=Date:To:From:Subject:From;
        b=B9Gz8jVXkERNsZqU8tgAeb/3ysFUIksSJWksnZhY/4yunlz/NRdNe2Jy9//XqEIum
         Ehw/FfEfwxaewI+08vjsdwvESeIi9daSSALVTECWU47kqWBjFvXNpk/a03QTC5piK1
         fCgDBYA0c0usTmdmJ4Wac8F3FMOfZvt/J+uG6g+g=
Date:   Mon, 03 Oct 2022 14:07:34 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-lru_sort-use-quotas-param-generator.patch removed from -mm tree
Message-Id: <20221003210735.22971C433B5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/lru_sort: use quotas param generator
has been removed from the -mm tree.  Its filename was
     mm-damon-lru_sort-use-quotas-param-generator.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use quotas param generator
Date: Tue, 13 Sep 2022 17:44:48 +0000

This commit makes DAMON_LRU_SORT to generate the module parameters for
DAMOS watermarks using the generator macro to simplify the code and reduce
duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-22-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |   70 +++++++++++-------------------------------
 1 file changed, 19 insertions(+), 51 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-quotas-param-generator
+++ a/mm/damon/lru_sort.c
@@ -65,30 +65,17 @@ module_param(hot_thres_access_freq, ulon
 static unsigned long cold_min_age __read_mostly = 120000000;
 module_param(cold_min_age, ulong, 0600);
 
-/*
- * Limit of time for trying the LRU lists sorting in milliseconds.
- *
- * DAMON_LRU_SORT tries to use only up to this time within a time window
- * (quota_reset_interval_ms) for trying LRU lists sorting.  This can be used
- * for limiting CPU consumption of DAMON_LRU_SORT.  If the value is zero, the
- * limit is disabled.
- *
- * 10 ms by default.
- */
-static unsigned long quota_ms __read_mostly = 10;
-module_param(quota_ms, ulong, 0600);
-
-/*
- * The time quota charge reset interval in milliseconds.
- *
- * The charge reset interval for the quota of time (quota_ms).  That is,
- * DAMON_LRU_SORT does not try LRU-lists sorting for more than quota_ms
- * milliseconds or quota_sz bytes within quota_reset_interval_ms milliseconds.
- *
- * 1 second by default.
- */
-static unsigned long quota_reset_interval_ms __read_mostly = 1000;
-module_param(quota_reset_interval_ms, ulong, 0600);
+static struct damos_quota damon_lru_sort_quota = {
+	/* Use up to 10 ms per 1 sec, by default */
+	.ms = 10,
+	.sz = 0,
+	.reset_interval = 1000,
+	/* Within the quota, mark hotter regions accessed first. */
+	.weight_sz = 0,
+	.weight_nr_accesses = 1,
+	.weight_age = 0,
+};
+DEFINE_DAMON_MODULES_DAMOS_TIME_QUOTA(damon_lru_sort_quota);
 
 struct damos_watermarks damon_lru_sort_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
@@ -162,19 +149,10 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = 0,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_quota quota = {
-		/*
-		 * Do not try LRU-lists sorting of hot pages for more than half
-		 * of quota_ms milliseconds within quota_reset_interval_ms.
-		 */
-		.ms = quota_ms / 2,
-		.sz = 0,
-		.reset_interval = quota_reset_interval_ms,
-		/* Within the quota, mark hotter regions accessed first. */
-		.weight_sz = 0,
-		.weight_nr_accesses = 1,
-		.weight_age = 0,
-	};
+	struct damos_quota quota = damon_lru_sort_quota;
+
+	/* Use half of total quota for hot pages sorting */
+	quota.ms = quota.ms / 2;
 
 	return damon_new_scheme(
 			&pattern,
@@ -200,20 +178,10 @@ static struct damos *damon_lru_sort_new_
 		.min_age_region = cold_thres,
 		.max_age_region = UINT_MAX,
 	};
-	struct damos_quota quota = {
-		/*
-		 * Do not try LRU-lists sorting of cold pages for more than
-		 * half of quota_ms milliseconds within
-		 * quota_reset_interval_ms.
-		 */
-		.ms = quota_ms / 2,
-		.sz = 0,
-		.reset_interval = quota_reset_interval_ms,
-		/* Within the quota, mark colder regions not accessed first. */
-		.weight_sz = 0,
-		.weight_nr_accesses = 0,
-		.weight_age = 1,
-	};
+	struct damos_quota quota = damon_lru_sort_quota;
+
+	/* Use half of total quota for cold pages sorting */
+	quota.ms = quota.ms / 2;
 
 	return damon_new_scheme(
 			&pattern,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

