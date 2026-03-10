Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3339D2010EE
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165650; cv=none; b=ADpLwAqK7KXbJOr7H9Ofl8If2aBby+lxijp6gX3oRbX2mPYr2yTjei9K25BcYPx805G189KBFrQVSMgpyXg36OlVXEUN3ud/MWMEcRIUolhdMLjwMwBdZ2+FWNT+5aMRzWYYjV2o+IHaguignzpIRraYp/dTk5+y2ox9ZfYAGL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165650; c=relaxed/simple;
	bh=Lq1Wjc4xs3KW/MKBN9thqxBCgmNWSQ1XGLONp9XJAsU=;
	h=Date:To:From:Subject:Message-Id; b=jPoqZcvhksqVqmW5d/JhnS8dm+pd3/lwirvQDEN5e3fn7KTVwCh9VLLY3ERv2zLE1kE84uJDbWSQfOYyAJ2iKiT9kG+98lPJZYpwjG4VPg6WO8UTODel5mB1CWv7NEt8aYupFFbY/laiuI1wgbLXvLk6tm8iW9IKJJgNG7oR29M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vie7dEe7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vie7dEe7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC037C19423;
	Tue, 10 Mar 2026 18:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165649;
	bh=Lq1Wjc4xs3KW/MKBN9thqxBCgmNWSQ1XGLONp9XJAsU=;
	h=Date:To:From:Subject:From;
	b=Vie7dEe7qv0d/HB0lOHL8AJsMSDIn7WDVSvfqlpTeMpgA+DJmkpLK8lV9B22F1OTa
	 CXokCoZBQ1KgkznNAQ6mr4hKuOw7GbuvAZHf2/YbPBPUE2SDvUNcLRzhXChlLEjqOz
	 J/Qxz4goX4lbuSunPNt2LGKCDyYoMd9SDy6gACz8=
Date: Tue, 10 Mar 2026 11:00:49 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch added to mm-new branch
Message-Id: <20260310180049.CC037C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL
Date: Mon, 9 Mar 2026 18:05:19 -0700

Introduce a new goal-based DAMOS quota auto-tuning algorithm, namely
DAMOS_QUOTA_GOAL_TUNER_TEMPORAL (temporal in short).  The algorithm aims
to trigger the DAMOS action only for a temporal time, to achieve the goal
as soon as possible.  For the temporal period, it uses as much quota as
allowed.  Once the goal is achieved, it sets the quota zero, so
effectively makes the scheme be deactivated.

Link: https://lkml.kernel.org/r/20260310010529.91162-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    2 ++
 mm/damon/core.c       |   29 ++++++++++++++++++++++++-----
 2 files changed, 26 insertions(+), 5 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos_quota_goal_tuner_temporal
+++ a/include/linux/damon.h
@@ -218,9 +218,11 @@ struct damos_quota_goal {
 /**
  * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
  * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ * @DAMOS_QUOTA_GOAL_TUNER_TEMPORAL:	Aim zero quota asap.
  */
 enum damos_quota_goal_tuner {
 	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+	DAMOS_QUOTA_GOAL_TUNER_TEMPORAL,
 };
 
 /**
--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal_tuner_temporal
+++ a/mm/damon/core.c
@@ -2345,6 +2345,26 @@ static unsigned long damos_quota_score(s
 	return highest_score;
 }
 
+static void damos_goal_tune_esz_bp_consist(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	quota->esz_bp = damon_feed_loop_next_input(
+			max(quota->esz_bp, 10000UL), score);
+}
+
+static void damos_goal_tune_esz_bp_temporal(struct damos_quota *quota)
+{
+	unsigned long score = damos_quota_score(quota);
+
+	if (score >= 10000)
+		quota->esz_bp = 0;
+	else if (quota->sz)
+		quota->esz_bp = quota->sz * 10000;
+	else
+		quota->esz_bp = ULONG_MAX;
+}
+
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
@@ -2359,11 +2379,10 @@ static void damos_set_effective_quota(st
 	}
 
 	if (!list_empty(&quota->goals)) {
-		unsigned long score = damos_quota_score(quota);
-
-		quota->esz_bp = damon_feed_loop_next_input(
-				max(quota->esz_bp, 10000UL),
-				score);
+		if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_CONSIST)
+			damos_goal_tune_esz_bp_consist(quota);
+		else if (quota->goal_tuner == DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
+			damos_goal_tune_esz_bp_temporal(quota);
 		esz = quota->esz_bp / 10000;
 	}
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch

