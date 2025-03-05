Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DBA34A06
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217519; cv=none; b=heTpGjcvBwKe00HPmelItPZjnhM6ofT/gd4nrhFR603PEcn1m1/9QC+vKizJCcegGWNPHsROCnci/u489fqbPq2FiwGTzF8DT+llK69yrhYVvxJzEAkqeMq+RvlNH4+NdjoMzKqOQbhnqkvpGWNkuCKla6X9c0gzJYhrGQgVtUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217519; c=relaxed/simple;
	bh=Nuv9S8BHR43gIwmu1Cqj+zOZBIog9iPUY5CufL5wMdo=;
	h=Date:To:From:Subject:Message-Id; b=QCb6n4jpVdaZ4KxqmIi6GGGm5iv6fix/btWIu+Lj7m4q9sdwB7DXWyWmhWQhjDrbVB7LEu/4I9mEV9WAl7nGmrs/YEILx3EEqj7coBnRuV+tCbcjRXhm2hqVyfGhAvroAvsDYiAej3ChVUBRIlqN3lcCxqgDH66+RAtVxqPpNb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ktJP5DcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ktJP5DcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CB9C4CED1;
	Wed,  5 Mar 2025 23:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217519;
	bh=Nuv9S8BHR43gIwmu1Cqj+zOZBIog9iPUY5CufL5wMdo=;
	h=Date:To:From:Subject:From;
	b=ktJP5DcD3SeMoJaZNgfIS+3BiMCP9O5i7yXqlvXDa0qCDUpbp7U+X5g/8hakNGTOA
	 8uph4+iLDv6YqO/pyZ2zCURWRfNs14P8udWomHuqGvDC+DCshxknvi4WKi/BPV0igz
	 MICGv+ev/o41eSifZVmKgTGDmIMkYTpMMm8crDgU=
Date: Wed, 05 Mar 2025 15:31:58 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch added to mm-unstable branch
Message-Id: <20250305233158.E4CB9C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: implement core_filters and ops_filters directories
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch

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
Subject: mm/damon/sysfs-schemes: implement core_filters and ops_filters directories
Date: Wed, 5 Mar 2025 14:27:27 -0800

Implement two DAMOS sysfs directories for managing core and operations
layer handled filters separately.  Those are named as 'core_filters' and
'ops_filters', and have files hierarchy same to 'filters'.  This commit is
only populating and cleaning up the directories, not really connecting the
files with DAMON.  Following changes will make the connections.

Link: https://lkml.kernel.org/r/20250305222733.59089-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   40 +++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -1504,6 +1504,8 @@ struct damon_sysfs_scheme {
 	unsigned long apply_interval_us;
 	struct damon_sysfs_quotas *quotas;
 	struct damon_sysfs_watermarks *watermarks;
+	struct damon_sysfs_scheme_filters *core_filters;
+	struct damon_sysfs_scheme_filters *ops_filters;
 	struct damon_sysfs_scheme_filters *filters;
 	struct damon_sysfs_stats *stats;
 	struct damon_sysfs_scheme_regions *tried_regions;
@@ -1624,6 +1626,33 @@ static int damon_sysfs_scheme_set_filter
 	return err;
 }
 
+static int damos_sysfs_set_filter_dirs(struct damon_sysfs_scheme *scheme)
+{
+	int err;
+
+	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+			&scheme->filters);
+	if (err)
+		return err;
+	err = damon_sysfs_scheme_set_filters(scheme, "core_filters",
+			&scheme->core_filters);
+	if (err)
+		goto put_filters_out;
+	err = damon_sysfs_scheme_set_filters(scheme, "ops_filters",
+			&scheme->ops_filters);
+	if (err)
+		goto put_core_filters_out;
+	return 0;
+
+put_core_filters_out:
+	kobject_put(&scheme->core_filters->kobj);
+	scheme->core_filters = NULL;
+put_filters_out:
+	kobject_put(&scheme->filters->kobj);
+	scheme->filters = NULL;
+	return err;
+}
+
 static int damon_sysfs_scheme_set_stats(struct damon_sysfs_scheme *scheme)
 {
 	struct damon_sysfs_stats *stats = damon_sysfs_stats_alloc();
@@ -1672,8 +1701,7 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
-	err = damon_sysfs_scheme_set_filters(scheme, "filters",
-			&scheme->filters);
+	err = damos_sysfs_set_filter_dirs(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_stats(scheme);
@@ -1688,6 +1716,10 @@ put_tried_regions_out:
 	kobject_put(&scheme->tried_regions->kobj);
 	scheme->tried_regions = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
+	kobject_put(&scheme->ops_filters->kobj);
+	scheme->ops_filters = NULL;
+	kobject_put(&scheme->core_filters->kobj);
+	scheme->core_filters = NULL;
 	kobject_put(&scheme->filters->kobj);
 	scheme->filters = NULL;
 put_watermarks_quotas_access_pattern_out:
@@ -1711,6 +1743,10 @@ static void damon_sysfs_scheme_rm_dirs(s
 	kobject_put(&scheme->watermarks->kobj);
 	damon_sysfs_scheme_filters_rm_dirs(scheme->filters);
 	kobject_put(&scheme->filters->kobj);
+	damon_sysfs_scheme_filters_rm_dirs(scheme->core_filters);
+	kobject_put(&scheme->core_filters->kobj);
+	damon_sysfs_scheme_filters_rm_dirs(scheme->ops_filters);
+	kobject_put(&scheme->ops_filters->kobj);
 	kobject_put(&scheme->stats->kobj);
 	damon_sysfs_scheme_regions_rm_dirs(scheme->tried_regions);
 	kobject_put(&scheme->tried_regions->kobj);
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

