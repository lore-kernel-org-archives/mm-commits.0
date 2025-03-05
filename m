Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786014A06
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217518; cv=none; b=hF2jdZ/UrJD7X7oSC1Fl0GNDuL5fGTsHoa7fmtynar4XnYPKgzKj8hcJ9+GIhD04KBpKhuwDZhchhCH4CAxi2Zg5QS8+wL9cwfMULfIAmAAqBsh9fomLSNGMfMwNFPhLMbJjLcNn6RN8VngrGczceHz9PNBS73e7zBej/ZOUL+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217518; c=relaxed/simple;
	bh=k9sCyYGV7N0A/NbwFhQ+eD0F5opVw+PxFrk8kM7yUaQ=;
	h=Date:To:From:Subject:Message-Id; b=tV046BJ4BMU67+6+bZbyyc232G4nN5IQ1M2c+VAU4ywVz4SGnRU8jHQb12S43LNw0WOtVV3c3hknRQFduLbzQA4IkeKrdoXJeIxh89G+saUHRGKe2rd5d/XsnYNvmPYHqp0tXBCGA5qUNXQuOVGAzgZMuna8tZCJtSHayfcgdHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=09aDeykb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="09aDeykb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C682EC4CED1;
	Wed,  5 Mar 2025 23:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217517;
	bh=k9sCyYGV7N0A/NbwFhQ+eD0F5opVw+PxFrk8kM7yUaQ=;
	h=Date:To:From:Subject:From;
	b=09aDeykbzc+CmKBPmpfnjhp+Z0k6k9NJ3H+x7czzrwlp9SbgXG3WRR3CKcK/D+VUp
	 93O6CJUZIGtUCoyMuVbmSsnJaiFUtukehrbl82+ue3OH9EwH/p4YrGXv5BuB29jaNO
	 Yeo+golIsc3U37+8qcc5PkZ01KnqWvvx4giyLFyM=
Date: Wed, 05 Mar 2025 15:31:57 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch added to mm-unstable branch
Message-Id: <20250305233157.C682EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: let damon_sysfs_scheme_set_filters() be used for different named directories
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch

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
Subject: mm/damon/sysfs-schemes: let damon_sysfs_scheme_set_filters() be used for different named directories
Date: Wed, 5 Mar 2025 14:27:26 -0800

Patch series "mm/damon: add sysfs dirs for managing DAMOS filters based on
handling layers".

DAMOS filters are categorized into two groups based on their handling
layers, namely core and operations layers.  The categorization affects
when each filter is evaluated.  Core layer handled filters are evaluated
first.  The order meant nothing before, but introduction of allow filters
changed that.

DAMOS sysfs interface provides single directory for filters, namely
'filters'.  Users can install any filters in any order there.  DAMON will
internally categorize those into core and operations layer handled ones,
and apply the evaluation order rule.  The ordering rule is clearly
documented.  But the interface could still confuse users since it is
allowed to install filters on the directory in mixed ways.

Add two sysfs directories for managing filters by handling layers, namely
'core_filters' and 'ops_filters' for filters that handled by core and
operations layer, respectively.  Those are avoided to be used for
installing filters that not handled by the assumed layers.

For backward compatibility, keep 'filters' directory with its curernt
behavior.  Filters installed in the directory will be added to DAMON after
those of 'core_filters' and 'ops_filters' directories, with the automatic
categorizations.  Also recommend users to use the new directories while
noticing 'filters' directory could be deprecated in future on the usage
documents.

Note that new directories provide all features that were provided with
'filters', but just in a more clear way.  Deprecating 'filters' in future
will hence not make an irreversal feature loss.


This patch (of 8):

damon_sysfs_scheme_set_filters() is using a hard-coded directory name,
"filters".  Refactor for general named directories of same files
hierarchy, to use from upcoming changes for adding sibling directories
having files same to those of "filters", and named as "core_filters" and
"ops_filters".

Link: https://lkml.kernel.org/r/20250305222733.59089-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250305222733.59089-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -1604,7 +1604,9 @@ static int damon_sysfs_scheme_set_waterm
 	return err;
 }
 
-static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme)
+static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme,
+		const char *name,
+		struct damon_sysfs_scheme_filters **filters_ptr)
 {
 	struct damon_sysfs_scheme_filters *filters =
 		damon_sysfs_scheme_filters_alloc();
@@ -1614,11 +1616,11 @@ static int damon_sysfs_scheme_set_filter
 		return -ENOMEM;
 	err = kobject_init_and_add(&filters->kobj,
 			&damon_sysfs_scheme_filters_ktype, &scheme->kobj,
-			"filters");
+			name);
 	if (err)
 		kobject_put(&filters->kobj);
 	else
-		scheme->filters = filters;
+		*filters_ptr = filters;
 	return err;
 }
 
@@ -1670,7 +1672,8 @@ static int damon_sysfs_scheme_add_dirs(s
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
 		goto put_quotas_access_pattern_out;
-	err = damon_sysfs_scheme_set_filters(scheme);
+	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+			&scheme->filters);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_stats(scheme);
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

