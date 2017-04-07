From: akpm@linux-foundation.org
Subject: + mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch added to -mm tree
Date: Fri, 07 Apr 2017 14:31:02 -0700
Message-ID: <58e80516.5r+/rvhg1Z6l7XEl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43114 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754282AbdDGVbD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Apr 2017 17:31:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ying.huang@intel.com, dave.hansen@intel.com, hughd@google.com, mhocko@suse.com, minchan@kernel.org, riel@redhat.com, shli@kernel.org, tim.c.chen@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap: U=use kvzalloc to allocate some swap data structure
has been added to the -mm tree.  Its filename is
     mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

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
Subject: mm, swap: U=use kvzalloc to allocate some swap data structure

Now vzalloc() is used in swap code to allocate various data structures,
such as swap cache, swap slots cache, cluster info, etc.  Because the size
may be too large on some system, so that normal kzalloc() may fail.  But
using kzalloc() has some advantages, for example, less memory
fragmentation, less TLB pressure, etc.  So change the data structure
allocation in swap code to use kvzalloc() which will try kzalloc()
firstly, and fallback to vzalloc() if kzalloc() failed.

In general, although kmalloc() will reduce the number of high-order pages
in short term, vmalloc() will cause more pain for memory fragmentation in
the long term.  And the swap data structure allocation that is changed in
this patch is expected to be long term allocation.  From Dave Hansen: for
example, we have a two-page data structure.  vmalloc() takes two
effectively random order-0 pages, probably from two different 2M pages and
pins them.  That "kills" two 2M pages.  kmalloc(), allocating two
*contiguous* pages, will not cross a 2M boundary.  That means it will only
"kill" the possibility of a single 2M page.  More 2M pages == less
fragmentation.

The allocation in this patch occurs during swap on time, which is usually
done during system boot, so usually we have high opportunity to allocate
the contiguous pages successfully.

The allocation for swap_map[] in struct swap_info_struct is not changed,
because that is usually quite large and vmalloc_to_page() is used for it. 
That makes it a little harder to change.

Link: http://lkml.kernel.org/r/20170407064911.25447-1-ying.huang@intel.com
Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Tim Chen <tim.c.chen@intel.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |   19 +++++++++++--------
 mm/swap_state.c |    2 +-
 mm/swapfile.c   |   10 ++++++----
 3 files changed, 18 insertions(+), 13 deletions(-)

diff -puN mm/swap_slots.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure mm/swap_slots.c
--- a/mm/swap_slots.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure
+++ a/mm/swap_slots.c
@@ -31,6 +31,7 @@
 #include <linux/cpumask.h>
 #include <linux/vmalloc.h>
 #include <linux/mutex.h>
+#include <linux/mm.h>
 
 #ifdef CONFIG_SWAP
 
@@ -119,16 +120,18 @@ static int alloc_swap_slot_cache(unsigne
 
 	/*
 	 * Do allocation outside swap_slots_cache_mutex
-	 * as vzalloc could trigger reclaim and get_swap_page,
+	 * as kvzalloc could trigger reclaim and get_swap_page,
 	 * which can lock swap_slots_cache_mutex.
 	 */
-	slots = vzalloc(sizeof(swp_entry_t) * SWAP_SLOTS_CACHE_SIZE);
+	slots = kvzalloc(sizeof(swp_entry_t) * SWAP_SLOTS_CACHE_SIZE,
+			 GFP_KERNEL);
 	if (!slots)
 		return -ENOMEM;
 
-	slots_ret = vzalloc(sizeof(swp_entry_t) * SWAP_SLOTS_CACHE_SIZE);
+	slots_ret = kvzalloc(sizeof(swp_entry_t) * SWAP_SLOTS_CACHE_SIZE,
+			     GFP_KERNEL);
 	if (!slots_ret) {
-		vfree(slots);
+		kvfree(slots);
 		return -ENOMEM;
 	}
 
@@ -152,9 +155,9 @@ static int alloc_swap_slot_cache(unsigne
 out:
 	mutex_unlock(&swap_slots_cache_mutex);
 	if (slots)
-		vfree(slots);
+		kvfree(slots);
 	if (slots_ret)
-		vfree(slots_ret);
+		kvfree(slots_ret);
 	return 0;
 }
 
@@ -171,7 +174,7 @@ static void drain_slots_cache_cpu(unsign
 		cache->cur = 0;
 		cache->nr = 0;
 		if (free_slots && cache->slots) {
-			vfree(cache->slots);
+			kvfree(cache->slots);
 			cache->slots = NULL;
 		}
 		mutex_unlock(&cache->alloc_lock);
@@ -186,7 +189,7 @@ static void drain_slots_cache_cpu(unsign
 		}
 		spin_unlock_irq(&cache->free_lock);
 		if (slots)
-			vfree(slots);
+			kvfree(slots);
 	}
 }
 
diff -puN mm/swap_state.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure mm/swap_state.c
--- a/mm/swap_state.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure
+++ a/mm/swap_state.c
@@ -523,7 +523,7 @@ int init_swap_address_space(unsigned int
 	unsigned int i, nr;
 
 	nr = DIV_ROUND_UP(nr_pages, SWAP_ADDRESS_SPACE_PAGES);
-	spaces = vzalloc(sizeof(struct address_space) * nr);
+	spaces = kvzalloc(sizeof(struct address_space) * nr, GFP_KERNEL);
 	if (!spaces)
 		return -ENOMEM;
 	for (i = 0; i < nr; i++) {
diff -puN mm/swapfile.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure
+++ a/mm/swapfile.c
@@ -2272,8 +2272,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	free_percpu(p->percpu_cluster);
 	p->percpu_cluster = NULL;
 	vfree(swap_map);
-	vfree(cluster_info);
-	vfree(frontswap_map);
+	kvfree(cluster_info);
+	kvfree(frontswap_map);
 	/* Destroy swap account information */
 	swap_cgroup_swapoff(p->type);
 	exit_swap_address_space(p->type);
@@ -2796,7 +2796,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 		p->cluster_next = 1 + (prandom_u32() % p->highest_bit);
 		nr_cluster = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
 
-		cluster_info = vzalloc(nr_cluster * sizeof(*cluster_info));
+		cluster_info = kvzalloc(nr_cluster * sizeof(*cluster_info),
+					GFP_KERNEL);
 		if (!cluster_info) {
 			error = -ENOMEM;
 			goto bad_swap;
@@ -2829,7 +2830,8 @@ SYSCALL_DEFINE2(swapon, const char __use
 	}
 	/* frontswap enabled? set up bit-per-page map for frontswap */
 	if (IS_ENABLED(CONFIG_FRONTSWAP))
-		frontswap_map = vzalloc(BITS_TO_LONGS(maxpages) * sizeof(long));
+		frontswap_map = kvzalloc(BITS_TO_LONGS(maxpages) * sizeof(long),
+					 GFP_KERNEL);
 
 	if (p->bdev &&(swap_flags & SWAP_FLAG_DISCARD) && swap_discardable(p)) {
 		/*
_

Patches currently in -mm which might be from ying.huang@intel.com are

mm-swap-fix-a-race-in-free_swap_and_cache.patch
mm-swap-fix-comment-in-__read_swap_cache_async.patch
mm-swap-improve-readability-via-make-spin_lock-unlock-balanced.patch
mm-swap-avoid-lock-swap_avail_lock-when-held-cluster-lock.patch
mm-swap-remove-unused-function-prototype.patch
mm-swap-use-kvzalloc-to-allocate-some-swap-data-structure.patch

