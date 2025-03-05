Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47B7207675
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 23:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741217520; cv=none; b=ZVTQ4LnYJ08O+O8dlpeZt4kyVxLeW6RWNfhobufL3Xma3ch45zpOU54vcz261++6zA4dWRtKl+pDM5bSWirYb2cM7o+Tv3swo4bYQWZV0UNJgyXG3iWEsHzJYowsgRQJJq8922o00/abqjVKCML0tx3PLFEK5E6BP6OY+regQRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741217520; c=relaxed/simple;
	bh=M75B2mmQ9KRcu5f5aXLnq+kztPynUrtjPOHLltwGTec=;
	h=Date:To:From:Subject:Message-Id; b=fWzwKFK4ZdkMA8NfdT9TeAGQ2Iqgsfi6B9FtTLxlxtrFTaH+JTJ7nssuR5SPd+/eQhPULnR6X0vyt4CfGNRgNbuQNORWWQFG44Ne0NOmyPxu2VDQo5x4QuPQezZWUsmlrb6WEkn2rAhT1YZTi9Xm0Fhr317cgyM3cm99+0EL+3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GsjfPglN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GsjfPglN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20439C4CEE9;
	Wed,  5 Mar 2025 23:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741217520;
	bh=M75B2mmQ9KRcu5f5aXLnq+kztPynUrtjPOHLltwGTec=;
	h=Date:To:From:Subject:From;
	b=GsjfPglNDi6rZACHIiWHwvWW9/+b8k99Kist6JeUrF5/fQY0jKurnovAJYqjpxswO
	 lSGRzBfz+QsjeK96wwNmC1J0IisZ5c+MYjaaKmHpk644IFEx4R+E3T/Wpm6Z6K64E2
	 LOE35rPT1FIe8vb1e9ISJWeIkY8IxdDD7SP/kvqU=
Date: Wed, 05 Mar 2025 15:31:59 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch added to mm-unstable branch
Message-Id: <20250305233200.20439C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs-schemes: commit filters in {core,ops}_filters directories
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch

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
Subject: mm/damon/sysfs-schemes: commit filters in {core,ops}_filters directories
Date: Wed, 5 Mar 2025 14:27:28 -0800

Connect user inputs for files under core_filters and ops_filters with
DAMON, so that the files can really function.  Becasuse {core,ops}_filters
are easier to be managed in terms of expecting filters evaluation order,
add filters in {core,ops}_filters before 'filters' directory.

Link: https://lkml.kernel.org/r/20250305222733.59089-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs-schemes.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/mm/damon/sysfs-schemes.c~mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories
+++ a/mm/damon/sysfs-schemes.c
@@ -2143,8 +2143,6 @@ static struct damos *damon_sysfs_mk_sche
 	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
 	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
 	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
-	struct damon_sysfs_scheme_filters *sysfs_filters =
-		sysfs_scheme->filters;
 	struct damos *scheme;
 	int err;
 
@@ -2184,7 +2182,17 @@ static struct damos *damon_sysfs_mk_sche
 		return NULL;
 	}
 
-	err = damon_sysfs_add_scheme_filters(scheme, sysfs_filters);
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->core_filters);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->ops_filters);
+	if (err) {
+		damon_destroy_scheme(scheme);
+		return NULL;
+	}
+	err = damon_sysfs_add_scheme_filters(scheme, sysfs_scheme->filters);
 	if (err) {
 		damon_destroy_scheme(scheme);
 		return NULL;
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

