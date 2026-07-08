Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD453F6C5A
	for <mm-commits@vger.kernel.org>; Wed,  8 Jul 2026 21:47:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783547236; cv=none; b=kDAK9PHuEkXr+dyP1fJKSyEvMrAHW9420y68V0r5t+3A0Releis/4R/4P+/+QmB1yjHf2XBEqS+FugvkI5XcXhO0ASPb9FicY7rQegWJZ3kQCfcwbTsH7ctEgqlM1+kIIYJIOMjk1DDHovpcCXDFHbDOCH7tM+wotTzyLkzGcPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783547236; c=relaxed/simple;
	bh=OTn9k5yRTLFyN+sDsUq/cZgLZxVIjtZ4ktI8+4Tzs0Y=;
	h=Date:To:From:Subject:Message-Id; b=r0q66sKIVJGqm3bxL+oAXu8856hNTP/8kdG9TFYO+uzEzDClfPFgUHplAegF2AVFUotjSIiHfwZsjXBoUp6/eQcWpqFmWaKgZq1x/xwzIBk6LQw5L/nqANNxmdyEd3VXWIyY541+KGtUOVj1DitY/DAGsZseRhIpln0bcaBhPTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sl3chcQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sl3chcQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A411F00A3A;
	Wed,  8 Jul 2026 21:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783547234;
	bh=t6bsnlRexYeEboEWOE9j9DcIAB+x5jCxDwaVsP1tnPg=;
	h=Date:To:From:Subject;
	b=sl3chcQBOU69vs8qoSWh+Zu96LEODIP6p2f6kZ9sPe7nB2Z/44QAZQjCal2v79owm
	 9+3YYnjGhUiWAfNWZxW/OZYIDWxGii2m7XatGaLvKe5NTx9+F4CNdqLSdm+UEralC+
	 V9Vrm/gPcjWci6Ueij6Y0+6/HGLvBh+B4YdzH6JY=
Date: Wed, 08 Jul 2026 14:47:13 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch added to mm-new branch
Message-Id: <20260708214714.34A411F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: s/damon_max_nr_accesses()/damon_nr_samples_per_aggr()/
Date: Wed, 8 Jul 2026 06:53:52 -0700

damon_max_nr_accesses() actually returns the number of samples DAMON
checks for each region per each aggregation interval.  Rename it to better
describe what it really does and not confusing for more general uses.

Link: https://lore.kernel.org/20260708135359.122587-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 ++++++----
 mm/damon/core.c       |    4 ++--
 mm/damon/lru_sort.c   |    2 +-
 mm/damon/ops-common.c |    2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

--- a/include/linux/damon.h~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/include/linux/damon.h
@@ -1056,15 +1056,17 @@ static inline bool damon_target_has_pid(
 	return ctx->ops.id == DAMON_OPS_VADDR || ctx->ops.id == DAMON_OPS_FVADDR;
 }
 
-static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
+/* Returns number of samples per aggregation interval */
+static inline unsigned int damon_nr_samples_per_aggr(
+		const struct damon_attrs *attrs)
 {
 	unsigned long sample_interval;
-	unsigned long max_nr_accesses;
+	unsigned long nr_samples;
 
 	sample_interval = attrs->sample_interval ? : 1;
-	max_nr_accesses = min(attrs->aggr_interval / sample_interval,
+	nr_samples = min(attrs->aggr_interval / sample_interval,
 			(unsigned long)UINT_MAX);
-	return max_nr_accesses ? : 1;
+	return nr_samples ? : 1;
 }
 
 
--- a/mm/damon/core.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/core.c
@@ -880,14 +880,14 @@ static unsigned int damon_age_for_new_at
 static unsigned int damon_accesses_bp_to_nr_accesses(
 		unsigned int accesses_bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
+	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
-	return mult_frac(nr_accesses, 10000, damon_max_nr_accesses(attrs));
+	return mult_frac(nr_accesses, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
--- a/mm/damon/lru_sort.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/lru_sort.c
@@ -303,7 +303,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 
 	err = -ENOMEM;
-	hot_thres = damon_max_nr_accesses(&attrs) *
+	hot_thres = damon_nr_samples_per_aggr(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
--- a/mm/damon/ops-common.c~mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr
+++ a/mm/damon/ops-common.c
@@ -112,7 +112,7 @@ int damon_hot_score(struct damon_ctx *c,
 	int hotness;
 
 	freq_subscore = r->nr_accesses * DAMON_MAX_SUBSCORE /
-		damon_max_nr_accesses(&c->attrs);
+		damon_nr_samples_per_aggr(&c->attrs);
 
 	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
 	if (age_in_sec)
_

Patches currently in -mm which might be from sj@kernel.org are

maintainers-s-seongjae-sj.patch
mm-damon-core-validate-ranges-in-damon_set_regions.patch
mm-damon-core-disallow-overlapping-input-ranges-for-damon_set_regions.patch
samples-damon-wsse-handle-damon_start-failure.patch
samples-damon-prcl-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_start-failure.patch
samples-damon-mtier-handle-damon_stop-failure.patch
samples-damon-wsse-stop-and-free-damon-ctx-when-damon_call-fails.patch
samples-damon-prcl-stop-and-free-damon-ctx-when-damon_call-fails.patch
mm-damon-sysfs-kobject_del-target-normal-context-and-kdamond-dirs.patch
mm-damon-sysfs-kobject_del-region-and-target-error-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-region-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-filter-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-quota-goal-dirs.patch
mm-damon-sysfs-schemes-kobject_del-scheme-action-destination-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs.patch
mm-damon-sysfs-kobject_del-probe-filter-dirs.patch
mm-damon-sysfs-kobject_del-probe-dirs-in-probes_addd_dir-error-path.patch
mm-damon-sysfs-schemes-kobject_del-region-for-populate_region-error.patch
docs-mm-damon-design-update-for-damos_quota_node_eligible_mem_bp.patch
docs-abi-damon-document-probe-files.patch
mm-damon-tests-core-kunit-test-damon_rand.patch
selftests-damon-sysfssh-test-multiple-probe-dirs-creation.patch
selftests-damon-sysfssh-test-coreops_filters-directories.patch
selftests-damon-sysfssh-test-dests-dir.patch
selftests-damon-sysfssh-test-all-files-in-quota-goal-dir.patch
mm-damon-core-reduce-range-setup-in-damon_commit_target_regions.patch
mm-damon-sysfs-split-probe-setup-function-out.patch
mm-damon-sysfs-split-out-filters-setup-function.patch
mm-damon-sysfs-fix-typos-in-probe_addrm_dirs-s-attr-probe.patch
mm-damon-core-introduce-damon_nr_accesses_mvsum.patch
mm-damon-tests-core-kunit-test-damon_mvsum.patch
mm-damon-core-always-update-last_nr_accesses-for-intervals-change.patch
mm-damon-core-handle-unreset-nr_accesses-in-damon_nr_accesses_mvsum.patch
mm-damon-core-use-damon_nr_accesses_mvsum-in-__damos_valid_target.patch
mm-damon-core-use-damon_nr_accesses_mvsum-for-damos-region-tracing.patch
mm-damon-sysfs-schemes-use-damon_nr_accesses_mvsum-for-damo-regions.patch
mm-damon-core-remove-damon_warn_fix_nr_accesses_corruption.patch
mm-damon-core-remove-damon_verify_reset_aggregated.patch
mm-damon-core-remove-damon_verify_merge_regions_of.patch
mm-damon-tests-core-kunit-remove-nr_accesses_bp-setup-and-tests.patch
selftests-damon-drgn_dump_damon_status-do-not-dump-nr_accesses_bp.patch
mm-damon-core-remove-nr_accesses_bp-setups-and-updates.patch
mm-damon-core-remove-attrs-param-from-damon_update_region_access_rate.patch
mm-damon-paddr-remove-attrs-param-from-__damon_pa_check_access.patch
mm-damon-vaddr-remove-attrs-param-from-__damon_va_check_access.patch
mm-damon-core-remove-damon_moving_sum-and-its-unit-test.patch
mm-damon-core-remove-damon_region-nr_accesses_bp.patch
mm-damon-add-damon_region-last_probe_hits.patch
mm-damon-core-introduce-damon_probe_hits_mvsum.patch
mm-damon-sysfs-schemes-set-probe-hits-as-pseudo-moving-sums.patch
mm-damon-core-safely-validate-src-on-damon_commit_ctx.patch
mm-damon-core-do-parameter-testing-commit-on-damon_start.patch
mm-damon-sysfs-remove-duplicated-commit-input-validity-check.patch
mm-damon-reclaim-remove-duplicated-min_region_sz-power-of-2-check.patch
mm-damon-lru_sort-remove-duplicated-min_region_sz-power_of_2-check.patch
mm-damon-document-region-size-validation-in-damon_set_regions.patch
mm-damon-core-remove-start-end-check-in-damon_set_region_system_rams.patch
mm-damon-sysfs-remove-region-size-validation.patch
mm-damon-core-stop-ctxs-in-damon_start-before-returning-an-error.patch
samples-damon-mtier-do-not-stop-first-context-for-damon_start-failure.patch
mm-damon-core-make-damon_stop-never-fails.patch
mm-damon-sysfs-ignore-damon_stop-return-value.patch
mm-damon-reclaaim-ignore-damon_stop-return-value.patch
mm-damon-lru_sort-ignore-damon_stop-return-value.patch
mm-damon-core-change-damon_stop-return-type-to-void.patch
samples-damon-mtier-stop-all-contexts-with-single-damon_stop-call.patch
mm-damon-core-wait-ctx-stop-in-damon_call-before-reruning-an-error.patch
samples-damon-wsse-do-not-stop-ctx-for-damon_call-failure.patch
samples-damon-prcl-do-not-stop-damon-for-damon_call-failure.patch
mm-damon-core-remove-comment-and-test-for-nr_to_bp-divide-by-zero.patch
mm-damon-core-s-damon_max_nr_accesses-damon_nr_samples_per_aggr.patch
mm-damon-core-s-accesses_bp_to_nr_accesses-sample_bp_to_count.patch
mm-damon-core-s-nr_accesses_to_accesses_bp-sample_count_to_bp.patch
mm-damon-core-s-nr_accesses_for_new_attrs-nr_samples_for_new_attrs.patch
mm-damon-core-update-probe-hits-for-new-parameter-commit.patch
mm-damon-core-handle-unreset-probe_hits-in-probe_hits_mvsum.patch

