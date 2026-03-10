Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B39A3C0620
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165645; cv=none; b=Bt3wytJvYQRGIdmW4L6sX2/CW4v5fU1MKRJHSwYDrA7RxGOutVTtEg1uF3M5gmsCsVG3C3rN9F+u9TipHjGYV/YtGjtDF3lZ52o7ifAYcBz1pdd3jbMbppA1u+WNbHdBANl0vOgthX5ocC0uC916iaHW0gN7301PAB7wdySlMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165645; c=relaxed/simple;
	bh=1zdiYE0ZnJCHriDR2/sz0DEaYTTtjzD+Vhx1qIC7Opk=;
	h=Date:To:From:Subject:Message-Id; b=IVX44kTnlGiyZrmdFhKbDA0XgM8eb6E4hV1Es6K6png6IlWq2BsUIKhVm0N5UQtNWTwwmWIQDxeVoSty6iEJz4CB5WUk1FNA3fdZrV5NtE2fsiGAQlcHvB1q6jfA9y91qefxt/l+41OVS67c+KTzEdH9PTFzCovgWPfRRraWw4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zb8rCFur; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zb8rCFur"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 391ACC19423;
	Tue, 10 Mar 2026 18:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165645;
	bh=1zdiYE0ZnJCHriDR2/sz0DEaYTTtjzD+Vhx1qIC7Opk=;
	h=Date:To:From:Subject:From;
	b=zb8rCFurN55mOoRHSYICurfjrpvJ7LtjZhFXuLfkM+bMZrIw7Ch07tCLPEy+NixE9
	 VtdXCvdZn5Bpe+NpoziDnm9vJjHa6Ove1DJRkZ4k1jHoVCOSLeC5LhHnENFZOGa6i+
	 3XZi4D1ef1CS0RcnpaOaGni4NiKlfTPP+ima4SoA=
Date: Tue, 10 Mar 2026 11:00:44 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,davidgow@google.com,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damos_quota_goal_tuner.patch added to mm-new branch
Message-Id: <20260310180045.391ACC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damos_quota_goal_tuner
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-introduce-damos_quota_goal_tuner.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damos_quota_goal_tuner.patch

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
Subject: mm/damon/core: introduce damos_quota_goal_tuner
Date: Mon, 9 Mar 2026 18:05:17 -0700

Patch series "mm/damon: support multiple goal-based quota tuning
algorithms".

Aim-oriented DAMOS quota auto-tuning uses a single tuning algorithm.  The
algorithm is designed to find a quota value that should be consistently
kept for achieving the aimed goal for long term.  It is useful and
reliable at automatically operating systems that have dynamic environments
in the long term.

As always, however, no single algorithm fits all.  When the environment
has static characteristics or there are control towers in not only the
kernel space but also the user space, the algorithm shows some
limitations.  In such environments, users want kernel work in a more short
term deterministic way.  Actually there were at least two reports [1,2] of
such cases.

Extend DAMOS quotas goal to support multiple quota tuning algorithms that
users can select.  Keep the current algorithm as the default one, to not
break the old users.  Also give it a name, "consist", as it is designed to
"consistently" apply the DAMOS action.  And introduce a new tuning
algorithm, namely "temporal".  It is designed to apply the DAMOS action
only temporally, in a deterministic way.  In more detail, as long as the
goal is under-achieved, it uses the maximum quota available.  Once the
goal is over-achieved, it sets the quota zero.

Tests
=====

I confirmed the feature is working as expected using the latest version of
DAMON user-space tool, like below.

    $ # start DAMOS for reclaiming memory aiming 30% free memory
    $ sudo ./damo/damo start --damos_action pageout \
            --damos_quota_goal_tuner temporal \
            --damos_quota_goal node_mem_free_bp 30% 0 \
            --damos_quota_interval 1s \
            --damos_quota_space 100M

Note that >=3.1.8 version of DAMON user-space tool supports this feature
(--damos_quota_goal_tuner).  As expected, DAMOS stops reclaiming memory as
soon as the goal amount of free memory is made.  When 'consist' tuner is
used, the reclamation was continued even after the goal amount of free
memory is made, resulting in more than goal amount of free memory, as
expected.

Patch Sequence
==============

First four patches implement the features.  Patch 1 extends core API to
allow multiple tuners and make the current tuner as the default and only
available tuner, namely 'consist'.  Patch 2 allows future tuners setting
zero effective quota.  Patch 3 introduces the second tuner, namely
'temporal'.  Patch 4 further extends DAMON sysfs API to let users use
that.

Three following patches (patches 5-7) update design, usage, and ABI
documents, respectively.

Final four patches (patches 8-11) are for adding tests.  The eighth patch
(patch 8) extends the kunit test for online parameters commit for
validating the goal_tuner.  The ninth and the tenth patches (patches 9-10)
extend the testing-purpose DAMON sysfs control helper and DAMON status
dumping tool to support the newly added feature.  The final eleventh one
(patch 11) extends the existing online commit selftest to cover the new
feature.

This patch (of 11):

DAMOS quota goal feature utilizes a single feedback loop based algorithm
for automatic tuning of the effective quota.  It is useful in dynamic
environments that operate systems with only kernels in the long term. 
But, no one fits all.  It is not very easy to control in environments
having more controlled characteristics and user-space control towers.  We
actually got multiple reports [1,2] of use cases that the algorithm is not
optimal.

Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
specifies what tuning algorithm the given scheme should use, and allows
DAMON API callers to set it as they want.  Nonetheless, this commit
introduces no new tuning algorithm but only the interface.  This commit
hence makes no behavioral change.  A new algorithm will be added by the
following commit.

Link: https://lkml.kernel.org/r/20260310010529.91162-2-sj@kernel.org
Link: https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com [1]
Link: https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com [2]
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |   10 ++++++++++
 mm/damon/core.c       |    1 +
 2 files changed, 11 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos_quota_goal_tuner
+++ a/include/linux/damon.h
@@ -216,11 +216,20 @@ struct damos_quota_goal {
 };
 
 /**
+ * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
+ * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ */
+enum damos_quota_goal_tuner {
+	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+};
+
+/**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
+ * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
@@ -262,6 +271,7 @@ struct damos_quota {
 	unsigned long ms;
 	unsigned long sz;
 	struct list_head goals;
+	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
 	unsigned int weight_sz;
--- a/mm/damon/core.c~mm-damon-core-introduce-damos_quota_goal_tuner
+++ a/mm/damon/core.c
@@ -912,6 +912,7 @@ static int damos_commit_quota(struct dam
 	err = damos_commit_quota_goals(dst, src);
 	if (err)
 		return err;
+	dst->goal_tuner = src->goal_tuner;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
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

