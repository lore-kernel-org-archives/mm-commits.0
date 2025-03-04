Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5067625F99E
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130342; cv=none; b=g3lTNjYFeGZY+u/qMpsVGQ5kWAmHvJ5N0ty1xTJLpYXis2xaNULBFZYQPm/vq5Pv5CN0nrgzxMwDQo0P2PhSirwgXjTuQH6zHFt19ldkfW1PchA4RgK/2wDGugCg5n69gG7F3hw4oWstFYIKlEMGBUeqd4KqlWg98M68MJU1IrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130342; c=relaxed/simple;
	bh=jMzN6CgZ4NswqOmex3JDJS6sHNbETHfxj+MfCoVVlss=;
	h=Date:To:From:Subject:Message-Id; b=MROfMytu+4ras471uh6aQfTWBLitv9VMAsdOkgd1MIpCSBrr2/UUD4HNvYUptvrnlpAiZMvojWStYtveF3Hibw/PZ5SmsvPyLNyBzr5u1I/h3Wak9vrs+QKggW4ORoUfNo3wvKw4AxkTPRYpNea9NlHGzHsqX52xonPJb6ABjog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ow/4dKXq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ow/4dKXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE8AC4CEE5;
	Tue,  4 Mar 2025 23:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130341;
	bh=jMzN6CgZ4NswqOmex3JDJS6sHNbETHfxj+MfCoVVlss=;
	h=Date:To:From:Subject:From;
	b=Ow/4dKXqneY72NDJVR/FxM24c/quZsJo0zDzTgvkxcRYDUWRNhfGG+ZkqCDH3GaTC
	 dVozGxzneFOF25vlx1o+myZH3/Tj7P7YfWJMGO1BcW8yYHJmrZh1VIvSQZDJZkHE5R
	 +e0AS/th3J6OMHZ/Kr9IPYBtgpza2LbpftNCTFd4=
Date: Tue, 04 Mar 2025 15:19:00 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-introduce-damos-ops_filters.patch added to mm-unstable branch
Message-Id: <20250304231901.BFE8AC4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: introduce damos->ops_filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-introduce-damos-ops_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-introduce-damos-ops_filters.patch

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
Subject: mm/damon/core: introduce damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:05 -0800

Patch series "mm/damon: make allow filters after reject filters useful and
intuitive".

DAMOS filters do allow or reject elements of memory for given DAMOS scheme
only if those match the filter criterias.  For elements that don't match
any DAMOS filter, 'allowing' is the default behavior.  This makes
allow-filters that don't have any reject-filter after them meaningless
sources of overhead.  The decision was made to keep the behavior
consistent with that before the introduction of allow-filters.  This,
however, makes usage of DAMOS filters confusing and inefficient.  It is
more intuitive and still consistent behavior to reject by default unless
there is no filter at all or the last filter is a reject filter.  Update
the filtering logic in the way and update documents to clarify the
behavior.

Note that this is changing the old behavior.  But the old behavior for the
problematic filter combination was definitely confusing, inefficient and
anyway useless.  Also, the behavior has relatively recently introduced. 
It is difficult to anticipate any user that depends on the behavior. 
Hence this is not a user-breaking behavior change but an obvious
improvement.


This patch (of 9):

DAMOS filters can be categorized into two groups depending on which layer
they are handled, namely core layer and ops layer.  The groups are
important because the filtering behavior depends on evaluation sequence of
filters, and core layer-handled filters are evaluated before operations
layer-handled ones.

The behavior is clearly documented, but the implementation is bit
inefficient and complicated.  All filters are maintained in a single list
(damos->filters) in mix.  Filters evaluation logics in core layer and
operations layer iterates all the filters on the list, while skipping
filters that should be not handled by the layer of the logic.  It is
inefficient.  Making future extensions having differentiations for filters
of different handling layers will also be complicated.

Add a new list that will be used for having all operations layer-handled
DAMOS filters to DAMOS scheme data structure.  Also add the support of its
initialization and basic traversal functions.

Link: https://lkml.kernel.org/r/20250304211913.53574-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250304211913.53574-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    8 ++++++++
 mm/damon/core.c       |    1 +
 2 files changed, 9 insertions(+)

--- a/include/linux/damon.h~mm-damon-core-introduce-damos-ops_filters
+++ a/include/linux/damon.h
@@ -448,6 +448,7 @@ struct damos_access_pattern {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
  * @filters:		Additional set of &struct damos_filter for &action.
+ * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @list:		List head for siblings.
@@ -508,6 +509,7 @@ struct damos {
 		int target_nid;
 	};
 	struct list_head filters;
+	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
 	struct list_head list;
@@ -858,6 +860,12 @@ static inline unsigned long damon_sz_reg
 #define damos_for_each_filter_safe(f, next, scheme) \
 	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
 
+#define damos_for_each_ops_filter(f, scheme) \
+	list_for_each_entry(f, &(scheme)->ops_filters, list)
+
+#define damos_for_each_ops_filter_safe(f, next, scheme) \
+	list_for_each_entry_safe(f, next, &(scheme)->ops_filters, list)
+
 #ifdef CONFIG_DAMON
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
--- a/mm/damon/core.c~mm-damon-core-introduce-damos-ops_filters
+++ a/mm/damon/core.c
@@ -375,6 +375,7 @@ struct damos *damon_new_scheme(struct da
 	scheme->next_apply_sis = 0;
 	scheme->walk_completed = false;
 	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
 
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
selftests-damon-damos_quota-make-real-expectation-of-quota-exceeds.patch
selftests-damon-damon_nr_regions-set-ops-update-for-merge-results-check-to-100ms.patch
selftests-damon-damon_nr_regions-sort-collected-regiosn-before-checking-with-min-max-boundaries.patch
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

