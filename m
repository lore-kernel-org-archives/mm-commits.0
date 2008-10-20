From: akpm@linux-foundation.org
Subject: - vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:32:44 -0700
Message-ID: <200810202032.m9KKWib9010466@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753294AbYJTUdj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:33:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     vmscan: add newly swapped in pages to the inactive list
has been removed from the -mm tree.  Its filename was
     vmscan-add-newly-swapped-in-pages-to-the-inactive-list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmscan: add newly swapped in pages to the inactive list
From: Rik van Riel <riel@redhat.com>

Swapin_readahead can read in a lot of data that the processes in memory
never need.  Adding swap cache pages to the inactive list prevents them
from putting too much pressure on the working set.

This has the potential to help the programs that are already in memory,
but it could also be a disadvantage to processes that are trying to get
swapped in.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swap_state.c~vmscan-add-newly-swapped-in-pages-to-the-inactive-list mm/swap_state.c
--- a/mm/swap_state.c~vmscan-add-newly-swapped-in-pages-to-the-inactive-list
+++ a/mm/swap_state.c
@@ -310,7 +310,7 @@ struct page *read_swap_cache_async(swp_e
 			/*
 			 * Initiate read into locked page and return.
 			 */
-			lru_cache_add_active_anon(new_page);
+			lru_cache_add_anon(new_page);
 			swap_readpage(NULL, new_page);
 			return new_page;
 		}
_

Patches currently in -mm which might be from riel@redhat.com are

origin.patch
linux-next.patch

