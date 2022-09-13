Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3853ECAAD8
	for <mm-commits@archiver.kernel.org>; Tue, 13 Sep 2022 21:54:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiIMVyg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Sep 2022 17:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiIMVyP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Sep 2022 17:54:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B60B6DFA1
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 14:54:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D555AB810F2
        for <mm-commits@vger.kernel.org>; Tue, 13 Sep 2022 21:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8078FC433D6;
        Tue, 13 Sep 2022 21:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663106050;
        bh=VWEAL9Bxaa4BGKZ2/kzF9Xx0sKQ/sXM9qLGHdRuyR08=;
        h=Date:To:From:Subject:From;
        b=WUSbI2Ks2z3KbhKY9Hypn/CgNNzuH4/S1C0lz+1noevnEJiTIjB0lzz3OkVNUd1hg
         xdrETvNkwx0K2NmeKIoow9xg3lI3lT8sebHaBUXP9ZLxyEKhMgsB9haUCv+wftzmzu
         4fVR+YlpJIqxdtzVQvg5/aHJQLao+hsdyveE1sNM=
Date:   Tue, 13 Sep 2022 14:54:09 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-quotas-param-generator.patch added to mm-unstable branch
Message-Id: <20220913215410.8078FC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/lru_sort: use quotas param generator
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-lru_sort-use-quotas-param-generator.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-quotas-param-generator.patch

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

