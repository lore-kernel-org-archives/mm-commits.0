Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572DF26D5B6
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 21:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741297112; cv=none; b=CT/NCpIEMOpj0Q7z07H88dTDNRH4yrPJOOeo7BOV+lF3v7gs3mq70ARk+iBJcghWToOqow4vSI54QS2r8NfsKLfQfBGae1VLO8EFole2TC/ZiIvAXIRKTWsdI9rRQcUUF5uoINGcAPXYJXhJMuPZ6suUDmMTm7Az+pJo9eYD0i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741297112; c=relaxed/simple;
	bh=XtcCrBTBytbUsOaf+PwM/YU8fsI2wXGjl7X9+LOj6VY=;
	h=Date:To:From:Subject:Message-Id; b=S55d7/yLtK3hD0suNAzUyedFzxhcX49uaRA6mUFNA2SCWwwDYIQAerz5iHw2TlOR/Cesl7y/dGRl7uDEJKCCKzECdH6jVyJl0VBWvgDfFt/1cY1AP+RgZM6ekHY3vgWS+tDExlbXB+vD8ia4gONxMpVEPRS5ZItqj+xi18q9AEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mSuQX0du; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mSuQX0du"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18F7EC4CEE0;
	Thu,  6 Mar 2025 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741297112;
	bh=XtcCrBTBytbUsOaf+PwM/YU8fsI2wXGjl7X9+LOj6VY=;
	h=Date:To:From:Subject:From;
	b=mSuQX0duEJ0ZqIZYAyO+wg3JYNaiK4KxUGxjD0v2JrKGcNFfivTbQGE5P7VurAQcp
	 aBtHTFFmooav/AZBG94RVMnwgd+bzkwzXGZwG/SlEGsEAqWCcx7TSoHzQUi66qc/CX
	 xNeYN7IyCl4KgG5xinwPUjWxH0Ayh3lzKX2JybvU=
Date: Thu, 06 Mar 2025 13:38:31 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-before_start-of-damon_callback.patch added to mm-unstable branch
Message-Id: <20250306213832.18F7EC4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove ->before_start of damon_callback
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-remove-before_start-of-damon_callback.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-before_start-of-damon_callback.patch

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
Subject: mm/damon: remove ->before_start of damon_callback
Date: Thu, 6 Mar 2025 09:59:05 -0800

The function pointer field was added to be used as a place to do some
initialization works just before DAMON starts working.  However, nobody is
using it now.  Remove it.

Link: https://lkml.kernel.org/r/20250306175908.66300-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    7 ++-----
 mm/damon/core.c       |    2 --
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/include/linux/damon.h~mm-damon-remove-before_start-of-damon_callback
+++ a/include/linux/damon.h
@@ -603,16 +603,14 @@ struct damon_operations {
 /**
  * struct damon_callback - Monitoring events notification callbacks.
  *
- * @before_start:	Called before starting the monitoring.
  * @after_wmarks_check:	Called after each schemes' watermarks check.
  * @after_sampling:	Called after each sampling.
  * @after_aggregation:	Called after each aggregation.
  * @before_damos_apply:	Called before applying DAMOS action.
  * @before_terminate:	Called before terminating the monitoring.
  *
- * The monitoring thread (&damon_ctx.kdamond) calls @before_start and
- * @before_terminate just before starting and finishing the monitoring,
- * respectively.
+ * The monitoring thread (&damon_ctx.kdamond) calls @before_terminate just
+ * before finishing the monitoring.
  *
  * The monitoring thread calls @after_wmarks_check after each DAMON-based
  * operation schemes' watermarks check.  If users need to make changes to the
@@ -628,7 +626,6 @@ struct damon_operations {
  * If any callback returns non-zero, monitoring stops.
  */
 struct damon_callback {
-	int (*before_start)(struct damon_ctx *context);
 	int (*after_wmarks_check)(struct damon_ctx *context);
 	int (*after_sampling)(struct damon_ctx *context);
 	int (*after_aggregation)(struct damon_ctx *context);
--- a/mm/damon/core.c~mm-damon-remove-before_start-of-damon_callback
+++ a/mm/damon/core.c
@@ -2407,8 +2407,6 @@ static int kdamond_fn(void *data)
 
 	if (ctx->ops.init)
 		ctx->ops.init(ctx);
-	if (ctx->callback.before_start && ctx->callback.before_start(ctx))
-		goto done;
 	ctx->regions_score_histogram = kmalloc_array(DAMOS_MAX_SCORE + 1,
 			sizeof(*ctx->regions_score_histogram), GFP_KERNEL);
 	if (!ctx->regions_score_histogram)
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

