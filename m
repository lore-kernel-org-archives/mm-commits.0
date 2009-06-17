From: akpm@linux-foundation.org
Subject: [merged] mm-reuse-unused-swap-entry-if-necessary.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:35:53 -0700
Message-ID: <200906171835.n5HIZr4F001918@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758108AbZFQS4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, dhaval@linux.vnet.ibm.com, hannes@cmpxchg.org, hugh.dickins@tiscali.co.uk, lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, yamamot


The patch titled
     mm: reuse unused swap entry if necessary
has been removed from the -mm tree.  Its filename was
     mm-reuse-unused-swap-entry-if-necessary.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: reuse unused swap entry if necessary
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently we can know a swap entry is just used as SwapCache via swap_map,
without looking up swap cache.

Then, we have a chance to reuse swap-cache-only swap entries in
get_swap_pages().

This patch tries to free swap-cache-only swap entries if swap is not
enough.

Note: We hit following path when swap_cluster code cannot find a free
cluster.  Then, vm_swap_full() is not only condition to allow the kernel
to reclaim unused swap.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Balbir Singh <balbir@in.ibm.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Tested-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff -puN mm/swapfile.c~mm-reuse-unused-swap-entry-if-necessary mm/swapfile.c
--- a/mm/swapfile.c~mm-reuse-unused-swap-entry-if-necessary
+++ a/mm/swapfile.c
@@ -79,6 +79,32 @@ static inline unsigned short encode_swap
 	return ret;
 }
 
+/* returnes 1 if swap entry is freed */
+static int
+__try_to_reclaim_swap(struct swap_info_struct *si, unsigned long offset)
+{
+	int type = si - swap_info;
+	swp_entry_t entry = swp_entry(type, offset);
+	struct page *page;
+	int ret = 0;
+
+	page = find_get_page(&swapper_space, entry.val);
+	if (!page)
+		return 0;
+	/*
+	 * This function is called from scan_swap_map() and it's called
+	 * by vmscan.c at reclaiming pages. So, we hold a lock on a page, here.
+	 * We have to use trylock for avoiding deadlock. This is a special
+	 * case and you should use try_to_free_swap() with explicit lock_page()
+	 * in usual operations.
+	 */
+	if (trylock_page(page)) {
+		ret = try_to_free_swap(page);
+		unlock_page(page);
+	}
+	page_cache_release(page);
+	return ret;
+}
 
 /*
  * We need this because the bdev->unplug_fn can sleep and we cannot
@@ -301,6 +327,19 @@ checks:
 		goto no_page;
 	if (offset > si->highest_bit)
 		scan_base = offset = si->lowest_bit;
+
+	/* reuse swap entry of cache-only swap if not busy. */
+	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+		int swap_was_freed;
+		spin_unlock(&swap_lock);
+		swap_was_freed = __try_to_reclaim_swap(si, offset);
+		spin_lock(&swap_lock);
+		/* entry was freed successfully, try to use this again */
+		if (swap_was_freed)
+			goto checks;
+		goto scan; /* check next one */
+	}
+
 	if (si->swap_map[offset])
 		goto scan;
 
@@ -382,6 +421,10 @@ scan:
 			spin_lock(&swap_lock);
 			goto checks;
 		}
+		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+			spin_lock(&swap_lock);
+			goto checks;
+		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
@@ -393,6 +436,10 @@ scan:
 			spin_lock(&swap_lock);
 			goto checks;
 		}
+		if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
+			spin_lock(&swap_lock);
+			goto checks;
+		}
 		if (unlikely(--latency_ration < 0)) {
 			cond_resched();
 			latency_ration = LATENCY_LIMIT;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix2.patch
memcg-add-file-based-rss-accounting.patch
memcg-add-file-based-rss-accounting-fix-mem_cgroup_update_mapped_file_stat-oops.patch
memcg-remove-mem_cgroup_cache_charge_swapin.patch
memcg-remove-some-redundant-checks.patch
memcg-remove-unneeded-forward-declaration-from-schedh.patch
memcg-fix-swap-accounting.patch
memcg-fix-swap-accounting-update.patch
memcg-fix-behavior-under-memorylimit-equals-to-memswlimit.patch
memcg-add-interface-to-reset-limits.patch
memcg-fix-lru-rotation-in-isolate_pages.patch
elf-reduce-default-max_map_count-to-be-safe-value.patch

