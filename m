Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2075C27183F
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297106; cv=none; b=DUkBYqNJ1s4Vu0F3RzknnT7hBzC9guczhPBydxjXwUYhncVbnActMP9DO52bvJ/p90Q6agtshnzc5l8UXGSGqD+iwZPcLGGERqhxzrhQoisnQVZ5dhO0PZwbgPuHRfC773/AstIqSLJzmeXt8LBh0K7Ne/RzuDCcf1k5XK7bkyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297106; c=relaxed/simple;
	bh=g9AOSB8f/po95O+QKqmXUtV3mueiNTweZENtCuG/ZXk=;
	h=Date:To:From:Subject:Message-Id; b=UuArjZcTRXAPjzVu/34duFDojCJC7le2VPN3UGvdu1g4QHX3EcJRJalsYy2PCNW1V6yRiigmC3nnhQDmASKShu+gD3HGZH0Dr9MBkDnGA0mjPcH2+pNN/0mY3g34AReBrHk+I+slHGFTvf17xLBVRiV7OwtjgkOLkNHsiGufEEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J6M6OFyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J6M6OFyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22B7C4CEE0;
	Thu,  6 Mar 2025 21:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297106;
	bh=g9AOSB8f/po95O+QKqmXUtV3mueiNTweZENtCuG/ZXk=;
	h=Date:To:From:Subject:From;
	b=J6M6OFykbpYdNCBborxXYge/GXkWK88OOscsQkWTU+grjqVTzsL7GyI2YWyUKarT4
	 UvYWTnmUPWA3g+AC9MEjL8rWpYMchkUbgW3JYII2zptM+ni+49VwQBY6bmpcCcsCNp
	 vg/KWWLcXDw0JaOX+4rBUuVdEWitIO+TOhCBEwEQ=
Date: Thu, 06 Mar 2025 13:38:25 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch added to mm-unstable branch
Message-Id: <20250306213825.E22B7C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request code from damon_sysfs_handle_cmd()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd.patch

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
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request code from damon_sysfs_handle_cmd()
Date: Thu, 6 Mar 2025 09:59:00 -0800

damon_sysfs_handle_cmd() handles user requests that it can directly handle
on its own.  For requests that need to be handled from damon_callback
hooks, it uses DAMON sysfs interface's own synchronous damon_callback
hooks management mechanism, namely damon_sysfs_cmd_request.  Now all user
requests are handled without damon_callback hooks, so
damon_sysfs_cmd_request client code in damon_sysfs_andle_cmd() does
nothing in real.  Remove the unnecessary code.

Link: https://lkml.kernel.org/r/20250306175908.66300-6-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   32 --------------------------------
 1 file changed, 32 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request-code-from-damon_sysfs_handle_cmd
+++ a/mm/damon/sysfs.c
@@ -1715,8 +1715,6 @@ static int damon_sysfs_update_schemes_tr
 static int damon_sysfs_handle_cmd(enum damon_sysfs_cmd cmd,
 		struct damon_sysfs_kdamond *kdamond)
 {
-	bool need_wait = true;
-
 	switch (cmd) {
 	case DAMON_SYSFS_CMD_ON:
 		return damon_sysfs_turn_damon_on(kdamond);
@@ -1747,38 +1745,8 @@ static int damon_sysfs_handle_cmd(enum d
 		return damon_sysfs_damon_call(
 				damon_sysfs_upd_tuned_intervals, kdamond);
 	default:
-		break;
-	}
-
-	/* Pass the command to DAMON callback for safe DAMON context access */
-	if (damon_sysfs_cmd_request.kdamond)
-		return -EBUSY;
-	if (!damon_sysfs_kdamond_running(kdamond))
 		return -EINVAL;
-	damon_sysfs_cmd_request.cmd = cmd;
-	damon_sysfs_cmd_request.kdamond = kdamond;
-
-	/*
-	 * wait until damon_sysfs_cmd_request_callback() handles the request
-	 * from kdamond context
-	 */
-	mutex_unlock(&damon_sysfs_lock);
-	while (need_wait) {
-		schedule_timeout_idle(msecs_to_jiffies(100));
-		if (!mutex_trylock(&damon_sysfs_lock))
-			continue;
-		if (!damon_sysfs_cmd_request.kdamond) {
-			/* damon_sysfs_cmd_request_callback() handled */
-			need_wait = false;
-		} else if (!damon_sysfs_kdamond_running(kdamond)) {
-			/* kdamond has already finished */
-			need_wait = false;
-			damon_sysfs_cmd_request.kdamond = NULL;
-		}
-		mutex_unlock(&damon_sysfs_lock);
 	}
-	mutex_lock(&damon_sysfs_lock);
-	return 0;
 }
 
 static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
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

