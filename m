Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15E25F99E
	for <mm-commits@vger.kernel.org>; Tue,  4 Mar 2025 23:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741130344; cv=none; b=W46CgLEVUg7zdzF18G3hIC92uFaSRXDclRSvNBmSQaHHHxHAuUnuPpCrMYoXXshBzpeFSyyzBADZ6E/6mlPju+JUxmZB9QzFgroGHGCC2BnHmzc6iUOMN9OkeqBn9bg/116h7hwzGuAo6P5MUZnHCKF7nXKlP38UFzgKHl6AqlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741130344; c=relaxed/simple;
	bh=z3axrroJICePNnUUo8aD0+ObaurVeX42AkOLBMuZpaQ=;
	h=Date:To:From:Subject:Message-Id; b=q8/oM7oNnFMQRGfXssUGOfG5S6Mok7iSWs6v84jDFi1s1n0j6wBvrFpNQZLFTCrWnS8mnKUrnFZMJfbn5hRXxnLtilxiTrhdknY3JjOVd4r1DAZKIVaH4IMaSdXJSHkyy8Th28bQGN8eg4VI3slQ8gM+uPQXLdTU7MqwO0ZRi0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5Vk6IHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5Vk6IHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40888C4CEE5;
	Tue,  4 Mar 2025 23:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741130344;
	bh=z3axrroJICePNnUUo8aD0+ObaurVeX42AkOLBMuZpaQ=;
	h=Date:To:From:Subject:From;
	b=c5Vk6IHngwlGkprT5Fco44HBRE8/sen34G8mnf+Wnzw6gbgrk5K/37wlM8iIe0M+3
	 qu+1ZCjGnRcRqWZtxeIXuR/t0SfBzQAJwF814VACHlaus3PhvWPKsUFoOZ2Wqb5AdO
	 mMP/05Gqh/KK6iqNkC62FatbiT0oXZuzHVBO7U8w=
Date: Tue, 04 Mar 2025 15:19:03 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-paddr-support-ops_filters.patch added to mm-unstable branch
Message-Id: <20250304231904.40888C4CEE5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/paddr: support ops_filters
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-paddr-support-ops_filters.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-paddr-support-ops_filters.patch

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
Subject: mm/damon/paddr: support ops_filters
Date: Tue, 4 Mar 2025 13:19:06 -0800

DAMON keeps all DAMOS filters in damos->filters.  Upcoming changes will
make it to use damos->ops_filters for all operations layer handled DAMOS
filters, though.  DAMON physical address space operations set
implementation (paddr) is not ready for the changes, since it handles only
damos->filters.  To avoid any breakage during the upcoming changes, make
paddr to handle both lists.  After the change is made, ->filters support
on paddr can be safely removed.

Link: https://lkml.kernel.org/r/20250304211913.53574-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/paddr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/mm/damon/paddr.c~mm-damon-paddr-support-ops_filters
+++ a/mm/damon/paddr.c
@@ -260,6 +260,10 @@ static bool damos_pa_filter_out(struct d
 		if (damos_pa_filter_match(filter, folio))
 			return !filter->allow;
 	}
+	damos_for_each_ops_filter(filter, scheme) {
+		if (damos_pa_filter_match(filter, folio))
+			return !filter->allow;
+	}
 	return false;
 }
 
@@ -290,6 +294,12 @@ static unsigned long damon_pa_pageout(st
 			break;
 		}
 	}
+	damos_for_each_ops_filter(filter, s) {
+		if (filter->type == DAMOS_FILTER_TYPE_YOUNG) {
+			install_young_filter = false;
+			break;
+		}
+	}
 	if (install_young_filter) {
 		filter = damos_new_filter(
 				DAMOS_FILTER_TYPE_YOUNG, true, false);
@@ -538,6 +548,8 @@ static bool damon_pa_scheme_has_filter(s
 
 	damos_for_each_filter(f, s)
 		return true;
+	damos_for_each_ops_filter(f, s)
+		return true;
 	return false;
 }
 
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

