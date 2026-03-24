Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5A237BE6E
	for <mm-commits@vger.kernel.org>; Tue, 24 Mar 2026 21:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774388654; cv=none; b=PN1mnD6GMz9jfPDQ/eS6fwI2MY8S7s5ttfjxcD6hKw7fo88VlwXFuaVC8CA+Ta1m4i5m39pGEbMN+l4eLZV3rWIlfEf3gc6HomxSpy6FKc2LsQKoyHgMN68Z/drl5McyyDutmljmoYhAhwxJz+QGe8KIz/FEzY5xL0H55aJ34GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774388654; c=relaxed/simple;
	bh=gku+issVdlkL+qQ6r8PM7oKhwkAVtZbg1TwCIBGse6c=;
	h=Date:To:From:Subject:Message-Id; b=MNRL0SMhe4YQynGHWQCmwA7mvGgUOPw4UmbByO14vaWRBYjXerQ38ZVw8T1w13M6Xoy7dPXMXT1qza704Bk1XW0c0yVKIOaOaZEJ4OFpl3383oOwrm7a6QtOsQRMbmp+5ey4aJOyMaMkmGtOsVb8HO8B6x68pIQJg0/+XXlKMi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FBc6ZaMF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FBc6ZaMF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8535BC2BC9E;
	Tue, 24 Mar 2026 21:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774388654;
	bh=gku+issVdlkL+qQ6r8PM7oKhwkAVtZbg1TwCIBGse6c=;
	h=Date:To:From:Subject:From;
	b=FBc6ZaMF9H09CINziKwekO4km6M+DQYAP9Bs9cc20P5t6DVGgSZOv27AlG0DaIm+W
	 RmhTiNBwPKJYinDxQIECUu/tbJRbD7xS/c9DMPGegfrU59MPx1nvnM3Q2nuDH1CBIZ
	 craqEWRH/3N2YzyCeTKP8eVIaN0ko8uUq0BlRuU8=
Date: Tue, 24 Mar 2026 14:44:14 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-set-quota-score-histogram-with-core-filters.patch removed from -mm tree
Message-Id: <20260324214414.8535BC2BC9E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/core: set quota-score histogram with core filters
has been removed from the -mm tree.  Its filename was
     mm-damon-core-set-quota-score-histogram-with-core-filters.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: set quota-score histogram with core filters
Date: Fri, 27 Feb 2026 09:06:20 -0800

Patch series "mm/damon/core: improve DAMOS quota efficiency for core layer
filters".

Improve two below problematic behaviors of DAMOS that makes it less
efficient when core layer filters are used.

DAMOS generates the under-quota regions prioritization-purpose access
temperature histogram [1] with only the scheme target access pattern.  The
DAMOS filters are ignored on the histogram, and this can result in the
scheme not applied to eligible regions.  For working around this, users
had to use separate DAMON contexts.  The memory tiering approaches are
such examples.

DAMOS splits regions that intersect with address filters, so that only
filtered-out part of the region is skipped.  But, the implementation is
skipping the other part of the region that is not filtered out, too.  As a
result, DAMOS can work slower than expected.

Improve the two inefficient behaviors with two patches, respectively. 
Read the patches for more details about the problem and how those are
fixed.


This patch (of 2):

The histogram for under-quota region prioritization [1] is made for all
regions that are eligible for the DAMOS target access pattern.  When there
are DAMOS filters, the prioritization-threshold access temperature that
generated from the histogram could be inaccurate.

For example, suppose there are three regions.  Each region is 1 GiB.  The
access temperature of the regions are 100, 50, and 0.  And a DAMOS scheme
that targets _any_ access temperature with quota 2 GiB is being used.  The
histogram will look like below:

    temperature	size of regions having >=temperature temperature
    0		3 GiB
    50		2 GiB
    100		1 GiB

Based on the histogram and the quota (2 GiB), DAMOS applies the action to
only the regions having >=50 temperature.  This is all good.

Let's suppose the region of temperature 50 is excluded by a DAMOS filter. 
Regardless of the filter, DAMOS will try to apply the action on only
regions having >=50 temperature.  Because the region of temperature 50 is
filtered out, the action is applied to only the region of temperature 100.
Worse yet, suppose the filter is excluding regions of temperature 50 and
100.  Then no action is really applied to any region, while the region of
temperature 0 is there.

People used to work around this by utilizing multiple contexts, instead of
the core layer DAMOS filters.  For example, DAMON-based memory tiering
approaches including the quota auto-tuning based one [2] are using a DAMON
context per NUMA node.  If the above explained issue is effectively
alleviated, those can be configured again to run with single context and
DAMOS filters for applying the promotion and demotion to only specific
NUMA nodes.

Alleviate the problem by checking core DAMOS filters when generating the
histogram.  The reason to check only core filters is the overhead.  While
core filters are usually for coarse-grained filtering (e.g.,
target/address filters for process, NUMA, zone level filtering), operation
layer filters are usually for fine-grained filtering (e.g., for anon
page).  Doing this for operation layer filters would cause significant
overhead.  There is no known use case that is affected by the operation
layer filters-distorted histogram problem, though.  Do this for only core
filters for now.  We will revisit this for operation layer filters in
future.  We might be able to apply a sort of sampling based operation
layer filtering.

After this fix is applied, for the first case that there is a DAMOS filter
excluding the region of temperature 50, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		2 GiB
    100		1 GiB

And DAMOS will set the temperature threshold as 0, allowing both regions
of temperatures 0 and 100 be applied.

For the second case that there is a DAMOS filter excluding the regions of
temperature 50 and 100, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		1 GiB

And DAMOS will set the temperature threshold as 0, allowing the region of
temperature 0 be applied.

[1] 'Prioritization' section of Documentation/mm/damon/design.rst
[2] commit 0e1c773b501f ("mm/damon/core: introduce damos quota goal
    metrics for memory node utilization")

Link: https://lkml.kernel.org/r/20260227170623.95384-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260227170623.95384-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-set-quota-score-histogram-with-core-filters
+++ a/mm/damon/core.c
@@ -2319,6 +2319,8 @@ static void damos_adjust_quota(struct da
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
+			if (damos_core_filter_out(c, t, r, s))
+				continue;
 			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-add-config_damon_debug_sanity.patch
mm-damon-core-add-damon_new_region-debug_sanity-check.patch
mm-damon-core-add-damon_del_region-debug_sanity-check.patch
mm-damon-core-add-damon_nr_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_two_regions-debug_sanity-check.patch
mm-damon-core-add-damon_merge_regions_of-debug_sanity-check.patch
mm-damon-core-add-damon_split_region_at-debug_sanity-check.patch
mm-damon-core-add-damon_reset_aggregated-debug_sanity-check.patch
mm-damon-tests-kunitconifg-enable-damon_debug_sanity.patch
selftests-damon-config-enable-damon_debug_sanity.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_commit_ctx.patch
docs-mm-damon-design-document-the-power-of-two-limitation-for-addr_unit.patch
mm-damon-core-remove-damos_set_next_apply_sis-duplicates.patch
mm-damon-core-use-time_before-for-next_apply_sis.patch
mm-damon-core-use-time_after_eq-in-kdamond_fn.patch
mm-damon-core-use-mult_frac.patch
mm-damon-tests-core-kunit-add-a-test-for-damon_is_last_region.patch
mm-damon-core-clarify-damon_set_attrs-usages.patch
mm-damon-document-non-zero-length-damon_region-assumption.patch
docs-admin-guide-mm-damn-lru_sort-fix-intervals-autotune-parameter-name.patch
docs-mm-damon-maintainer-profile-use-flexible-review-cadence.patch
docs-mm-damon-index-fix-typo-autoamted-automated.patch
mm-damon-core-introduce-damos_quota_goal_tuner.patch
mm-damon-core-allow-quota-goals-set-zero-effective-size-quota.patch
mm-damon-core-introduce-damos_quota_goal_tuner_temporal.patch
mm-damon-sysfs-schemes-implement-quotas-goal_tuner-file.patch
docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch
docs-admin-guide-mm-damon-usage-document-goal_tuner-sysfs-file.patch
docs-abi-damon-update-for-goal_tuner.patch
mm-damon-tests-core-kunit-test-goal_tuner-commit.patch
selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch
selftests-damon-drgn_dump_damon_status-support-quota-goal_tuner-dumping.patch
selftests-damon-sysfspy-test-goal_tuner-commit.patch
mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram.patch
mm-damon-core-support-addr_unit-on-damon_find_biggest_system_ram-fix.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default-fix.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

