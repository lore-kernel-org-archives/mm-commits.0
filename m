Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336FE1FDE01
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130350; cv=none; b=pSRyC8l5RFezz7/X6zlxO9M1Ijcoj6cmwbACvdzyVneYiFVdnWrusxv7f/vMM1Cbag+o5gJvA4ua1eZ/29ODc9pwWvlihBJS2cQr5QsLI9EbqbXpzVSputKpMy5UXfJeDdWzeYbzOwL8zaFn13zKVU+vKjQpt2MjAUWGeva/WhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130350; c=relaxed/simple;
	bh=OZUMogyU17UYRN5NtETWNDMSxy8QMVRPab86MxMBmjw=;
	h=Date:To:From:Subject:Message-Id; b=mukKdHs9QM54gA7jFetw5BTT6gS367ou9gsYjtC79G+oYbFtO8E4tGq2in2bgTqL/Yyn6vDMtEboq68eejsEZtT3L++SOMzJub2mSbg+s7hAdRnQW9lb6QW7NuoJ57hzkhAJDosOwcrQjPbM6BAxLVO7gpMBMKCZwGLPwIOyZaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PhoPmiOy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PhoPmiOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE18C4CEE9;
	Tue,  4 Mar 2025 23:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130350;
	bh=OZUMogyU17UYRN5NtETWNDMSxy8QMVRPab86MxMBmjw=;
	h=Date:To:From:Subject:From;
	b=PhoPmiOyX+XbPOeUKVVPCJigjQtZslg+xVztq4pOg6LlWZhj8JPT3Q6TuQq1LfldQ
	 ujTPAdUkOC+2uEsbXHywsyyf0A2b3tEZdyPUm0bqYYYileBVM5RAky8+8p/3dWKA8K
	 VWt1sQy8XIVZV4691uJZNEI9PY1iS+SUtpnSLYOY=
Date: Tue, 04 Mar 2025 15:19:09 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-only-damos-ops_filters.patch added to mm-unstable branch
Message-Id: <20250304231910.0AE18C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support only damos->ops_filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-only-damos-ops_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-only-damos-ops_filters.patch

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
Subject: mm/damon/paddr: support only damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:09 -0800

DAMON physical address space operation set implementation (paddr) started
handling both damos->filters and damos->ops_filters to avoid breakage
during the change for the ->ops_filters setup.  Now the change is done, so
paddr's support of ->filters is only a waste that can safely be dropped. 
Remove it.

Link: https://lkml.kernel.org/r/20250304211913.53574-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-only-damos-ops_filters
+++ a/mm/damon/paddr.c
@@ -256,10 +256,6 @@ static bool damos_pa_filter_out(struct d
 	if (scheme->core_filters_allowed)
 		return false;
 
-	damos_for_each_filter(filter, scheme) {
-		if (damos_pa_filter_match(filter, folio))
-			return !filter->allow;
-	}
 	damos_for_each_ops_filter(filter, scheme) {
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
@@ -288,12 +284,6 @@ static unsigned long damon_pa_pageout(st
 	struct folio *folio;
 
 	/* check access in page level again by default */
-	damos_for_each_filter(filter, s) {
-		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
-			install_young_filter = false;
-			break;
-		}
-	}
 	damos_for_each_ops_filter(filter, s) {
 		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
 			install_young_filter = false;
@@ -546,8 +536,6 @@ static bool damon_pa_scheme_has_filter(s
 {
 	struct damos_filter *f;
 
-	damos_for_each_filter(f, s)
-		return true;
 	damos_for_each_ops_filter(f, s)
 		return true;
 	return false;
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

