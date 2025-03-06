Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964F320012D
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297115; cv=none; b=IbPXND/FHc6VcKWk+1/8qHU0SH2Wv0sQgcvhA22GQEsnpxJriTJGYWTJGGWtCHNOTLlI/1KgDaJSsLsc7s7rDZbfrlXBVBJbbtb8ry2Y5tdBBAM04JDrjezGgRbzT3SE4KJv4nZRnBrgOhfAoBYVqUgtLWzVhS7pCFnBO7x5NnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297115; c=relaxed/simple;
	bh=l/JMdr4Vbkd9PvIpwphPjzd1ylFGNXtslcw0gwgjph0=;
	h=Date:To:From:Subject:Message-Id; b=oZwFyjyjCQ2TxH7WhZzuRlLLr5wAFE+4zzmeBKAa5juY0gPKfmhNt2B4Ql9LH01efOfEKIU/f1L3Zhbv4pf5UF4Ajcyk99TNO87NLDxlDOj4cx10l3TA9ebbcLg+5xhRvSQT6dKGVX16aFgxSKh1ZSvYqhbBYpIpeWMkHPKbANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Edb2zMlo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Edb2zMlo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0686C4CEE0;
	Thu,  6 Mar 2025 21:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297115;
	bh=l/JMdr4Vbkd9PvIpwphPjzd1ylFGNXtslcw0gwgjph0=;
	h=Date:To:From:Subject:From;
	b=Edb2zMlofHnzaUqfywSp0rSinUu5hc80iSKH4w9qinLFRflpnCzdfEq9UR8HAY2TO
	 Xt38UBvnzlpTym/CuUIba8Fmz7F7RWEAvEDTZ66sTjgAzeg+JPjZOv9MkDdpKCouVF
	 MuozqSJtK8rTz3PudyNjikR5QtQx+8to+9Omvea4=
Date: Thu, 06 Mar 2025 13:38:34 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-damon_callback-before_damos_apply.patch added to mm-unstable branch
Message-Id: <20250306213834.F0686C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove damon_callback->before_damos_apply
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-damon_callback-before_damos_apply.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-damon_callback-before_damos_apply.patch

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
Subject: mm/damon: remove damon_callback->before_damos_apply
Date: Thu, 6 Mar 2025 09:59:07 -0800

The hook was introduced to let DAMON kernel API users access DAMOS
schemes-eligible regions in a safe way.  Now it is no more used by anyone,
and the functionality is provided in a better way by damos_walk().  Remove
it.

Link: https://lkml.kernel.org/r/20250306175908.66300-13-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    5 -----
 mm/damon/core.c       |   13 ++++---------
 2 files changed, 4 insertions(+), 14 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-damon_callback-before_damos_apply
+++ a/include/linux/damon.h
@@ -605,7 +605,6 @@ struct damon_operations {
  *
  * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_aggregation:	Called after each aggregation.
- * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
  *
  * The monitoring thread (&damon_ctx.kdamond) calls @before_terminate just
@@ -626,10 +625,6 @@ struct damon_operations {
 struct damon_callback {
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
-	int (*before_damos_apply)(struct damon_ctx *context,
-			struct damon_target *target,
-			struct damon_region *region,
-			struct damos *scheme);
 	void (*before_terminate)(struct damon_ctx *context);
 };
 
--- a/mm/damon/core.c~mm-damon-remove-damon_callback-before_damos_apply
+++ a/mm/damon/core.c
@@ -1731,7 +1731,6 @@ static void damos_apply_scheme(struct da
 	struct timespec64 begin, end;
 	unsigned long sz_applied = 0;
 	unsigned long sz_ops_filter_passed = 0;
-	int err = 0;
 	/*
 	 * We plan to support multiple context per kdamond, as DAMON sysfs
 	 * implies with 'nr_contexts' file.  Nevertheless, only single context
@@ -1771,14 +1770,10 @@ static void damos_apply_scheme(struct da
 		if (damos_filter_out(c, t, r, s))
 			return;
 		ktime_get_coarse_ts64(&begin);
-		if (c->callback.before_damos_apply)
-			err = c->callback.before_damos_apply(c, t, r, s);
-		if (!err) {
-			trace_damos_before_apply(cidx, sidx, tidx, r,
-					damon_nr_regions(t), do_trace);
-			sz_applied = c->ops.apply_scheme(c, t, r, s,
-					&sz_ops_filter_passed);
-		}
+		trace_damos_before_apply(cidx, sidx, tidx, r,
+				damon_nr_regions(t), do_trace);
+		sz_applied = c->ops.apply_scheme(c, t, r, s,
+				&sz_ops_filter_passed);
 		damos_walk_call_walk(c, t, r, s, sz_ops_filter_passed);
 		ktime_get_coarse_ts64(&end);
 		quota->total_charged_ns += timespec64_to_ns(&end) -
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

