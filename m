Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C3260384
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130358; cv=none; b=YxUmwX0o+OR9HEsPghy5WPtjorgIPYPHoOnRmDJuh6b7DkS0P5ukrpR4K6ZrA9ZVpYhw97yCQAblwjUUnatmxXMG73sWmG3HxO8yMEXAoLeYZQiIJLgLEONZaNLrlp12K8s57ZZAkZ6ue50Hezbis7GnZhmRpjakdYKbMNlOJBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130358; c=relaxed/simple;
	bh=gAxHnCGVJe/MXfk/7vVIlmRZqIY30BsF8enCrvkpAEc=;
	h=Date:To:From:Subject:Message-Id; b=BdwsNv2ara2bfhxMAYTtPnruEJxwjKiI0XH7pyO2dkWwXdOkgFfzOE/QYUKVEdVnQI8GoEeowbHeZvvaiKzfm3zpOIZqV3kUL2o8vuBcAxduJxXiYBvBtFQBRSZsOiQ6tsRTNP8hQ2WIQLpt3Q0Sip1IT/Xd6+DWhlwD9Gej08s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1sDOjffv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1sDOjffv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94F2C4CEE5;
	Tue,  4 Mar 2025 23:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130357;
	bh=gAxHnCGVJe/MXfk/7vVIlmRZqIY30BsF8enCrvkpAEc=;
	h=Date:To:From:Subject:From;
	b=1sDOjffvY0iPA/lGFB002HA608ar/9L09P5oykAkLIazJ6tmMoJSzwckr3DHQ4asL
	 aPMXPCgj/JGbj543qYxmcaOUUIg86nxQogX7T0cnw3fg+QF1F+K/bYDxsN8McgNG1U
	 nOyZ2Q/Y5KhaOBKbL+hbFKhhP5amykRLZ0ZL6rCw=
Date: Tue, 04 Mar 2025 15:19:17 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-changed-filter-default-behavior.patch added to mm-unstable branch
Message-Id: <20250304231917.D94F2C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: update for changed filter-default behavior
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-update-for-changed-filter-default-behavior.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-changed-filter-default-behavior.patch

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
Subject: Docs/mm/damon/design: update for changed filter-default behavior
Date: Tue, 4 Mar 2025 13:19:13 -0800

Update the design documentation for changed DAMOS filters default
allowance behaviors.

Link: https://lkml.kernel.org/r/20250304211913.53574-10-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-changed-filter-default-behavior
+++ a/Documentation/mm/damon/design.rst
@@ -631,9 +631,10 @@ When multiple filters are installed, the
 core layer are evaluated first.  After that, the group of filters that handled
 by the operations layer are evaluated.  Filters in each of the groups are
 evaluated in the installed order.  If a part of memory is matched to one of the
-filter, next filters are ignored.  If the memory passes through the filters
+filter, next filters are ignored.  If the part passes through the filters
 evaluation stage because it is not matched to any of the filters, applying the
-scheme's action to it is allowed, same to the behavior when no filter exists.
+scheme's action to it depends on the last filter's allowance type.  If the last
+filter was for allowing, the part of memory will be rejected, and vice versa.
 
 For example, let's assume 1) a filter for allowing anonymous pages and 2)
 another filter for rejecting young pages are installed in the order.  If a page
@@ -645,11 +646,6 @@ second reject-filter blocks it.  If the
 the page will pass through the filters evaluation stage since there is no
 matching filter, and the action will be applied to the page.
 
-Note that the action can equally be applied to memory that either explicitly
-filter-allowed or filters evaluation stage passed.  It means that installing
-allow-filters at the end of the list makes no practical change but only
-filters-checking overhead.
-
 Below ``type`` of filters are currently supported.
 
 - Core layer handled
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

