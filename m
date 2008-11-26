From: akpm@linux-foundation.org
Subject: + swapfile-swap-allocation-cycle-if-nonrot.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:24:02 -0800
Message-ID: <200811260124.mAQ1O3bZ008822@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48243 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbYKZBY2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:24:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx, nickpiggin@yahoo.com.au, teheo@suse.de


The patch titled
     swapfile: swap allocation cycle if nonrot
has been added to the -mm tree.  Its filename is
     swapfile-swap-allocation-cycle-if-nonrot.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

linux-next.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-apply_to_range-call-pte-function-with-lazy-updates.patch
mm-remove-cgroup_mm_owner_callbacks.patch
mm-remove-aop_writepage_activate.patch
mm-remove-gfp_highuser_pagecache.patch
mm-add-setclearpageswapcache-stubs.patch
mm-replace-some-bug_ons-by-vm_bug_ons.patch
mm-add_active_or_unevictable-into-rmap.patch
mm-make-page_lock_anon_vma-static.patch
mm-further-cleanup-page_add_new_anon_rmap.patch
mm-gup-persist-for-write-permission.patch
mm-wp-lock-page-before-deciding-cow.patch
mm-reuse_swap_page-replaces-can_share_swap_page.patch
mm-try_to_free_swap-replaces-remove_exclusive_swap_page.patch
mm-try_to_unuse-check-removing-right-swap.patch
mm-remove-try_to_munlock-from-vmscan.patch
mm-remove-gfp_mask-from-add_to_swap.patch
mm-add-add_to_swap-stub.patch
mm-optimize-get_scan_ratio-for-no-swap.patch
make-get_user_pages-interruptible.patch
make-get_user_pages-interruptible-update.patch
swapfile-swapon-needs-larger-size-type.patch
swapfile-remove-swp_active-mask.patch
swapfile-remove-surplus-whitespace.patch
swapfile-remove-v0-swap-space-message.patch
swapfile-rearrange-scan-and-swap_info.patch
swapfile-swapon-use-discard-trim.patch
swapfile-swap-allocation-use-discard.patch
swapfile-swapon-randomize-if-nonrot.patch
swapfile-swap-allocation-cycle-if-nonrot.patch
memcg-handle-swap-caches.patch
memcg-handle-swap-caches-build-fix.patch
memcg-swap-cgroup-for-remembering-usage.patch
memcg-memswap-controller-core.patch
memcg-memswap-controller-core-make-resize-limit-hold-mutex.patch
memcg-memswap-controller-core-swapcache-fixes.patch
prio_tree-debugging-patch.patch

