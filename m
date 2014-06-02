From: akpm@linux-foundation.org
Subject: +
 swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch added to -mm tree
Date: Mon, 02 Jun 2014 13:50:08 -0700
Message-ID: <538ce380.rXKfbhg3K5ez1cip%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41241 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaFBUuJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 16:50:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, hughd@google.com, slaoub@gmail.com

Subject: + swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch added to -mm tree
To: slaoub@gmail.com,hughd@google.com,shli@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 13:50:08 -0700


The patch titled
     Subject: mm/swapfile.c: delete  the "last_in_cluster < scan_base" loop in the body of scan_swap_map()
has been added to the -mm tree.  Its filename is
     swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm/swapfile.c: delete  the "last_in_cluster < scan_base" loop in the body of scan_swap_map()

Via ebc2a1a69111 ("swap: make cluster allocation per-cpu"), we can find
that all SWP_SOLIDSTATE "seek is cheap"(SSD case) has already gone to
si->cluster_info scan_swap_map_try_ssd_cluster() route.  So that the
"last_in_cluster < scan_base" loop in the body of scan_swap_map() has
already become a dead code snippet, and it should have been deleted.

This patch is to delete the redundant loop as Hugh and Shaohua suggested.

Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   20 --------------------
 1 file changed, 20 deletions(-)

diff -puN mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map mm/swapfile.c
--- a/mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map
+++ a/mm/swapfile.c
@@ -549,26 +549,6 @@ static unsigned long scan_swap_map(struc
 			}
 		}
 
-		offset = si->lowest_bit;
-		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
-
-		/* Locate the first empty (unaligned) cluster */
-		for (; last_in_cluster < scan_base; offset++) {
-			if (si->swap_map[offset])
-				last_in_cluster = offset + SWAPFILE_CLUSTER;
-			else if (offset == last_in_cluster) {
-				spin_lock(&si->lock);
-				offset -= SWAPFILE_CLUSTER - 1;
-				si->cluster_next = offset;
-				si->cluster_nr = SWAPFILE_CLUSTER - 1;
-				goto checks;
-			}
-			if (unlikely(--latency_ration < 0)) {
-				cond_resched();
-				latency_ration = LATENCY_LIMIT;
-			}
-		}
