Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFA71BC41
	for <mm-commits@vger.kernel.org>; Mon, 17 Mar 2025 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742172068; cv=none; b=pxwyzRH93w+z9WF20sgbFLU6L3/MF11q6YRfIEBj4ihDn61Det36Atf68emXXgWu11VMhVPevzN2OgP4XWvc6guGLlZI6z3ZidAZ0G6dOwtAIh2igBQOlveqDCGs3TCmQy9KmXKnCzZCXr0N4p3okNogen0EcBF+HM4Y/AmpU4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742172068; c=relaxed/simple;
	bh=itoMA749K64RwLOZTYNLKYIqEKhnTev/2A79f5ycW9I=;
	h=Date:To:From:Subject:Message-Id; b=XYqvsLTxspyTnR2VTyIzA3+3jYGZqdynK5lRdQNFdSC4uwS7ZG+WEUNjRDM7Yip2ovXJ38N9v0MsXhti5Nm3LcaXUj8YWplNcXl4QVBpzmvA9ukCdy+QPe2oiXaLjl9aqOcbYmLNOeZ+nQOkJ0Xl9lLPjciaTmxJxkizIOEZLko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F3FeOcm8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F3FeOcm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACB8C4CEDD;
	Mon, 17 Mar 2025 00:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1742172067;
	bh=itoMA749K64RwLOZTYNLKYIqEKhnTev/2A79f5ycW9I=;
	h=Date:To:From:Subject:From;
	b=F3FeOcm8e0gaJYS2Usjzlq1f/Y4VEjwFtRJ4BSZSy2Nwgh6Jr9SryhxtMv5o+eUVG
	 OfuVOTEeUUE9LVXttzUEb4RYgSqhGRiuGo6l2J4ADUfYTQXhhRZ3DP9bwW5qLgsnSt
	 gra1/y8fYjaukPZI1zi2rMAehSACBr1SiJyqUdtY=
Date: Sun, 16 Mar 2025 17:41:07 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch removed from -mm tree
Message-Id: <20250317004107.DACB8C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: respect core layer filters' allowance decision on ops layer
has been removed from the -mm tree.  Its filename was
     mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon: respect core layer filters' allowance decision on ops layer
Date: Fri, 28 Feb 2025 09:53:36 -0800

Filtering decisions are made in filters evaluation order.  Once a decision
is made by a filter, filters that scheduled to be evaluated after the
decision-made filter should just respect it.  This is the intended and
documented behavior.  Since core layer-handled filters are evaluated
before operations layer-handled filters, decisions made on core layer
should respected by ops layer.

In case of reject filters, the decision is respected, since core
layer-rejected regions are not passed to ops layer.  But in case of allow
filters, ops layer filters don't know if the region has passed to them
because it was allowed by core filters or just because it didn't match to
any core layer.  The current wrong implementation assumes it was due to
not matched by any core filters.  As a reuslt, the decision is not
respected.  Pass the missing information to ops layer using a new filed in
'struct damos', and make the ops layer filters respect it.

Link: https://lkml.kernel.org/r/20250228175336.42781-1-sj@kernel.org
Fixes: 491fee286e56 ("mm/damon/core: support damos_filter->allow")
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 +++++
 mm/damon/core.c       |    6 +++++-
 mm/damon/paddr.c      |    3 +++
 3 files changed, 13 insertions(+), 1 deletion(-)

--- a/include/linux/damon.h~mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer
+++ a/include/linux/damon.h
@@ -470,6 +470,11 @@ struct damos {
 	unsigned long next_apply_sis;
 	/* informs if ongoing DAMOS walk for this scheme is finished */
 	bool walk_completed;
+	/*
+	 * If the current region in the filtering stage is allowed by core
+	 * layer-handled filters.  If true, operations layer allows it, too.
+	 */
+	bool core_filters_allowed;
 /* public: */
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
--- a/mm/damon/core.c~mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer
+++ a/mm/damon/core.c
@@ -1429,9 +1429,13 @@ static bool damos_filter_out(struct damo
 {
 	struct damos_filter *filter;
 
+	s->core_filters_allowed = false;
 	damos_for_each_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter))
+		if (damos_filter_match(ctx, t, r, filter)) {
+			if (filter->allow)
+				s->core_filters_allowed = true;
 			return !filter->allow;
+		}
 	}
 	return false;
 }
--- a/mm/damon/paddr.c~mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer
+++ a/mm/damon/paddr.c
@@ -236,6 +236,9 @@ static bool damos_pa_filter_out(struct d
 {
 	struct damos_filter *filter;
 
+	if (scheme->core_filters_allowed)
+		return false;
+
 	damos_for_each_filter(filter, scheme) {
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
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

