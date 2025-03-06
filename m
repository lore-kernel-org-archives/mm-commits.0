Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23D325CC88
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297113; cv=none; b=t3pmmoirwiq+hZ2S0oNoqfqSmub2bv575wH+Y9WkBEfJU1RdV82CwSt/WOwfK9TlYlTyRK+6xPpFLKK5cKrTqd3RWyZoEKKAqzuM2jcy+ntnO6vgJEKen/penPcCt8LICEijm67O1Z9yl/vgSR7l0ylASK0fi+Ib1Mn5uegBISI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297113; c=relaxed/simple;
	bh=tvIsmhXYT1G9f4SjqKJgbpx/3WxAj+Mo95jiWZWNYO4=;
	h=Date:To:From:Subject:Message-Id; b=C1gum7aCWLKVKYtRs70Zh/hdPYdFUSFhn7ewcrFh1xYrQQwTrpYZzDKz3O3roUP5EBwyW5GLHLoRJG2MPEpGNuznpBMW0jwFVApfNoZqhrhSBzrqsXRNa/USULRhNu0TKWguucLGUayhfGKgyzPT8OsTWMg+4eT3Dftf2nDasrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=szG0XUNh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="szG0XUNh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE2FC4CEE0;
	Thu,  6 Mar 2025 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297113;
	bh=tvIsmhXYT1G9f4SjqKJgbpx/3WxAj+Mo95jiWZWNYO4=;
	h=Date:To:From:Subject:From;
	b=szG0XUNh4SN6euihxacL/xjK+Ct/VMxontLtQhSKKijaxNS3C7N/FlSbcyCymN2CQ
	 HTEw/TKFxUhhSv50JIXrSWJobpG7aWla7DuqfLRrnqsN6IsH7O1Tk8BsNE/sgwLS80
	 xht1iscmaZkGDC1405k0rYg5N4FoeQMJOJDNRVYw=
Date: Thu, 06 Mar 2025 13:38:32 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-damon_callback-after_sampling.patch added to mm-unstable branch
Message-Id: <20250306213833.8AE2FC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove damon_callback->after_sampling
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-damon_callback-after_sampling.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-damon_callback-after_sampling.patch

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
Subject: mm/damon: remove damon_callback->after_sampling
Date: Thu, 6 Mar 2025 09:59:06 -0800

The callback was used by DAMON sysfs interface for reading DAMON internal
data.  But it is no more being used, and damon_call() can do similar works
in a better way.  Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   11 ++++-------
 mm/damon/core.c       |    3 ---
 2 files changed, 4 insertions(+), 10 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_callback-after_sampling
+++ a/include/linux/damon.h
@@ -604,7 +604,6 @@ struct damon_operations {
  * struct damon_callback - Monitoring events notification callbacks.
  *
  * @after_wmarks_check:	Called after each schemes' watermarks check.
- * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
  * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
@@ -617,17 +616,15 @@ struct damon_operations {
  * attributes of the monitoring context while it's deactivated due to the
  * watermarks, this is the good place to do.
  *
- * The monitoring thread calls @after_sampling and @after_aggregation for each
- * of the sampling intervals and aggregation intervals, respectively.
- * Therefore, users can safely access the monitoring results without additional
- * protection.  For the reason, users are recommended to use these callback for
- * the accesses to the results.
+ * The monitoring thread calls @after_aggregation for each of the aggregation
+ * intervals.  Therefore, users can safely access the monitoring results
+ * without additional protection.  For the reason, users are recommended to use
+ * these callback for the accesses to the results.
  *
  * If any callback returns non-zero, monitoring stops.
  */
 struct damon_callback {
 	int (*after_wmarks_check)(struct damon_ctx *context);
-	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
 	int (*before_damos_apply)(struct damon_ctx *context,
 			struct damon_target *target,
--- a/mm/damon/core.c~mm-damon-remove-damon_callback-after_sampling
+++ a/mm/damon/core.c
@@ -2431,9 +2431,6 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.prepare_access_checks)
 			ctx->ops.prepare_access_checks(ctx);
-		if (ctx->callback.after_sampling &&
-				ctx->callback.after_sampling(ctx))
-			break;
 
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
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

