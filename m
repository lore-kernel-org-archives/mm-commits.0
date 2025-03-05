Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53034207A3F
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217523; cv=none; b=f5OWl5C8PvLJrO1Xwa2r2tIixrAq+NU5j+HEmmL4gp9lE54028Ih6wuwufioEUm+vJ/eKV2vNDXkfe9vduACWqrLNMNnM8R6VEuUWz57nbEoK4FF6dlCJqFKJLJxOd62pIS8z8RCU2rbb3RzKX/52A/7pFdGIlmTJmJEK0be6gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217523; c=relaxed/simple;
	bh=2b7j1nIvfISzp32gkouN9UeYe4QyH7HZC2HgBpT8K9g=;
	h=Date:To:From:Subject:Message-Id; b=tiTnvQ5Jr1L8yfLIeF/Yk0d7p27avJEnSM+mtiJZeANFX1i7sQNKvdcijW2FZXNIhF19MtTxNv/XqkKMfVBgJwNUkmuo/4xYrqrObMNR/Ddg+lMtXsmd9oUlIOLWPwTLRQ88RKQykAD7jihKQdz2KR5n5UpKauGoEMT5LR7cRno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QuXMGbyn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QuXMGbyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C87C4CEE7;
	Wed,  5 Mar 2025 23:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217522;
	bh=2b7j1nIvfISzp32gkouN9UeYe4QyH7HZC2HgBpT8K9g=;
	h=Date:To:From:Subject:From;
	b=QuXMGbyn0LDCOPLSnFtMPaFomDe9gNgV7sUtfUvwq5keL6uL7kZO1UFeSx+y3d74v
	 fCajSN1aShxLImIgHWgj8h19XZMKkoWiYpVUwwpeJ8lmRzeD/F5U9cEVx/UxlNB/O+
	 ozFc8EK065lckIqMCOMA4Qy3yPatvKe3KcXq/mX4=
Date: Wed, 05 Mar 2025 15:32:02 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch added to mm-unstable branch
Message-Id: <20250305233202.B6C87C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: record filters of which layer should be added to the given filters directory
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch

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
Subject: mm/damon/sysfs-schemes: record filters of which layer should be added to the given filters directory
Date: Wed, 5 Mar 2025 14:27:30 -0800

Unlike their name and assumed purposes, {core,ops}_filters DAMOS sysfs
directories are allowing installing any type of filters.  As a first step
for preventing such wrong installments, add information about filters that
handled by what layer should the installed to the given filters directory
in the DAMOS sysfs internal data structures.

Link: https://lkml.kernel.org/r/20250305222733.59089-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   46 ++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 10 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory
+++ a/mm/damon/sysfs-schemes.c
@@ -309,8 +309,18 @@ static const struct kobj_type damon_sysf
  * filter directory
  */
 
+/*
+ * enum damos_sysfs_filter_handle_layer - Layers handling filters of a dir.
+ */
+enum damos_sysfs_filter_handle_layer {
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE,
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS,
+	DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH,
+};
+
 struct damon_sysfs_scheme_filter {
 	struct kobject kobj;
+	enum damos_sysfs_filter_handle_layer handle_layer;
 	enum damos_filter_type type;
 	bool matching;
 	bool allow;
@@ -320,9 +330,15 @@ struct damon_sysfs_scheme_filter {
 	int target_idx;
 };
 
-static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(void)
+static struct damon_sysfs_scheme_filter *damon_sysfs_scheme_filter_alloc(
+		enum damos_sysfs_filter_handle_layer layer)
 {
-	return kzalloc(sizeof(struct damon_sysfs_scheme_filter), GFP_KERNEL);
+	struct damon_sysfs_scheme_filter *filter;
+
+	filter = kzalloc(sizeof(struct damon_sysfs_scheme_filter), GFP_KERNEL);
+	if (filter)
+		filter->handle_layer = layer;
+	return filter;
 }
 
 /* Should match with enum damos_filter_type */
@@ -595,14 +611,20 @@ static const struct kobj_type damon_sysf
 
 struct damon_sysfs_scheme_filters {
 	struct kobject kobj;
+	enum damos_sysfs_filter_handle_layer handle_layer;
 	struct damon_sysfs_scheme_filter **filters_arr;
 	int nr;
 };
 
 static struct damon_sysfs_scheme_filters *
-damon_sysfs_scheme_filters_alloc(void)
+damon_sysfs_scheme_filters_alloc(enum damos_sysfs_filter_handle_layer layer)
 {
-	return kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
+	struct damon_sysfs_scheme_filters *filters;
+
+	filters = kzalloc(sizeof(struct damon_sysfs_scheme_filters), GFP_KERNEL);
+	if (filters)
+		filters->handle_layer = layer;
+	return filters;
 }
 
 static void damon_sysfs_scheme_filters_rm_dirs(
@@ -635,7 +657,8 @@ static int damon_sysfs_scheme_filters_ad
 	filters->filters_arr = filters_arr;
 
 	for (i = 0; i < nr_filters; i++) {
-		filter = damon_sysfs_scheme_filter_alloc();
+		filter = damon_sysfs_scheme_filter_alloc(
+				filters->handle_layer);
 		if (!filter) {
 			damon_sysfs_scheme_filters_rm_dirs(filters);
 			return -ENOMEM;
@@ -1607,11 +1630,11 @@ static int damon_sysfs_scheme_set_waterm
 }
 
 static int damon_sysfs_scheme_set_filters(struct damon_sysfs_scheme *scheme,
-		const char *name,
+		enum damos_sysfs_filter_handle_layer layer, const char *name,
 		struct damon_sysfs_scheme_filters **filters_ptr)
 {
 	struct damon_sysfs_scheme_filters *filters =
-		damon_sysfs_scheme_filters_alloc();
+		damon_sysfs_scheme_filters_alloc(layer);
 	int err;
 
 	if (!filters)
@@ -1630,15 +1653,18 @@ static int damos_sysfs_set_filter_dirs(s
 {
 	int err;
 
-	err = damon_sysfs_scheme_set_filters(scheme, "filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_BOTH, "filters",
 			&scheme->filters);
 	if (err)
 		return err;
-	err = damon_sysfs_scheme_set_filters(scheme, "core_filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_CORE, "core_filters",
 			&scheme->core_filters);
 	if (err)
 		goto put_filters_out;
-	err = damon_sysfs_scheme_set_filters(scheme, "ops_filters",
+	err = damon_sysfs_scheme_set_filters(scheme,
+			DAMOS_SYSFS_FILTER_HANDLE_LAYER_OPS, "ops_filters",
 			&scheme->ops_filters);
 	if (err)
 		goto put_core_filters_out;
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

