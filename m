From: akpm@linux-foundation.org
Subject: [merged] swap-fix-races-exposed-by-swap-discard.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:42:41 -0700
Message-ID: <52321931.QXJqHXAjs4jH5XKC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58028 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab3ILTmm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:42:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@fusionio.com, riel@redhat.com, minchan@kernel.org, kmpark@infradead.org, hughd@google.com, aquini@redhat.com, shli@kernel.org

Subject: [merged] swap-fix-races-exposed-by-swap-discard.patch removed from -mm tree
To: shli@kernel.org,aquini@redhat.com,hughd@google.com,kmpark@infradead.org,minchan@kernel.org,riel@redhat.com,shli@fusionio.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:42:41 -0700


The patch titled
     Subject: swap: fix races exposed by swap discard
has been removed from the -mm tree.  Its filename was
     swap-fix-races-exposed-by-swap-discard.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shaohua Li <shli@kernel.org>
Subject: swap: fix races exposed by swap discard

Last patch can expose races, according to Hugh:

swapoff was sometimes failing with "Cannot allocate memory", coming from
try_to_unuse()'s -ENOMEM: it needs to allow for swap_duplicate() failing
on a free entry temporarily SWAP_MAP_BAD while being discarded.

We should use ACCESS_ONCE() there, and whenever accessing swap_map
locklessly; but rather than peppering it throughout try_to_unuse(), just
declare *swap_map with volatile.

try_to_unuse() is accustomed to *swap_map going down racily, but not
necessarily to it jumping up from 0 to SWAP_MAP_BAD: we'll be safer to
prevent that transition once SWP_WRITEOK is switched off, when it's a
waste of time to issue discards anyway (swapon can do a whole discard).

Another issue is:

In swapin_readahead(), read_swap_cache_async() can read a bad swap entry,
because we don't check if readahead swap entry is bad.  This doesn't break
anything but such swapin page is wasteful and can only be freed at page
reclaim.  We should avoid read such swap entry.  And in discard, we mark
swap entry SWAP_MAP_BAD and then switch it to normal when discard is
finished.  If readahead reads such swap entry, we have the same issue, so
we much check if swap entry is bad too.

Thanks Hugh to inspire swapin_readahead could use bad swap entry.

[include Hugh's patch 'swap: fix swapoff ENOMEMs from discard']
Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Kyungmin Park <kmpark@infradead.org>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swap-fix-races-exposed-by-swap-discard mm/swapfile.c
--- a/mm/swapfile.c~swap-fix-races-exposed-by-swap-discard
+++ a/mm/swapfile.c
@@ -370,7 +370,8 @@ static void dec_cluster_info_page(struct
 		 * instead of free it immediately. The cluster will be freed
 		 * after discard.
 		 */
-		if (p->flags & SWP_PAGE_DISCARD) {
+		if ((p->flags & (SWP_WRITEOK | SWP_PAGE_DISCARD)) ==
+				 (SWP_WRITEOK | SWP_PAGE_DISCARD)) {
 			swap_cluster_schedule_discard(p, idx);
 			return;
 		}
@@ -1288,7 +1289,7 @@ static unsigned int find_next_to_unuse(s
 			else
 				continue;
 		}
-		count = si->swap_map[i];
+		count = ACCESS_ONCE(si->swap_map[i]);
 		if (count && swap_count(count) != SWAP_MAP_BAD)
 			break;
 	}
@@ -1308,7 +1309,11 @@ int try_to_unuse(unsigned int type, bool
 {
 	struct swap_info_struct *si = swap_info[type];
 	struct mm_struct *start_mm;
-	unsigned char *swap_map;
+	volatile unsigned char *swap_map; /* swap_map is accessed without
+					   * locking. Mark it as volatile
+					   * to prevent compiler doing
+					   * something odd.
+					   */
 	unsigned char swcount;
 	struct page *page;
 	swp_entry_t entry;
@@ -1359,7 +1364,15 @@ int try_to_unuse(unsigned int type, bool
 			 * reused since sys_swapoff() already disabled
 			 * allocation from here, or alloc_page() failed.
 			 */
-			if (!*swap_map)
+			swcount = *swap_map;
+			/*
+			 * We don't hold lock here, so the swap entry could be
+			 * SWAP_MAP_BAD (when the cluster is discarding).
+			 * Instead of fail out, We can just skip the swap
+			 * entry because swapoff will wait for discarding
+			 * finish anyway.
+			 */
+			if (!swcount || swcount == SWAP_MAP_BAD)
 				continue;
 			retval = -ENOMEM;
 			break;
@@ -2543,6 +2556,16 @@ static int __swap_duplicate(swp_entry_t
 		goto unlock_out;
 
 	count = p->swap_map[offset];
+
+	/*
+	 * swapin_readahead() doesn't check if a swap entry is valid, so the
+	 * swap entry could be SWAP_MAP_BAD. Check here with lock held.
+	 */
+	if (unlikely(swap_count(count) == SWAP_MAP_BAD)) {
+		err = -ENOENT;
+		goto unlock_out;
+	}
+
 	has_cache = count & SWAP_HAS_CACHE;
 	count &= ~SWAP_HAS_CACHE;
 	err = 0;
_

Patches currently in -mm which might be from shli@kernel.org are

origin.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch

