Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168B3418359
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468308; cv=none; b=CyvKXFoD74qV3SVX2nuRkT6vRFrYIfRL+CUaZLhCfIfzUqa39F7X3VAGT6rIJ/ST3ulxcwgWJs4t+i3ATIXwL0aQCP4PgIXYxkEyKhh1EuGV/cNS9VkepwA1qm1rmisPQ+SphpCwEqP+h4T7lvb+y9vQhfSZjgsTh4kZVZzV39Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468308; c=relaxed/simple;
	bh=LWvbc9G1X3FOZUEiDw0BThl0UZ3XhEVsSH7qfI8MA2Y=;
	h=Date:To:From:Subject:Message-Id; b=fMCKlUy1OM5VYOlaX+3ukjnXiY45GyUrbQGUDmzZRVT8BWQORa7FjkNFrxghKNwp73kNxl5rkikxPBLH3r9Hqi/oCSFGzgdrRIGwkciVzzHkXUxxINb8kJB3PkVDn2vac4GTBH+5a8d9DsXOJnjhC/G/G8QaQC+1dEVz2h7IIEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TkrdK2FS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TkrdK2FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C061F000E9;
	Thu,  3 Sep 2026 20:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788468295;
	bh=VEABHH8CiiZzWj4NM8h/1QSMxVUUcBbU6Enn4Cn5hhE=;
	h=Date:To:From:Subject;
	b=TkrdK2FS5BDLSuOj8IoTAC9Q3Efi7Bf+Dg2StxnhsKLiMrdYcyWbeA0fVGSi/JPHB
	 s1RMVK2gIjNLmsxexcdCeLwKV9yi2kyUfL1+xoqs90mTI9o5WkYWK7HrITKPgpuBBW
	 A7jkmlwL0/9bmBc28u2zTgE9tMzzmVWtBkUUC/R8=
Date: Thu, 03 Sep 2026 13:44:54 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch added to mm-new branch
Message-Id: <20260903204455.56C061F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: handle NULL ctx parameter in damon_call()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-handle-null-ctx-parameter-in-damon_call.patch

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
From: SJ Park <sj@kernel.org>
Subject: mm/damon/core: handle NULL ctx parameter in damon_call()
Date: Wed, 2 Sep 2026 18:03:30 -0700

Patch series "mm/damon: allow NULL or unstarted damon_ctx parameter for
damon_call()".

Callers of damon_call() should validate the damon_ctx object parameter. 
If it is NULL or never damon_start()-ed object, damon_call() could
dereference the NULL pointer or indefinitely hang.  Ensuring all callers
doing the validation correctly has turned out to be difficult.  Handle the
corner cases inside the core layer and remove callers' validations.

Patches 1 and 2 respectively allow passing NULL and not yet
damon_start()-ed ctx parameter to damon_call().  Patches 3 and 4 remove
the callers side validations in DMON_RECLAIM and DASMON_LRU_SORT,
respectively.


This patch (of 4):

When NULL damon_ctx pointer parameter is passed, damon_call() could do
NULL dereference.  The caller is responsible to avoid that.  It is easy to
forget, and there are many damon_call() callers.  Meanwhile, damon_call()
is never meant to be performance critical.  It uses mutex and completion. 
Add the NULL pointer check inside damon_call() so that callers can pass
the parameter without NULL checks.

Link: https://lore.kernel.org/20260903010334.93622-1-sj@kernel.org
Link: https://lore.kernel.org/20260903010334.93622-2-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/core.c~mm-damon-core-handle-null-ctx-parameter-in-damon_call
+++ a/mm/damon/core.c
@@ -2216,6 +2216,8 @@ int damon_kdamond_pid(struct damon_ctx *
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
 {
+	if (!ctx)
+		return -EINVAL;
 	if (!control->repeat)
 		init_completion(&control->completion);
 	control->canceled = false;
_

Patches currently in -mm which might be from sj@kernel.org are

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

