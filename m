From: akpm@linux-foundation.org
Subject: +
 mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch added
 to -mm tree
Date: Fri, 04 Apr 2014 13:28:18 -0700
Message-ID: <533f15e2.kGwehc42fTAql6Ho%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaDDU2T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 16:28:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, suleiman@google.com, stable@kernel.org, riel@redhat.com, mgorman@suse.de, hughd@google.com, aquini@redhat.com, hannes@cmpxchg.org

Subject: + mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch added to -mm tree
To: hannes@cmpxchg.org,aquini@redhat.com,hughd@google.com,mgorman@suse.de,riel@redhat.com,stable@kernel.org,suleiman@google.com
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 13:28:18 -0700


The patch titled
     Subject: mm: vmscan: do not swap anon pages just because free+file is low
has been added to the -mm tree.  Its filename is
     mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: vmscan: do not swap anon pages just because free+file is low

Page reclaim force-scans / swaps anonymous pages when file cache drops
below the high watermark of a zone in order to prevent what little cache
remains from thrashing.

However, on bigger machines the high watermark value can be quite large
and when the workload is dominated by a static anonymous/shmem set, the
file set might just be a small window of used-once cache.  In such
situations, the VM starts swapping heavily when instead it should be
recycling the no longer used cache.

This is a longer-standing problem, but it's more likely to trigger after
81c0a2bb515f ("mm: page_alloc: fair zone allocator policy") because file
pages can no longer accumulate in a single zone and are dispersed into
smaller fractions among the available zones.

To resolve this, do not force scan anon when file pages are low but
instead rely on the scan/rotation ratios to make the right prediction.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Suleiman Souhlal <suleiman@google.com>
Cc: <stable@kernel.org>		[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff -puN mm/vmscan.c~mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low mm/vmscan.c
--- a/mm/vmscan.c~mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low
+++ a/mm/vmscan.c
@@ -1862,7 +1862,7 @@ static void get_scan_count(struct lruvec
 	struct zone *zone = lruvec_zone(lruvec);
 	unsigned long anon_prio, file_prio;
 	enum scan_balance scan_balance;
-	unsigned long anon, file, free;
+	unsigned long anon, file;
 	bool force_scan = false;
 	unsigned long ap, fp;
 	enum lru_list lru;
@@ -1916,20 +1916,6 @@ static void get_scan_count(struct lruvec
 		get_lru_size(lruvec, LRU_INACTIVE_FILE);
 
 	/*
-	 * If it's foreseeable that reclaiming the file cache won't be
-	 * enough to get the zone back into a desirable shape, we have
-	 * to swap.  Better start now and leave the - probably heavily
-	 * thrashing - remaining file pages alone.
-	 */
-	if (global_reclaim(sc)) {
-		free = zone_page_state(zone, NR_FREE_PAGES);
-		if (unlikely(file + free <= high_wmark_pages(zone))) {
-			scan_balance = SCAN_ANON;
-			goto out;
-		}
-	}
-
-	/*
 	 * There is enough inactive page cache, do not reclaim
 	 * anything from the anonymous working set right now.
 	 */
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-vmscan-do-not-swap-anon-pages-just-because-freefile-is-low.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-vmallocc-enhance-vm_map_ram-comment.patch
mm-vmallocc-enhance-vm_map_ram-comment-fix.patch
mm-memcg-remove-unnecessary-preemption-disabling.patch
mm-memcg-remove-mem_cgroup_move_account_page_stat.patch
mm-memcg-inline-mem_cgroup_charge_common.patch
mm-memcg-push-mm-handling-out-to-page-cache-charge-function.patch
memcg-remove-unnecessary-mm-check-from-try_get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm.patch
memcg-get_mem_cgroup_from_mm-fix.patch
memcg-do-not-replicate-get_mem_cgroup_from_mm-in-__mem_cgroup_try_charge.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol.patch
memcg-sanitize-__mem_cgroup_try_charge-call-protocol-fix.patch
memcg-rename-high-level-charging-functions.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
linux-next.patch
memcg-slab-never-try-to-merge-memcg-caches.patch
memcg-slab-cleanup-memcg-cache-creation.patch
memcg-slab-separate-memcg-vs-root-cache-creation-paths.patch
memcg-slab-unregister-cache-from-memcg-before-starting-to-destroy-it.patch
memcg-slab-do-not-destroy-children-caches-if-parent-has-aliases.patch
slub-adjust-memcg-caches-when-creating-cache-alias.patch
slub-rework-sysfs-layout-for-memcg-caches.patch
debugging-keep-track-of-page-owners.patch

