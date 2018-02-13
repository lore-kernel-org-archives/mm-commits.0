From: akpm@linux-foundation.org
Subject: + mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch added to -mm tree
Date: Tue, 13 Feb 2018 15:42:26 -0800
Message-ID: <5a8377e2.LmB0+jPxenzmN+Jl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35716 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966064AbeBMXm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 13 Feb 2018 18:42:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, aarcange@redhat.com, aaron.lu@intel.com, dave.jiang@intel.com, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jglisse@redhat.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, paulmck@linux.vnet.ibm.com, riel@redhat.com, rientjes@google.com, shli@fb.com, tim.c.chen@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: Fix race between swapoff and some swap operations
has been added to the -mm tree.  Its filename is
     mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Huang Ying <ying.huang@intel.com>
Subject: mm, swap: Fix race between swapoff and some swap operations

When swapin is performed, after getting the swap entry information from
the page table, system will swap in the swap entry, without any lock held
to prevent the swap device from being swapoff.  This may cause the race
like below,

CPU 1				CPU 2
-----				-----
				do_swap_page
				  swapin_readahead
				    __read_swap_cache_async
swapoff				      swapcache_prepare
  p->swap_map = NULL		        __swap_duplicate
					  p->swap_map[?] /* !!! NULL pointer access */

Because swapoff is usually done when system shutdown only, the race
may not hit many people in practice.  But it is still a race need to
be fixed.

To fix the race, get_swap_device() is added to check whether the
specified swap entry is valid in its swap device.  If so, it will keep
the swap entry valid via preventing the swap device from being
swapoff, until put_swap_device() is called.

Because swapoff() is very rare code path, to make the normal path runs
as fast as possible, disabling preemption + stop_machine() instead of
reference count is used to implement get/put_swap_device().  From
get_swap_device() to put_swap_device(), the preemption is disabled, so
stop_machine() in swapoff() will wait until put_swap_device() is
called.

In addition to swap_map, cluster_info, etc. data structure in the
struct swap_info_struct, the swap cache radix tree will be freed after
swapoff, so this patch fixes the race between swap cache looking up
and swapoff too.

Races between some other swap cache usages protected via disabling
preemption and swapoff are fixed too via calling stop_machine()
between clearing PageSwapCache() and freeing swap cache data
structure.

Link: http://lkml.kernel.org/r/20180213014220.2464-1-ying.huang@intel.com
Signed-off-by: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Shaohua Li <shli@fb.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Aaron Lu <aaron.lu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   13 +++-
 mm/memory.c          |    2 
 mm/swap_state.c      |   16 ++++-
 mm/swapfile.c        |  129 +++++++++++++++++++++++++++++++----------
 4 files changed, 123 insertions(+), 37 deletions(-)

diff -puN include/linux/swap.h~mm-swap-fix-race-between-swapoff-and-some-swap-operations include/linux/swap.h
--- a/include/linux/swap.h~mm-swap-fix-race-between-swapoff-and-some-swap-operations
+++ a/include/linux/swap.h
@@ -172,8 +172,9 @@ enum {
 	SWP_PAGE_DISCARD = (1 << 9),	/* freed swap page-cluster discards */
 	SWP_STABLE_WRITES = (1 << 10),	/* no overwrite PG_writeback pages */
 	SWP_SYNCHRONOUS_IO = (1 << 11),	/* synchronous IO is efficient */
+	SWP_VALID	= (1 << 12),	/* swap is valid to be operated on? */
 					/* add others here before... */
-	SWP_SCANNING	= (1 << 12),	/* refcount in scan_swap_map */
+	SWP_SCANNING	= (1 << 13),	/* refcount in scan_swap_map */
 };
 
 #define SWAP_CLUSTER_MAX 32UL
@@ -470,7 +471,7 @@ extern unsigned int count_swap_pages(int
 extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int page_swapcount(struct page *);
-extern int __swap_count(struct swap_info_struct *si, swp_entry_t entry);
+extern int __swap_count(swp_entry_t entry);
 extern int __swp_swapcount(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 extern struct swap_info_struct *page_swap_info(struct page *);
@@ -480,6 +481,12 @@ extern int try_to_free_swap(struct page
 struct backing_dev_info;
 extern int init_swap_address_space(unsigned int type, unsigned long nr_pages);
 extern void exit_swap_address_space(unsigned int type);
+extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
+
+static inline void put_swap_device(struct swap_info_struct *si)
+{
+	preempt_enable();
+}
 
 #else /* CONFIG_SWAP */
 
@@ -597,7 +604,7 @@ static inline int page_swapcount(struct
 	return 0;
 }
 
-static inline int __swap_count(struct swap_info_struct *si, swp_entry_t entry)
+static inline int __swap_count(swp_entry_t entry)
 {
 	return 0;
 }
diff -puN mm/memory.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations mm/memory.c
--- a/mm/memory.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations
+++ a/mm/memory.c
@@ -2938,7 +2938,7 @@ int do_swap_page(struct vm_fault *vmf)
 		struct swap_info_struct *si = swp_swap_info(entry);
 
 		if (si->flags & SWP_SYNCHRONOUS_IO &&
-				__swap_count(si, entry) == 1) {
+		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, vmf->address);
 			if (page) {
diff -puN mm/swapfile.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations
+++ a/mm/swapfile.c
@@ -38,6 +38,7 @@
 #include <linux/export.h>
 #include <linux/swap_slots.h>
 #include <linux/sort.h>
+#include <linux/stop_machine.h>
 
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
@@ -1107,6 +1108,41 @@ static struct swap_info_struct *swap_inf
 	return p;
 }
 
+/*
+ * Check whether swap entry is valid in the swap device.  If so,
+ * return pointer to swap_info_struct, and keep the swap entry valid
+ * via preventing the swap device from being swapoff, until
+ * put_swap_device() is called.  Otherwise return NULL.
+ */
+struct swap_info_struct *get_swap_device(swp_entry_t entry)
+{
+	struct swap_info_struct *si;
+	unsigned long type, offset;
+
+	if (!entry.val)
+		goto out;
+	type = swp_type(entry);
+	if (type >= nr_swapfiles)
+		goto bad_nofile;
+	si = swap_info[type];
+
+	preempt_disable();
+	if (!(si->flags & SWP_VALID))
+		goto unlock_out;
+	offset = swp_offset(entry);
+	if (offset >= si->max)
+		goto unlock_out;
+
+	return si;
+bad_nofile:
+	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+out:
+	return NULL;
+unlock_out:
+	preempt_enable();
+	return NULL;
+}
+
 static unsigned char __swap_entry_free(struct swap_info_struct *p,
 				       swp_entry_t entry, unsigned char usage)
 {
@@ -1328,11 +1364,18 @@ int page_swapcount(struct page *page)
 	return count;
 }
 
-int __swap_count(struct swap_info_struct *si, swp_entry_t entry)
+int __swap_count(swp_entry_t entry)
 {
+	struct swap_info_struct *si;
 	pgoff_t offset = swp_offset(entry);
+	int count = 0;
 
-	return swap_count(si->swap_map[offset]);
+	si = get_swap_device(entry);
+	if (si) {
+		count = swap_count(si->swap_map[offset]);
+		put_swap_device(si);
+	}
+	return count;
 }
 
 static int swap_swapcount(struct swap_info_struct *si, swp_entry_t entry)
@@ -1357,9 +1400,11 @@ int __swp_swapcount(swp_entry_t entry)
 	int count = 0;
 	struct swap_info_struct *si;
 
-	si = __swap_info_get(entry);
-	if (si)
+	si = get_swap_device(entry);
+	if (si) {
 		count = swap_swapcount(si, entry);
+		put_swap_device(si);
+	}
 	return count;
 }
 
@@ -2451,9 +2496,9 @@ static int swap_node(struct swap_info_st
 	return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
 }
 
-static void _enable_swap_info(struct swap_info_struct *p, int prio,
-				unsigned char *swap_map,
-				struct swap_cluster_info *cluster_info)
+static void setup_swap_info(struct swap_info_struct *p, int prio,
+			    unsigned char *swap_map,
+			    struct swap_cluster_info *cluster_info)
 {
 	int i;
 
@@ -2478,7 +2523,11 @@ static void _enable_swap_info(struct swa
 	}
 	p->swap_map = swap_map;
 	p->cluster_info = cluster_info;
-	p->flags |= SWP_WRITEOK;
+}
+
+static void _enable_swap_info(struct swap_info_struct *p)
+{
+	p->flags |= SWP_WRITEOK | SWP_VALID;
 	atomic_long_add(p->pages, &nr_swap_pages);
 	total_swap_pages += p->pages;
 
@@ -2497,6 +2546,11 @@ static void _enable_swap_info(struct swa
 	add_to_avail_list(p);
 }
 
+static int swap_onoff_stop(void *arg)
+{
+	return 0;
+}
+
 static void enable_swap_info(struct swap_info_struct *p, int prio,
 				unsigned char *swap_map,
 				struct swap_cluster_info *cluster_info,
@@ -2505,7 +2559,17 @@ static void enable_swap_info(struct swap
 	frontswap_init(p->type, frontswap_map);
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
-	 _enable_swap_info(p, prio, swap_map, cluster_info);
+	setup_swap_info(p, prio, swap_map, cluster_info);
+	spin_unlock(&p->lock);
+	spin_unlock(&swap_lock);
+	/*
+	 * Guarantee swap_map, cluster_info, etc. fields are used
+	 * between get/put_swap_device() only if SWP_VALID bit is set
+	 */
+	stop_machine(swap_onoff_stop, NULL, cpu_online_mask);
+	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
+	_enable_swap_info(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
@@ -2514,7 +2578,8 @@ static void reinsert_swap_info(struct sw
 {
 	spin_lock(&swap_lock);
 	spin_lock(&p->lock);
-	_enable_swap_info(p, p->prio, p->swap_map, p->cluster_info);
+	setup_swap_info(p, p->prio, p->swap_map, p->cluster_info);
+	_enable_swap_info(p);
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 }
@@ -2617,6 +2682,17 @@ SYSCALL_DEFINE1(swapoff, const char __us
 
 	reenable_swap_slots_cache_unlock();
 
+	spin_lock(&swap_lock);
+	spin_lock(&p->lock);
+	p->flags &= ~SWP_VALID;		/* mark swap device as invalid */
+	spin_unlock(&p->lock);
+	spin_unlock(&swap_lock);
+	/*
+	 * wait for swap operations protected by get/put_swap_device()
+	 * to complete
+	 */
+	stop_machine(swap_onoff_stop, NULL, cpu_online_mask);
+
 	flush_work(&p->discard_work);
 
 	destroy_swap_extents(p);
@@ -3356,22 +3432,16 @@ static int __swap_duplicate(swp_entry_t
 {
 	struct swap_info_struct *p;
 	struct swap_cluster_info *ci;
-	unsigned long offset, type;
+	unsigned long offset;
 	unsigned char count;
 	unsigned char has_cache;
 	int err = -EINVAL;
 
-	if (non_swap_entry(entry))
+	p = get_swap_device(entry);
+	if (!p)
 		goto out;
 
-	type = swp_type(entry);
-	if (type >= nr_swapfiles)
-		goto bad_file;
-	p = swap_info[type];
 	offset = swp_offset(entry);
-	if (unlikely(offset >= p->max))
-		goto out;
-
 	ci = lock_cluster_or_swap_info(p, offset);
 
 	count = p->swap_map[offset];
@@ -3417,11 +3487,9 @@ static int __swap_duplicate(swp_entry_t
 unlock_out:
 	unlock_cluster_or_swap_info(p, ci);
 out:
+	if (p)
+		put_swap_device(p);
 	return err;
-
-bad_file:
-	pr_err("swap_dup: %s%08lx\n", Bad_file, entry.val);
-	goto out;
 }
 
 /*
@@ -3513,6 +3581,7 @@ int add_swap_count_continuation(swp_entr
 	struct page *list_page;
 	pgoff_t offset;
 	unsigned char count;
+	int ret = 0;
 
 	/*
 	 * When debugging, it's easier to use __GFP_ZERO here; but it's better
@@ -3520,15 +3589,15 @@ int add_swap_count_continuation(swp_entr
 	 */
 	page = alloc_page(gfp_mask | __GFP_HIGHMEM);
 
-	si = swap_info_get(entry);
+	si = get_swap_device(entry);
 	if (!si) {
 		/*
 		 * An acceptable race has occurred since the failing
-		 * __swap_duplicate(): the swap entry has been freed,
-		 * perhaps even the whole swap_map cleared for swapoff.
+		 * __swap_duplicate(): the swap device may be swapoff
 		 */
 		goto outer;
 	}
+	spin_lock(&si->lock);
 
 	offset = swp_offset(entry);
 
@@ -3546,9 +3615,8 @@ int add_swap_count_continuation(swp_entr
 	}
 
 	if (!page) {
-		unlock_cluster(ci);
-		spin_unlock(&si->lock);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
 	/*
@@ -3600,10 +3668,11 @@ out_unlock_cont:
 out:
 	unlock_cluster(ci);
 	spin_unlock(&si->lock);
+	put_swap_device(si);
 outer:
 	if (page)
 		__free_page(page);
-	return 0;
+	return ret;
 }
 
 /*
diff -puN mm/swap_state.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-fix-race-between-swapoff-and-some-swap-operations
+++ a/mm/swap_state.c
@@ -334,8 +334,13 @@ struct page *lookup_swap_cache(swp_entry
 	struct page *page;
 	unsigned long ra_info;
 	int win, hits, readahead;
+	struct swap_info_struct *si;
 
+	si = get_swap_device(entry);
+	if (!si)
+		return NULL;
 	page = find_get_page(swap_address_space(entry), swp_offset(entry));
+	put_swap_device(si);
 
 	INC_CACHE_INFO(find_total);
 	if (page) {
@@ -365,8 +370,8 @@ struct page *__read_swap_cache_async(swp
 			struct vm_area_struct *vma, unsigned long addr,
 			bool *new_page_allocated)
 {
-	struct page *found_page, *new_page = NULL;
-	struct address_space *swapper_space = swap_address_space(entry);
+	struct page *found_page = NULL, *new_page = NULL;
+	struct swap_info_struct *si;
 	int err;
 	*new_page_allocated = false;
 
@@ -376,7 +381,12 @@ struct page *__read_swap_cache_async(swp
 		 * called after lookup_swap_cache() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		found_page = find_get_page(swapper_space, swp_offset(entry));
+		si = get_swap_device(entry);
+		if (!si)
+			break;
+		found_page = find_get_page(swap_address_space(entry),
+					   swp_offset(entry));
+		put_swap_device(si);
 		if (found_page)
 			break;
 
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-race-between-swapoff-and-some-swap-operations.patch

