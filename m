Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE8C51121C
	for <mm-commits@vger.kernel.org>; Thu,  3 Sep 2026 20:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788468206; cv=none; b=GaCb9hvP181lGLUDrBh5aEvKi5JylpGaO6AcBK9tDywOA4Cifdhgnr4DsDCGu8VcenBw3cb2vb93yVUduo5YCv0wruVOS4gFWjQsh6Mt2eU8Wxjx32+Xn7doYMrByqSfZS52SObub7ZH/99HWbK6f2vjInW7Om2WjvajmMcHtyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788468206; c=relaxed/simple;
	bh=5PNjZpnHD1PcLvt7bUfaqrNfMJ0klpirn/RsR7wA8Qo=;
	h=Date:To:From:Subject:Message-Id; b=hHly3mBeYolCkn25bMIi0N9tMhBY/EwjyZCQHcREMamF6DigzvcM8E/aF90yQKhLkG4xNM86ybWSfWJQdv2AbukEAfDussa+BfRej3R6i0lhgeV5/POlNT73Lq1aO8A8kAQMjhMRxTRwU65EKRPp9x6yHuD0eopeZVhp14P+zic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IAnW/6eG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IAnW/6eG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950111F00A3D;
	Thu,  3 Sep 2026 20:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788468188;
	bh=psHe+o2qAX3fktjYzEr0r4EVbegRbWsao95i/rvMtAw=;
	h=Date:To:From:Subject;
	b=IAnW/6eGSEpB7u9xAeQC+69PHkyTe+KiNrB5cEYtWFsbw6ObtBNzezfy0iWZmoYxA
	 kEM3v+GuPbN24ut3vEe2c/d/XngEkqKSMLizSQV+h2wx0rrTAQnGqAQi7RRwsTCKKq
	 zDP1HXrC0dfXzW+plRvJvTpATHfCDiyEKCy6Qons=
Date: Thu, 03 Sep 2026 13:43:08 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch added to mm-new branch
Message-Id: <20260903204308.950111F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
has been added to the -mm mm-new branch.  Its filename is
     revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp.patch

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
Subject: Revert "mm/damon/lru_sort: error out for >10000 active_mem_bp"
Date: Wed, 2 Sep 2026 18:07:20 -0700

This reverts commit 06befa61c427e74319781e6f35a364cfc32dbae8.

The commit was made to avoid zero damos quota goal target value, because
it can trigger division-by-zero.  Now the core layer handles the corner
case.  It returns an error for any attempt setting the aero target_value. 
The corner case handling in DAMON_LRU_SORT is hence no more needed. 
Remove it.

Note that this slightly changes the user behavior.  It still disallows
active_mem_bp of 10,002.  But now it allows other >10,000 active_mem_bp
values.  Setting >10,000 active_mem_bp makes not much sense.  But it
doesn't cause critical problems such as memory leak or crash, either. 
Arguably that doesn't deserve additional code complexity.  Just allow it.

Link: https://lore.kernel.org/20260903010722.94244-3-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/lru_sort.c~revert-mm-damon-lru_sort-error-out-for-10000-active_mem_bp
+++ a/mm/damon/lru_sort.c
@@ -233,8 +233,6 @@ static int damon_lru_sort_add_quota_goal
 
 	if (!active_mem_bp)
 		return 0;
-	if (10000 < active_mem_bp)
-		return -EINVAL;
 	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
 	if (!goal)
 		return -ENOMEM;
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

