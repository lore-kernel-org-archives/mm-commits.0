Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AF2207A34
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297109; cv=none; b=bvdEjsObfKUsIEc6uL6G0y5o2CgvDP11sq/NApCMXmuMByORuq4D7/limyFUSQsNUPE2ove3FI7TcdXlhSM0O9jyNWSGxN1hH2RICGI9WMDV3INuSN1fwDwmB4MeC6hxuupFyuHVePKNcMoE7M5z8DR1qjWgrtGDzRnkNVhNf9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297109; c=relaxed/simple;
	bh=hH7kOdI56OJpwyQaBurYunzcGZJif+Z5StsgORb4mRU=;
	h=Date:To:From:Subject:Message-Id; b=fiMpKH5gGQhAWeuXOLez6QepuFgBc60pF7sWy/JDxt4X//fWU4gwyQU3Q6nnj2NwHU2JCkE+XmkbVOpTg+48gfyEEmxtmElXgXtwbylPc/oskeHzNDXdHgMrXXy0Rf8uqBPmU4LScl/IPuOoeQ6B2JOL97O/TOcR3yFUHTLsHpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=zvlgQ8ZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="zvlgQ8ZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397E0C4CEE0;
	Thu,  6 Mar 2025 21:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297108;
	bh=hH7kOdI56OJpwyQaBurYunzcGZJif+Z5StsgORb4mRU=;
	h=Date:To:From:Subject:From;
	b=zvlgQ8ZVe2QgN201tmzBP12fXm5YZvSQs3CLIbddy+UtuVojQwIyIFIRpyQnVSNnV
	 HJL2BPSp13CvpMwdpNmz/BrvFvQbqZX5O25B7xS1H0ughoRb72BMakwPyZRPar3xrC
	 y15AqrsN3p+orn0YaYOa02CySh7oHCMBmaiEJkGM=
Date: Thu, 06 Mar 2025 13:38:27 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch added to mm-unstable branch
Message-Id: <20250306213828.397E0C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request and its readers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers.patch

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
Subject: mm/damon/sysfs: remove damon_sysfs_cmd_request and its readers
Date: Thu, 6 Mar 2025 09:59:02 -0800

damon_sysfs_cmd_request is DAMON sysfs interface's own synchronization
mechanism for accessing DAMON internal data via damon_callback hooks.  All
the users are now migrated to damon_call() and damos_walk(), so nobody
really uses it.  No one writes to the data structure but reading code is
still remained.  Remove the reading code and the entire data structure.

Link: https://lkml.kernel.org/r/20250306175908.66300-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/sysfs.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-remove-damon_sysfs_cmd_request-and-its-readers
+++ a/mm/damon/sysfs.c
@@ -1238,25 +1238,6 @@ static const char * const damon_sysfs_cm
 	"update_tuned_intervals",
 };
 
-/*
- * struct damon_sysfs_cmd_request - A request to the DAMON callback.
- * @cmd:	The command that needs to be handled by the callback.
- * @kdamond:	The kobject wrapper that associated to the kdamond thread.
- *
- * This structure represents a sysfs command request that need to access some
- * DAMON context-internal data.  Because DAMON context-internal data can be
- * safely accessed from DAMON callbacks without additional synchronization, the
- * request will be handled by the DAMON callback.  None-``NULL`` @kdamond means
- * the request is valid.
- */
-struct damon_sysfs_cmd_request {
-	enum damon_sysfs_cmd cmd;
-	struct damon_sysfs_kdamond *kdamond;
-};
-
-/* Current DAMON callback request.  Protected by damon_sysfs_lock. */
-static struct damon_sysfs_cmd_request damon_sysfs_cmd_request;
-
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
@@ -1555,8 +1536,6 @@ static int damon_sysfs_turn_damon_on(str
 
 	if (damon_sysfs_kdamond_running(kdamond))
 		return -EBUSY;
-	if (damon_sysfs_cmd_request.kdamond == kdamond)
-		return -EBUSY;
 	/* TODO: support multiple contexts per kdamond */
 	if (kdamond->contexts->nr != 1)
 		return -EINVAL;
@@ -1796,8 +1775,7 @@ static bool damon_sysfs_kdamonds_busy(st
 	int i;
 
 	for (i = 0; i < nr_kdamonds; i++) {
-		if (damon_sysfs_kdamond_running(kdamonds[i]) ||
-		    damon_sysfs_cmd_request.kdamond == kdamonds[i])
+		if (damon_sysfs_kdamond_running(kdamonds[i]))
 			return true;
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

