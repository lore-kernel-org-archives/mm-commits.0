From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch
 removed from -mm tree
Date: Thu, 07 Sep 2017 11:41:52 -0700
Message-ID: <20170907184152.I2RX1_-eL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755748AbdIGSly (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave.hansen@intel.com, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, minchan@kernel.org, mm-commits@vger.kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, ying.huang@intel.com


The patch titled
     Subject: mm, swap: don't use VMA based swap readahead if HDD is used as swap
has been removed from the -mm tree.  Its filename was
     mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: don't use VMA based swap readahead if HDD is used as swap

VMA based swap readahead will readahead the virtual pages that is
continuous in the virtual address space.  While the original swap
readahead will readahead the swap slots that is continuous in the swap
device.  Although VMA based swap readahead is more correct for the swap
slots to be readahead, it will trigger more small random readings, which
may cause the performance of HDD (hard disk) to degrade heavily, and may
finally exceed the benefit.

To avoid the issue, in this patch, if the HDD is used as swap, the VMA
based swap readahead will be disabled, and the original swap readahead
will be used instead.

Link: http://lkml.kernel.org/r/20170807054038.1843-6-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Tim Chen <tim.c.chen@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   11 ++++++-----
 mm/swapfile.c        |    8 +++++++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff -puN include/linux/swap.h~mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap
+++ a/include/linux/swap.h
@@ -400,16 +400,17 @@ extern struct page *do_swap_page_readahe
 					   struct vm_fault *vmf,
 					   struct vma_swap_readahead *swap_ra);
 
-static inline bool swap_use_vma_readahead(void)
-{
-	return READ_ONCE(swap_vma_readahead);
-}
-
 /* linux/mm/swapfile.c */
 extern atomic_long_t nr_swap_pages;
 extern long total_swap_pages;
+extern atomic_t nr_rotate_swap;
 extern bool has_usable_swap(void);
 
+static inline bool swap_use_vma_readahead(void)
+{
+	return READ_ONCE(swap_vma_readahead) && !atomic_read(&nr_rotate_swap);
+}
+
 /* Swap 50% full? Release swapcache more aggressively.. */
 static inline bool vm_swap_full(void)
 {
diff -puN mm/swapfile.c~mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-dont-use-vma-based-swap-readahead-if-hdd-is-used-as-swap
+++ a/mm/swapfile.c
@@ -96,6 +96,8 @@ static DECLARE_WAIT_QUEUE_HEAD(proc_poll
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
+atomic_t nr_rotate_swap = ATOMIC_INIT(0);
+
 static inline unsigned char swap_count(unsigned char ent)
 {
 	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
@@ -2569,6 +2571,9 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
+	if (!p->bdev || !blk_queue_nonrot(bdev_get_queue(p->bdev)))
+		atomic_dec(&nr_rotate_swap);
+
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
@@ -3145,7 +3150,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 			cluster = per_cpu_ptr(p->percpu_cluster, cpu);
 			cluster_set_null(&cluster->index);
 		}
-	}
+	} else
+		atomic_inc(&nr_rotate_swap);
 
 	error = swap_cgroup_swapon(p->type, maxpages);
 	if (error)
_

Patches currently in -mm which might be from ying.huang@intel.com are


