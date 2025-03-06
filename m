Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921B620012D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297116; cv=none; b=V+kL71zBTfYHLu/+5aDdk320lUojcWNaHee1Fjtnb+gCP26Qydt64ZpBzahwtK+iq+zO7Bmfcl/H08Qtt2b8kRES0w4C/nEsZFSWb6AkmwDYJyD99Sz58nAW7/Om3QPshFBINHmcLayupQdDw2lc/E1CCvfFlio13dK3DiPigF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297116; c=relaxed/simple;
	bh=EDoK1eZ6cjFD8Nmwmfh7GMg+pSnlF8W2sPqjCeOeW4I=;
	h=Date:To:From:Subject:Message-Id; b=Dv9nQ4O0ugOGqkOp8VwyTTHAtx0a93LkunxSZJ9K1GAsjOa6f1YzIqjYobcCF39k1cOQFyHkMoX1MLeWb9R28joJ+KnuPvxRj2HINvv/Vlcz36ZO+wbVMZFfTEzNVoNLRqvjTMYy2dqmbtLUyEQJ0QyQj4pklEFi30voOcv8oKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I/7TIvPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I/7TIvPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6804FC4CEE0;
	Thu,  6 Mar 2025 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297116;
	bh=EDoK1eZ6cjFD8Nmwmfh7GMg+pSnlF8W2sPqjCeOeW4I=;
	h=Date:To:From:Subject:From;
	b=I/7TIvPwt50pmYcNr/kZYFHEAoQTzGsnAz6keDw/WWCsaIYsGqJwI10DWhm8K+p6A
	 919YzUvbcxy99PoXK9TquM/N/pyyaaVUqjRNZgl14LKsE84/TVPQXz10ctDAbNgtnp
	 rK0jD8b59gYKzYXJ657t5vh39MTd60/c7EpYSnrk=
Date: Thu, 06 Mar 2025 13:38:35 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-damon_operations-reset_aggregated.patch added to mm-unstable branch
Message-Id: <20250306213836.6804FC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove damon_operations->reset_aggregated
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-damon_operations-reset_aggregated.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-damon_operations-reset_aggregated.patch

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
Subject: mm/damon: remove damon_operations->reset_aggregated
Date: Thu, 6 Mar 2025 09:59:08 -0800

The operations layer hook was introduced to let operations set do any
aggregation data reset if needed.  But it is not really be used now. 
Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-14-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 +------
 mm/damon/core.c       |    2 --
 mm/damon/paddr.c      |    1 -
 mm/damon/vaddr.c      |    1 -
 4 files changed, 1 insertion(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_operations-reset_aggregated
+++ a/include/linux/damon.h
@@ -542,7 +542,6 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
- * @reset_aggregated:		Reset aggregated accesses monitoring results.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -554,8 +553,7 @@ enum damon_ops_id {
  * (&damon_ctx.kdamond) calls @init and @prepare_access_checks before starting
  * the monitoring, @update after each &damon_attrs.ops_update_interval, and
  * @check_accesses, @target_valid and @prepare_access_checks after each
- * &damon_attrs.sample_interval.  Finally, @reset_aggregated is called after
- * each &damon_attrs.aggr_interval.
+ * &damon_attrs.sample_interval.
  *
  * Each &struct damon_operations instance having valid @id can be registered
  * via damon_register_ops() and selected by damon_select_ops() later.
@@ -570,8 +568,6 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
- * @reset_aggregated should reset the access monitoring results that aggregated
- * by @check_accesses.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -589,7 +585,6 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*reset_aggregated)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
--- a/mm/damon/core.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/core.c
@@ -2489,8 +2489,6 @@ static int kdamond_fn(void *data)
 
 			kdamond_reset_aggregated(ctx);
 			kdamond_split_regions(ctx);
-			if (ctx->ops.reset_aggregated)
-				ctx->ops.reset_aggregated(ctx);
 		}
 
 		if (ctx->passed_sample_intervals >= next_ops_update_sis) {
--- a/mm/damon/paddr.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/paddr.c
@@ -621,7 +621,6 @@ static int __init damon_pa_initcall(void
 		.update = NULL,
 		.prepare_access_checks = damon_pa_prepare_access_checks,
 		.check_accesses = damon_pa_check_accesses,
-		.reset_aggregated = NULL,
 		.target_valid = NULL,
 		.cleanup = NULL,
 		.apply_scheme = damon_pa_apply_scheme,
--- a/mm/damon/vaddr.c~mm-damon-remove-damon_operations-reset_aggregated
+++ a/mm/damon/vaddr.c
@@ -710,7 +710,6 @@ static int __init damon_va_initcall(void
 		.update = damon_va_update,
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
-		.reset_aggregated = NULL,
 		.target_valid = damon_va_target_valid,
 		.cleanup = NULL,
 		.apply_scheme = damon_va_apply_scheme,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
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
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
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

