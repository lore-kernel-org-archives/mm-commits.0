Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDD2C43217
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJCVMz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbiJCVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:11:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 731F152089
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:07:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F5CF610A3
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FBBC433D6;
        Mon,  3 Oct 2022 21:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831247;
        bh=aHEr/of+jrPlS/AIHr68ChSz+iX1OE/+PS9upil/MWg=;
        h=Date:To:From:Subject:From;
        b=ZQKKPBDsLdte3diXIdm9Wm7ZgJ1Yz6nCa+4ZgaDnHdJBnU5ZyyGKfBCJ9yQXB2H8A
         R1B3MT361jrSpuQ8uUVNUmDBStqjbg5p4oe3ScNV869rzhY+Vnpl1aiZcVlAdPbKxc
         9wFNERR2h6Gnzh28fuB8yGMGYP+6j9cHfBObs1Q0=
Date:   Mon, 03 Oct 2022 14:07:26 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch removed from -mm tree
Message-Id: <20221003210727.60FBBC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/reclaim: use watermarks parameters generator macro
has been removed from the -mm tree.  Its filename was
     mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/reclaim: use watermarks parameters generator macro
Date: Tue, 13 Sep 2022 17:44:41 +0000

This commit makes DAMON_RECLAIM to generate the module parameters for
DAMOS watermarks using the generator macro to simplify the code and reduce
duplicates.

Link: https://lkml.kernel.org/r/20220913174449.50645-15-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |   56 ++++++-------------------------------------
 1 file changed, 9 insertions(+), 47 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-use-watermarks-parameters-generator-macro
+++ a/mm/damon/reclaim.c
@@ -91,45 +91,14 @@ module_param(quota_sz, ulong, 0600);
 static unsigned long quota_reset_interval_ms __read_mostly = 1000;
 module_param(quota_reset_interval_ms, ulong, 0600);
 
-/*
- * The watermarks check time interval in microseconds.
- *
- * Minimal time to wait before checking the watermarks, when DAMON_RECLAIM is
- * enabled but inactive due to its watermarks rule.  5 seconds by default.
- */
-static unsigned long wmarks_interval __read_mostly = 5000000;
-module_param(wmarks_interval, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the high watermark.
- *
- * If free memory of the system in bytes per thousand bytes is higher than
- * this, DAMON_RECLAIM becomes inactive, so it does nothing but periodically
- * checks the watermarks.  500 (50%) by default.
- */
-static unsigned long wmarks_high __read_mostly = 500;
-module_param(wmarks_high, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the middle watermark.
- *
- * If free memory of the system in bytes per thousand bytes is between this and
- * the low watermark, DAMON_RECLAIM becomes active, so starts the monitoring
- * and the reclaiming.  400 (40%) by default.
- */
-static unsigned long wmarks_mid __read_mostly = 400;
-module_param(wmarks_mid, ulong, 0600);
-
-/*
- * Free memory rate (per thousand) for the low watermark.
- *
- * If free memory of the system in bytes per thousand bytes is lower than this,
- * DAMON_RECLAIM becomes inactive, so it does nothing but periodically checks
- * the watermarks.  In the case, the system falls back to the LRU-based page
- * granularity reclamation logic.  200 (20%) by default.
- */
-static unsigned long wmarks_low __read_mostly = 200;
-module_param(wmarks_low, ulong, 0600);
+struct damos_watermarks damon_reclaim_wmarks = {
+	.metric = DAMOS_WMARK_FREE_MEM_RATE,
+	.interval = 5000000,	/* 5 seconds */
+	.high = 500,		/* 50 percent */
+	.mid = 400,		/* 40 percent */
+	.low = 200,		/* 20 percent */
+};
+DEFINE_DAMON_MODULES_WMARKS_PARAMS(damon_reclaim_wmarks);
 
 static struct damon_attrs damon_reclaim_mon_attrs = {
 	.sample_interval = 5000,	/* 5 ms */
@@ -214,13 +183,6 @@ static struct damos *damon_reclaim_new_s
 			damon_reclaim_mon_attrs.aggr_interval,
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
 		 * Do not try reclamation for more than quota_ms milliseconds
@@ -242,7 +204,7 @@ static struct damos *damon_reclaim_new_s
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
-			&wmarks);
+			&damon_reclaim_wmarks);
 }
 
 static int damon_reclaim_apply_parameters(void)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-initialize-damon_target-list-in-damon_new_target.patch

