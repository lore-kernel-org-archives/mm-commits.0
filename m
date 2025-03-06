Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D720E19E97A;
	Thu,  6 Mar 2025 05:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741239460; cv=none; b=FbWGv5LX/KmlnQ8oeRZdUk5i0bbC0HDhXPs0btLPBbxPs26o7GNMuoMs68FkBIF+s1ElBuiIekAO805UjGWzbAb5+dM5+gWYefFYuFTv0tbqCN8tRKu1ZObgflcEN0FxohUaRhXSP8JX+hGgNBJjxUtHBq3H5YkITV5BxieVOe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741239460; c=relaxed/simple;
	bh=IY4DvPFo3vnwF0TW3TwE4vT+STE2QhTYEb5ArDzfI4Y=;
	h=Date:To:From:Subject:Message-Id; b=uli2xIk40ArhaY53RW6TaUFvGvKR6fp+uP6bc+cEH76RAmL+J9zN9Lj3flkQlOexe4nhIkX+/6oJSMxGSf/K5RnICEhBVVe7O0OF05xJlKgEiM3tgBhGJP2bxH5w0DB/ANebx6OJgHBy7G9n8jRQuraRMxboUFrrkTpTSWzQXLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U0HesEyr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U0HesEyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE83FC4CEE4;
	Thu,  6 Mar 2025 05:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741239460;
	bh=IY4DvPFo3vnwF0TW3TwE4vT+STE2QhTYEb5ArDzfI4Y=;
	h=Date:To:From:Subject:From;
	b=U0HesEyrZDteqYvjMxTUWM/SAzMOJcYAxGfPDlhg5e2C6cYYK0XBYsu49fiI7x1bR
	 PyJp0XiR2C53RUIZDwgWJmzmRGY6xH+WZQ8KuHOvQxuzaRrrAhEeRVY0NgXPIojaTQ
	 n9/PuZogUjxWXoZQzEX2yME+VONkwX4dDfV3ma18=
Date: Wed, 05 Mar 2025 21:37:40 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch removed from -mm tree
Message-Id: <20250306053740.AE83FC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/damon_nr_regions: sort collected regiosn before checking with min/max boundaries
has been removed from the -mm tree.  Its filename was
     selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: selftests/damon/damon_nr_regions: sort collected regiosn before checking with min/max boundaries
Date: Tue, 25 Feb 2025 14:23:33 -0800

damon_nr_regions.py starts DAMON, periodically collect number of regions
in snapshots, and see if it is in the requested range.  The check code
assumes the numbers are sorted on the collection list, but there is no
such guarantee.  Hence this can result in false positive test success. 
Sort the list before doing the check.

Link: https://lkml.kernel.org/r/20250225222333.505646-4-sj@kernel.org
Fixes: 781497347d1b ("selftests/damon: implement test for min/max_nr_regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/damon_nr_regions.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/damon_nr_regions.py~selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries
+++ a/tools/testing/selftests/damon/damon_nr_regions.py
@@ -65,6 +65,7 @@ def test_nr_regions(real_nr_regions, min
 
     test_name = 'nr_regions test with %d/%d/%d real/min/max nr_regions' % (
             real_nr_regions, min_nr_regions, max_nr_regions)
+    collected_nr_regions.sort()
     if (collected_nr_regions[0] < min_nr_regions or
         collected_nr_regions[-1] > max_nr_regions):
         print('fail %s' % test_name)
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

