Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8894424DFE1
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130356; cv=none; b=nGh17oqJNmie4bLdRqqCn2tMJqzjKeyGLHlKW1ylmZdBY1i08gzZrTlXBj+r73j4pK7lf7V5k0BOEJjwQSYEqY1Ey5z/2BZVAWShAEhFwF4trx1X2dOcZt7Zqby6PjsMPehJ+tR6Rdqv0R1RljxV5TuP66gj4xX3dW8IxlMkM/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130356; c=relaxed/simple;
	bh=JmBlbvQx/nZDqk4tYDnL7gfsHdZYQcYNN6PU9UMOSXA=;
	h=Date:To:From:Subject:Message-Id; b=eCsMbv2fX4LEx8DGg8ya1VrhE1M7g30bzOJyxFE2Ll+R813dE+I+TfHxFvFs/Q2ZEbVjYpWBnkXU3Cpbo94Z8RWdrRJTYuq6xaO4d6yWtjLw6vibzsdfJ2oaHBR6faiNOT07eaCFNTu4GzK4OhqTk+HhDPN5ZAvhVSio1fY3Z28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pxpVhws2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pxpVhws2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40B7C4CEE5;
	Tue,  4 Mar 2025 23:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130356;
	bh=JmBlbvQx/nZDqk4tYDnL7gfsHdZYQcYNN6PU9UMOSXA=;
	h=Date:To:From:Subject:From;
	b=pxpVhws2zbDjMcsi3OQjzLpU7bnpH+tXRzKcQ7zH3QpJCnwH1rSwMX0xYGAbXZhp6
	 jRXCTcOw0FCw1UKswZboW1eo7YZKJ/+OMud1CmiYuXwfsMYOy/9FtDelMSPYtS3BtQ
	 ZnMrXJEdKqV6Ih9FeMlanFIqjKouxRavWR+1kDxw=
Date: Tue, 04 Mar 2025 15:19:15 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-respect-ops_filters_default_reject.patch added to mm-unstable branch
Message-Id: <20250304231915.F40B7C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: respect ops_filters_default_reject
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-respect-ops_filters_default_reject.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-respect-ops_filters_default_reject.patch

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
Subject: mm/damon/paddr: respect ops_filters_default_reject
Date: Tue, 4 Mar 2025 13:19:12 -0800

Use damos->ops_filters_default_reject, which is set based on the installed
filters' behaviors, from physical address space DAMON operations set.

Link: https://lkml.kernel.org/r/20250304211913.53574-9-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/paddr.c~mm-damon-paddr-respect-ops_filters_default_reject
+++ a/mm/damon/paddr.c
@@ -260,7 +260,7 @@ static bool damos_pa_filter_out(struct d
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
 	}
-	return false;
+	return scheme->ops_filters_default_reject;
 }
 
 static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
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

