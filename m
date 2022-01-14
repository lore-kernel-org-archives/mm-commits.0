Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9B9C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbiANWKW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:10:22 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:38468 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiANWKV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:10:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2AD6CE19A9
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8A0C36AEC;
        Fri, 14 Jan 2022 22:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198218;
        bh=p3sRxf5KPrCsfdnLLYtlaAUPCoyKYoRrNnN/gDyVi5Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=brLFC7zqfiR+AEIfjjY4IbSoZBQOhgJH57wsYTNTd8vjYftbbZzWZfZdGbePQnVBg
         vm9ELWtxClaIzLmWkAdo9GKXG55VyepUsjUShlnbnDquew9vhyDS9LkC2bwnOnamqr
         oxRoRDmDTVczDJIrXix3QBY4aUNIIUordIkHcx08=
Date:   Fri, 14 Jan 2022 14:10:17 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sj@kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 135/146] mm/damon/schemes: account scheme actions
 that successfully applied
Message-ID: <20220114221017.9wTeZ8OM6%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/schemes: account scheme actions that successfully applied

Patch series "mm/damon/schemes: Extend stats for better online analysis and tuning".

To help online access pattern analysis and tuning of DAMON-based Operation
Schemes (DAMOS), DAMOS provides simple statistics for each scheme. 
Introduction of DAMOS time/space quota further made the tuning easier by
making the risk management easier.  However, that also made understanding
of the working schemes a little bit more difficult.

For an example, progress of a given scheme can now be throttled by not
only the aggressiveness of the target access pattern, but also the
time/space quotas.  So, when a scheme is showing unexpectedly slow
progress, it's difficult to know by what the progress of the scheme is
throttled, with currently provided statistics.

This patchset extends the statistics to contain some metrics that can be
helpful for such online schemes analysis and tuning (patches 1-2), exports
those to users (patches 3 and 5), and add documents (patches 4 and 6).


This patch (of 6):

DAMON-based operation schemes (DAMOS) stats provide only the number and
the amount of regions that the action of the scheme has tried to be
applied.  Because the action could be failed for some reasons, the
currently provided information is sometimes not useful or convenient
enough for schemes profiling and tuning.  To improve this situation, this
commit extends the DAMOS stats to provide the number and the amount of
regions that the action has successfully applied.

Link: https://lkml.kernel.org/r/20211210150016.35349-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20211210150016.35349-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   28 +++++++++++++++++++++-------
 mm/damon/core.c       |   13 ++++++++-----
 mm/damon/dbgfs.c      |    2 +-
 mm/damon/paddr.c      |   13 +++++++------
 mm/damon/vaddr.c      |   30 ++++++++++++++++--------------
 5 files changed, 53 insertions(+), 33 deletions(-)

--- a/include/linux/damon.h~mm-damon-schemes-account-scheme-actions-that-successfully-applied
+++ a/include/linux/damon.h
@@ -193,6 +193,20 @@ struct damos_watermarks {
 };
 
 /**
+ * struct damos_stat - Statistics on a given scheme.
+ * @nr_tried:	Total number of regions that the scheme is tried to be applied.
+ * @sz_tried:	Total size of regions that the scheme is tried to be applied.
+ * @nr_applied:	Total number of regions that the scheme is applied.
+ * @sz_applied:	Total size of regions that the scheme is applied.
+ */
+struct damos_stat {
+	unsigned long nr_tried;
+	unsigned long sz_tried;
+	unsigned long nr_applied;
+	unsigned long sz_applied;
+};
+
+/**
  * struct damos - Represents a Data Access Monitoring-based Operation Scheme.
  * @min_sz_region:	Minimum size of target regions.
  * @max_sz_region:	Maximum size of target regions.
@@ -203,8 +217,7 @@ struct damos_watermarks {
  * @action:		&damo_action to be applied to the target regions.
  * @quota:		Control the aggressiveness of this scheme.
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
- * @stat_count:		Total number of regions that this scheme is applied.
- * @stat_sz:		Total size of regions that this scheme is applied.
+ * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
  *
  * For each aggregation interval, DAMON finds regions which fit in the
@@ -235,8 +248,7 @@ struct damos {
 	enum damos_action action;
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
-	unsigned long stat_count;
-	unsigned long stat_sz;
+	struct damos_stat stat;
 	struct list_head list;
 };
 
@@ -281,7 +293,8 @@ struct damon_ctx;
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
  * DAMON-based operation scheme is found.  It should apply the scheme's action
- * to the region.
+ * to the region and return bytes of the region that the action is successfully
+ * applied.
  * @target_valid should check whether the target is still valid for the
  * monitoring.
  * @cleanup is called from @kdamond just before its termination.
@@ -295,8 +308,9 @@ struct damon_primitive {
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
-	int (*apply_scheme)(struct damon_ctx *context, struct damon_target *t,
-			struct damon_region *r, struct damos *scheme);
+	unsigned long (*apply_scheme)(struct damon_ctx *context,
+			struct damon_target *t, struct damon_region *r,
+			struct damos *scheme);
 	bool (*target_valid)(void *target);
 	void (*cleanup)(struct damon_ctx *context);
 };
--- a/mm/damon/core.c~mm-damon-schemes-account-scheme-actions-that-successfully-applied
+++ a/mm/damon/core.c
@@ -102,8 +102,7 @@ struct damos *damon_new_scheme(
 	scheme->min_age_region = min_age_region;
 	scheme->max_age_region = max_age_region;
 	scheme->action = action;
-	scheme->stat_count = 0;
-	scheme->stat_sz = 0;
+	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota.ms = quota->ms;
@@ -574,6 +573,7 @@ static void damon_do_apply_schemes(struc
 		struct damos_quota *quota = &s->quota;
 		unsigned long sz = r->ar.end - r->ar.start;
 		struct timespec64 begin, end;
+		unsigned long sz_applied = 0;
 
 		if (!s->wmarks.activated)
 			continue;
@@ -627,7 +627,7 @@ static void damon_do_apply_schemes(struc
 				damon_split_region_at(c, t, r, sz);
 			}
 			ktime_get_coarse_ts64(&begin);
-			c->primitive.apply_scheme(c, t, r, s);
+			sz_applied = c->primitive.apply_scheme(c, t, r, s);
 			ktime_get_coarse_ts64(&end);
 			quota->total_charged_ns += timespec64_to_ns(&end) -
 				timespec64_to_ns(&begin);
@@ -641,8 +641,11 @@ static void damon_do_apply_schemes(struc
 			r->age = 0;
 
 update_stat:
-		s->stat_count++;
-		s->stat_sz += sz;
+		s->stat.nr_tried++;
+		s->stat.sz_tried += sz;
+		if (sz_applied)
+			s->stat.nr_applied++;
+		s->stat.sz_applied += sz_applied;
 	}
 }
 
--- a/mm/damon/dbgfs.c~mm-damon-schemes-account-scheme-actions-that-successfully-applied
+++ a/mm/damon/dbgfs.c
@@ -117,7 +117,7 @@ static ssize_t sprint_schemes(struct dam
 				s->quota.weight_age,
 				s->wmarks.metric, s->wmarks.interval,
 				s->wmarks.high, s->wmarks.mid, s->wmarks.low,
-				s->stat_count, s->stat_sz);
+				s->stat.nr_tried, s->stat.sz_tried);
 		if (!rc)
 			return -ENOMEM;
 
--- a/mm/damon/paddr.c~mm-damon-schemes-account-scheme-actions-that-successfully-applied
+++ a/mm/damon/paddr.c
@@ -213,14 +213,15 @@ bool damon_pa_target_valid(void *t)
 	return true;
 }
 
-static int damon_pa_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
-	unsigned long addr;
+	unsigned long addr, applied;
 	LIST_HEAD(page_list);
 
 	if (scheme->action != DAMOS_PAGEOUT)
-		return -EINVAL;
+		return 0;
 
 	for (addr = r->ar.start; addr < r->ar.end; addr += PAGE_SIZE) {
 		struct page *page = damon_get_page(PHYS_PFN(addr));
@@ -241,9 +242,9 @@ static int damon_pa_apply_scheme(struct
 			put_page(page);
 		}
 	}
-	reclaim_pages(&page_list);
+	applied = reclaim_pages(&page_list);
 	cond_resched();
-	return 0;
+	return applied * PAGE_SIZE;
 }
 
 static int damon_pa_scheme_score(struct damon_ctx *context,
--- a/mm/damon/vaddr.c~mm-damon-schemes-account-scheme-actions-that-successfully-applied
+++ a/mm/damon/vaddr.c
@@ -572,32 +572,34 @@ bool damon_va_target_valid(void *target)
 }
 
 #ifndef CONFIG_ADVISE_SYSCALLS
-static int damos_madvise(struct damon_target *target, struct damon_region *r,
-			int behavior)
+static unsigned long damos_madvise(struct damon_target *target,
+		struct damon_region *r, int behavior)
 {
-	return -EINVAL;
+	return 0;
 }
 #else
-static int damos_madvise(struct damon_target *target, struct damon_region *r,
-			int behavior)
+static unsigned long damos_madvise(struct damon_target *target,
+		struct damon_region *r, int behavior)
 {
 	struct mm_struct *mm;
-	int ret = -ENOMEM;
+	unsigned long start = PAGE_ALIGN(r->ar.start);
+	unsigned long len = PAGE_ALIGN(r->ar.end - r->ar.start);
+	unsigned long applied;
 
 	mm = damon_get_mm(target);
 	if (!mm)
-		goto out;
+		return 0;
 
-	ret = do_madvise(mm, PAGE_ALIGN(r->ar.start),
-			PAGE_ALIGN(r->ar.end - r->ar.start), behavior);
+	applied = do_madvise(mm, start, len, behavior) ? 0 : len;
 	mmput(mm);
-out:
-	return ret;
+
+	return applied;
 }
 #endif	/* CONFIG_ADVISE_SYSCALLS */
 
-static int damon_va_apply_scheme(struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos *scheme)
+static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
+		struct damon_target *t, struct damon_region *r,
+		struct damos *scheme)
 {
 	int madv_action;
 
@@ -620,7 +622,7 @@ static int damon_va_apply_scheme(struct
 	case DAMOS_STAT:
 		return 0;
 	default:
-		return -EINVAL;
+		return 0;
 	}
 
 	return damos_madvise(t, r, madv_action);
_
