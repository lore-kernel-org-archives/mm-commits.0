Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B13207A31
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297107; cv=none; b=QST/VPxQqH+YvLc6oPDATuGpOWXHTmMt2oPHeEFrglQOTcl4IC9fSFHaj4ydHJkGOewBaIhF8DarXlMD8eVwG1W0v9oLyyeh8K1tWCxzjehROY/YGKS3wDU4ZcJGTxTRO3QEEGVtvTEE1Bf9dXF+3lCSGPaVHrGUnHlwdIVMNa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297107; c=relaxed/simple;
	bh=7Hb3/Tywx6zkb9KbC2o9k0NTGbcchDUl9ArR/gd1RNY=;
	h=Date:To:From:Subject:Message-Id; b=QsinqqDUEAG6zzyJMHzfeu3ZFF6YN6nfHUiGJ9h7nNSR53bTK0A0F11XRvVWcp5sUBXFImAftIsIDPQBvAE7Ehm5nuW64qHmlgDB3emIF8BjguXT57v2W8yXiMJBUtEMKisg1zUfgvFmVmfFwwVLzfinLyqAbt4jB9U35VEGGMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q90WFNHz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q90WFNHz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D20BC4CEE0;
	Thu,  6 Mar 2025 21:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297107;
	bh=7Hb3/Tywx6zkb9KbC2o9k0NTGbcchDUl9ArR/gd1RNY=;
	h=Date:To:From:Subject:From;
	b=Q90WFNHzC7Lo1N85XfTww65sPt6GZp3rISQP3ZsoOsrb0MPBrQYOniyMgMLM168HU
	 uuoHYUso72Y/YC8ftMYLZd6rwMWAgUV+0xwfk+zRksn5G75/boA4yz1C9RdKwOjzok
	 LCBmbhLklZcVFVpgdZZhNaTSIlzYyy+Y7WBWX2rU=
Date: Thu, 06 Mar 2025 13:38:26 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch added to mm-unstable branch
Message-Id: <20250306213827.0D20BC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request_callback() and its callers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers.patch

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
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request_callback() and its callers
Date: Thu, 6 Mar 2025 09:59:01 -0800

damon_sysfs_cmd_request_callback() is the damon_callback hook functions
that were used to handle user requests that need to read and/or write
DAMON internal data.  All the usages are now updated to use damon_call()
or damos_walk(), though.  Remove it and its callers.

Link: https://lkml.kernel.org/r/20250306175908.66300-7-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   62 ---------------------------------------------
 1 file changed, 62 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request_callback-and-its-callers
+++ a/mm/damon/sysfs.c
@@ -1529,65 +1529,6 @@ static int damon_sysfs_upd_tuned_interva
 	return 0;
 }
 
-/*
- * damon_sysfs_cmd_request_callback() - DAMON callback for handling requests.
- * @c:		The DAMON context of the callback.
- * @active:	Whether @c is not deactivated due to watermarks.
- * @after_aggr:	Whether this is called from after_aggregation() callback.
- *
- * This function is periodically called back from the kdamond thread for @c.
- * Then, it checks if there is a waiting DAMON sysfs request and handles it.
- */
-static int damon_sysfs_cmd_request_callback(struct damon_ctx *c, bool active,
-		bool after_aggregation)
-{
-	struct damon_sysfs_kdamond *kdamond;
-	int err = 0;
-
-	/* avoid deadlock due to concurrent state_store('off') */
-	if (!mutex_trylock(&damon_sysfs_lock))
-		return 0;
-	kdamond = damon_sysfs_cmd_request.kdamond;
-	if (!kdamond || kdamond->damon_ctx != c)
-		goto out;
-	switch (damon_sysfs_cmd_request.cmd) {
-	default:
-		break;
-	}
-	/* Mark the request as invalid now. */
-	damon_sysfs_cmd_request.kdamond = NULL;
-out:
-	mutex_unlock(&damon_sysfs_lock);
-	return err;
-}
-
-static int damon_sysfs_after_wmarks_check(struct damon_ctx *c)
-{
-	/*
-	 * after_wmarks_check() is called back while the context is deactivated
-	 * by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, false, false);
-}
-
-static int damon_sysfs_after_sampling(struct damon_ctx *c)
-{
-	/*
-	 * after_sampling() is called back only while the context is not
-	 * deactivated by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, true, false);
-}
-
-static int damon_sysfs_after_aggregation(struct damon_ctx *c)
-{
-	/*
-	 * after_aggregation() is called back only while the context is not
-	 * deactivated by watermarks.
-	 */
-	return damon_sysfs_cmd_request_callback(c, true, true);
-}
-
 static struct damon_ctx *damon_sysfs_build_ctx(
 		struct damon_sysfs_context *sys_ctx)
 {
@@ -1603,9 +1544,6 @@ static struct damon_ctx *damon_sysfs_bui
 		return ERR_PTR(err);
 	}
 
-	ctx->callback.after_wmarks_check = damon_sysfs_after_wmarks_check;
-	ctx->callback.after_sampling = damon_sysfs_after_sampling;
-	ctx->callback.after_aggregation = damon_sysfs_after_aggregation;
 	ctx->callback.before_terminate = damon_sysfs_before_terminate;
 	return ctx;
 }
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

