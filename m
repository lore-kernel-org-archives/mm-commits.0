Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C011547DE
	for <mm-commits@vger.kernel.org>; Wed,  5 Mar 2025 21:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741211811; cv=none; b=CXbRu9BSKzTgPV7S/wgO8Qg9Mdzl8hxN8k7DoLck5j81/wqpAgzt8QSmPMLhyeb09f4INhYm+S9SQZpdKAzQiioFbia/B9tk4Hz3x+XHaENOR7PDTIMbJY/khdAcggDMz83xxBKjS/YCv6hP2Oj2YyqQTAeJY7UB2Df8v9+2z6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741211811; c=relaxed/simple;
	bh=4ltOtwLxyU+inF/+ywhr5TI4HiF4YfFKQudTycISoJA=;
	h=Date:To:From:Subject:Message-Id; b=R4yHUCW1r/LEAxbGzKSuj8OQ1PqdXJ+RuuFOjLwcWY5tL4nU/Zew50d5HE13EXQ391cxlLJiG4W5JfuJ43Z502ssZN3Gkrv7xpt/a9xq9zKvnI57k0qp2Gs0kDLCyuWFawGwQK8GB3LSa0dGPgoxsN9WRaHsTQp77kH4yYc/+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LHNBpN04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LHNBpN04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D860C4CED1;
	Wed,  5 Mar 2025 21:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741211811;
	bh=4ltOtwLxyU+inF/+ywhr5TI4HiF4YfFKQudTycISoJA=;
	h=Date:To:From:Subject:From;
	b=LHNBpN04LvO9946i99yjxmmIQ6F+fjYbCNLJhbsmL5Ov3kvqIPQaCia9KxSNnBJVs
	 bMMTd1CxIR90XYgtY0MN3mtqJ4uTfC1qIkIcqTNQA3LJGq7hWpSZEphr4XwCZjzvji
	 KioGtpO1RnE/XSZ4usoELLx256FrYJ26L83ehSUw=
Date: Wed, 05 Mar 2025 13:56:50 -0800
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch added to mm-unstable branch
Message-Id: <20250305215651.0D860C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: fix a typo on 'intervals auto-tuning' section
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-for-intervals-auto-tuning-fix.patch

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
Subject: Docs/mm/damon/design: fix a typo on 'intervals auto-tuning' section
Date: Wed, 5 Mar 2025 10:27:44 -0800

Commit ("Docs/mm/damon/design: document for intervals auto-tuning") made a
typo on a cross reference link in monitoring intervals auto-tuning
section.  It causes document build warning.  Fix it.

Link: https://lkml.kernel.org/r/20250305182744.56125-1-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20250305203312.6f30e9c2@canb.auug.org.au
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-for-intervals-auto-tuning-fix
+++ a/Documentation/mm/damon/design.rst
@@ -340,7 +340,7 @@ DAMON-observed access events to the theo
 (``aggrs``).
 
 The DAMON-observed access events are calculated in byte granularity based on
-DAMON :ref:`region assumption <damon_design_region_based_sample>`.  For
+DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
 example, if a region of size ``X`` bytes of ``Y`` ``nr_accesses`` is found, it
 means ``X * Y`` access events are observed by DAMON.  Theoretical maximum
 access events for the region is calculated in same way, but replacing ``Y``
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

