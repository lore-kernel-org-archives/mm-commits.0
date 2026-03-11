Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064B340DFB1
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262294; cv=none; b=ezTZ6Y8o3+a/iDbpKIMjhuxK+KBJmF7tixjqnUMfYKW66Q0e+0Hd4DjYl6uwBdhgYGmmARNw37idiJr1PzAngzGLxZWl2DvRX4/dEzJbYptDKjHOF/VyE65RsAJi4naVW4Su5p4VOZ2vtn+0jEQ2XTfNrkDg3hvSGOAc7bcKf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262294; c=relaxed/simple;
	bh=Zm/y7P0j1lDjxVz4bvWidxIkLSZR/XjKZTJo4kW/sfI=;
	h=Date:To:From:Subject:Message-Id; b=FDLt0leL8tRvgYl/0E2iyaB/J+4OdyCfJVJvynxbwEdSkfEjux/V7HcxK6wOwG5feIKkLa2qwT4+fkWlla7HYmGSsDECvYxFyiKrIBRA6N4wu4CYol8+000Wm4Ct7DmUr/uOgWClDMX/EzOE8lu229bynhVps9Qo9soJUIFeKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2ef+BU2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2ef+BU2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7523AC4CEF7;
	Wed, 11 Mar 2026 20:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773262293;
	bh=Zm/y7P0j1lDjxVz4bvWidxIkLSZR/XjKZTJo4kW/sfI=;
	h=Date:To:From:Subject:From;
	b=2ef+BU2/+hVhA5kmANuWS66Q/ets7PBbFl04P/s7gnBSvLCP2JtVULFnx136baOZc
	 R54/lNDLiOUGtAssSLArKk4QYLe7euMlqXjDJqC/2kz4vgzwsLVQiLwoNhDGzJzfvV
	 8/TCRp1hlrF9PXz+XNOFTH5OwLxcWXOJycp+CDQg=
Date: Wed, 11 Mar 2026 13:51:32 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch added to mm-new branch
Message-Id: <20260311205133.7523AC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: fix wrong end address assignment on walk_system_ram()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: fix wrong end address assignment on walk_system_ram()
Date: Tue, 10 Mar 2026 22:29:22 -0700

Patch series "mm/damon: support addr_unit on default monitoring targets
for modules".

DAMON_RECLAIM and DAMON_LRU_SORT support 'addr_unit' parameters only when
the monitoring target address range is explicitly set.  This was
intentional for making the initial 'addr_unit' support change small.  Now
'addr_unit' support is being quite stabilized.  Having the corner case of
the support is only making the code inconsistent with implicit rules.  The
inconsistency makes it easy to confuse [1] readers.  After all, there is
no real reason to keep 'addr_unit' support incomplete.  Add the support
for the case to improve the readability and more completely support
'addr_unit'.

This series is constructed with five patches.  The first one (patch 1)
fixes a small bug that mistakenly assigns inclusive end address to open
end address, which was found from this work.  The second and third ones
(patches 2 and 3) extend the default monitoring target setting functions
in the core layer one by one, to support the 'addr_unit' while making no
visible changes.  The final two patches (patches 4 and 5) update
DAMON_RECLAIM and DAMON_LRU_SORT to support 'addr_unit' for the default
monitoring target address ranges, by passing the user input to the core
functions.


This patch (of 5):

'struct damon_addr_range' and 'struct resource' represent different types
of address ranges.  'damon_addr_range' is for end-open ranges ([start,
end)).  'resource' is for fully-closed ranges ([start, end]).  But
walk_system_ram() is assigning resource->end to damon_addr_range->end
without the inclusiveness adjustment.  As a result, the function returns
an address range that is missing the last one byte.

The function is being used to find and set the biggest system ram as the
default monitoring target for DAMON_RECLAIM and DAMON_LRU_SORT.  Missing
the last byte of the big range shouldn't be a real problem for the real
use cases.  That said, the loss is definitely an unintended behavior.  Do
the correct adjustment.

Link: https://lkml.kernel.org/r/20260311052927.93921-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260311052927.93921-2-sj@kernel.org
Link: https://lore.kernel.org/20260131015643.79158-1-sj@kernel.org [1]
Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-fix-wrong-end-address-assignment-on-walk_system_ram
+++ a/mm/damon/core.c
@@ -3060,7 +3060,7 @@ static int walk_system_ram(struct resour
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end;
+		a->end = res->end + 1;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-set-quota-score-histogram-with-core-filters.patch
mm-damon-core-do-non-safe-region-walk-on-kdamond_apply_schemes.patch
mm-damon-core-split-regions-for-min_nr_regions.patch
mm-damon-vaddr-do-not-split-regions-for-min_nr_regions.patch
mm-damon-test-core-kunit-add-damon_apply_min_nr_regions-test.patch
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
mm-damon-core-receive-addr_unit-on-damon_set_region_biggest_system_ram_default.patch
mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch
mm-damon-lru_sort-respect-addr_unit-on-default-monitoring-region-setup.patch

