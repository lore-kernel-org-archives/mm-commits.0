Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9031B0F11
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 04:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742186041; cv=none; b=JovUYBjGNiAhcpuccpJdb0A7z+KR4gMRNqQ+oWS07jvHrF79JoG6Xzi1p6CDWNhdyQ8iQ0qZ4YTlSBYGj1xoUwosi7kcs31FsRgNwtkda+SulhftCvWxIJGlBpZB6KxVKB9hEAizpHA6Q/yZIIBHY90FMZBqnk/QGwiOsN4fvJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742186041; c=relaxed/simple;
	bh=kH7PXPjH2N7ospL3GWbNk5FXPFRAhTvHsbxEp41HFxE=;
	h=Date:To:From:Subject:Message-Id; b=ChTN0OqOsHFWNGpHKKeiBWOhEfeFALRVYrZsKvXIHSNo3yqoWk5t0K398AYWwwGTve0V2OwlVip/2Il4ka1mhhEDStLGHnQxMEge8hmpii9av6ylg/8HfUl/lzEEZxQG7LXqkDu4n+ffTV1SuTlpV9EPT4FeUhmqlf4jySJFMCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=foobYLGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="foobYLGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B81C4CEEC;
	Mon, 17 Mar 2025 04:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742186041;
	bh=kH7PXPjH2N7ospL3GWbNk5FXPFRAhTvHsbxEp41HFxE=;
	h=Date:To:From:Subject:From;
	b=foobYLGMvKBaVbauBGR/CGaS2Sv4u9OyegqBW6FJY4C13kM+thd544tENy+ODyJXk
	 1cofQDmsVq0XtJRxrwGL6HlYryT8HzbmhBv2r/FaRBvoi1nCZoS+xf6rt8sjA96kno
	 fbiTOm/B3IFow+xgz0tfGaliRd+hQALAH6ZQABao=
Date: Sun, 16 Mar 2025 21:34:00 -0700
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch removed from -mm tree
Message-Id: <20250317043401.28B81C4CEEC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: add kernel-doc comment for damos_filter->sz_range
has been removed from the -mm tree.  Its filename was
     mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch

This patch was dropped because it was folded into mm-damon-introduce-damos-filter-type-hugepage_size.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: add kernel-doc comment for damos_filter->sz_range
Date: Tue, 18 Feb 2025 14:30:58 -0800

Commit 212f4d0cb42c ("mm/damon: introduce DAMOS filter type
hugepage_size") on mm-unstable added sz_range field to 'struct
damos_filter'.  It missed updating the kernel-doc comment, though.  It is
making the documentation build unhappy.  Add a comment for the field.

Link: https://lkml.kernel.org/r/20250218223058.52459-1-sj@kernel.org
Fixes: 212f4d0cb42c ("mm/damon: introduce DAMOS filter type hugepage_size") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-introduce-damos-filter-type-hugepage_size-fix
+++ a/include/linux/damon.h
@@ -372,6 +372,7 @@ enum damos_filter_type {
  * @target_idx:	Index of the &struct damon_target of
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
+ * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
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
mm-damon-introduce-damos-filter-type-hugepage_size.patch
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
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters-fix.patch
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

