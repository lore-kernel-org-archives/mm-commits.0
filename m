Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB830C159
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788908888; cv=none; b=CK8QpvcSaUE39p2g+cZ1HSniIhg32SxUdaba736MgsG0dFiWt5q/a7b90X2uCdV8NiTrMRWSgPW4/Q3NxRUnYHzegk4rGDxjp+sX2rWTydpKQHPH5RYqkwLWPiG1W7Nt+vVKI2+yqgfdO9H5t0ONbIZyPjYmIy0SL9JEr83nxVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788908888; c=relaxed/simple;
	bh=kbMQBk5pEle5UEYxzXFIutBI6RnNJnXeJ4oR1B5yTRA=;
	h=Date:To:From:Subject:Message-Id; b=kO79YSDVYF2fZJOLL5odpyt3kYqjMO9DdvH8ijMegFOQpCEuPE8ZbrwF/W4XYSGjAm7tJFUsoOW8ODL6Q6UJw1uox9kKqZcJw7Dt/Y2WKOPxs2FaH1kNhJ4Jleh60ysJgMmeJayCdt23SBx8Ae+W9LAbIBcQgZXe0iTaWPhG9/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IpeIRCgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IpeIRCgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352DA1F00A3F;
	Tue,  8 Sep 2026 23:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788908882;
	bh=H+OU2tEetWb1MbDgoMlJ2X8wFllJHgvRNzhIbS8gbcQ=;
	h=Date:To:From:Subject;
	b=IpeIRCgkJm+xTwFNE8odpzpWO91N/4nWBcmrj8puvotxwfpjx1gK+sLnQlpPoQVJB
	 ClMzsakggjVGt3bXRSu5LUWrZ4BLPXz2zfL5IQvHg9XBCRpbfD4tKRzO2tg3RTrVIY
	 kCzEzaYcY4A+NjGxlNzUMyXtGXUYjz7WXqIQ5DII=
Date: Tue, 08 Sep 2026 16:08:01 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-damon-sysfspy-test-damon-probes.patch removed from -mm tree
Message-Id: <20260908230802.352DA1F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/damon/sysfs.py: test damon probes
has been removed from the -mm tree.  Its filename was
     selftests-damon-sysfspy-test-damon-probes.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: selftests/damon/sysfs.py: test damon probes
Date: Wed, 2 Sep 2026 07:03:12 -0700

Extend sysfs.py to commit DAMON probes via sysfs, and see if it changed
in-kernel DAMON status as expected using drgn.

Link: https://lore.kernel.org/20260902140313.85983-7-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/damon/sysfs.py |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-test-damon-probes
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -319,7 +319,21 @@ def main():
                 intervals_goal=_damon_sysfs.IntervalsGoal(
                     access_bp=400, aggrs=3, min_sample_us=5000,
                     max_sample_us=10000000),
-                update_us=2000000),
+                update_us=2000000,
+                probes=_damon_sysfs.DamonProbes(
+                    probes=[_damon_sysfs.DamonProbe(
+                        weight=42,
+                        filters=_damon_sysfs.DamonFilters(
+                            filters=[
+                                _damon_sysfs.DamonFilter(
+                                    type_='anon',
+                                    matching=True,
+                                    allow=True,
+                                    ),
+                                ]),
+                            ),
+                            ]),
+                    ),
             schemes=[_damon_sysfs.Damos(
                 action='pageout',
                 access_pattern=_damon_sysfs.DamosAccessPattern(
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-vaddr-avoid-hw-driven-pte-updates-during-damon_hugetlb_mkold.patch
mm-damon-core-skip-applying-scheme-if-region-split-for-quota-fails.patch
mm-damon-paddr-respect-folio-end-for-damos_stat.patch
mm-damon-paddr-respect-folio-end-for-damos-actions-except-stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_stat.patch
mm-damon-vaddr-respect-folio-end-for-damos_migrate_hotcold.patch
mm-damon-core-handle-extreme-memory-state-in-damon_get_node_mem_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_node_memcg_used_bp.patch
mm-damon-core-handle-extreme-memory-state-in-get_in_active_mem_bp.patch
mm-damon-core-introduce-damon_filter_type_pgidle_unset.patch
mm-damon-paddr-support-pgidle_unset-probe-filter-type.patch
mm-damon-sysfs-support-pgidle_unset-probe-filter-type.patch
docs-mm-damon-design-document-pgidle_unset-probe-filter-type.patch
mm-damon-core-introduce-damon_prep-struct.patch
mm-damon-core-commit-preps.patch
mm-damon-core-introduce-damon_operations-prep_probes.patch
mm-damon-paddr-support-damon_prep.patch
mm-damon-sysfs-implement-preps-directory.patch
mm-damon-sysfs-implement-preps-nr_preps-file.patch
mm-damon-sysfs-create-directories-for-nr_preps-writes.patch
mm-damon-sysfs-implement-prep_action-file.patch
mm-damon-sysfs-pass-preps-to-damon-core.patch
selftests-damon-sysfssh-test-probe-prep-sysfs-files.patch
docs-mm-damon-design-document-probe-preps.patch
docs-admin-guide-mm-damon-usage-document-probe-preps-sysfs-files.patch
docs-abi-damon-document-probe-prep-sysfs-files.patch
mm-damon-tests-core-kunit-test-committing-psi-goal-to-psi-goal.patch
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total.patch
mm-damon-core-copy-nid-for-eligible_mem_bp-damos-quota-goal-commit.patch
mm-damon-sysfs-set-next-refresh-jiffies-per-sysfs-context.patch
mm-damon-core-use-damon_nr_samples_per_aggr-for-max-merge-threshold.patch
mm-damon-core-remove-debug-messages.patch
mm-damon-core-remove-debug-messages-fix.patch
mm-damon-vaddr-remove-a-debug-message.patch
mm-damon-core-validate-number-of-probes-in-valid_probe_params.patch
mm-damon-sysfs-remove-probes-number-validation.patch
mm-damon-tests-core-kunit-extend-set_regions-test-for-error-case.patch
mm-damon-tests-core-kunit-test-=0-size-damon_set_regions-inputs.patch
mm-damon-tests-core-kunit-test-overlapping-ranges-for-set_regions.patch
mm-damon-tests-core-kunit-test-damon_nr_samples_per_aggr.patch
selftests-damon-sysfssh-test-hugepage_mem_bp-quota-goal.patch
docs-mm-damon-maintainer-profile-update-ai-review-for-sashiko-replies.patch
docs-abi-damon-recommend-subsystem-doc-instead-of-admin-guide.patch
mm-damon-core-error-damos_commit_quota_goal-for-zero-target_value.patch
revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch
revert-samples-damon-mtier-error-out-for-zero-quota-goal-target-values.patch
mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch
mm-damon-core-set-ctx-call_controls_obsolete-in-damon_new_ctx.patch
mm-damon-reclaim-remove-unnecessary-damon_call-param-validation.patch
mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch

