Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F31DE2C5
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921899; cv=none; b=kfyTdkvMdLBcCkzKup4+J4eAc+iP/63DB/eY075BISoIy6felegM5wb8B+eiKs5EChqGOIFi7KaWTUxmznZksGMkhpqPzYgWRYQnbDjk5FUQS5i7YWf+qLfSQ/pAUV+73TnSh7I+MxYY0N3GvRP9EH7gZSAIYjbyvg8v45XqSqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921899; c=relaxed/simple;
	bh=wAQSIySQQ0j3bkMl8PBTnweCa6KlPHVtCla54XZye/Q=;
	h=Date:To:From:Subject:Message-Id; b=f11/RdZUww+rNJoJv9sNDi3dQgNMGjXxSo5DSXMDeveMjvZO8sbxnp4Dw1AYxHEdTxGO8iRWWoRqmQgtmi2ge+5TKEMxMZ7YBIVykyTiT+I1D9Go/wXwwadzcdk53/5fWUx2AxGX4mPtJF6zdwuAjcRJKMV1k0JGdb7FdluzZ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sZUFTL64; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sZUFTL64"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2394C4CEE2;
	Tue, 18 Feb 2025 23:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921899;
	bh=wAQSIySQQ0j3bkMl8PBTnweCa6KlPHVtCla54XZye/Q=;
	h=Date:To:From:Subject:From;
	b=sZUFTL64yFThcQHitOtW4Ne2+vI5na2wei2Frex85Ox7yJGwVo4RgA7Ld6zqXqcII
	 k0g7hVkROH7OSy0z8fL3iC/kSlmi1g1VQTu7utHT4lOP8Tgj6mpn6m38njMPH6hMum
	 Eapxb0Bg+hwQGJJcgUO2EIIU3iXPrEmVs5hnDK0U=
Date: Tue, 18 Feb 2025 15:38:18 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-hugepage_size-filter.patch added to mm-unstable branch
Message-Id: <20250218233818.F2394C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document hugepage_size filter
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-hugepage_size-filter.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-hugepage_size-filter.patch

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
Subject: Docs/mm/damon/design: document hugepage_size filter
Date: Tue, 18 Feb 2025 14:37:05 -0800

'hugepage_size' DAMOS filter type is not documented on the design doc.
Add a description of the type.

Link: https://lkml.kernel.org/r/20250218223708.53437-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    3 +++
 1 file changed, 3 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-hugepage_size-filter
+++ a/Documentation/mm/damon/design.rst
@@ -610,6 +610,9 @@ Below ``type`` of filters are currently
     - Applied to pages that are accessed after the last access check from the
       scheme.
     - Handled by operations set layer.  Supported by only ``paddr`` set.
+- pages that managed in a given size range
+    - Applied to pages that managed in a given size range.
+    - Handled by operations set layer.  Supported by only ``paddr`` set.
 - address range
     - Applied to pages that belonging to a given address range.
     - Handled by the core logic.
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
docs-mm-damon-design-fix-typo-on-damos-filters-usage-doc-link.patch
docs-mm-damon-design-document-hugepage_size-filter.patch
docs-damon-move-damos-filter-type-names-and-meaning-to-design-doc.patch
docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch
docs-mm-damon-design-categorize-damos-filter-types-based-on-handling-layer.patch

