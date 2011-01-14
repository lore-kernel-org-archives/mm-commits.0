From: akpm@linux-foundation.org
Subject: [merged] thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:15 -0800
Message-ID: <201101142250.p0EMo5vu005371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43352 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab1ANWuS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: don't alloc harder for gfp nomemalloc even if nowait
has been removed from the -mm tree.  Its filename was
     thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: don't alloc harder for gfp nomemalloc even if nowait
From: Andrea Arcangeli <aarcange@redhat.com>

Not worth throwing away the precious reserved free memory pool for
allocations that can fail gracefully (either through mempool or because
they're transhuge allocations later falling back to 4k allocations).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait mm/page_alloc.c
--- a/mm/page_alloc.c~thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait
+++ a/mm/page_alloc.c
@@ -1971,7 +1971,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
 
 	if (!wait) {
-		alloc_flags |= ALLOC_HARDER;
+		/*
+		 * Not worth trying to allocate harder for
+		 * __GFP_NOMEMALLOC even if it can't schedule.
+		 */
+		if  (!(gfp_mask & __GFP_NOMEMALLOC))
+			alloc_flags |= ALLOC_HARDER;
 		/*
 		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
 		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

