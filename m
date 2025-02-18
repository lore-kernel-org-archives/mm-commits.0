Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BE81D61B1
	for <mm-commits@vger.kernel.org>; Tue, 18 Feb 2025 23:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739921903; cv=none; b=eT2bIGHFil+i2etALJd4T5oy2yoEh09wIvcRMV0nm6QSWGOxcp8llZTVUN33UXhVeKxrHx2jyTDBXim/uWbjLkZGNoKzNX/VCEeJF4YKLivdofrJafdfpgWdJeVA+euar0uQFc8BgOvmKJQXELhezsjDMD8DdeJRFm+y58N1h2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739921903; c=relaxed/simple;
	bh=cn6p/AJEaKnlbMhddMj01gC+gIBX2nApRxTBn/Hd5zw=;
	h=Date:To:From:Subject:Message-Id; b=kP6e2pmW9izONG0F7zw8vi2rXf/Ey63UpBXZW+2B6V+Ykruvqn6xrtepcmgmTZN5cts9qW3LNJcuGnbRRf5MqENxrj9HcPIsX/Fhsz65fSapnzNV6H8iBGuA3NstWVfyZMGyG2OL304raWEHgleSvqKZvdBr7U4QaLbgaFINfL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FJQiHtg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FJQiHtg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B117C4CEE2;
	Tue, 18 Feb 2025 23:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1739921903;
	bh=cn6p/AJEaKnlbMhddMj01gC+gIBX2nApRxTBn/Hd5zw=;
	h=Date:To:From:Subject:From;
	b=FJQiHtg+smIu+wnClC4lbhsB+llLZ/lpX6VqFrhi0r7HEafpdGzJhNNfOLLJAsm/T
	 moRSZs6H9hbE1xSmzZyZrt8KvttUYDP2Y6DFmc99zbdm90Tj/W34MmGEbmvXlBwi/3
	 1SYL1LaO52lzSW6CuoocaLK/GpsOiT1+T99Gu4Bc=
Date: Tue, 18 Feb 2025 15:38:22 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch added to mm-unstable branch
Message-Id: <20250218233823.0B117C4CEE2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: clarify handling layer based filters evaluation sequence
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence.patch

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
Subject: Docs/mm/damon/design: clarify handling layer based filters evaluation sequence
Date: Tue, 18 Feb 2025 14:37:07 -0800

If an element of memory matches a DAMOS filter, filters that installed
after that get no chance to make any effect to the element.  Hence in what
order DAMOS filters are handled is important, if both allow filters and
reject filters are used together.

The ordering is affected by both the installation order and which layter
the filters are handled.  The design document is not clearly documenting
the latter part.  Clarify it on the design doc.

Link: https://lkml.kernel.org/r/20250218223708.53437-5-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-clarify-handling-layer-based-filters-evaluation-sequence
+++ a/Documentation/mm/damon/design.rst
@@ -569,11 +569,21 @@ number of filters for each scheme.  Each
 - whether it is to allow (include) or reject (exclude) applying
   the scheme's action to the memory (``allow``).
 
-When multiple filters are installed, each filter is evaluated in the installed
-order.  If a part of memory is matched to one of the filter, next filters are
-ignored.  If the memory passes through the filters evaluation stage because it
-is not matched to any of the filters, applying the scheme's action to it is
-allowed, same to the behavior when no filter exists.
+For efficient handling of filters, some types of filters are handled by the
+core layer, while others are handled by operations set.  In the latter case,
+hence, support of the filter types depends on the DAMON operations set.  In
+case of the core layer-handled filters, the memory regions that excluded by the
+filter are not counted as the scheme has tried to the region.  In contrast, if
+a memory regions is filtered by an operations set layer-handled filter, it is
+counted as the scheme has tried.  This difference affects the statistics.
+
+When multiple filters are installed, the group of filters that handled by the
+core layer are evaluated first.  After that, the group of filters that handled
+by the operations layer are evaluated.  Filters in each of the groups are
+evaluated in the installed order.  If a part of memory is matched to one of the
+filter, next filters are ignored.  If the memory passes through the filters
+evaluation stage because it is not matched to any of the filters, applying the
+scheme's action to it is allowed, same to the behavior when no filter exists.
 
 For example, let's assume 1) a filter for allowing anonymous pages and 2)
 another filter for rejecting young pages are installed in the order.  If a page
@@ -590,14 +600,6 @@ filter-allowed or filters evaluation sta
 allow-filters at the end of the list makes no practical change but only
 filters-checking overhead.
 
-For efficient handling of filters, some types of filters are handled by the
-core layer, while others are handled by operations set.  In the latter case,
-hence, support of the filter types depends on the DAMON operations set.  In
-case of the core layer-handled filters, the memory regions that excluded by the
-filter are not counted as the scheme has tried to the region.  In contrast, if
-a memory regions is filtered by an operations set layer-handled filter, it is
-counted as the scheme has tried.  This difference affects the statistics.
-
 Below ``type`` of filters are currently supported.
 
 - anon
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

