Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8373A75BB
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777314207; cv=none; b=DooLzXjr4rrnEsXhxdf0sTWsHIg4QMuqU5jCjqy9x5F3SJ5nyre8vdOUlvdy4OuLIxSsNBRN38QBcKMZUbSIA0tUfysOISeaJaxEN38Nan2CXrWEM0U4LhbnrQqdj7TQwftyckgoOal+YqmtKOx97nG1WDQ5WPRSBNFretVR3HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777314207; c=relaxed/simple;
	bh=SgccKvQvCP1HoP81THoFVmBWVRLmnWKW6ReSZQ3kB3Q=;
	h=Date:To:From:Subject:Message-Id; b=G3guLBlA2nJFM7QdCD46K8WkYDzIITBOv/YIHDdWAW1crto2ct3uet5aAMKUf6o3qK6unRD4IgWQKP6Ceu3+ri3uDwI5FSVQTRG7pe8XPWocpESYb7BqxbWqxMxCy3Ud1Wui+YCCX3DwDm81w5kOQQu56v1sXNrVhyKvUaPSJGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dgwemP5f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dgwemP5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0999CC2BCB6;
	Mon, 27 Apr 2026 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777314207;
	bh=SgccKvQvCP1HoP81THoFVmBWVRLmnWKW6ReSZQ3kB3Q=;
	h=Date:To:From:Subject:From;
	b=dgwemP5fY9rCluFdhamD71cdE8XpQ39fct6QcL6NxRijZB8YMhJlYNw/U5uaQzOu/
	 foRlAPrgJ3dlNYd8zU273xqvfnoJ+IcZqAo93sX0KnlP4NT/iWDjb6CPiCC6xfvHUt
	 zTPH5r/uokvJdQDqmfaF6/EJReuzFDapEJTrA2d0=
Date: Mon, 27 Apr 2026 11:23:26 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch added to mm-new branch
Message-Id: <20260427182327.0999CC2BCB6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mglru: remove redundant swap constrained check upon isolation
has been added to the -mm mm-new branch.  Its filename is
     mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/mglru: remove redundant swap constrained check upon isolation
Date: Tue, 28 Apr 2026 02:07:00 +0800

Remove the swap-constrained early reject check upon isolation.  This check
is a micro optimization when swap IO is not allowed, so folios are
rejected early.  But it is redundant and overly broad since
shrink_folio_list() already handles all these cases with proper
granularity.

Notably, this check wrongly rejected lazyfree folios, and it doesn't cover
all rejection cases.  shrink_folio_list() uses may_enter_fs(), which
distinguishes non-SWP_FS_OPS devices from filesystem-backed swap and does
all the checks after folio is locked, so flags like swap cache are stable.

This check also covers dirty file folios, which are not a problem now
since sort_folio() already bumps dirty file folios to the next generation,
but causes trouble for unifying dirty folio writeback handling.

And there should be no performance impact from removing it.  We may have
lost a micro optimization, but unblocked lazyfree reclaim for NOIO
contexts, which is not a common case in the first place.

Link: https://lore.kernel.org/20260428-mglru-reclaim-v7-9-02fabb92dc43@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Leno Hou <lenohou@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Yafang <laoar.shao@gmail.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/mm/vmscan.c~mm-mglru-remove-redundant-swap-constrained-check-upon-isolation
+++ a/mm/vmscan.c
@@ -4650,12 +4650,6 @@ static bool isolate_folio(struct lruvec
 {
 	bool success;
 
-	/* swap constrained */
-	if (!(sc->gfp_mask & __GFP_IO) &&
-	    (folio_test_dirty(folio) ||
-	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
-		return false;
-
 	/* raced with release_pages() */
 	if (!folio_try_get(folio))
 		return false;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-mglru-consolidate-common-code-for-retrieving-evictable-size.patch
mm-mglru-rename-variables-related-to-aging-and-rotation.patch
mm-mglru-relocate-the-lru-scan-batch-limit-to-callers.patch
mm-mglru-restructure-the-reclaim-loop.patch
mm-mglru-scan-and-count-the-exact-number-of-folios.patch
mm-mglru-use-a-smaller-batch-for-reclaim.patch
mm-mglru-dont-abort-scan-immediately-right-after-aging.patch
mm-mglru-remove-redundant-swap-constrained-check-upon-isolation.patch
mm-mglru-use-the-common-routine-for-dirty-writeback-reactivation.patch
mm-mglru-simplify-and-improve-dirty-writeback-handling.patch
mm-mglru-remove-no-longer-used-reclaim-argument-for-folio-protection.patch
mm-vmscan-remove-sc-file_taken.patch
mm-vmscan-remove-sc-unqueued_dirty.patch
mm-vmscan-unify-writeback-reclaim-statistic-and-throttling.patch

