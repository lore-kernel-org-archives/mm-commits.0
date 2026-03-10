Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D4623CFF42
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165648; cv=none; b=LNig1Hm1HI8blgvU5cw0YgStJnDyzjvP2Gmx/vAwjsa/PbpCQiVLafNuD2/sybtXrNqDqkLWB7Rrim8KWIfXojQ2f4HIE3oZR6dXHFf9aIuA8T/2ydAt1RuNaUG9ozdMaYN6lFH6vGRhj69d1g8qi+7d57NXWDmVWoR7toMyLzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165648; c=relaxed/simple;
	bh=gng7rf7KReq1DvFmMeMCWjfj9czaqRy+3TJZ3iuZPZM=;
	h=Date:To:From:Subject:Message-Id; b=qeG2dOJIrCjrQaoVfQn02GhrU48Wyyi2fsT/flYbwVWnPLQeuxXP2ug4tPnJbNPuWsPXoDCDjCqg7YTQbn37ZwH+7RATtbxAt0SjYRQR9NJlNu2wt5Szkb1nAwcXg0H8YrbePhfJZ/iKvsa+Sk1uP/C4CVDXFvfgeRnTgANrY1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qK1hY649; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qK1hY649"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D65C19423;
	Tue, 10 Mar 2026 18:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165647;
	bh=gng7rf7KReq1DvFmMeMCWjfj9czaqRy+3TJZ3iuZPZM=;
	h=Date:To:From:Subject:From;
	b=qK1hY649SwbcDmTXUW5c1M8tWYVIhpR6lUoPdstjCRVWRewTFxvP+p9aVgGznL8QB
	 ZpMjdSTrYrA0guAh2kfoURDwJnD99E/eNrE+NEUr1PbGmQAkcSBSV8cT4Q+rfN4tli
	 j4qgcsATHYltIcptZYw0gh4fuDbqS5LtxB+YuWsA=
Date: Tue, 10 Mar 2026 11:00:47 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch added to mm-new branch
Message-Id: <20260310180047.B6D65C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: allow quota goals set zero effective size quota
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch

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
Subject: mm/damon/core: allow quota goals set zero effective size quota
Date: Mon, 9 Mar 2026 18:05:18 -0700

User-explicit quotas (size and time quotas) having zero value means the
quotas are unset.  And, effective size quota is set as the minimum value
of the explicit quotas.  When quota goals are set, the goal-based quota
tuner can make it lower.  But the existing only single tuner never sets
the effective size quota zero.  Because of the fact, DAMON core assumes
zero effective quota means the user has set no quota.

Multiple tuners are now allowed, though.  In the future, some tuners might
want to set a zero effective size quota.  There is no reason to restrict
that.  Meanwhile, because of the current implementation, it will only
deactivate all quotas and make the scheme work at its full speed.

Introduce a dedicated function for checking if no quota is set.  The
function checks the fact by showing if the user-set explicit quotas are
zero and no goal is installed.  It is decoupled from zero effective quota,
and hence allows future tuners set zero effective quota for intentionally
deactivating the scheme by a purpose.

Link: https://lkml.kernel.org/r/20260310010529.91162-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   31 ++++++++++++++++++++++++++-----
 1 file changed, 26 insertions(+), 5 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-allow-quota-goals-set-zero-effective-size-quota
+++ a/mm/damon/core.c
@@ -387,6 +387,11 @@ void damos_destroy_quota_goal(struct dam
 	damos_free_quota_goal(g);
 }
 
+static bool damos_quota_goals_empty(struct damos_quota *q)
+{
+	return list_empty(&q->goals);
+}
+
 /* initialize fields of @quota that normally API users wouldn't set */
 static struct damos_quota *damos_quota_init(struct damos_quota *quota)
 {
@@ -1789,12 +1794,24 @@ static bool __damos_valid_target(struct
 		r->age <= s->pattern.max_age_region;
 }
 
+/*
+ * damos_quota_is_set() - Return if the given quota is actually set.
+ * @quota:	The quota to check.
+ *
+ * Returns true if the quota is set, false otherwise.
+ */
+static bool damos_quota_is_set(struct damos_quota *quota)
+{
+	return quota->esz || quota->sz || quota->ms ||
+		!damos_quota_goals_empty(quota);
+}
+
 static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
 		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
-	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
+	if (!ret || !damos_quota_is_set(&s->quota) || !c->ops.get_scheme_score)
 		return ret;
 
 	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
@@ -2064,7 +2081,8 @@ static void damos_apply_scheme(struct da
 	}
 
 	if (c->ops.apply_scheme) {
-		if (quota->esz && quota->charged_sz + sz > quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz + sz > quota->esz) {
 			sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
 					c->min_region_sz);
 			if (!sz)
@@ -2083,7 +2101,8 @@ static void damos_apply_scheme(struct da
 		quota->total_charged_ns += timespec64_to_ns(&end) -
 			timespec64_to_ns(&begin);
 		quota->charged_sz += sz;
-		if (quota->esz && quota->charged_sz >= quota->esz) {
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
 			quota->charge_addr_from = r->ar.end + 1;
 		}
@@ -2111,7 +2130,8 @@ static void damon_do_apply_schemes(struc
 			continue;
 
 		/* Check the quota */
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			continue;
 
 		if (damos_skip_charged_region(t, r, s, c->min_region_sz))
@@ -2396,7 +2416,8 @@ static void damos_adjust_quota(struct da
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
 				msecs_to_jiffies(quota->reset_interval))) {
-		if (quota->esz && quota->charged_sz >= quota->esz)
+		if (damos_quota_is_set(quota) &&
+				quota->charged_sz >= quota->esz)
 			s->stat.qt_exceeds++;
 		quota->total_charged_sz += quota->charged_sz;
 		quota->charged_from = jiffies;
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

