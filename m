From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 073/128] swap: reduce lock contention on swap
 cache from swap slots allocation
Date: Tue, 02 Jun 2020 13:14:10 -0700
Message-ID: <20200602201410.lnAbITXlG%akpm@linux-foundation.org>
References: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgFBUOM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Jun 2020 16:14:12 -0400
In-Reply-To: <20200602130930.8e8f10fa6f19e3766e70921f@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, daniel.m.jordan@oracle.com, hughd@google.com, linux-mm@kvack.org, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com, torvalds@linux-foundation.org, ying.huang@intel.com

From: Huang Ying <ying.huang@intel.com>
Subject: swap: reduce lock contention on swap cache from swap slots allocation

In some swap scalability test, it is found that there are heavy lock
contention on swap cache even if we have split one swap cache radix tree
per swap device to one swap cache radix tree every 64 MB trunk in commit
4b3ef9daa4fc ("mm/swap: split swap cache into 64MB trunks").

The reason is as follow.  After the swap device becomes fragmented so that
there's no free swap cluster, the swap device will be scanned linearly to
find the free swap slots.  swap_info_struct->cluster_next is the next
scanning base that is shared by all CPUs.  So nearby free swap slots will
be allocated for different CPUs.  The probability for multiple CPUs to
operate on the same 64 MB trunk is high.  This causes the lock contention
on the swap cache.

To solve the issue, in this patch, for SSD swap device, a percpu version
next scanning base (cluster_next_cpu) is added.  Every CPU will use its
own per-cpu next scanning base.  And after finishing scanning a 64MB
trunk, the per-cpu scanning base will be changed to the beginning of
another randomly selected 64MB trunk.  In this way, the probability for
multiple CPUs to operate on the same 64 MB trunk is reduced greatly.  Thus
the lock contention is reduced too.  For HDD, because sequential access is
more important for IO performance, the original shared next scanning base
is used.

To test the patch, we have run 16-process pmbench memory benchmark on a
2-socket server machine with 48 cores.  One ram disk is configured as the
swap device per socket.  The pmbench working-set size is much larger than
the available memory so that swapping is triggered.  The memory read/write
ratio is 80/20 and the accessing pattern is random.  In the original
implementation, the lock contention on the swap cache is heavy.  The perf
profiling data of the lock contention code path is as following,

_raw_spin_lock_irq.add_to_swap_cache.add_to_swap.shrink_page_list:      7.91
_raw_spin_lock_irqsave.__remove_mapping.shrink_page_list:               7.11
_raw_spin_lock.swapcache_free_entries.free_swap_slot.__swap_entry_free: 2.51
_raw_spin_lock_irqsave.swap_cgroup_record.mem_cgroup_uncharge_swap:     1.66
_raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node:      1.29
_raw_spin_lock.free_pcppages_bulk.drain_pages_zone.drain_pages:         1.03
_raw_spin_lock_irq.shrink_active_list.shrink_lruvec.shrink_node:        0.93

After applying this patch, it becomes,

_raw_spin_lock.swapcache_free_entries.free_swap_slot.__swap_entry_free: 3.58
_raw_spin_lock_irq.shrink_inactive_list.shrink_lruvec.shrink_node:      2.3
_raw_spin_lock_irqsave.swap_cgroup_record.mem_cgroup_uncharge_swap:     2.26
_raw_spin_lock_irq.shrink_active_list.shrink_lruvec.shrink_node:        1.8
_raw_spin_lock.free_pcppages_bulk.drain_pages_zone.drain_pages:         1.19

The lock contention on the swap cache is almost eliminated.

And the pmbench score increases 18.5%.  The swapin throughput increases
18.7% from 2.96 GB/s to 3.51 GB/s.  While the swapout throughput increases
18.5% from 2.99 GB/s to 3.54 GB/s.

We need really fast disk to show the benefit.  I have tried this on 2
Intel P3600 NVMe disks.  The performance improvement is only about 1%. 
The improvement should be better on the faster disks, such as Intel Optane
disk.

[ying.huang@intel.com: fix cluster_next_cpu allocation and freeing, per Daniel]
  Link: http://lkml.kernel.org/r/20200525002648.336325-1-ying.huang@intel.com
[ying.huang@intel.com: v4]
  Link: http://lkml.kernel.org/r/20200529010840.928819-1-ying.huang@intel.com
Link: http://lkml.kernel.org/r/20200520031502.175659-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swapfile.c        |   61 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 5 deletions(-)

--- a/include/linux/swap.h~swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation
+++ a/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	unsigned int inuse_pages;	/* number of those currently in use */
 	unsigned int cluster_next;	/* likely index for next allocation */
 	unsigned int cluster_nr;	/* countdown to next cluster search */
+	unsigned int __percpu *cluster_next_cpu; /*percpu index for next allocation */
 	struct percpu_cluster __percpu *percpu_cluster; /* per cpu's swap location */
 	struct rb_root swap_extent_root;/* root of the swap extent rbtree */
 	struct block_device *bdev;	/* swap device or bdev of swap file */
--- a/mm/swapfile.c~swap-reduce-lock-contention-on-swap-cache-from-swap-slots-allocation
+++ a/mm/swapfile.c
@@ -613,10 +613,12 @@ new_cluster:
 		} else if (!cluster_list_empty(&si->discard_clusters)) {
 			/*
 			 * we don't have free cluster but have some clusters in
-			 * discarding, do discard now and reclaim them
+			 * discarding, do discard now and reclaim them, then
+			 * reread cluster_next_cpu since we dropped si->lock
 			 */
 			swap_do_scheduled_discard(si);
-			*scan_base = *offset = si->cluster_next;
+			*scan_base = this_cpu_read(*si->cluster_next_cpu);
+			*offset = *scan_base;
 			goto new_cluster;
 		} else
 			return false;
@@ -722,6 +724,34 @@ static void swap_range_free(struct swap_
 	}
 }
 
+static void set_cluster_next(struct swap_info_struct *si, unsigned long next)
+{
+	unsigned long prev;
+
+	if (!(si->flags & SWP_SOLIDSTATE)) {
+		si->cluster_next = next;
+		return;
+	}
+
+	prev = this_cpu_read(*si->cluster_next_cpu);
+	/*
+	 * Cross the swap address space size aligned trunk, choose
+	 * another trunk randomly to avoid lock contention on swap
+	 * address space if possible.
+	 */
+	if ((prev >> SWAP_ADDRESS_SPACE_SHIFT) !=
+	    (next >> SWAP_ADDRESS_SPACE_SHIFT)) {
+		/* No free swap slots available */
+		if (si->highest_bit <= si->lowest_bit)
+			return;
+		next = si->lowest_bit +
+			prandom_u32_max(si->highest_bit - si->lowest_bit + 1);
+		next = ALIGN_DOWN(next, SWAP_ADDRESS_SPACE_PAGES);
+		next = max_t(unsigned int, next, si->lowest_bit);
+	}
+	this_cpu_write(*si->cluster_next_cpu, next);
+}
+
 static int scan_swap_map_slots(struct swap_info_struct *si,
 			       unsigned char usage, int nr,
 			       swp_entry_t slots[])
@@ -746,7 +776,16 @@ static int scan_swap_map_slots(struct sw
 	 */
 
 	si->flags += SWP_SCANNING;
-	scan_base = offset = si->cluster_next;
+	/*
+	 * Use percpu scan base for SSD to reduce lock contention on
+	 * cluster and swap cache.  For HDD, sequential access is more
+	 * important.
+	 */
+	if (si->flags & SWP_SOLIDSTATE)
+		scan_base = this_cpu_read(*si->cluster_next_cpu);
+	else
+		scan_base = si->cluster_next;
+	offset = scan_base;
 
 	/* SSD algorithm */
 	if (si->cluster_info) {
@@ -835,7 +874,6 @@ checks:
 	unlock_cluster(ci);
 
 	swap_range_alloc(si, offset, 1);
-	si->cluster_next = offset + 1;
 	slots[n_ret++] = swp_entry(si->type, offset);
 
 	/* got enough slots or reach max slots? */
@@ -884,6 +922,7 @@ checks:
 	}
 
 done:
+	set_cluster_next(si, offset + 1);
 	si->flags -= SWP_SCANNING;
 	return n_ret;
 
@@ -2653,6 +2692,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	mutex_unlock(&swapon_mutex);
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	free_percpu(p->cluster_next_cpu);
+	p->cluster_next_cpu = NULL;
 	vfree(swap_map);
 	kvfree(cluster_info);
 	kvfree(frontswap_map);
@@ -3205,11 +3246,19 @@ SYSCALL_DEFINE2(swapon, const char __use
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
 		 */
-		p->cluster_next = 1 + prandom_u32_max(p->highest_bit);
+		for_each_possible_cpu(cpu) {
+			per_cpu(*p->cluster_next_cpu, cpu) =
+				1 + prandom_u32_max(p->highest_bit);
+		}
 		nr_cluster = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
 		cluster_info = kvcalloc(nr_cluster, sizeof(*cluster_info),
@@ -3325,6 +3374,8 @@ bad_swap_unlock_inode:
 bad_swap:
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
+	free_percpu(p->cluster_next_cpu);
+	p->cluster_next_cpu = NULL;
 	if (inode && S_ISBLK(inode->i_mode) && p->bdev) {
 		set_blocksize(p->bdev, p->old_block_size);
 		blkdev_put(p->bdev, FMODE_READ | FMODE_WRITE | FMODE_EXCL);
_
