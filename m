Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B85E1F63F0
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297101; cv=none; b=LoDGm5ojtteg4Niv2f2KhaP/5BEmlGDW2tATC0YZywaXI0JT92avnpF1P/ILr9GF0FaQ4lzJv3q3K8jZecQa87rkrjdI6rRYWlYVD8lzRxQDqcmwgZkkRh2oCTycWDEK4BZJpwcp2XPxwFHi5Gq4vwU57ULkUJvm0sQji+beTkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297101; c=relaxed/simple;
	bh=b4Ec58T//YNwaLRk9+Y5Oc+aeSZ1rAeuEhgVpSiftF0=;
	h=Date:To:From:Subject:Message-Id; b=kh08rKabhE9ZFVV/+uQjpL+nGVTQsUEBw0+qBje+UnfDy5Itzzu4oZ4PZemW5JCdaocPJ/CYymtbrHFX99SRrinzZTa3/27+y5MPSCHcDQHBvUSpHL8filrNmUMsA2f0CI3mjOvdEaQPNNE9CVmz1vW1Ylh5tmhCGb806wPY/nA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=y7C7Ihy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="y7C7Ihy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2665C4CEE0;
	Thu,  6 Mar 2025 21:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297101;
	bh=b4Ec58T//YNwaLRk9+Y5Oc+aeSZ1rAeuEhgVpSiftF0=;
	h=Date:To:From:Subject:From;
	b=y7C7Ihy8VzS6Vt6rn5tW6GF0WSrKfeS1s1UzYirfGMiZHAsHx3FVoHirlj8CaY/Nx
	 8HfWHYysmFfjshrF1Iqe4f7x3o3NwexPtUCkiZopJZ9529VwWfT16Q6tPDg7ekJlvR
	 TtNPoeKp7HDolPpJ48gXJf/gyCIYEQe0B8twKrpY=
Date: Thu, 06 Mar 2025 13:38:20 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch added to mm-unstable branch
Message-Id: <20250306213820.E2665C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: validate user inputs from damon_sysfs_commit_input()
Date: Thu, 6 Mar 2025 09:58:56 -0800

Patch series "mm/damon/sysfs: commit parameters online via damon_call()".

Due to the lack of ways to synchronously access DAMON internal data, DAMON
sysfs interface is using damon_callback hooks with its own synchronization
mechanism.  The mechanism is built on top of damon_callback hooks in an
ineifficient and complicated way.

Patch series "mm/damon: replace most damon_callback usages in sysfs with
new core functions", which starts with commit e035320fd38e
("mm/damon/sysfs-schemes: remove unnecessary schemes existence check in
damon_sysfs_schemes_clear_regions()") introduced two new DAMON kernel API
functions that providing the synchronous access, replaced most
damon_callback hooks usage in DAMON sysfs interface, and cleaned up
unnecessary code.

Continue the replacement and cleanup works.  Update the last DAMON sysfs'
usage of its own synchronization mechanism, namely online DAMON parameters
commit, to use damon_call() instead of the damon_callback hooks and the
hard-to-maintain core-external synchronization mechanism.  Then remove the
no more be used code due to the change, and more unused code that just not
yet cleaned up.

The first four patches (patches 1-4) of this series makes DAMON sysfs
interface's online parameters commit to use damon_call().  Then, following
three patches (patches 5-7) remove the DAMON sysfs interface's own
synchronization mechanism and its usages, which is no more be used by
anyone due to the first four patches.  Finally, six patches (8-13) do more
cleanup of outdated comment and unused code.


This patch (of 13):

Online DAMON parameters commit via DAMON sysfs interface can make kdamond
stop.  This behavior was made because it can make the implementation
simpler.  The implementation tries committing the parameter without
validation.  If it finds something wrong in the middle of the parameters
update, it returns error without reverting the partially committed
parameters back.  It is safe though, since it immediately breaks kdamond
main loop in the case of the error return.

Users can make the wrong parameters by mistake, though.  Stopping kdamond
in the case is not very useful behavior.  Also this makes it difficult to
utilize damon_call() instead of damon_callback hook for online parameters
update, since damon_call() cannot immediately break kdamond main loop in
the middle.

Validate the input parameters and return error when it fails before
starting parameters updates.  In case of mistakenly wrong parameters,
kdamond can continue running with the old and valid parameters.

Link: https://lkml.kernel.org/r/20250306175908.66300-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250306175908.66300-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input
+++ a/mm/damon/sysfs.c
@@ -1449,11 +1449,11 @@ static struct damon_ctx *damon_sysfs_bui
  * damon_sysfs_commit_input() - Commit user inputs to a running kdamond.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
- * If the sysfs input is wrong, the kdamond will be terminated.
+ * Returns error if the sysfs input is wrong.
  */
 static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
 {
-	struct damon_ctx *param_ctx;
+	struct damon_ctx *param_ctx, *test_ctx;
 	int err;
 
 	if (!damon_sysfs_kdamond_running(kdamond))
@@ -1465,7 +1465,15 @@ static int damon_sysfs_commit_input(stru
 	param_ctx = damon_sysfs_build_ctx(kdamond->contexts->contexts_arr[0]);
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
+	test_ctx = damon_new_ctx();
+	err = damon_commit_ctx(test_ctx, param_ctx);
+	if (err) {
+		damon_sysfs_destroy_targets(test_ctx);
+		damon_destroy_ctx(test_ctx);
+		goto out;
+	}
 	err = damon_commit_ctx(kdamond->damon_ctx, param_ctx);
+out:
 	damon_sysfs_destroy_targets(param_ctx);
 	damon_destroy_ctx(param_ctx);
 	return err;
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-respect-core-layer-filters-allowance-decision-on-ops-layer.patch
mm-damon-core-initialize-damos-walk_completed-in-damon_new_scheme.patch
mm-madvise-split-out-mmap-locking-operations-for-madvise.patch
mm-madvise-split-out-madvise-input-validity-check.patch
mm-madvise-split-out-madvise-behavior-execution.patch
mm-madvise-remove-redundant-mmap_lock-operations-from-process_madvise.patch
mm-damon-avoid-applying-damos-action-to-same-entity-multiple-times.patch
mm-damon-core-unset-damos-walk_completed-after-confimed-set.patch
mm-damon-core-do-not-call-damos_walk_control-walk-if-walk-is-completed.patch
mm-damon-core-do-damos-walking-in-entire-regions-granularity.patch
mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch
mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch
docs-mm-damon-design-document-unmapped-damos-filter-type.patch
mm-damon-add-data-structure-for-monitoring-intervals-auto-tuning.patch
mm-damon-core-implement-intervals-auto-tuning.patch
mm-damon-sysfs-implement-intervals-tuning-goal-directory.patch
mm-damon-sysfs-commit-intervals-tuning-goal.patch
mm-damon-sysfs-implement-a-command-to-update-auto-tuned-monitoring-intervals.patch
docs-mm-damon-design-document-for-intervals-auto-tuning.patch
docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch
docs-abi-damon-document-intervals-auto-tuning-abi.patch
docs-admin-guide-mm-damon-usage-add-intervals_goal-directory-on-the-hierarchy.patch
mm-damon-core-introduce-damos-ops_filters.patch
mm-damon-paddr-support-ops_filters.patch
mm-damon-core-support-committing-ops_filters.patch
mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch
mm-damon-paddr-support-only-damos-ops_filters.patch
mm-damon-add-default-allow-reject-behavior-fields-to-struct-damos.patch
mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch
mm-damon-paddr-respect-ops_filters_default_reject.patch
docs-mm-damon-design-update-for-changed-filter-default-behavior.patch
mm-damon-sysfs-schemes-let-damon_sysfs_scheme_set_filters-be-used-for-different-named-directories.patch
mm-damon-sysfs-schemes-implement-core_filters-and-ops_filters-directories.patch
mm-damon-sysfs-schemes-commit-filters-in-coreops_filters-directories.patch
mm-damon-core-expose-damos_filter_for_ops-to-damon-kernel-api-callers.patch
mm-damon-sysfs-schemes-record-filters-of-which-layer-should-be-added-to-the-given-filters-directory.patch
mm-damon-sysfs-schemes-return-error-when-for-attempts-to-install-filters-on-wrong-sysfs-directory.patch
docs-abi-damon-document-coreops_filters-directories.patch
docs-admin-guide-mm-damon-usage-update-for-coreops_filters-directories.patch
mm-damon-sysfs-validate-user-inputs-from-damon_sysfs_commit_input.patch
mm-damon-core-invoke-kdamond_call-after-merging-is-done-if-possible.patch
mm-damon-core-make-damon_set_attrs-be-safe-to-be-called-from-damon_call.patch
mm-damon-sysfs-handle-commit-command-using-damon_call.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch
mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch
mm-damon-sysfs-schemes-remove-obsolete-comment-for-damon_sysfs_schemes_clear_regions.patch
mm-damon-remove-damon_callback-private.patch
mm-damon-remove-before_start-of-damon_callback.patch
mm-damon-remove-damon_callback-after_sampling.patch
mm-damon-remove-damon_callback-before_damos_apply.patch
mm-damon-remove-damon_operations-reset_aggregated.patch

