Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA3225B68C
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 22:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740005730; cv=none; b=nRVekjkt1xbU8hdDnL1XacDmOK/CK8oc0QpAqfZkbhrmSIPAwmmiZlevU7bYdO/6h1vzL2rdsbsmWh7EIGEMuJsQroaG2JbxVnnZAw41KTfLxKHZLmusnrbveOyJU0ULAISYd0H9W26XdvjLE+b09bM98Rj67N5AcMLNtyZiK6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740005730; c=relaxed/simple;
	bh=pic7iT8evcJNiwkUUnnGxjcNxnEuLy3JBZ2HmIB6k+g=;
	h=Date:To:From:Subject:Message-Id; b=Y91qIQbWYvSvAtkJUgvrfqaGA26SLz+J1XOvF+wHHluLdRYsU5I/uPPseL7VuiwnoDow3hu0qN8sUTW32A1/yhFf/KqfdAuhyBaQt4ZG4zllwwgDbIdVfUMB/YAr0Icgen0OWsUtnYUnxVd58sXyFpZsoTM9PEeWTijVY1vfP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MfjMiI8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MfjMiI8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9795C4CED1;
	Wed, 19 Feb 2025 22:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740005729;
	bh=pic7iT8evcJNiwkUUnnGxjcNxnEuLy3JBZ2HmIB6k+g=;
	h=Date:To:From:Subject:From;
	b=MfjMiI8+WxSjhBLQjyKlLjHzgYjgT0xwsXvNraS9rhQ+G/r7JwYqj7nanFMfSBXi7
	 iSC4rgxMo0jqPgf3HOoQAlP46A+HZgl638OwaWquhiXXJZEGZcmtyI5RQ01+BkZolr
	 h1Bu8iZypuh2STH+bgEMtSi2T7HnKKF26ayoB9tk=
Date: Wed, 19 Feb 2025 14:55:29 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch added to mm-unstable branch
Message-Id: <20250219225529.A9795C4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: implement a new DAMOS filter type for unmapped pages
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages.patch

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
Subject: mm/damon: implement a new DAMOS filter type for unmapped pages
Date: Wed, 19 Feb 2025 14:01:45 -0800

Patch series "mm/damon: introduce DAMOS filter type for unmapped pages".

User decides whether their memory will be mapped or unmapped.  It implies
that the two types of memory can have different characteristics and
management requirements.  Provide the DAMON-observaibility DAMOS-operation
capability for the different types by introducing a new DAMOS filter type
for unmapped pages.


This patch (of 2):

Implement yet another DAMOS filter type for unmapped pages on DAMON kernel
API, and add support of it from the physical address space DAMON
operations set (paddr).  Since it is for only unmapped pages, support from
the virtual address spaces DAMON operations set (vaddr) is not required.

Link: https://lkml.kernel.org/r/20250219220146.133650-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20250219220146.133650-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h    |    2 ++
 mm/damon/paddr.c         |    3 +++
 mm/damon/sysfs-schemes.c |    1 +
 3 files changed, 6 insertions(+)

--- a/include/linux/damon.h~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/include/linux/damon.h
@@ -337,6 +337,7 @@ struct damos_stat {
  * @DAMOS_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  * @DAMOS_FILTER_TYPE_YOUNG:	Recently accessed pages.
  * @DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
+ * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
  * @DAMOS_FILTER_TYPE_ADDR:	Address range.
  * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
  * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
@@ -357,6 +358,7 @@ enum damos_filter_type {
 	DAMOS_FILTER_TYPE_MEMCG,
 	DAMOS_FILTER_TYPE_YOUNG,
 	DAMOS_FILTER_TYPE_HUGEPAGE_SIZE,
+	DAMOS_FILTER_TYPE_UNMAPPED,
 	DAMOS_FILTER_TYPE_ADDR,
 	DAMOS_FILTER_TYPE_TARGET,
 	NR_DAMOS_FILTER_TYPES,
--- a/mm/damon/paddr.c~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/mm/damon/paddr.c
@@ -236,6 +236,9 @@ static bool damos_pa_filter_match(struct
 		matched = filter->sz_range.min <= folio_sz &&
 			  folio_sz <= filter->sz_range.max;
 		break;
+	case DAMOS_FILTER_TYPE_UNMAPPED:
+		matched = !folio_mapped(folio) || !folio_raw_mapping(folio);
+		break;
 	default:
 		break;
 	}
--- a/mm/damon/sysfs-schemes.c~mm-damon-implement-a-new-damos-filter-type-for-unmapped-pages
+++ a/mm/damon/sysfs-schemes.c
@@ -331,6 +331,7 @@ static const char * const damon_sysfs_sc
 	"memcg",
 	"young",
 	"hugepage_size",
+	"unmapped",
 	"addr",
 	"target",
 };
_

Patches currently in -mm which might be from sj@kernel.org are

selftests-damon-damos_quota_goal-handle-minimum-quota-that-cannot-be-further-reduced.patch
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

