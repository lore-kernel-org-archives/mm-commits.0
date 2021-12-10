Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879FDC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 10 Dec 2021 16:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244018AbhLJQx6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 10 Dec 2021 11:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233753AbhLJQx5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 10 Dec 2021 11:53:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A665EC0617A1
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 08:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D864B828D7
        for <mm-commits@vger.kernel.org>; Fri, 10 Dec 2021 16:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A58C341C6;
        Fri, 10 Dec 2021 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639155020;
        bh=f9KsL/ff0wWnadIQb3he/DJC+33etHsmrTjJzOYhSNA=;
        h=Date:From:To:Subject:From;
        b=jFpiAnyVepS0pw/4clDBrkLh0tOrKU+kMv6F19ZGqsf+ms33RIXh5WkinOUXPx33B
         AxEpqZwhfdWMz8edgwZTcfs0XM4oqUJLgW+98WOTwq03GTab6nHb6XrWFuN9JyXUrz
         3QGaGfBQxEfZcgqeqkbUWxUtBakrHk+Ls3WTKLeg=
Date:   Fri, 10 Dec 2021 08:50:19 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, sj@kernel.org
Subject:  +
 mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
 added to -mm tree
Message-ID: <20211210165019.BLDfmLRKo%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/damon/schemes: account scheme actions that successfully applied
has been added to the -mm tree.  Its filename is
     mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from sj@kernel.org are

timers-implement-usleep_idle_range.patch
mm-damon-core-fix-fake-load-reports-due-to-uninterruptible-sleeps.patch
mm-damon-core-use-better-timer-mechanisms-selection-threshold.patch
mm-damon-dbgfs-remove-an-unnecessary-error-message.patch
mm-damon-core-remove-unnecessary-error-messages.patch
mm-damon-vaddr-remove-an-unnecessary-warning-message.patch
mm-damon-vaddr-test-split-a-test-function-having-1024-bytes-frame-size.patch
mm-damon-vaddr-test-remove-unnecessary-variables.patch
selftests-damon-skip-test-if-damon-is-running.patch
selftests-damon-test-damon-enabling-with-empty-target_ids-case.patch
selftests-damon-test-wrong-damos-condition-ranges-input.patch
selftests-damon-test-debugfs-file-reads-writes-with-huge-count.patch
selftests-damon-split-test-cases.patch
mm-damon-remove-some-no-need-func-definitions-in-damonh-file-fix.patch
mm-damon-convert-macro-functions-to-static-inline-functions.patch
docs-admin-guide-mm-damon-usage-update-for-scheme-quotas-and-watermarks.patch
docs-admin-guide-mm-damon-usage-remove-redundant-information.patch
docs-admin-guide-mm-damon-usage-mention-tracepoint-at-the-beginning.patch
docs-admin-guide-mm-damon-usage-update-for-kdamond_pid-and-mkrm_contexts.patch
mm-damon-remove-a-mistakenly-added-comment-for-a-future-feature.patch
mm-damon-schemes-account-scheme-actions-that-successfully-applied.patch
mm-damon-schemes-account-how-many-times-quota-limit-has-exceeded.patch
mm-damon-reclaim-provide-reclamation-statistics.patch
docs-admin-guide-mm-damon-reclaim-document-statistics-parameters.patch
mm-damon-dbgfs-support-all-damos-stats.patch
docs-admin-guide-mm-damon-usage-update-for-schemes-statistics.patch

