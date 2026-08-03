Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB44432BD4;
	Mon,  3 Aug 2026 18:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785782590; cv=none; b=YbwoYI7tkiz0aU8jffYRqfj0spZWXv/Bv3VILHaeAwShPjZyRzepfNh/NY2i3IsqfsTBK2x1tfoFH82geJxsyM4OqCSZ5Hxn0gUa23/PBAFqr+RBawGxHw5H+L9U3Ca/dqUbV4UMUlFutrBYRMeUHkmhBTZXaCrklHYm/awbK7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785782590; c=relaxed/simple;
	bh=uNlO3tqbOuLT86ykyFyugJ4yF5zhoEDMBgQhfCfbmUk=;
	h=Date:To:From:Subject:Message-Id; b=GTegRkvCJqSxDiUJnm+mvC7NFG89HIoZ328jy2cxF4hSG0JZIh9BqPcinWkbW45ngD/9Kp8e8CYxXwQrVQ4WyM3YCRq5X+cmL6sgsENzviDkjtG9t3Br2cF5vwwIjgp7yRlUpHWcz/Dzz+fAWi9sH2NEJlClGAnDl2yyrbZA+Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HGIsqmf5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HGIsqmf5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69421F00A3A;
	Mon,  3 Aug 2026 18:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785782589;
	bh=NGapyajbcRN8BHUprmHcPKQay7l6o5A7MxZIrHdEnRY=;
	h=Date:To:From:Subject;
	b=HGIsqmf5Qy7lK8T7LDolwj+qJaCUYBxG/m9SyuNHtbrMe/oZw3XWJz0oCLMFwPEAb
	 1vfxOieK6pmU2L3SUResx/dThQO0CGoB+mfgRUFiZaRbmLL3dZ88GL/RZi75XHJSU6
	 pmx3ccqZeiAYpRKrpvBECZ9ZH/kbMl0Jbs/tEUUc=
Date: Mon, 03 Aug 2026 11:43:08 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch added to mm-hotfixes-unstable branch
Message-Id: <20260803184308.D69421F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: error out for >10000 active_mem_bp
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/lru_sort: error out for >10000 active_mem_bp
Date: Mon, 3 Aug 2026 06:40:33 -0700

damos_quota_score() can trigger division by zero if the target value is
zero.  DAMON_LRU_SORT lets users set the target value for the hot memory
scheme via active_mem_bp parameter.  It avoids setting it as the target
value if the parameter value is zero.  However, it also sets the cold
memory scheme with a target value that is calculated as '10000 -
active_mem_bp + 2'.  Hence, if a user sets active_mem_bp 10002, the cold
memory scheme's quota goal target value can be zero.  As a result,
division by zero can be triggered.  Fix by returning an error when the
user tries to start DAMON with >10000 active_mem_bp parameter value.

It makes no sense to set active_mem_bp with 10002.  It also requires
module parameters write permission to reproduce the issue.  That said, the
consequence is quite bad.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_lru_sort/parameters
    # echo 1000 > wmarks_high
    # echo 995 > wmarks_mid
    # echo 0 > wmarks_low
    # echo 10002 > active_mem_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [  597.421247] Oops: divide error: 0000 [#1] SMP NOPTI
    [  597.428848] RIP: 0010:damos_quota_score+0x6f/0x480

This issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260803134034.15217-3-sj@kernel.org
Link: https://lore.kernel.org/20260801213028.5127-1-sj@kernel.org [1]
Fixes: 40d98d31cd70 ("mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-error-out-for-10000-active_mem_bp
+++ a/mm/damon/lru_sort.c
@@ -233,6 +233,8 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
+	if (10000 < active_mem_bp)
+		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-adjust-isolated-pages-stat-for-damos_migrate_hotcold.patch
samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
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
mm-damon-core-introduce-damon_probe-weight.patch
mm-damon-core-ask-apply_probes-ops-callback-to-set-sampling-address.patch
mm-damon-paddr-set-samples-in-apply_probes-if-requested.patch
mm-damon-core-ask-apply_probe-to-return-max-probe-hits-weighted-sum.patch
mm-damon-core-implement-damon_probe_hits_wsum.patch
mm-damon-paddr-respect-return_max_wsum.patch
mm-damon-core-use-abs_diff-instead-of-abs.patch
mm-damon-core-extend-merge-function-to-work-with-probe-hits.patch
mm-damon-core-disallow-probe_hits-overflow-on-attrs-only-monitoring.patch
mm-damon-core-validate-params-for-probe-hits-weighted-sum-overflow.patch
mm-damon-core-disable-access-monitoring-when-probe-weights-are-set.patch
mm-damon-core-set-samples-in-apply_probes-if-probe-weights-are-set.patch
mm-damon-core-s-max_nr_accesses-max_merge_score-in-kdamond_fn.patch
mm-damon-core-get-merge-threshold-from-probe-hits-when-weights-are-set.patch
mm-damon-core-implement-damon_has_probe_weight.patch
mm-damon-sysfs-implement-probe-weight-file.patch
docs-mm-damon-design-document-attrs-only-monitoring.patch
docs-admin-guide-mm-damon-usage-document-weight-sysfs-file.patch
docs-abi-damon-document-probe-weight-file.patch
mm-damon-core-skip-aging-from-repeated-aggressive-merging.patch
mm-damon-core-hide-private-damon_region-fields.patch
mm-damon-core-hide-private-damon_target-fields.patch
mm-damon-core-hide-private-damos_quota_goal-fields.patch
mm-damon-core-hide-private-damos_quota-fields.patch
mm-damon-core-hide-private-damos_filter-fields.patch
mm-damon-core-hide-private-damos-fields.patch
mm-damon-core-hide-private-damon_filter-fields.patch
mm-damon-core-hide-private-damon_probe-fields.patch
mm-damon-sysfs-do-not-directly-access-damon_ctx-ops.patch
mm-damon-core-hide-core-private-damon_ctx-fields.patch
mm-damon-core-avoid-infinite-kdamond_merge_regions-internal-loop.patch
mm-damon-tests-core-kunit-catch-test-failure-in-test_merge_regions_of.patch
mm-damon-vaddr-drop-last-same-folio-access-check-optimization.patch
mm-damon-paddr-drop-last-same-folio-access-check-reuse-optimization.patch
mm-damon-sysfs-read-addr_unit-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-sysfs-read-ops_id-only-once-in-damon_sysfs_apply_inputs.patch
mm-damon-core-initialize-damos-last_applied.patch
mm-damon-core-kunit-check-region-count-before-testing-in-split_at.patch
mm-damon-vaddr-kunit-check-region-count-in-three_regions-test.patch
mm-damon-core-kunit-handle-region-split-failure-in-filter_out.patch
mm-damon-core-kunit-skip-wrong-dest-walk-in-commit_dests_for.patch
mm-damon-core-kunit-skip-wrong-quota-goal-walk-in-commit_quota_goals.patch
mm-damon-core-kunit-skip-wrong-region-walk-in-commit_target_regions.patch
mm-damon-ops-common-use-nr_accesses-moving-sum-for-quota-score.patch
mm-damon-core-handle-region-split-failure-in-apply_min_nr_regions.patch

