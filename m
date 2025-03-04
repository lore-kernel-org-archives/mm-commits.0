Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEE027814C
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130352; cv=none; b=q8chJXCGDRP+jUDD3H2n1aGHgYDmkH3tl5rb1MVN2h3y8VEKFNM6QRzMj3QTP18psv2kHXRBqzmc5iTXQBRiNO4iaTb+aSv+NwM9IhylCa3CTkmbXAg7OENxzjELNz/FNrDXlrCPY9zLmUdt2xutptV0NkujpPZWR82Adu00Ls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130352; c=relaxed/simple;
	bh=bmhltNgYzbPjB09WNns9XONg3XkrrhDnBeVaxZ89Ivs=;
	h=Date:To:From:Subject:Message-Id; b=VFwIBgHbtjjRTXleuEXlnf0Q5rAClyknJ679N8xT263lv4jXTwX+Bb0dpsr+YYmJJE6OcKuMsvIhBFrUahiBvHc8Www3+8SjlMwBLxjy8Nuc3G+wroxJ7gvcvShrEX3ZY5VX2rQ/5RrLEWnrm1rU8WGHkbaSDXM/4/Pw9hDPpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IErU+nOZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IErU+nOZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C13C4CEE9;
	Tue,  4 Mar 2025 23:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130352;
	bh=bmhltNgYzbPjB09WNns9XONg3XkrrhDnBeVaxZ89Ivs=;
	h=Date:To:From:Subject:From;
	b=IErU+nOZKqQys2YlzKTfiIM/0BXsM4I4xBQQw29Kz8CfibPit6Ecls6WTNyql/cuO
	 z0TRF0EB9Z5uiTS2hmTvLooj2sF1PdHy1euQoAea4z26uH7jMsOi7YruleWaOjbHaV
	 0MfH4/fpom9muK2aCTHuUjbwY4Gpsop9eX3liy5w=
Date: Tue, 04 Mar 2025 15:19:11 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch added to mm-unstable branch
Message-Id: <20250304231912.17C13C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add default allow/reject behavior fields to struct damos
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch

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
Subject: mm/damon: add default allow/reject behavior fields to struct damos
Date: Tue, 4 Mar 2025 13:19:10 -0800

Current default allow/reject behavior of filters handling stage has made
before introduction of the allow behavior.  For allow-filters usage, it is
confusing and inefficient.

It is more intuitive to decide the default filtering stage allow/reject
behavior as opposite to the last filter's behavior.  The decision should
be made separately for core and operations layers' filtering stages, since
last core layer-handled filter is not really a last filter if there are
operations layer handling filters.

Keeping separate decisions for the two categories can make the logic
simpler.  Add fields for storing the two decisions.

Link: https://lkml.kernel.org/r/20250304211913.53574-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    3 +++
 1 file changed, 3 insertions(+)

--- a/include/linux/damon.h~mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos
+++ a/include/linux/damon.h
@@ -502,6 +502,9 @@ struct damos {
 	 * layer-handled filters.  If true, operations layer allows it, too.
 	 */
 	bool core_filters_allowed;
+	/* whether to reject core/ops filters umatched regions */
+	bool core_filters_default_reject;
+	bool ops_filters_default_reject;
 /* public: */
 	struct damos_quota quota;
 	struct damos_watermarks wmarks;
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

