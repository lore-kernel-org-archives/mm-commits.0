Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3373C660E
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165662; cv=none; b=inFDwYToGSkiS5zpgq4/+54f2PaRTuRnNBCn3rtH2qjhM4WtIzRqWs8cN+Fkt2TGpn79HF4xKdq+OsXFtjmT6snjnoyyIg/cNB6kZR6ERFaDnN8Na48STVpkMMUk5M1r6BbolyHP7lfQIRGw10NVH7ukh7SCr6n/UqLgOv1GmQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165662; c=relaxed/simple;
	bh=nlG1TOBZu5yzr2fsPK8/R/3gL/TjsVZcCS8hnBuKHPw=;
	h=Date:To:From:Subject:Message-Id; b=KpKIdrnvEb4tDcL9HvbJNr/pOi5Y+78bTpkVHVo0Vcr6R+UFYyXM/RQHVuK2srW6+iz6RfrXh/gqrHeTYjnT7wrTjMgxEN6q9AxnuaGMUKdAtGM8au3qOPFNfP2lEK6YMAMbg2FIdJupPQGQ5MJkZb4zVUuwVAzDAo0bQFl3iO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0SwwFO8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0SwwFO8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7472DC19423;
	Tue, 10 Mar 2026 18:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165662;
	bh=nlG1TOBZu5yzr2fsPK8/R/3gL/TjsVZcCS8hnBuKHPw=;
	h=Date:To:From:Subject:From;
	b=0SwwFO8S1Jnzr6fMBCoQNmqgm3+iaQ7mu03YjdRf6EfqRs/vf3w8crefpZx12Cd+7
	 ClhQGut5Zxo5HI7qqM7gqVn3lUTliE6vYALBZhOgHIL4swDI6ABfoKIq2faQoKZ56g
	 q+2IWfT2f6PxUQezzfegTX7MsXiLH9wIm2zsCsqc=
Date: Tue, 10 Mar 2026 11:01:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch added to mm-new branch
Message-Id: <20260310180102.7472DC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/_damon_sysfs: support goal_tuner setup
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-_damon_sysfs-support-goal_tuner-setup.patch

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
Subject: selftests/damon/_damon_sysfs: support goal_tuner setup
Date: Mon, 9 Mar 2026 18:05:25 -0700

Add support of goal_tuner setup to the test-purpose DAMON sysfs interface
control helper, _damon_sysfs.py.

Link: https://lkml.kernel.org/r/20260310010529.91162-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/_damon_sysfs.py |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/damon/_damon_sysfs.py~selftests-damon-_damon_sysfs-support-goal_tuner-setup
+++ a/tools/testing/selftests/damon/_damon_sysfs.py
@@ -130,15 +130,16 @@ class DamosQuota:
     sz = None                   # size quota, in bytes
     ms = None                   # time quota
     goals = None                # quota goals
+    goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0,
-                 weight_sz_permil=0, weight_nr_accesses_permil=0,
-                 weight_age_permil=0):
+    def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
+                 reset_interval_ms=0, weight_sz_permil=0,
+                 weight_nr_accesses_permil=0, weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -146,6 +147,7 @@ class DamosQuota:
         self.weight_nr_accesses_permil = weight_nr_accesses_permil
         self.weight_age_permil = weight_age_permil
         self.goals = goals if goals is not None else []
+        self.goal_tuner = goal_tuner
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
@@ -191,6 +193,10 @@ class DamosQuota:
             err = goal.stage()
             if err is not None:
                 return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
+        if err is not None:
+            return err
         return None
 
 class DamosWatermarks:
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

