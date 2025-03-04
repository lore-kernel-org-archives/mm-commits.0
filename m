Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E461FDE01
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130348; cv=none; b=st58C5g5wBR+YVGbYjqslI+RVZB0/Ngh/YDxNo+RwdK9Luqzi9lxY8DIztRnFi0RhqUjDBx4s3Y0byA+q2BAfCXX5aeFkFrizd9fXUNBkss7gRYCx6HgFCgPbjPkn/hftjSwLWULa3TnUJvVsdFKiecNyvUdWnoVPGmBlFiSzuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130348; c=relaxed/simple;
	bh=7IxHN5Cqka4SHZF/tSDqF41+KI+yzSHd+ca06/+v65s=;
	h=Date:To:From:Subject:Message-Id; b=TFiPx1qDqWi3S7xBT3HDxKnvEs9DjtSEAQn9yo73IFnGZ7OiADs/RUUuWrP+/Dvx+w1boiQOqF6NdYf47a5D9k/y56u1MQHKhGlWzLy367AknIs9LXOof+6mj0YjTvz2OBF1wT4AJia/8LVVQph3+8vK9GRyiG6R4gM4rv1vcgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X7xJXzbu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X7xJXzbu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F451C4CEE9;
	Tue,  4 Mar 2025 23:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130348;
	bh=7IxHN5Cqka4SHZF/tSDqF41+KI+yzSHd+ca06/+v65s=;
	h=Date:To:From:Subject:From;
	b=X7xJXzbuKEyhsav8mlYSoJcbprKbFYVjhUec1LdC+9PcM8OlRn6C6EC+RD+WH+bf6
	 mGCRyq+2wJGkyRYVIIM0TCx0CQzaehgD0L6vNTxMHHsmNxkH7rtzoRSGgt1C1Liibm
	 xfaO+SFTrLXikmiOIRD3fPtBZjQ3uC4RZi/Eq4CA=
Date: Tue, 04 Mar 2025 15:19:07 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch added to mm-unstable branch
Message-Id: <20250304231908.1F451C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: put ops-handled filters to damos->ops_filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-put-ops-handled-filters-to-damos-ops_filters.patch

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
Subject: mm/damon/core: put ops-handled filters to damos->ops_filters
Date: Tue, 4 Mar 2025 13:19:08 -0800

damos->ops_filters has introduced to be used for all operations layer
handled filters.  But DAMON kernel API callers can put any type of DAMOS
filters to any of damos->filters and damos->ops_filters.  DAMON user-space
ABI users have no way to use ->ops_filters at all.  Update
damos_add_filter(), which should be used by API callers to install DAMOS
filters, to add filters to ->filters and ->ops_filters depending on their
handling layer.  The change forces both API callers and ABI users to use
proper lists since ABI users use the API internally.

Link: https://lkml.kernel.org/r/20250304211913.53574-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-put-ops-handled-filters-to-damos-ops_filters
+++ a/mm/damon/core.c
@@ -281,9 +281,24 @@ struct damos_filter *damos_new_filter(en
 	return filter;
 }
 
+static bool damos_filter_for_ops(enum damos_filter_type type)
+{
+	switch (type) {
+	case DAMOS_FILTER_TYPE_ADDR:
+	case DAMOS_FILTER_TYPE_TARGET:
+		return false;
+	default:
+		break;
+	}
+	return true;
+}
+
 void damos_add_filter(struct damos *s, struct damos_filter *f)
 {
-	list_add_tail(&f->list, &s->filters);
+	if (damos_filter_for_ops(f->type))
+		list_add_tail(&f->list, &s->ops_filters);
+	else
+		list_add_tail(&f->list, &s->filters);
 }
 
 static void damos_del_filter(struct damos_filter *f)
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

