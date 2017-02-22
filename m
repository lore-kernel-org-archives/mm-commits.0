From: akpm@linux-foundation.org
Subject: [folded-merged] mm-swap-add-cluster-lock-v5-fix.patch removed
 from -mm tree
Date: Wed, 22 Feb 2017 15:25:20 -0800
Message-ID: <58ae1de0.38WIYObbOB6pH1Ks%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46386 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933777AbdBVXZp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2017 18:25:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hughd@google.com, tim.c.chen@linux.intel.com, ying.huang@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: swapfile: initialize spinlock for swap_cluster_info
has been removed from the -mm tree.  Its filename was
     mm-swap-add-cluster-lock-v5-fix.patch

This patch was dropped because it was folded into mm-swap-add-cluster-lock.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: swapfile: initialize spinlock for swap_cluster_info

We changed swap_cluster_info lock from bit_spin_lock to spinlock so we
need to initialize the spinlock before the using.  Otherwise, lockdep is
broken.

Link: http://lkml.kernel.org/r/1486434945-29753-1-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-add-cluster-lock-v5-fix
+++ a/mm/swapfile.c
@@ -2591,6 +2591,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 
 	if (p->bdev && blk_queue_nonrot(bdev_get_queue(p->bdev))) {
 		int cpu;
+		unsigned long ci, nr_cluster;
 
 		p->flags |= SWP_SOLIDSTATE;
 		/*
@@ -2598,13 +2599,17 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * SSD
 		 */
 		p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
+		nr_cluster = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
-		cluster_info = vzalloc(DIV_ROUND_UP(maxpages,
-			SWAPFILE_CLUSTER) * sizeof(*cluster_info));
+		cluster_info = vzalloc(nr_cluster * sizeof(*cluster_info));
 		if (!cluster_info) {
 			error = -ENOMEM;
 			goto bad_swap;
 		}
+
+		for (ci = 0; ci < nr_cluster; ci++)
+			spin_lock_init(&((cluster_info + ci)->lock));
+
 		p->percpu_cluster = alloc_percpu(struct percpu_cluster);
 		if (!p->percpu_cluster) {
 			error = -ENOMEM;
_

Patches currently in -mm which might be from minchan@kernel.org are

mm-swap-add-cluster-lock.patch

