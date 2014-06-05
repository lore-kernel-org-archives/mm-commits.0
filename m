From: akpm@linux-foundation.org
Subject: [merged]
 swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch removed from -mm tree
Date: Thu, 05 Jun 2014 12:53:37 -0700
Message-ID: <5390cac1.HEaWx34XYxFBJVkD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaFETxi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2014 15:53:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, shli@kernel.org, hughd@google.com, slaoub@gmail.com

Subject: [merged] swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch removed from -mm tree
To: slaoub@gmail.com,hughd@google.com,shli@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 05 Jun 2014 12:53:37 -0700


The patch titled
     Subject: mm/swapfile.c: delete  the "last_in_cluster < scan_base" loop in the body of scan_swap_map()
has been removed from the -mm tree.  Its filename was
     swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Chen Yucong <slaoub@gmail.com>
Subject: mm/swapfile.c: delete  the "last_in_cluster < scan_base" loop in the body of scan_swap_map()

Via ebc2a1a69111 ("swap: make cluster allocation per-cpu"), we can find
that all SWP_SOLIDSTATE "seek is cheap"(SSD case) has already gone to
si->cluster_info scan_swap_map_try_ssd_cluster() route.  So that the
"last_in_cluster < scan_base" loop in the body of scan_swap_map() has
already become a dead code snippet, and it should have been deleted.

This patch is to delete the redundant loop as Hugh and Shaohua suggested.

[hughd@google.com: fix comment, simplify code]
Signed-off-by: Chen Yucong <slaoub@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   29 +++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff -puN mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map mm/swapfile.c
--- a/mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map
+++ a/mm/swapfile.c
@@ -523,13 +523,10 @@ static unsigned long scan_swap_map(struc
 		/*
 		 * If seek is expensive, start searching for new cluster from
 		 * start of partition, to minimize the span of allocated swap.
-		 * But if seek is cheap, search from our current position, so
-		 * that swap is allocated from all over the partition: if the
-		 * Flash Translation Layer only remaps within limited zones,
-		 * we don't want to wear out the first zone too quickly.
+		 * If seek is cheap, that is the SWP_SOLIDSTATE si->cluster_info
+		 * case, just handled by scan_swap_map_try_ssd_cluster() above.
 		 */
-		if (!(si->flags & SWP_SOLIDSTATE))
-			scan_base = offset = si->lowest_bit;
+		scan_base = offset = si->lowest_bit;
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
@@ -537,26 +534,6 @@ static unsigned long scan_swap_map(struc
 			if (si->swap_map[offset])
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
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
-
-		offset = si->lowest_bit;
-		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
