Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314B367;
	Thu,  6 Mar 2025 05:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239459; cv=none; b=iSIfTVHeVulVLMry1rLX5Gw1svkjMqp6KCfUlRARFTdAeeECDfBuPmkZGviMo0sEFNpZ/E1Nj7YBW66eAWzG3gGDq+UcE0pxgkDqeOLyvJ0xVmzKSmzVwPIDg7Jm/dTR4RDePdTiIDZxpxer1X+lTGmGoDGXH7S+5bQyPdcdD+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239459; c=relaxed/simple;
	bh=Y0MbpPn2Sk0CB1BAwx/U9338SxIXESLVNOO3vHHR4V0=;
	h=Date:To:From:Subject:Message-Id; b=ZwchO8bbkTH3POG5N31WxK2yOYeB7eSDnxM67RJqHYuhWneBmPTZAfCoQxJIJA776d1psTzFHDOPZRcqHUoqPPPrX6NE5wit5Tz+DEl3tcsAQvGJDmZm3Bd1FMa8q2dqdEnoOa6PH/yuW3Fzp04lbimbJhiNqz3bksxEvfGOu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LrtdEdyG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LrtdEdyG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87DE7C4CEE4;
	Thu,  6 Mar 2025 05:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239459;
	bh=Y0MbpPn2Sk0CB1BAwx/U9338SxIXESLVNOO3vHHR4V0=;
	h=Date:To:From:Subject:From;
	b=LrtdEdyG3TEeQpgdzjrk/h0CFQe1SX2kONaGOXHrIY72MWR4i+42NUYDIMN/ide2R
	 mM4F6+jd9kzwjshEkqxg4+07sfNylr3JjCoxFFPPPN6nWYS74ISeEnun9ULHBl7YZM
	 3n+hT9iuW1IKB6HRSOUi6dY9uJG8oiwr3Mol9/Xc=
Date: Wed, 05 Mar 2025 21:37:39 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch removed from -mm tree
Message-Id: <20250306053739.87DE7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damon_nr_regions: set ops update for merge results check to 100ms
has been removed from the -mm tree.  Its filename was
     selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damon_nr_regions: set ops update for merge results check to 100ms
Date: Tue, 25 Feb 2025 14:23:32 -0800

damon_nr_regions.py updates max_nr_regions to a number smaller than
expected number of real regions and confirms DAMON respect the harsh
limit.  To give time for DAMON to make changes for the regions, 3
aggregation intervals (300 milliseconds) are given.

The internal mechanism works with not only the max_nr_regions, but also
sz_limit, though.  It avoids merging region if that casn make region of
size larger than sz_limit.  In the test, sz_limit is set too small to
achive the new max_nr_regions, unless it is updated for the new
min_nr_regions.  But the update is done only once per operations set
update interval, which is one second by default.

Hence, the test randomly incurs false positive failures.  Fix it by
setting the ops interval same to aggregation interval, to make sure
sz_limit is updated by the time of the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-3-sj@kernel.org
Fixes: 8bf890c81612 ("selftests/damon/damon_nr_regions: test online-tuned max_nr_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damon_nr_regions.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -109,6 +109,7 @@ def main():
     attrs = kdamonds.kdamonds[0].contexts[0].monitoring_attrs
     attrs.min_nr_regions = 3
     attrs.max_nr_regions = 7
+    attrs.update_us = 100000
     err = kdamonds.kdamonds[0].commit()
     if err is not None:
         proc.terminate()
_

Patches currently in -mm which might be from sj@kernel.org are

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

