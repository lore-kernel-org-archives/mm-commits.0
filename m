Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EC7615ADA6
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 02:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741056804; cv=none; b=VYV/br3GP/L6lP5xH3Q37T7/XvLnk/J1LQSfBluIJkQg+Mc5X8NwbpG/hAIjgzCFcQHlqEvm20WnbkUEPA6d7hAOsDPyWyAwjH/spWyVFC75eJ5NCN7ORrGpXKDPZ+4tvnA36szUkkrd37iHYe8EIhhtYJeJWO75FsFCbZlS3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741056804; c=relaxed/simple;
	bh=aFVRZgV9gWYwmVo8XHW3Fsx4n+NTSdmc8bM1mFdH8QM=;
	h=Date:To:From:Subject:Message-Id; b=loXfJiqGstpU//sNeJuymyxpvX63KB7llkIBHXDVXhmDbmgHOskM34L4vyHbv2SPWcsJ0m55fFQSIiv0/2fN2hhwhUIDzziIDdXtkj97kE0cz7FdCkx5Ef+75vYhvMSFtmBBPpPn47kbezN8i6fVmXRjCXVsieaASE0Sku+NXgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yWFaLsrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yWFaLsrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71756C4CEE4;
	Tue,  4 Mar 2025 02:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741056803;
	bh=aFVRZgV9gWYwmVo8XHW3Fsx4n+NTSdmc8bM1mFdH8QM=;
	h=Date:To:From:Subject:From;
	b=yWFaLsrllUBWRkXdVl+g8awI1zQwxVdJAKkZv/c4pDc5Tyef+T52W6S+oGTKQzhw6
	 mAyeKvUfFp+OuoSone6z8YDOpE1PHB9DudooM3R4c2o31Itzh95i41N+VujE+EZbzt
	 pGIpH5JDoFmmslJ9OC6g/v7roI5dxj0sj/nmQXF8=
Date: Mon, 03 Mar 2025 18:53:22 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch added to mm-hotfixes-unstable branch
Message-Id: <20250304025323.71756C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: respect core layer filters' allowance decision on ops layer
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
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

