Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2255C54EE9
	for <mm-commits@archiver.kernel.org>; Thu,  8 Sep 2022 20:42:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbiIHUmd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Sep 2022 16:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIHUmc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2022 16:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA26AD983
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 13:42:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7868E61E29
        for <mm-commits@vger.kernel.org>; Thu,  8 Sep 2022 20:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0ECC433D6;
        Thu,  8 Sep 2022 20:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662669749;
        bh=TPDqdJiTabXrkJAyGOO+ekUECfL3UMvAN/fjUiBaHmQ=;
        h=Date:To:From:Subject:From;
        b=hfZ9Bf6NGZkckuvVNmU9TIju1O82OF1ElQATLUFg6v+zRcr0IWfI8LaUz5aB11R9G
         CSb2CAJosZ6PdgDTl8Rf4yzFdD2/vFICh+FNYfJBnynkXFRpEQsg6ZvV4RCBccMiN+
         BidrYry13vsscH8rprenTt3gZM0R4OWWPDFMR8Cs=
Date:   Thu, 08 Sep 2022 13:42:28 -0700
To:     mm-commits@vger.kernel.org, sj@kernel.org, yajun.deng@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-struct-damos_access_pattern.patch added to mm-unstable branch
Message-Id: <20220908204229.BF0ECC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon: introduce struct damos_access_pattern
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-introduce-struct-damos_access_pattern.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-struct-damos_access_pattern.patch

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
From: Yajun Deng <yajun.deng@linux.dev>
Subject: mm/damon: introduce struct damos_access_pattern
Date: Thu, 8 Sep 2022 19:14:43 +0000

damon_new_scheme() has too many parameters, so introduce struct
damos_access_pattern to simplify it.

In additon, we can't use a bpf trace kprobe that has more than 5
parameters.

Link: https://lkml.kernel.org/r/20220908191443.129534-1-sj@kernel.org
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   37 +++++++++++++++++---------------
 mm/damon/core.c       |   31 +++++++++++++-------------
 mm/damon/dbgfs.c      |   27 ++++++++++++++---------
 mm/damon/lru_sort.c   |   46 ++++++++++++++++++++++++----------------
 mm/damon/reclaim.c    |   23 ++++++++++++--------
 mm/damon/sysfs.c      |   17 ++++++++++----
 6 files changed, 106 insertions(+), 75 deletions(-)

--- a/include/linux/damon.h~mm-damon-introduce-struct-damos_access_pattern
+++ a/include/linux/damon.h
@@ -216,13 +216,26 @@ struct damos_stat {
 };
 
 /**
- * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
+ * struct damos_access_pattern - Target access pattern of the given scheme.
  * @min_sz_region:	Minimum size of target regions.
  * @max_sz_region:	Maximum size of target regions.
  * @min_nr_accesses:	Minimum ``->nr_accesses`` of target regions.
  * @max_nr_accesses:	Maximum ``->nr_accesses`` of target regions.
  * @min_age_region:	Minimum age of target regions.
  * @max_age_region:	Maximum age of target regions.
+ */
+struct damos_access_pattern {
+	unsigned long min_sz_region;
+	unsigned long max_sz_region;
+	unsigned int min_nr_accesses;
+	unsigned int max_nr_accesses;
+	unsigned int min_age_region;
+	unsigned int max_age_region;
+};
+
+/**
+ * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
+ * @pattern:		Access pattern of target regions.
  * @action:		&damo_action to be applied to the target regions.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
@@ -230,10 +243,8 @@ struct damos_stat {
  * @list:		List head for siblings.
  *
  * For each aggregation interval, DAMON finds regions which fit in the
- * condition (&min_sz_region, &max_sz_region, &min_nr_accesses,
- * &max_nr_accesses, &min_age_region, &max_age_region) and applies &action to
- * those.  To avoid consuming too much CPU time or IO resources for the
- * &action, &quota is used.
+ * &pattern and applies &action to those. To avoid consuming too much
+ * CPU time or IO resources for the &action, &quota is used.
  *
  * To do the work only when needed, schemes can be activated for specific
  * system situations using &wmarks.  If all schemes that registered to the
@@ -248,12 +259,7 @@ struct damos_stat {
  * &action is applied.
  */
 struct damos {
-	unsigned long min_sz_region;
-	unsigned long max_sz_region;
-	unsigned int min_nr_accesses;
-	unsigned int max_nr_accesses;
-	unsigned int min_age_region;
-	unsigned int max_age_region;
+	struct damos_access_pattern pattern;
 	enum damos_action action;
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
@@ -509,12 +515,9 @@ void damon_destroy_region(struct damon_r
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges);
 
-struct damos *damon_new_scheme(
-		unsigned long min_sz_region, unsigned long max_sz_region,
-		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
-		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action, struct damos_quota *quota,
-		struct damos_watermarks *wmarks);
+struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
+			enum damos_action action, struct damos_quota *quota,
+			struct damos_watermarks *wmarks);
 void damon_add_scheme(struct damon_ctx *ctx, struct damos *s);
 void damon_destroy_scheme(struct damos *s);
 
--- a/mm/damon/core.c~mm-damon-introduce-struct-damos_access_pattern
+++ a/mm/damon/core.c
@@ -231,24 +231,21 @@ int damon_set_regions(struct damon_targe
 	return 0;
 }
 
-struct damos *damon_new_scheme(
-		unsigned long min_sz_region, unsigned long max_sz_region,
-		unsigned int min_nr_accesses, unsigned int max_nr_accesses,
-		unsigned int min_age_region, unsigned int max_age_region,
-		enum damos_action action, struct damos_quota *quota,
-		struct damos_watermarks *wmarks)
+struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
+			enum damos_action action, struct damos_quota *quota,
+			struct damos_watermarks *wmarks)
 {
 	struct damos *scheme;
 
 	scheme = kmalloc(sizeof(*scheme), GFP_KERNEL);
 	if (!scheme)
 		return NULL;
-	scheme->min_sz_region = min_sz_region;
-	scheme->max_sz_region = max_sz_region;
-	scheme->min_nr_accesses = min_nr_accesses;
-	scheme->max_nr_accesses = max_nr_accesses;
-	scheme->min_age_region = min_age_region;
-	scheme->max_age_region = max_age_region;
+	scheme->pattern.min_sz_region = pattern->min_sz_region;
+	scheme->pattern.max_sz_region = pattern->max_sz_region;
+	scheme->pattern.min_nr_accesses = pattern->min_nr_accesses;
+	scheme->pattern.max_nr_accesses = pattern->max_nr_accesses;
+	scheme->pattern.min_age_region = pattern->min_age_region;
+	scheme->pattern.max_age_region = pattern->max_age_region;
 	scheme->action = action;
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
@@ -667,10 +664,12 @@ static bool __damos_valid_target(struct
 	unsigned long sz;
 
 	sz = r->ar.end - r->ar.start;
-	return s->min_sz_region <= sz && sz <= s->max_sz_region &&
-		s->min_nr_accesses <= r->nr_accesses &&
-		r->nr_accesses <= s->max_nr_accesses &&
-		s->min_age_region <= r->age && r->age <= s->max_age_region;
+	return s->pattern.min_sz_region <= sz &&
+		sz <= s->pattern.max_sz_region &&
+		s->pattern.min_nr_accesses <= r->nr_accesses &&
+		r->nr_accesses <= s->pattern.max_nr_accesses &&
+		s->pattern.min_age_region <= r->age &&
+		r->age <= s->pattern.max_age_region;
 }
 
 static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
--- a/mm/damon/dbgfs.c~mm-damon-introduce-struct-damos_access_pattern
+++ a/mm/damon/dbgfs.c
@@ -131,9 +131,12 @@ static ssize_t sprint_schemes(struct dam
 	damon_for_each_scheme(s, c) {
 		rc = scnprintf(&buf[written], len - written,
 				"%lu %lu %u %u %u %u %d %lu %lu %lu %u %u %u %d %lu %lu %lu %lu %lu %lu %lu %lu %lu\n",
-				s->min_sz_region, s->max_sz_region,
-				s->min_nr_accesses, s->max_nr_accesses,
-				s->min_age_region, s->max_age_region,
+				s->pattern.min_sz_region,
+				s->pattern.max_sz_region,
+				s->pattern.min_nr_accesses,
+				s->pattern.max_nr_accesses,
+				s->pattern.min_age_region,
+				s->pattern.max_age_region,
 				damos_action_to_dbgfs_scheme_action(s->action),
 				s->quota.ms, s->quota.sz,
 				s->quota.reset_interval,
@@ -221,8 +224,6 @@ static struct damos **str_to_schemes(con
 	struct damos *scheme, **schemes;
 	const int max_nr_schemes = 256;
 	int pos = 0, parsed, ret;
-	unsigned long min_sz, max_sz;
-	unsigned int min_nr_a, max_nr_a, min_age, max_age;
 	unsigned int action_input;
 	enum damos_action action;
 
@@ -233,13 +234,18 @@ static struct damos **str_to_schemes(con
 
 	*nr_schemes = 0;
 	while (pos < len && *nr_schemes < max_nr_schemes) {
+		struct damos_access_pattern pattern = {};
 		struct damos_quota quota = {};
 		struct damos_watermarks wmarks;
 
 		ret = sscanf(&str[pos],
 				"%lu %lu %u %u %u %u %u %lu %lu %lu %u %u %u %u %lu %lu %lu %lu%n",
-				&min_sz, &max_sz, &min_nr_a, &max_nr_a,
-				&min_age, &max_age, &action_input, &quota.ms,
+				&pattern.min_sz_region, &pattern.max_sz_region,
+				&pattern.min_nr_accesses,
+				&pattern.max_nr_accesses,
+				&pattern.min_age_region,
+				&pattern.max_age_region,
+				&action_input, &quota.ms,
 				&quota.sz, &quota.reset_interval,
 				&quota.weight_sz, &quota.weight_nr_accesses,
 				&quota.weight_age, &wmarks.metric,
@@ -251,7 +257,9 @@ static struct damos **str_to_schemes(con
 		if ((int)action < 0)
 			goto fail;
 
-		if (min_sz > max_sz || min_nr_a > max_nr_a || min_age > max_age)
+		if (pattern.min_sz_region > pattern.max_sz_region ||
+		    pattern.min_nr_accesses > pattern.max_nr_accesses ||
+		    pattern.min_age_region > pattern.max_age_region)
 			goto fail;
 
 		if (wmarks.high < wmarks.mid || wmarks.high < wmarks.low ||
@@ -259,8 +267,7 @@ static struct damos **str_to_schemes(con
 			goto fail;
 
 		pos += parsed;
-		scheme = damon_new_scheme(min_sz, max_sz, min_nr_a, max_nr_a,
-				min_age, max_age, action, &quota, &wmarks);
+		scheme = damon_new_scheme(&pattern, action, &quota, &wmarks);
 		if (!scheme)
 			goto fail;
 
--- a/mm/damon/lru_sort.c~mm-damon-introduce-struct-damos_access_pattern
+++ a/mm/damon/lru_sort.c
@@ -293,6 +293,17 @@ static bool get_monitoring_region(unsign
 /* Create a DAMON-based operation scheme for hot memory regions */
 static struct damos *damon_lru_sort_new_hot_scheme(unsigned int hot_thres)
 {
+	struct damos_access_pattern pattern = {
+		/* Find regions having PAGE_SIZE or larger size */
+		.min_sz_region = PAGE_SIZE,
+		.max_sz_region = ULONG_MAX,
+		/* and accessed for more than the threshold */
+		.min_nr_accesses = hot_thres,
+		.max_nr_accesses = UINT_MAX,
+		/* no matter its age */
+		.min_age_region = 0,
+		.max_age_region = UINT_MAX,
+	};
 	struct damos_watermarks wmarks = {
 		.metric = DAMOS_WMARK_FREE_MEM_RATE,
 		.interval = wmarks_interval,
@@ -313,26 +324,31 @@ static struct damos *damon_lru_sort_new_
 		.weight_nr_accesses = 1,
 		.weight_age = 0,
 	};
-	struct damos *scheme = damon_new_scheme(
-			/* Find regions having PAGE_SIZE or larger size */
-			PAGE_SIZE, ULONG_MAX,
-			/* and accessed for more than the threshold */
-			hot_thres, UINT_MAX,
-			/* no matter its age */
-			0, UINT_MAX,
+
+	return damon_new_scheme(
+			&pattern,
 			/* prioritize those on LRU lists, as soon as found */
 			DAMOS_LRU_PRIO,
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
 			&wmarks);
-
-	return scheme;
 }
 
 /* Create a DAMON-based operation scheme for cold memory regions */
 static struct damos *damon_lru_sort_new_cold_scheme(unsigned int cold_thres)
 {
+	struct damos_access_pattern pattern = {
+		/* Find regions having PAGE_SIZE or larger size */
+		.min_sz_region = PAGE_SIZE,
+		.max_sz_region = ULONG_MAX,
+		/* and not accessed at all */
+		.min_nr_accesses = 0,
+		.max_nr_accesses = 0,
+		/* for min_age or more micro-seconds */
+		.min_age_region = cold_thres,
+		.max_age_region = UINT_MAX,
+	};
 	struct damos_watermarks wmarks = {
 		.metric = DAMOS_WMARK_FREE_MEM_RATE,
 		.interval = wmarks_interval,
@@ -354,21 +370,15 @@ static struct damos *damon_lru_sort_new_
 		.weight_nr_accesses = 0,
 		.weight_age = 1,
 	};
-	struct damos *scheme = damon_new_scheme(
-			/* Find regions having PAGE_SIZE or larger size */
-			PAGE_SIZE, ULONG_MAX,
-			/* and not accessed at all */
-			0, 0,
-			/* for cold_thres or more micro-seconds, and */
-			cold_thres, UINT_MAX,
+
+	return damon_new_scheme(
+			&pattern,
 			/* mark those as not accessed, as soon as found */
 			DAMOS_LRU_DEPRIO,
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
 			&wmarks);
-
-	return scheme;
 }
 
 static int damon_lru_sort_apply_parameters(void)
--- a/mm/damon/reclaim.c~mm-damon-introduce-struct-damos_access_pattern
+++ a/mm/damon/reclaim.c
@@ -264,6 +264,17 @@ static bool get_monitoring_region(unsign
 
 static struct damos *damon_reclaim_new_scheme(void)
 {
+	struct damos_access_pattern pattern = {
+		/* Find regions having PAGE_SIZE or larger size */
+		.min_sz_region = PAGE_SIZE,
+		.max_sz_region = ULONG_MAX,
+		/* and not accessed at all */
+		.min_nr_accesses = 0,
+		.max_nr_accesses = 0,
+		/* for min_age or more micro-seconds */
+		.min_age_region = min_age / aggr_interval,
+		.max_age_region = UINT_MAX,
+	};
 	struct damos_watermarks wmarks = {
 		.metric = DAMOS_WMARK_FREE_MEM_RATE,
 		.interval = wmarks_interval,
@@ -284,21 +295,15 @@ static struct damos *damon_reclaim_new_s
 		.weight_nr_accesses = 0,
 		.weight_age = 1
 	};
-	struct damos *scheme = damon_new_scheme(
-			/* Find regions having PAGE_SIZE or larger size */
-			PAGE_SIZE, ULONG_MAX,
-			/* and not accessed at all */
-			0, 0,
-			/* for min_age or more micro-seconds, and */
-			min_age / aggr_interval, UINT_MAX,
+
+	return damon_new_scheme(
+			&pattern,
 			/* page out those, as soon as found */
 			DAMOS_PAGEOUT,
 			/* under the quota. */
 			&quota,
 			/* (De)activate this according to the watermarks. */
 			&wmarks);
-
-	return scheme;
 }
 
 static int damon_reclaim_apply_parameters(void)
--- a/mm/damon/sysfs.c~mm-damon-introduce-struct-damos_access_pattern
+++ a/mm/damon/sysfs.c
@@ -2259,11 +2259,20 @@ static int damon_sysfs_set_targets(struc
 static struct damos *damon_sysfs_mk_scheme(
 		struct damon_sysfs_scheme *sysfs_scheme)
 {
-	struct damon_sysfs_access_pattern *pattern =
+	struct damon_sysfs_access_pattern *access_pattern =
 		sysfs_scheme->access_pattern;
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
 	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
+
+	struct damos_access_pattern pattern = {
+		.min_sz_region = access_pattern->sz->min,
+		.max_sz_region = access_pattern->sz->max,
+		.min_nr_accesses = access_pattern->nr_accesses->min,
+		.max_nr_accesses = access_pattern->nr_accesses->max,
+		.min_age_region = access_pattern->age->min,
+		.max_age_region = access_pattern->age->max,
+	};
 	struct damos_quota quota = {
 		.ms = sysfs_quotas->ms,
 		.sz = sysfs_quotas->sz,
@@ -2280,10 +2289,8 @@ static struct damos *damon_sysfs_mk_sche
 		.low = sysfs_wmarks->low,
 	};
 
-	return damon_new_scheme(pattern->sz->min, pattern->sz->max,
-			pattern->nr_accesses->min, pattern->nr_accesses->max,
-			pattern->age->min, pattern->age->max,
-			sysfs_scheme->action, &quota, &wmarks);
+	return damon_new_scheme(&pattern, sysfs_scheme->action, &quota,
+			&wmarks);
 }
 
 static int damon_sysfs_set_schemes(struct damon_ctx *ctx,
_

Patches currently in -mm which might be from yajun.deng@linux.dev are

mm-damon-introduce-struct-damos_access_pattern.patch

