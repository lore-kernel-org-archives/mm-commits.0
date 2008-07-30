From: akpm@linux-foundation.org
Subject: - swapfile-vmscan-update-comments-related-to-vmscan-functions.patch removed from -mm tree
Date: Wed, 30 Jul 2008 12:15:10 -0700
Message-ID: <200807301915.m6UJFANN010981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755997AbYG3T3Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Jul 2008 15:29:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swapfile/vmscan: update comments related to vmscan functions
has been removed from the -mm tree.  Its filename was
     swapfile-vmscan-update-comments-related-to-vmscan-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile/vmscan: update comments related to vmscan functions
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 ++--
 mm/vmscan.c   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/swapfile.c~swapfile-vmscan-update-comments-related-to-vmscan-functions mm/swapfile.c
--- a/mm/swapfile.c~swapfile-vmscan-update-comments-related-to-vmscan-functions
+++ a/mm/swapfile.c
@@ -656,8 +656,8 @@ static int unuse_mm(struct mm_struct *mm
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		/*
-		 * Activate page so shrink_cache is unlikely to unmap its
-		 * ptes while lock is dropped, so swapoff can make progress.
+		 * Activate page so shrink_inactive_list is unlikely to unmap
+		 * its ptes while lock is dropped, so swapoff can make progress.
 		 */
 		activate_page(page);
 		unlock_page(page);
diff -puN mm/vmscan.c~swapfile-vmscan-update-comments-related-to-vmscan-functions mm/vmscan.c
--- a/mm/vmscan.c~swapfile-vmscan-update-comments-related-to-vmscan-functions
+++ a/mm/vmscan.c
@@ -1979,7 +1979,7 @@ module_init(kswapd_init)
 int zone_reclaim_mode __read_mostly;
 
 #define RECLAIM_OFF 0
-#define RECLAIM_ZONE (1<<0)	/* Run shrink_cache on the zone */
+#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
 #define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
 
_

Patches currently in -mm which might be from fernando@oss.ntt.co.jp are

origin.patch

