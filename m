From: akpm@linux-foundation.org
Subject: + swapfile-vmscan-update-comments-related-to-vmscan-functions.patch added to -mm tree
Date: Tue, 29 Jul 2008 15:31:20 -0700
Message-ID: <200807292231.m6TMVKlE025249@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59807 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755391AbYG2WcP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 18:32:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fernando@oss.ntt.co.jp, hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     swapfile/vmscan: update comments related to vmscan functions
has been added to the -mm tree.  Its filename is
     swapfile-vmscan-update-comments-related-to-vmscan-functions.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

madvise-update-function-comment-of-madvise_dontneed.patch
swap-update-function-comment-of-release_pages.patch
swapfile-vmscan-update-comments-related-to-vmscan-functions.patch
do_try_to_free_page-update-comments-related-to-vmscan-functions.patch

