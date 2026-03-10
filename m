Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78703C9434
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165654; cv=none; b=Vn/HgkjDzfgrL63s9eu45iIeK+xP3kS83Nr7z6ojjnjfmk8JlclYkn4u6VDzPJID6pHOnhXybaLgzhPZjfx4KCq8/msOMj/OGQNzHusJUGrT2prtECuSRSamHuFg94UDoihqAh1mgZNAl8f9Z9gDtikJW7znW5Bbbrmfmmz/Cds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165654; c=relaxed/simple;
	bh=8ygJn82osMWq3XZFyPEmo6uVDbPzcBzNvtr4sVzIJZE=;
	h=Date:To:From:Subject:Message-Id; b=DHO2bpTP1zfTwXS0QjZFX8BulIJyfj5264iJTabeL1ep8Ekgr2yAMNblK0iVSnTbID5k2aBkLqlLZ/ClRrbuNNL1af0g9mjWA+PfU9ICQWoOEb8ZGebdVO4v/deWGdf49+eZ3iiCpj9EKzxWeLJllIAaxN69V+1SQ5rodUGEKBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kcYp4kKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kcYp4kKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA17C19423;
	Tue, 10 Mar 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165654;
	bh=8ygJn82osMWq3XZFyPEmo6uVDbPzcBzNvtr4sVzIJZE=;
	h=Date:To:From:Subject:From;
	b=kcYp4kKYIW/7o991UPlvpFUAq2WAgGmdB66GHrF7f+rw6kPP+U9/XH0MZTV6jXbky
	 ubpuqcokXg/IqoRcAsljHAOG7gn/Er6Fvu8ZRdZv7S4lsiFAqsvKL/ZuKnkzdOGMsf
	 7nLjj+/N0nxfZpH6Sya8p/SJ8lPNfo/R9tNho5ro=
Date: Tue, 10 Mar 2026 11:00:53 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch added to mm-new branch
Message-Id: <20260310180054.5CA17C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document the goal-based quota tuner selections
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-the-goal-based-quota-tuner-selections.patch

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
Subject: Docs/mm/damon/design: document the goal-based quota tuner selections
Date: Mon, 9 Mar 2026 18:05:21 -0700

Update the design document for the newly added goal-based quota tuner
selection feature.

Link: https://lkml.kernel.org/r/20260310010529.91162-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-the-goal-based-quota-tuner-selections
+++ a/Documentation/mm/damon/design.rst
@@ -566,6 +566,18 @@ aggressiveness (the quota) of the corres
 is under achieving the goal, DAMOS automatically increases the quota.  If DAMOS
 is over achieving the goal, it decreases the quota.
 
+There are two such tuning algorithms that users can select as they need.
+
+- ``consist``: A proportional feedback loop based algorithm.  Tries to find an
+  optimum quota that should be consistently kept, to keep achieving the goal.
+  Useful for kernel-only operation on dynamic and long-running environments.
+  This is the default selection.  If unsure, use this.
+- ``temporal``: More straightforward algorithm.  Tries to achieve the goal as
+  fast as possible, using maximum allowed quota, but only for a temporal short
+  time.  When the quota is under-achieved, this algorithm keeps tuning quota to
+  a maximum allowed one.  Once the quota is [over]-achieved, this sets the
+  quota zero.  Useful for deterministic control required environments.
+
 The goal can be specified with five parameters, namely ``target_metric``,
 ``target_value``, ``current_value``, ``nid`` and ``path``.  The auto-tuning
 mechanism tries to make ``current_value`` of ``target_metric`` be same to
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

