From: akpm@linux-foundation.org
Subject: + mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd.patch added to -mm tree
Date: Thu, 14 Apr 2011 12:12:26 -0700
Message-ID: <201104141912.p3EJCQA7000975@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932492Ab1DNTOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Apr 2011 15:14:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, avillaci@fiec.espol.edu.ec, mel@csn.ul.ie


The patch titled
     mm/compaction: reverse the change that forbade sync migraton with __GFP_NO_KSWAPD
has been added to the -mm tree.  Its filename is
     mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/compaction: reverse the change that forbade sync migraton with __GFP_NO_KSWAPD
From: Andrea Arcangeli <aarcange@redhat.com>

It's uncertain this has been beneficial, so it's safer to undo it.  All
other compaction users would still go in synchronous mode if a first
attempt at async compaction failed.  Hopefully we don't need to force
special behavior for THP (which is the only __GFP_NO_KSWAPD user so far
and it's the easier to exercise and to be noticeable).  This also make
__GFP_NO_KSWAPD return to its original strict semantics specific to bypass
kswapd, as THP allocations have khugepaged for the async THP
allocations/compactions.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Alex Villacis Lasso <avillaci@fiec.espol.edu.ec>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd mm/page_alloc.c
--- a/mm/page_alloc.c~mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd
+++ a/mm/page_alloc.c
@@ -2106,7 +2106,7 @@ rebalance:
 					sync_migration);
 	if (page)
 		goto got_pg;
-	sync_migration = !(gfp_mask & __GFP_NO_KSWAPD);
+	sync_migration = true;
 
 	/* Try direct reclaim and then allocating */
 	page = __alloc_pages_direct_reclaim(gfp_mask, order,
_

Patches currently in -mm which might be from aarcange@redhat.com are

mm-add-vm-counters-for-transparent-hugepages.patch
mm-thp-use-conventional-format-for-boolean-attributes.patch
mm-compaction-reverse-the-change-that-forbade-sync-migraton-with-__gfp_no_kswapd.patch

