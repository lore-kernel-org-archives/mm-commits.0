From: akpm@linux-foundation.org
Subject: [folded-merged]
 =?US-ASCII?Q?swap-reduce-lock-contention-on-swap-cache-from-swap-slots?=
 =?US-ASCII?Q?-allocation-v3.patch?= removed from -mm tree
Date: Mon, 01 Jun 2020 21:17:58 -0700
Message-ID: <20200602041758.L5LBlo2I5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgFBER7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 00:17:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3
has been removed from the -mm tree.  Its filename was
     swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3.patch

This patch was dropped because it was folded into swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation.patch

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3

fix cluster_next_cpu allocation and freeing, per Daniel

Link: http://lkml.kernel.org/r/20200525002648.336325-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/swapfile.c~swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3
+++ a/mm/swapfile.c
@@ -2691,6 +2691,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	free_percpu(p->cluster_next_cpu);
+	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
 	kvfree(cluster_info);
 	kvfree(frontswap_map);
@@ -2872,11 +2874,6 @@ static struct swap_info_struct *alloc_sw
 	p = kvzalloc(struct_size(p, avail_lists, nr_node_ids), GFP_KERNEL);
 	if (!p)
 		return ERR_PTR(-ENOMEM);
-	p->cluster_next_cpu = alloc_percpu(unsigned int);
-	if (!p->cluster_next_cpu) {
-		kvfree(p);
-		return ERR_PTR(-ENOMEM);
-	}
 
 	spin_lock(&swap_lock);
 	for (type = 0; type < nr_swapfiles; type++) {
@@ -3248,6 +3245,11 @@ SYSCALL_DEFINE2(swapon, const char __use
 		unsigned long ci, nr_cluster;
 
 		p->flags |= SWP_SOLIDSTATE;
+		p->cluster_next_cpu = alloc_percpu(unsigned int);
+		if (!p->cluster_next_cpu) {
+			error = -ENOMEM;
+			goto bad_swap_unlock_inode;
+		}
 		/*
 		 * select a random position to start with to help wear leveling
 		 * SSD
@@ -3371,6 +3373,8 @@ bad_swap_unlock_inode:
 bad_swap:
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	free_percpu(p->cluster_next_cpu);
+	p->cluster_next_cpu = NULL;
 	if (inode && S_ISBLK(inode->i_mode) && p->bdev) {
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
_

Patches currently in -mm which might be from ying.huang@intel.com are

swap-try-to-scan-more-free-slots-even-when-fragmented.patch
mm-swap-use-prandom_u32_max.patch
swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation.patch
swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v4.patch
proc-pid-smaps-add-pmd-migration-entry-parsing.patch
