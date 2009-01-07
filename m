From: akpm@linux-foundation.org
Subject: - swapfile-swap-allocation-cycle-if-nonrot.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:33 -0800
Message-ID: <200901072213.n07MDXFm013625@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758513AbZAGWN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx


The patch titled
     swapfile: swap allocation cycle if nonrot
has been removed from the -mm tree.  Its filename was
     swapfile-swap-allocation-cycle-if-nonrot.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: swap allocation cycle if nonrot
From: Hugh Dickins <hugh@veritas.com>

Though attempting to find free clusters (Andrea), swap allocation has
always restarted its searches from the beginning of the swap area (sct),
to reduce seek times between swap pages, by not scattering them all over
the partition.

But on a solidstate swap device, seeks are cheap, and block remapping to
level the wear may be limited by zones: in that case it's better to cycle
around the whole partition.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Joern Engel <joern@logfs.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Donjun Shin <djshin90@gmail.com>
Cc: Tejun Heo <teheo@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   50 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff -puN mm/swapfile.c~swapfile-swap-allocation-cycle-if-nonrot mm/swapfile.c
--- a/mm/swapfile.c~swapfile-swap-allocation-cycle-if-nonrot
+++ a/mm/swapfile.c
@@ -169,6 +169,7 @@ static int wait_for_discard(void *word)
 static inline unsigned long scan_swap_map(struct swap_info_struct *si)
 {
 	unsigned long offset;
+	unsigned long scan_base;
 	unsigned long last_in_cluster = 0;
 	int latency_ration = LATENCY_LIMIT;
 	int found_free_cluster = 0;
@@ -181,10 +182,11 @@ static inline unsigned long scan_swap_ma
 	 * all over the entire swap partition, so that we reduce
 	 * overall disk seek times between swap pages.  -- sct
 	 * But we do now try to find an empty cluster.  -Andrea
+	 * And we let swap pages go all over an SSD partition.  Hugh
 	 */
 
 	si->flags += SWP_SCANNING;
-	offset = si->cluster_next;
+	scan_base = offset = si->cluster_next;
 
 	if (unlikely(!si->cluster_nr--)) {
 		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER) {
@@ -206,7 +208,16 @@ static inline unsigned long scan_swap_ma
 		}
 		spin_unlock(&swap_lock);
 
-		offset = si->lowest_bit;
+		/*
+		 * If seek is expensive, start searching for new cluster from
+		 * start of partition, to minimize the span of allocated swap.
+		 * But if seek is cheap, search from our current position, so
+		 * that swap is allocated from all over the partition: if the
+		 * Flash Translation Layer only remaps within limited zones,
+		 * we don't want to wear out the first zone too quickly.
+		 */
+		if (!(si->flags & SWP_SOLIDSTATE))
+			scan_base = offset = si->lowest_bit;
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
@@ -228,6 +239,27 @@ static inline unsigned long scan_swap_ma
 		}
 
 		offset = si->lowest_bit;
+		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
+
+		/* Locate the first empty (unaligned) cluster */
+		for (; last_in_cluster < scan_base; offset++) {
+			if (si->swap_map[offset])
+				last_in_cluster = offset + SWAPFILE_CLUSTER;
+			else if (offset == last_in_cluster) {
+				spin_lock(&swap_lock);
+				offset -= SWAPFILE_CLUSTER - 1;
+				si->cluster_next = offset;
+				si->cluster_nr = SWAPFILE_CLUSTER - 1;
+				found_free_cluster = 1;
+				goto checks;
+			}
+			if (unlikely(--latency_ration < 0)) {
+				cond_resched();
+				latency_ration = LATENCY_LIMIT;
+			}
+		}
+
+		offset = scan_base;
 		spin_lock(&swap_lock);
 		si->cluster_nr = SWAPFILE_CLUSTER - 1;
 		si->lowest_alloc = 0;
@@ -239,7 +271,7 @@ checks:
 	if (!si->highest_bit)
 		goto no_page;
 	if (offset > si->highest_bit)
-		offset = si->lowest_bit;
+		scan_base = offset = si->lowest_bit;
 	if (si->swap_map[offset])
 		goto scan;
 
@@ -323,8 +355,18 @@ scan:
 			latency_ration = LATENCY_LIMIT;
 		}
 	}
+	offset = si->lowest_bit;
+	while (++offset < scan_base) {
+		if (!si->swap_map[offset]) {
+			spin_lock(&swap_lock);
+			goto checks;
+		}
+		if (unlikely(--latency_ration < 0)) {
+			cond_resched();
+			latency_ration = LATENCY_LIMIT;
+		}
+	}
 	spin_lock(&swap_lock);
-	goto checks;
 
 no_page:
 	si->flags -= SWP_SCANNING;
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
linux-next.patch
mark-complex-bitopsh-inlines-as-__always_inline.patch
clocksource-pass-clocksource-to-read-callback.patch
clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
bio-zero-inlined-bio_vec.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
mm-shmemc-fix-division-by-zero.patch
getrusage-fill-ru_maxrss-value.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
memcg-revert-gfp-mask-fix.patch
memcg-check-group-leader-fix.patch
memcg-memoryswap-controller-fix-limit-check.patch
memcg-swapout-refcnt-fix.patch
memcg-hierarchy-avoid-unnecessary-reclaim.patch
inactive_anon_is_low-move-to-vmscan.patch
mm-introduce-zone_reclaim-struct.patch
mm-add-zone-nr_pages-helper-function.patch
mm-make-get_scan_ratio-safe-for-memcg.patch
memcg-add-null-check-to-page_cgroup_zoneinfo.patch
memcg-add-inactive_anon_is_low.patch
memcg-add-mem_cgroup_zone_nr_pages.patch
memcg-add-zone_reclaim_stat.patch
memcg-add-zone_reclaim_stat-reclaim-stat-trivial-fixes-fix.patch
memcg-remove-mem_cgroup_cal_reclaim.patch
memcg-show-reclaim-stat.patch
memcg-rename-scan-global-lru.patch
memcg-protect-prev_priority.patch
memcg-swappiness.patch
memcg-explain-details-and-test-document.patch
memcg-fix-swap-accounting-leak-v3.patch
memcg-fix-swap-accounting-leak-doc-fix.patch
memcg-fix-shmems-swap-accounting.patch
prio_tree-debugging-patch.patch

