Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F1225B691
	for <mm-commits@vger.kernel.org>; Wed, 19 Feb 2025 22:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740005731; cv=none; b=tDrxdPP6ctAdGS/+InUUoPsnXgypFQGvup0n7DBkge7JCyjxuBqodySOzTq5arorwfb+5kasi3fhotS6KKHufw42BkEQzbS1UIK1oyaSXt/8EPjvqeYmsE1l53ZoRKDDKslP847ktWYfS+3PDuAW1YldFTwgKseDCfjMhGPB1MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740005731; c=relaxed/simple;
	bh=c1U77fvhkkoA/bzRTjUGAJi7T9PMlEvr0JeOyuMXG6w=;
	h=Date:To:From:Subject:Message-Id; b=F9YMbeZdvzrHgi2uj66X5m2NNMcpYQk3GYRWoDeW412Dl7XB/mc10m2uQwcbmO+e9S1QO8DyQdLrweWDrK83JxhNthAAlUkj99Pq9w+QR3L2xj83wsFB+qUa7emoLR7ZLEtmDfIwMNfn/D0m3+AlUler92Zjzd3ta1oldIp6f3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W4xVAiq5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W4xVAiq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE3EC4CED1;
	Wed, 19 Feb 2025 22:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1740005731;
	bh=c1U77fvhkkoA/bzRTjUGAJi7T9PMlEvr0JeOyuMXG6w=;
	h=Date:To:From:Subject:From;
	b=W4xVAiq5a/eytH0Fxg3qFLDOgbDkVq8ILNjXsvf8VBC4AtxMDB9n9ysQbUGrGDyau
	 928hj9uVXuS6hdvBXylOB2IZLgyjzSYU33USj3paHMljo/EICyzFIhenauNUPQIsJt
	 auWIbVpgFUJshn0J939ooEI5nX/zcTxME+X7oE1k=
Date: Wed, 19 Feb 2025 14:55:30 -0800
To: mm-commits@vger.kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-document-unmapped-damos-filter-type.patch added to mm-unstable branch
Message-Id: <20250219225531.3CE3EC4CED1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: document unmapped DAMOS filter type
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-design-document-unmapped-damos-filter-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-document-unmapped-damos-filter-type.patch

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
Subject: Docs/mm/damon/design: document unmapped DAMOS filter type
Date: Wed, 19 Feb 2025 14:01:46 -0800

Document availability and meaning of unmapped DAMOS filter type on design
document.  Since introduction of the type requires no additional user ABI,
usage and ABI document need no update.

Link: https://lkml.kernel.org/r/20250219220146.133650-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    2 ++
 1 file changed, 2 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-document-unmapped-damos-filter-type
+++ a/Documentation/mm/damon/design.rst
@@ -617,6 +617,8 @@ Below ``type`` of filters are currently
           scheme.
     - hugepage_size
         - Applied to pages that managed in a given size range.
+    - unmapped
+        - Applied to pages that unmapped.
 
 To know how user-space can set the filters via :ref:`DAMON sysfs interface
 <sysfs_interface>`, refer to :ref:`filters <sysfs_filters>` part of the
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

