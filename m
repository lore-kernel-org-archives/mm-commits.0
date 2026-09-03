Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0ED743CE7E
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468315; cv=none; b=OXJNH20qokOS/QHdmgXj1Av50xsQkofDLeXVo1u/CI78/bflMOzCC1MJw6e51nHUqA9NQzPTMdQWUbgHMfsOnC9vj1czJXnwXKclLK50+cZaqEixJJeHu0okUGuKmbJesqqpS8BwCLiyC93rvk0vY+suSQOdvoIF213WibHYRPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468315; c=relaxed/simple;
	bh=X9RO7LYhWXiM7y79P7KRkYXtbFe47v+czYzp056n8/Y=;
	h=Date:To:From:Subject:Message-Id; b=cc5yB0yQEKMtSYkQCmD3lIWv6aL4/d1zduFNx2LhthXX9Rv7if776W+Bgan5dkhwZob1yapqxJX6mW/bQK8JwOndvmVhYK9e4hS2JTtGwWm4ih7WsF+wbFLAR8YI/u2zbIbdUO2P2jDRMYPeU3fClKmlgiI0+4lo17AxKFltw2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OfmBkYVd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OfmBkYVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107E31F00A3F;
	Thu,  3 Sep 2026 20:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788468301;
	bh=3O42cJF5ok3T0z1uMVyUwQLuED5DmqjCvL6I2FuNNWc=;
	h=Date:To:From:Subject;
	b=OfmBkYVdKjwSxYPWq5nLGI4vNiydLmuoDpMi7dcvLrHeaSz1IGKw5pkqzKTJgSlcH
	 n9AMLIuhHDcKc2cfw/1D9hVJZ9zdJTUlyTYkiVu9gZ5mGLwekoNC7sg+NP/rAxOfeA
	 SXi5Re2RFErG2vlQ9l5RFsWeJBlBWqTY21+M6zvw=
Date: Thu, 03 Sep 2026 13:45:00 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch added to mm-new branch
Message-Id: <20260903204501.107E31F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: remove unnecessary damon_call() param validation
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation.patch

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
Subject: mm/damon/lru_sort: remove unnecessary damon_call() param validation
Date: Wed, 2 Sep 2026 18:03:33 -0700

DAMON_LRU_SORT avoids passing NULL or unstarted damon_ctx to damon_call()
with its own validation.  The validation is no longer needed, because the
DAMON core layer now handles the corner cases itself.  Remove the
unnecessary check.

Link: https://lore.kernel.org/20260903010334.93622-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-remove-unnecessary-damon_call-param-validation
+++ a/mm/damon/lru_sort.c
@@ -344,8 +344,6 @@ static int damon_lru_sort_commit_inputs_
 	return damon_lru_sort_apply_parameters();
 }
 
-static bool damon_lru_sort_damon_has_started;
-
 static int damon_lru_sort_commit_inputs_store(const char *val,
 					      const struct kernel_param *kp)
 {
@@ -366,10 +364,6 @@ static int damon_lru_sort_commit_inputs_
 	if (!commit_inputs_request)
 		return 0;
 
-	/* Skip damon_call() if ctx has not successfully started. */
-	if (!damon_lru_sort_damon_has_started)
-		return -EINVAL;
-
 	err = damon_call(ctx, &control);
 
 	return err ? err : control.return_code;
@@ -420,8 +414,6 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	if (!damon_lru_sort_damon_has_started)
-		damon_lru_sort_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
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

