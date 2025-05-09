Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F4921D3E8
	for <mm-commits@vger.kernel.org>; Fri,  9 May 2025 20:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746824380; cv=none; b=Z88WxVrHI28Zgl8bNH8xcEiRDKuMS4maIoNw4jnalfRBLxB1cvbtRE/7bAA1NQ6FqSvfP6Ej9B2/5Hef4h1IfNVtBk2i5Q77tHhv04vY6lN5eBszrvTc8m2K/DhY5I7Wd6ifKi2I18PEUPWJHQq/ZyXkHbEHS2DccxQDGQDACkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746824380; c=relaxed/simple;
	bh=kePCQ4l0q6w3Xa0biKLBdoftEtzfIrVLufz+aaUyo10=;
	h=Date:To:From:Subject:Message-Id; b=q6/ztSSoDf0YbKdFU0bIjCDNdQlVGC8eYPyOn3duinrmGW5BWY5Ygx7DJfajji1LwFImvYapjHWBD8hLexTXWozln48OADnwDGxk6fhOfiNAznwXLBXMlfsAaMIBtGRtWBGa+PVasWeX1yS1cy0tHyCXw2XhikW8LwWOpnzsVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R28sz59D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R28sz59D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2A9C4CEE4;
	Fri,  9 May 2025 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1746824380;
	bh=kePCQ4l0q6w3Xa0biKLBdoftEtzfIrVLufz+aaUyo10=;
	h=Date:To:From:Subject:From;
	b=R28sz59DWlDx7TAVq1m1ptDGQbLKl/VB16HXMYGadLnQYu6Xyzps+Ry1ptmKIXHL2
	 NGqT7sutXcLJyI+saSX3arPyJlpUj0iQm9XzCZEvbU3gfoHdZFoYnQHU4r1bfrjnxM
	 52RrVnWk1aTq905MKA71FCort48/7MZSVJIaL2Sc=
Date: Fri, 09 May 2025 13:59:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch added to mm-new branch
Message-Id: <20250509205940.1A2A9C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fix unused function warnings
has been added to the -mm mm-new branch.  Its filename is
     mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: Zi Yan <ziy@nvidia.com>
Subject: fix unused function warnings
Date: Fri, 9 May 2025 09:29:09 -0400

1. add __maybe_unused to get_pageblock_isolate(), which is used in
   VM_BUG_ON only.
2. remove unused set_pageblock_isolate().

Link: https://lkml.kernel.org/r/E40B7150-70AA-4D51-B5F3-4FF22AD887FD@nvidia.com
Signed-off-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_isolation.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/mm/page_isolation.c~mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2
+++ a/mm/page_isolation.c
@@ -15,7 +15,7 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
-static inline bool get_pageblock_isolate(struct page *page)
+static inline bool __maybe_unused get_pageblock_isolate(struct page *page)
 {
 	return get_pfnblock_flags_mask(page, page_to_pfn(page),
 			PB_migrate_isolate_bit);
@@ -25,12 +25,6 @@ static inline void clear_pageblock_isola
 	set_pfnblock_flags_mask(page, 0, page_to_pfn(page),
 			PB_migrate_isolate_bit);
 }
-static inline void set_pageblock_isolate(struct page *page)
-{
-	set_pfnblock_flags_mask(page, PB_migrate_isolate_bit,
-			page_to_pfn(page),
-			PB_migrate_isolate_bit);
-}
 
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
_

Patches currently in -mm which might be from ziy@nvidia.com are

mm-page_isolation-make-page-isolation-a-standalone-bit.patch
mm-page_isolation-make-page-isolation-a-standalone-bit-fix.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate.patch
mm-page_isolation-remove-migratetype-from-move_freepages_block_isolate-fix.patch
mm-page_isolation-remove-migratetype-from-undo_isolate_page_range.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix.patch
mm-page_isolation-remove-migratetype-parameter-from-more-functions-fix-2.patch

