Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99AF91FAC4C
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130354; cv=none; b=m8kZUQz/gGksAQDr7ij3jqZDv/cpHvQpzyQjAp9LHSNy4rDllzh40jRxDOIS5Ra0yV9J1n/XWNpUZ6Rn0GXPQp8hLDzRujd2u917FHoALdrC9+7sNO9S4YBjtNK989dsKr0z2mSomjXe70wEgO5KGs4+aSguP/cy/oH37T0Zw+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130354; c=relaxed/simple;
	bh=z86oUtv55JHNFZttWyFc9XsQUxRLZWDqBoYC7DM+oKc=;
	h=Date:To:From:Subject:Message-Id; b=oMfhQj8+LcHRtgNZlXJeP/kuZj2A60ojqLNIJ9kMrgxJxS+DEj7dI+L93KD6W+C5QiZmYR12SD7+jCDkmOvrlYGpL2xRelEN6MCq3zJ9u5NxwBbOWOM9NDdrDG/11+kH2iqEAm1xFHdibKFRtudjXO5oCCCQOMkjtGdec3QkboY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=K2xr4btQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="K2xr4btQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08FE5C4CEE9;
	Tue,  4 Mar 2025 23:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130354;
	bh=z86oUtv55JHNFZttWyFc9XsQUxRLZWDqBoYC7DM+oKc=;
	h=Date:To:From:Subject:From;
	b=K2xr4btQgCpeJYZAzYRR76W10fnO+7wEBHk62WtrhM7I6Z7Ng2g6/meI2DfMxV+ic
	 0tri3GVeigDvdkWMuXfjsKlKvYq9bGBfpX1nIXetF+LoJqASJyyB1s9MSsW4CIy/dP
	 cdU1dKxNsX+H/Y2zC8n8+81cnz21kPBd2C+BVbH0=
Date: Tue, 04 Mar 2025 15:19:13 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch added to mm-unstable branch
Message-Id: <20250304231914.08FE5C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set damos_filter default allowance behavior based on installed filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters.patch

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
Subject: mm/damon/core: set damos_filter default allowance behavior based on installed filters
Date: Tue, 4 Mar 2025 13:19:11 -0800

Decide whether to allow or reject by default on core and opertions layer
handled filters evaluation stages.  It is decided as the opposite of the
last installed filter's behavior.  If there is no filter at all, allow by
default.  If there is any operations layer handled filters, core layer's
filtering stage sets allowing as the default behavior regardless of the
last filter of core layer-handling ones, since the last filter of core
layer handled filters in the case is not really the last filter of the
entire filtering stage.

Also, make the core layer's DAMOS filters handling stage uses the newly
set behavior field.

Link: https://lkml.kernel.org/r/20250304211913.53574-8-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   34 ++++++++++++++++++++++++++++++++--
 1 file changed, 32 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-set-damos_filter-default-allowance-behavior-based-on-installed-filters
+++ a/mm/damon/core.c
@@ -891,6 +891,32 @@ static int damos_commit_ops_filters(stru
 	return 0;
 }
 
+/**
+ * damos_filters_default_reject() - decide whether to reject memory that didn't
+ *				    match with any given filter.
+ * @filters:	Given DAMOS filters of a group.
+ */
+static bool damos_filters_default_reject(struct list_head *filters)
+{
+	struct damos_filter *last_filter;
+
+	if (list_empty(filters))
+		return false;
+	last_filter = list_last_entry(filters, struct damos_filter, list);
+	return last_filter->allow;
+}
+
+static void damos_set_filters_default_reject(struct damos *s)
+{
+	if (!list_empty(&s->ops_filters))
+		s->core_filters_default_reject = false;
+	else
+		s->core_filters_default_reject =
+			damos_filters_default_reject(&s->filters);
+	s->ops_filters_default_reject =
+		damos_filters_default_reject(&s->ops_filters);
+}
+
 static int damos_commit_filters(struct damos *dst, struct damos *src)
 {
 	int err;
@@ -898,7 +924,11 @@ static int damos_commit_filters(struct d
 	err = damos_commit_core_filters(dst, src);
 	if (err)
 		return err;
-	return damos_commit_ops_filters(dst, src);
+	err = damos_commit_ops_filters(dst, src);
+	if (err)
+		return err;
+	damos_set_filters_default_reject(dst);
+	return 0;
 }
 
 static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
@@ -1580,7 +1610,7 @@ static bool damos_filter_out(struct damo
 			return !filter->allow;
 		}
 	}
-	return false;
+	return s->core_filters_default_reject;
 }
 
 /*
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

