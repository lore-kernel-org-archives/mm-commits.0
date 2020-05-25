From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?swap-reduce-lock-contention-on-swap-cache-from-swap-slots?=
 =?US-ASCII?Q?-allocation-v3.patch?= added to -mm tree
Date: Sun, 24 May 2020 17:57:17 -0700
Message-ID: <20200525005717.WBPtMX7St%akpm@linux-foundation.org>
References: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388294AbgEYA5T (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 24 May 2020 20:57:19 -0400
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: daniel.m.jordan@oracle.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, ying.huang@intel.com


The patch titled
     Subject: swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3
has been added to the -mm tree.  Its filename is
     swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation-v3.patch
proc-pid-smaps-add-pmd-migration-entry-parsing.patch
