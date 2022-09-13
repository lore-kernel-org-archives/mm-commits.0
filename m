Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59868ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiIMVyM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiIMVx4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:53:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F36DAEA
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:53:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 918C4615D7
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:53:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4761C433C1;
        Tue, 13 Sep 2022 21:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106034;
        bh=vRtvNhz2Zi5n0zqaedpsQlna2HQ7sgYZdzTnkusdKd4=;
        h=Date:To:From:Subject:From;
        b=NotmnfkaSn2X4bsUBYkwePFAp0Wf/eNNVtCzbHdYVXf4sLHXnzdSZ4TMyK3J/Kt7F
         8r928v0slZk4erIm1rEgmbVHOMAJoAzT38kjkLCPE5o3tRf8DIsmenv5lRQiLOxphC
         Mb50bVQMYgtZq5fvyh8d3i2tfAH8Bpq9T6Rffbmk=
Date:   Tue, 13 Sep 2022 14:53:53 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch added to mm-unstable branch
Message-Id: <20220913215353.E4761C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: use watermarks parameters generator macro
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch

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

mm-demotion-update-node_is_toptier-to-work-with-memory-tiers-fix.patch
selftest-damon-add-a-test-for-duplicate-context-dirs-creation.patch
mm-damon-core-avoid-holes-in-newly-set-monitoring-target-ranges.patch
mm-damon-core-test-test-damon_set_regions.patch
docs-admin-guide-mm-damon-rename-the-title-of-the-document.patch
mm-damon-kconfig-notify-debugfs-deprecation-plan.patch
docs-admin-guide-mm-damon-start-mention-the-dependency-as-sysfs-instead-of-debugfs.patch
docs-admin-guide-mm-damon-usage-note-damon-debugfs-interface-deprecation-plan.patch
mm-damon-paddr-make-supported-damos-actions-of-paddr-clear.patch
mm-damon-paddr-deduplicate-damon_pa_mark_accesseddeactivate_pages.patch
mm-damon-core-copy-struct-to-struct-instead-of-field-to-field-in-damon_new_scheme.patch
mm-damon-core-factor-out-damos_quota-private-fileds-initialization.patch
mm-damon-core-use-a-dedicated-struct-for-monitoring-attributes.patch
mm-damon-core-reduce-parameters-for-damon_set_attrs.patch
mm-damon-reclaim-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-lru_sort-use-struct-damon_attrs-for-storing-parameters-for-it.patch
mm-damon-implement-a-monitoring-attributes-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-monitoring-attributes-parameters-generaotr-macro.patch
mm-damon-reclaim-use-monitoring-attributes-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-watermarks-module-parameters-generator-macro.patch
mm-damon-lru_sort-use-watermarks-parameters-generator-macro.patch
mm-damon-reclaim-use-watermarks-parameters-generator-macro.patch
mm-damon-modules-common-implement-a-stats-parameters-generator-macro.patch
mm-damon-reclaim-use-stat-parameters-generator.patch
mm-damon-lru_sort-use-stat-generator.patch
mm-damon-modules-common-implement-a-damos-quota-params-generator.patch
mm-damon-modules-common-implement-damos-time-quota-params-generator.patch
mm-damon-reclaim-use-the-quota-params-generator-macro.patch
mm-damon-lru_sort-use-quotas-param-generator.patch
mm-damon-lru_sort-deduplicate-hot-cold-schemes-generators.patch

