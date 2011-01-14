From: akpm@linux-foundation.org
Subject: [merged] thp-_gfp_no_kswapd.patch removed from -mm tree
Date: Fri, 14 Jan 2011 14:47:13 -0800
Message-ID: <201101142250.p0EMo3ZN005366@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49442 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753868Ab1ANWuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Jan 2011 17:50:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aarcange@redhat.com, mel@csn.ul.ie, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     thp: _GFP_NO_KSWAPD
has been removed from the -mm tree.  Its filename was
     thp-_gfp_no_kswapd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: _GFP_NO_KSWAPD
From: Andrea Arcangeli <aarcange@redhat.com>

Transparent hugepage allocations must be allowed not to invoke kswapd or
any other kind of indirect reclaim (especially when the defrag sysfs is
control disabled).  It's unacceptable to swap out anonymous pages
(potentially anonymous transparent hugepages) in order to create new
transparent hugepages.  This is true for the MADV_HUGEPAGE areas too
(swapping out a kvm virtual machine and so having it suffer an unbearable
slowdown, so another one with guest physical memory marked MADV_HUGEPAGE
can run 30% faster if it is running memory intensive workloads, makes no
sense).  If a transparent hugepage allocation fails the slowdown is minor
and there is total fallback, so kswapd should never be asked to swapout
memory to allow the high order allocation to succeed.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/gfp.h |    5 ++++-
 mm/page_alloc.c     |    3 ++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN include/linux/gfp.h~thp-_gfp_no_kswapd include/linux/gfp.h
--- a/include/linux/gfp.h~thp-_gfp_no_kswapd
+++ a/include/linux/gfp.h
@@ -34,6 +34,7 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOTRACK		0
 #endif
+#define ___GFP_NO_KSWAPD	0x400000u
 
 /*
  * GFP bitmasks..
@@ -81,13 +82,15 @@ struct vm_area_struct;
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE) /* Page is reclaimable */
 #define __GFP_NOTRACK	((__force gfp_t)___GFP_NOTRACK)  /* Don't track with kmemcheck */
 
+#define __GFP_NO_KSWAPD	((__force gfp_t)___GFP_NO_KSWAPD)
+
 /*
  * This may seem redundant, but it's a way of annotating false positives vs.
  * allocations that simply cannot be supported (e.g. page tables).
  */
 #define __GFP_NOTRACK_FALSE_POSITIVE (__GFP_NOTRACK)
 
-#define __GFP_BITS_SHIFT 22	/* Room for 22 __GFP_FOO bits */
+#define __GFP_BITS_SHIFT 23	/* Room for 23 __GFP_FOO bits */
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /* This equals 0, but use constants in case they ever change */
diff -puN mm/page_alloc.c~thp-_gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~thp-_gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2027,7 +2027,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, u
 		goto nopage;
 
 restart:
-	wake_all_kswapd(order, zonelist, high_zoneidx,
+	if (!(gfp_mask & __GFP_NO_KSWAPD))
+		wake_all_kswapd(order, zonelist, high_zoneidx,
 						zone_idx(preferred_zone));
 
 	/*
_

Patches currently in -mm which might be from aarcange@redhat.com are

origin.patch
thp-add-pagetranscompound.patch

