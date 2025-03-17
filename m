Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795C5EEA9
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186616; cv=none; b=GrLDix7JManN8hPu6i8oPuNMu2OgyO59Qkj1ohtKvJYiCgt2WRo2Pf4JDBGjyb85tXZ9wQ3YG5pneXuJcYcq/cTb8L/FrjX0hX2ZePrWIFbus1x2Hs4GlX29zMxQ1UTBmKcKou5Cn6baf2tJZ+BCTxvcs4vJwGkhkoJfU0VHQCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186616; c=relaxed/simple;
	bh=BUg/e4iwEidhp71t1xskjCf/ecHg9DhoVm3t6/ey3II=;
	h=Date:To:From:Subject:Message-Id; b=cnLc8EWhDpV7393EFuEOd0uPmckZQNY9vGlFiGZ294zqncyKOByTotjH8EDJD4BHWvRO05Su/zInus7tzILAeOUnryy4ruDwPy3tbVIxhqCMpnClVxrUKgvzZrFcISBzP64fynH96mLlYZ6bPHlwaicvqKwmQW/IvEpUfDdqJOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nu2Vd6v2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nu2Vd6v2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6EFC4CEEC;
	Mon, 17 Mar 2025 04:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186615;
	bh=BUg/e4iwEidhp71t1xskjCf/ecHg9DhoVm3t6/ey3II=;
	h=Date:To:From:Subject:From;
	b=nu2Vd6v2KKRouWhYQf1N8+JnjPKTsaaND0I8Vix8TUcKXjEx6UE+dkueHkOao3Gi1
	 f/IwZ4INtvvU9TPCNMTVnE/JqY3qFSsN6c+A2Rxn4bWSPKZkXiTr7WlNPHcDY44T4z
	 ajS9kqVAicxLcD3LFBAmvL65YdgNgQCpFvlinJc0=
Date: Sun, 16 Mar 2025 21:43:35 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters-fix.patch removed from -mm tree
Message-Id: <20250317044335.DA6EFC4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: setup damos->{core,ops}_filters_default_reject for initial start
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters-fix.patch

This patch was dropped because it was folded into mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: setup damos->{core,ops}_filters_default_reject for initial start
Date: Sat, 15 Mar 2025 15:26:10 -0700

Commit 6a0f07289bc7 ("mm/damon/core: set damos_filter default allowance
behavior based on installed filters") on mm-unstable sets
damos->{core,ops}_filters_default_reject fields on only damon_commit_ctx()
code path, which is called for only online parameters update.  Hence,
users who set filters from the beginning could set it not properly
initialized.  As a result, unnnecessarily DAMOS target regions can be
rejected.  Set the fields at the beginning of DAMON worker thread
execution, too.

Link: https://lkml.kernel.org/r/20250315222610.35245-1-sj@kernel.org
Fixes: ("mm/damon/core: set damos_filter default allowance behavior based on installed filters")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters-fix
+++ a/mm/damon/core.c
@@ -518,7 +518,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
 
 	ctx->passed_sample_intervals = 0;
-	/* These will be set from kdamond_init_intervals_sis() */
+	/* These will be set from kdamond_init_ctx() */
 	ctx->next_aggregation_sis = 0;
 	ctx->next_ops_update_sis = 0;
 
@@ -2345,7 +2345,7 @@ static int kdamond_wait_activation(struc
 	return -EBUSY;
 }
 
-static void kdamond_init_intervals_sis(struct damon_ctx *ctx)
+static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
 		ctx->attrs.sample_interval : 1;
@@ -2363,6 +2363,7 @@ static void kdamond_init_intervals_sis(s
 		apply_interval = scheme->apply_interval_us ?
 			scheme->apply_interval_us : ctx->attrs.aggr_interval;
 		scheme->next_apply_sis = apply_interval / sample_interval;
+		damos_set_filters_default_reject(scheme);
 	}
 }
 
@@ -2380,7 +2381,7 @@ static int kdamond_fn(void *data)
 	pr_debug("kdamond (%d) starts\n", current->pid);
 
 	complete(&ctx->kdamond_started);
-	kdamond_init_intervals_sis(ctx);
+	kdamond_init_ctx(ctx);
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch
mm-damon-sysfs-schemes-avoid-wformat-security-warning-on-damon_sysfs_access_pattern_add_range_dir.patch
mm-madvise-use-is_memory_failure-from-madvise_do_behavior.patch
mm-madvise-split-out-populate-behavior-check-logic.patch
mm-madvise-deduplicate-madvise_do_behavior-skip-case-handlings.patch
mm-madvise-remove-len-parameter-of-madvise_do_behavior.patch

