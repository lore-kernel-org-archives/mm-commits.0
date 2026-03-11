Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7773043DC
	for <mm-commits@vger.kernel.org>; Wed, 11 Mar 2026 20:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773262299; cv=none; b=U9DRgmhK22efAph92dZeplvJPz/EZUW+rc4kx0kPB32J/GloTPvaIVMb6iUElJI7D+B72LiRt5SAtn8hzOMngQfoPSlE+ky9ZSQAUMdkmRPsjtNh+EeuY8fHr8BR+9HZncUF7AUIK0dFHSaGwfey90UQS4Hrqtwmk2QdbpziIS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773262299; c=relaxed/simple;
	bh=ze9KP4MuQs02qCw7WLY2VXYqdrZJ4ObqaG9IBn5/+nQ=;
	h=Date:To:From:Subject:Message-Id; b=NHcBXN8p3AReu0WPlRtdbCsyVbHnkVYAJkS4it0Tcj0A5kGfCMw2FS3lPaU7+hoQIBLEkboX//4MDdg6feq3wdr/bf4pjZ25oDn+1jxMfqg9X9lF1Fn5jxf26RFZ1kSrh/jfMAuFq1MImqiGFGbCGU+05qfFHCGGtSZ1krqRqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u89lyz9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u89lyz9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AED1C4CEF7;
	Wed, 11 Mar 2026 20:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773262298;
	bh=ze9KP4MuQs02qCw7WLY2VXYqdrZJ4ObqaG9IBn5/+nQ=;
	h=Date:To:From:Subject:From;
	b=u89lyz9gcH7GPh+mQ5xpDmxqZcJVCyzq4VKPN+VAU3hgNvnz8Wux++1V4rQYfXsSI
	 GK98Y+h2Yxz1T2R64I6tzBrwagPA5mprgaVZ2X3GzI4hNd78RqzF14Ks5+snKFlFLo
	 8cCB50FJHRfKGzfiODeMb3tqlOUv7zuiZJQm5Xkw=
Date: Wed, 11 Mar 2026 13:51:37 -0700
To: mm-commits@vger.kernel.org,yangyingliang@huawei.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch added to mm-new branch
Message-Id: <20260311205138.7AED1C4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/reclaim: respect addr_unit on default monitoring region setup
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup.patch

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
Subject: mm/damon/reclaim: respect addr_unit on default monitoring region setup
Date: Tue, 10 Mar 2026 22:29:25 -0700

In the past, damon_set_region_biggest_system_ram_default(), which is the
core function for setting the default monitoring target region of
DAMON_RECLAIM, didn't support addr_unit.  Hence DAMON_RECLAIM was silently
ignoring the user input for addr_unit when the user doesn't explicitly set
the monitoring target regions, and therefore the default target region is
being used.  No real problem from that ignorance was reported so far. 
But, the implicit rule is only making things confusing.  Also, the default
target region setup function is updated to support addr_unit.  Hence there
is no reason to keep ignoring it.  Respect the user-passed addr_unit for
the default target monitoring region use case.

Link: https://lkml.kernel.org/r/20260311052927.93921-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Yang yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/reclaim.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/damon/reclaim.c~mm-damon-reclaim-respect-addr_unit-on-default-monitoring-region-setup
+++ a/mm/damon/reclaim.c
@@ -201,12 +201,6 @@ static int damon_reclaim_apply_parameter
 	if (err)
 		return err;
 
-	/*
-	 * If monitor_region_start/end are unset, always silently
-	 * reset addr_unit to 1.
-	 */
-	if (!monitor_region_start && !monitor_region_end)
-		addr_unit = 1;
 	param_ctx->addr_unit = addr_unit;
 	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
 
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

