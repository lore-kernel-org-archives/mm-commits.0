Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2743B198A2F
	for <mm-commits@vger.kernel.org>; Mon,  3 Mar 2025 22:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741041119; cv=none; b=uE/YH0XvvNVMCD/lhA16595kHReWs8qtLA0M+aJoLA/3NkkD77eZBlMuz17iJk0jIk/9fk2AucwOIKYygAeiXfhP2Q6DOXr6l0e0SKiY7+A74KTMyUATs6aQX2mH9hMIU56kevjxD1wMKBvBOn27OdErsQWP/DfMtAerSZomr8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741041119; c=relaxed/simple;
	bh=PwCmo1I2JRvA/tG1wsOMomaDqkDIw0A/Z2sMB/xTLBw=;
	h=Date:To:From:Subject:Message-Id; b=i2Y6/x8sLa33lW8hNun4cejGv0FxdfYsVNfsBkffpiNdLXYLWfN7Q7qS7cSLoX10OlYINVgC8D2X2BCgOhuyXzwOus3GXG1J3YVeUXWe7xckO9YazWJgM+lZbwpZ4zpQd9PUBu8b3yB/XZ847p20sl1/ot5GeNguE2ce/UJNgJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=un4Ia4ye; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="un4Ia4ye"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D821AC4CED6;
	Mon,  3 Mar 2025 22:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741041118;
	bh=PwCmo1I2JRvA/tG1wsOMomaDqkDIw0A/Z2sMB/xTLBw=;
	h=Date:To:From:Subject:From;
	b=un4Ia4yecsVGwbXqc6BnWiEVZxBpu+yjn6efrDOWI5a767WUy19mYQZ747oCx0MU3
	 4LJ8XJ3o5w6/NB2FdL3i2ZN+fseM25xk+0FMeAQTtWDj3O3s1bg6WJTmYZyHKvTT1i
	 a5CL6iPfQMzvGI0RCYs3/ZfO730n9j0ISiy/t7Vk=
Date: Mon, 03 Mar 2025 14:31:58 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-commit-intervals-tuning-goal.patch added to mm-unstable branch
Message-Id: <20250303223158.D821AC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: commit intervals tuning goal
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-commit-intervals-tuning-goal.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-commit-intervals-tuning-goal.patch

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
Subject: mm/damon/sysfs: commit intervals tuning goal
Date: Mon, 3 Mar 2025 14:17:22 -0800

Connect DAMON sysfs interface for sampling and aggregation intervals
auto-tuning with DAMON core API, so that users can really use the feature
using the sysfs files.

Link: https://lkml.kernel.org/r/20250303221726.484227-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-commit-intervals-tuning-goal
+++ a/mm/damon/sysfs.c
@@ -1273,11 +1273,18 @@ static int damon_sysfs_set_attrs(struct
 		struct damon_sysfs_attrs *sys_attrs)
 {
 	struct damon_sysfs_intervals *sys_intervals = sys_attrs->intervals;
+	struct damon_sysfs_intervals_goal *sys_goal =
+		sys_intervals->intervals_goal;
 	struct damon_sysfs_ul_range *sys_nr_regions =
 		sys_attrs->nr_regions_range;
 	struct damon_attrs attrs = {
 		.sample_interval = sys_intervals->sample_us,
 		.aggr_interval = sys_intervals->aggr_us,
+		.intervals_goal = {
+			.access_bp = sys_goal->access_bp,
+			.aggrs = sys_goal->aggrs,
+			.min_sample_us = sys_goal->min_sample_us,
+			.max_sample_us = sys_goal->max_sample_us},
 		.ops_update_interval = sys_intervals->update_us,
 		.min_nr_regions = sys_nr_regions->min,
 		.max_nr_regions = sys_nr_regions->max,
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

