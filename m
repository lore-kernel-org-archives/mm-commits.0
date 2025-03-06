Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22D20764B
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297105; cv=none; b=Jl6EpEpGw2LSkveT9WTMERR46Qmkd19CdTtYN6NNl52qERVC7tB+3pxKba7lqMhjltbIWspwKZRiO0c3uwNKjvJqWp6RdRQqacaZuKfb2lcTvBsEvz2uZm7vviYSdojwJnIL6S+mqyd4kmRMb4w/4/v+4GQj3C0K9Klv9WHGOxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297105; c=relaxed/simple;
	bh=iScIFq70A71FtP2aw2nsIPRvG7GITZel9clSwKDRedI=;
	h=Date:To:From:Subject:Message-Id; b=mLbLnRSn5y03JWTkSjdz9c9EXxuxRbDb4/UuMql7lCHzL1G5A6physoQRK9I5k7L8muyuhMqOHBlCsLDs0F0daGNu7zAOiwCj2A6oBFprSssUdsr8PmYzxdj00i3aO6L10+N8V/1yng4Ma/n8rNnQwsEV1kO8zsoAgwuiSLHV/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIOOyYM1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIOOyYM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA49BC4CEE5;
	Thu,  6 Mar 2025 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297104;
	bh=iScIFq70A71FtP2aw2nsIPRvG7GITZel9clSwKDRedI=;
	h=Date:To:From:Subject:From;
	b=JIOOyYM1O9FxeGKLFiJwUehddIBES6C6W5qoLh+EA7Opl5Tlgwdw3ZYmFVyHfLRDs
	 qwU9tRG/JBKKHnTIfWjYB+yz5HKKqHbDlqyW8u2y8MRy4iBoXkigvJGDUfvT8paF1r
	 fgRhPzpJgx7cqn5dyvm+KP4tO33mIM2s6zj1NvI0=
Date: Thu, 06 Mar 2025 13:38:24 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-handle-commit-command-using-damon_call.patch added to mm-unstable branch
Message-Id: <20250306213824.AA49BC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: handle commit command using damon_call()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-handle-commit-command-using-damon_call.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-handle-commit-command-using-damon_call.patch

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
Subject: mm/damon/sysfs: handle commit command using damon_call()
Date: Thu, 6 Mar 2025 09:58:59 -0800

DAMON sysfs interface is using damon_callback->after_aggregation hook with
its self-implemented synchronization mechanism for the hook.  It is
inefficient, complicated, and take up to one aggregation interval to
complete, which can be long on some configs.

Use damon_call() instead.  It provides a synchronization mechanism that
built inside DAMON's core layer, so more efficient than DAMON sysfs
interface's own one.  Also it isolates the implementation inside the core
layer, and hence it makes the code easier to maintain.  Finally, it takes
up to one sampling interval, which is much shorter than the aggregation
interval in common setups.

Link: https://lkml.kernel.org/r/20250306175908.66300-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-handle-commit-command-using-damon_call
+++ a/mm/damon/sysfs.c
@@ -1451,8 +1451,9 @@ static struct damon_ctx *damon_sysfs_bui
  *
  * Returns error if the sysfs input is wrong.
  */
-static int damon_sysfs_commit_input(struct damon_sysfs_kdamond *kdamond)
+static int damon_sysfs_commit_input(void *data)
 {
+	struct damon_sysfs_kdamond *kdamond = data;
 	struct damon_ctx *param_ctx, *test_ctx;
 	int err;
 
@@ -1550,11 +1551,6 @@ static int damon_sysfs_cmd_request_callb
 	if (!kdamond || kdamond->damon_ctx != c)
 		goto out;
 	switch (damon_sysfs_cmd_request.cmd) {
-	case DAMON_SYSFS_CMD_COMMIT:
-		if (!after_aggregation)
-			goto out;
-		err = damon_sysfs_commit_input(kdamond);
-		break;
 	default:
 		break;
 	}
@@ -1712,11 +1708,7 @@ static int damon_sysfs_update_schemes_tr
  * @cmd:	The command to handle.
  * @kdamond:	The kobject wrapper for the associated kdamond.
  *
- * This function handles a DAMON sysfs command for a kdamond.  For commands
- * that need to access running DAMON context-internal data, it requests
- * handling of the command to the DAMON callback
- * (@damon_sysfs_cmd_request_callback()) and wait until it is properly handled,
- * or the context is completed.
+ * This function handles a DAMON sysfs command for a kdamond.
  *
  * Return: 0 on success, negative error code otherwise.
  */
@@ -1730,6 +1722,9 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_turn_damon_on(kdamond);
 	case DAMON_SYSFS_CMD_OFF:
 		return damon_sysfs_turn_damon_off(kdamond);
+	case DAMON_SYSFS_CMD_COMMIT:
+		return damon_sysfs_damon_call(
+				damon_sysfs_commit_input, kdamond);
 	case DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS:
 		return damon_sysfs_damon_call(
 				damon_sysfs_commit_schemes_quota_goals,
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

