Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74AA1FDE01
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130346; cv=none; b=lAux987MuYnAbicsXPJrg8PuevGTbA+3Mc39XUkNP/SSkg/M7KI/lEhm6PMgNPu3CDyEV2iSk2/25JcBUcawPx/60yCA6CAQ1X7/onuf6+oHPFt0zyCM7Xa93qwB7D3UhkHPiriG8AV5UgGZMOh5BtiQTMoeMUTwlB1XHVLLlj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130346; c=relaxed/simple;
	bh=Ek/cGPMJJ5NhNdRg0oAti2rdiXxB65quvh3fSQ0dHUs=;
	h=Date:To:From:Subject:Message-Id; b=BBQHceG2GwCjKJqVmheXx71Z20tL25QH1czBVUJBj5h0lQw8N6nzyICJzINf/8kZ14ElxWiwGiu0kjbIYkShX/q+zncCW08pBCHkhMlTJm+9gsoWfxXPevh3t2HiZWejpGBnDA4YEnbOmYpqXdH5IW4UBjwGMuJvXhfEz1hZ/Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2LOOahYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2LOOahYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23316C4CEE5;
	Tue,  4 Mar 2025 23:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130346;
	bh=Ek/cGPMJJ5NhNdRg0oAti2rdiXxB65quvh3fSQ0dHUs=;
	h=Date:To:From:Subject:From;
	b=2LOOahYu5e6WvllR7Y/emCI5Jv7LjqlGIna/I3tF+1dMavDe63abaz7bxHtjOZSQe
	 ugPhh9wV6QoNugVTF0xPfxTTc2k4Aq1uS1U3sgOX84Cs7ODkBrZUCqwgfMQIutYcNO
	 VljMRt7FQaXfZM6bwmkHe9b/zFkEmF8FSmOs1V7I=
Date: Tue, 04 Mar 2025 15:19:05 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-support-committing-ops_filters.patch added to mm-unstable branch
Message-Id: <20250304231906.23316C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: support committing ops_filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-support-committing-ops_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-support-committing-ops_filters.patch

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
Subject: mm/damon/core: support committing ops_filters
Date: Tue, 4 Mar 2025 13:19:07 -0800

DAMON kernel API callers should use damon_commit_ctx() to install DAMON
parameters including DAMOS filters.  But damos_commit_ops_filters(), which
is called by damon_commit_ctx() for filters installing, is not handling
damos->ops_filters.  Hence, no DAMON kernel API caller can use
damos->ops_filters.  Do the committing of the ops_filters to make it
usable.

Link: https://lkml.kernel.org/r/20250304211913.53574-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |   40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-support-committing-ops_filters
+++ a/mm/damon/core.c
@@ -820,7 +820,7 @@ static void damos_commit_filter(
 	damos_commit_filter_arg(dst, src);
 }
 
-static int damos_commit_filters(struct damos *dst, struct damos *src)
+static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 {
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
@@ -848,6 +848,44 @@ static int damos_commit_filters(struct d
 	return 0;
 }
 
+static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
+{
+	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
+	int i = 0, j = 0;
+
+	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_filter(i++, src);
+		if (src_filter)
+			damos_commit_filter(dst_filter, src_filter);
+		else
+			damos_destroy_filter(dst_filter);
+	}
+
+	damos_for_each_ops_filter_safe(src_filter, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_filter = damos_new_filter(
+				src_filter->type, src_filter->matching,
+				src_filter->allow);
+		if (!new_filter)
+			return -ENOMEM;
+		damos_commit_filter_arg(new_filter, src_filter);
+		damos_add_filter(dst, new_filter);
+	}
+	return 0;
+}
+
+static int damos_commit_filters(struct damos *dst, struct damos *src)
+{
+	int err;
+
+	err = damos_commit_core_filters(dst, src);
+	if (err)
+		return err;
+	return damos_commit_ops_filters(dst, src);
+}
+
 static struct damos *damon_nth_scheme(int n, struct damon_ctx *ctx)
 {
 	struct damos *s;
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

