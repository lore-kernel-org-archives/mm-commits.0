Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9D12F12AC
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 23:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788909047; cv=none; b=My5mLpTLicEoltLYdr0Z14/nIZ9yCLFR37YNlANxrSveJSjBJ+XD3/7wQg0URQFbekkUTSwaGNQkZTfxgSSGx+XhnPGfEbhRjZHAI0pbICpB2ine18rFbAo3MEper9xL65yGX5nxIAZv3xsV0b/fSr6jIbl1CnaAsi0roqdzmbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788909047; c=relaxed/simple;
	bh=gMAn4H20gqdnw61kGKgjJNYVWUFCu2leTDOVbSp3Ry4=;
	h=Date:To:From:Subject:Message-Id; b=aKLB7hrK+b3w0jtnt0gKt/9iQEIBVn8dmO5Wq2igjLw9K12DkibkXI+W2Dd3PZp4qIqmEw8rrvmLqMnsCLZRMPNXjiZrJJPotzY7gz35VhxnXfFAxlBL2oM7xkULLqLcJZdA6RUNvVun75bPpQ17K+mkOslC/WzW79omR6wI/9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tMCptPUm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tMCptPUm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A160E1F00A3A;
	Tue,  8 Sep 2026 23:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788909045;
	bh=cmP3ZRujAChrr7QoGVLU9VnbmOkorGxwml1oK5e2RTs=;
	h=Date:To:From:Subject;
	b=tMCptPUmGtL+PWuf4mVeBXE5GgyGiOoU8hQWyftmpw9JoC68lbxfPEH1kNe8fOec8
	 Ej9UhaL5xGp7QYm5YYvciQ1n2VDoDGtUsJ+yWtOuiGTTuSHfawBjfiyaArk54y1YTI
	 ogD+AastNoNSmsvHzSSQY3/VLJNEWNOt4FwtacJ0=
Date: Tue, 08 Sep 2026 16:10:45 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-test-damon-probes.patch added to mm-unstable branch
Message-Id: <20260908231045.A160E1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: test damon probes
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-damon-sysfspy-test-damon-probes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-test-damon-probes.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
mm-damon-tests-core-kunit-test-damon_commit_filter.patch
mm-damon-tests-core-kunit-add-damon_commit_probes-test.patch
selftests-damon-_damon_sysfs-implement-damonprobes.patch
selftests-damon-drgn_dump_damon_status-dump-probes.patch
selftests-damon-sysfspy-extend-commit-assertion-function-for-probes.patch
selftests-damon-sysfspy-test-damon-probes.patch
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

