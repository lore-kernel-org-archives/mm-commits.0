Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD31CEAC3
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921967; cv=none; b=McXFYkBpbtSjfiIrvo3sL1GtE/UeGyjT7LMKcrYXcMjTU55ttsHu4rUPpkbcQmTdPFBCb+/1I+F+88s5mOCkq8IvE7k0C2Qmm5cwyqnzypeRDCyrs2oqYkybcRPisXWrRcdR3UJ6eduSsm9TJ9KiuTu7PyaGJnIQBVn1LE+UxJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921967; c=relaxed/simple;
	bh=Qq7CNg42ubcnkMI0VKHfo1up1ks5kVHqeZB8HiIxkSk=;
	h=Date:To:From:Subject:Message-Id; b=mTkFJ/kBY5twquyc9aNz85QnohQ2arTa5K33AV9bzAfeogUmB4lNl3WsAmR/NDCj/OGOMOc1cItJpRTNoQoM5JK7H4PW0Z+ssF+JvQgxTpZOenCxE991jPWMBtSKNJB3OgiHrK4KV0UfcM08wd5xXNCnJPlcLBlQfIqjgkrO5fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GxGTpqks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GxGTpqks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF2CC4CEE2;
	Tue, 18 Feb 2025 23:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921966;
	bh=Qq7CNg42ubcnkMI0VKHfo1up1ks5kVHqeZB8HiIxkSk=;
	h=Date:To:From:Subject:From;
	b=GxGTpqksGzMfJY4HQ79uiVrHybrQkDY+lRkETJozdbAPVV+0oWZmv7mOHNG0MuMN6
	 +HkGdBKgSeHuVxI4+2o7Vh/WDErasA9T1rAAc4ee2DK4bh3Yo8hksbsM309LeG4/H/
	 QCA5sGiQNqUNMEFlnTOgSoM9u4Wr502iPY2ukBjg=
Date: Tue, 18 Feb 2025 15:39:26 -0800
To: mm-commits@vger.kernel.org,usamaarif642@gmail.com,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch added to mm-unstable branch
Message-Id: <20250218233926.CDF2CC4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add kernel-doc comment for damos_filter->sz_range
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-introduce-damos-filter-type-hugepage_size-fix.patch

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
Subject: mm/damon: add kernel-doc comment for damos_filter->sz_range
Date: Tue, 18 Feb 2025 14:30:58 -0800

Commit 212f4d0cb42c ("mm/damon: introduce DAMOS filter type
hugepage_size") on mm-unstable added sz_range field to 'struct
damos_filter'.  It missed updating the kernel-doc comment, though.  It is
making the documentation build unhappy.  Add a comment for the field.

Link: https://lkml.kernel.org/r/20250218223058.52459-1-sj@kernel.org
Fixes: 212f4d0cb42c ("mm/damon: introduce DAMOS filter type hugepage_size") # mm-unstable
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-introduce-damos-filter-type-hugepage_size-fix
+++ a/include/linux/damon.h
@@ -372,6 +372,7 @@ enum damos_filter_type {
  * @target_idx:	Index of the &struct damon_target of
  *		&damon_ctx->adaptive_targets if @type is
  *		DAMOS_FILTER_TYPE_TARGET.
+ * @sz_range:	Size range if @type is DAMOS_FILTER_TYPE_HUGEPAGE_SIZE.
  * @list:	List head for siblings.
  *
  * Before applying the &damos->action to a memory region, DAMOS checks if each
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

