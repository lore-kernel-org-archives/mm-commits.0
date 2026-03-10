Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8813C9423
	for <mm-commits@vger.kernel.org>; Tue, 10 Mar 2026 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773165666; cv=none; b=FpKiYDUiJ5f0jxFc6LGZgAVY1Eof94blU+a8XF2DtjceTUH14e9xMvC5eslkZyI4TJEBKoVMBFEmLqbwb/VSXWaSBp6Khlv+fZUTS7blW3jq6rUBVtD4dEF0IemVfuatxyfxN4Rnw+t/P+cTIpQ38S8PpHfyT0ndGQ61lcomfg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773165666; c=relaxed/simple;
	bh=qJigIA/ryEUUve14vWOGuDWhLHJIEfcO7GGS+aErB9k=;
	h=Date:To:From:Subject:Message-Id; b=g2w16yYEL6V7yyjprXVBK9Z/OWXN1b+Tbv6Tl+fyODDbvETWJlprSqWGKC/jZtgC2iONU72gROJseeDQkXqGM2I/L9NuFdz6zCdc0MKVKLVmSJESV0zjZqgTFMTGw63siDKzGLB0G2NPJujquhCjIOgbVSWmgazI8k6FKoyIO+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v9T+vxAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v9T+vxAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42107C19425;
	Tue, 10 Mar 2026 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773165666;
	bh=qJigIA/ryEUUve14vWOGuDWhLHJIEfcO7GGS+aErB9k=;
	h=Date:To:From:Subject:From;
	b=v9T+vxAZsb7q2/PnqZ/Pkwa2TxiZ94jk9xxzYS/zs/OJ9keqU8l4rGrtng+JMnfXA
	 t71MRWsvvtVflGLrSEpcbkVRHmPz0x0L9QorrU6/pu1J2xDXm9g8myltAganbmoj/c
	 BVecVlfSvvez5bFL5CO12r0wABw474SXk3d8VVAU=
Date: Tue, 10 Mar 2026 11:01:05 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-goal_tuner-commit.patch added to mm-new branch
Message-Id: <20260310180106.42107C19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test goal_tuner commit
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-test-goal_tuner-commit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-goal_tuner-commit.patch

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
Subject: selftests/damon/sysfs.py: test goal_tuner commit
Date: Mon, 9 Mar 2026 18:05:27 -0700

Extend the near-full DAMON parameters commit selftest to commit goal_tuner
and confirm the internal status is updated as expected.

Link: https://lkml.kernel.org/r/20260310010529.91162-12-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-goal_tuner-commit
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -67,6 +67,12 @@ def assert_quota_committed(quota, dump):
     assert_true(dump['sz'] == quota.sz, 'sz', dump)
     for idx, qgoal in enumerate(quota.goals):
         assert_quota_goal_committed(qgoal, dump['goals'][idx])
+    tuner_val = {
+            'consist': 0,
+            'temporal': 1,
+            }
+    assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
+                'goal_tuner', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -231,6 +237,7 @@ def main():
                         metric='node_mem_used_bp',
                         target_value=9950,
                         nid=1)],
+                    goal_tuner='temporal',
                     reset_interval_ms=1500,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
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

