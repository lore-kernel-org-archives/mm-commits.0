From: akpm@linux-foundation.org
Subject: + swapfile-rearrange-scan-and-swap_info.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:23:31 -0800
Message-ID: <200811260123.mAQ1NW4j008514@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54230 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYKZBYJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:24:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au


The patch titled
     swapfile: rearrange scan and swap_info
has been added to the -mm tree.  Its filename is
     swapfile-rearrange-scan-and-swap_info.patch

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
Subject: swapfile: rearrange scan and swap_info
From: Hugh Dickins <hugh@veritas.com>

Before making functional changes, rearrange scan_swap_map() to simplify
subsequent diffs.  Actually, there is one functional change in there:
leave cluster_nr negative while scanning for a new cluster - resetting it
early increased the likelihood that when we have difficulty finding a free
cluster, another task may come in and try doing exactly the same - just a
waste of cpu.

Before making functional changes, rearrange struct swap_info_struct
slightly: flags will be needed as an unsigned long (for wait_on_bit), next
is a good int to pair with prio, old_block_size is uninteresting so shift
it to the end.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    8 ++--
 mm/swapfile.c        |   66 ++++++++++++++++++++++-------------------
 2 files changed, 41 insertions(+), 33 deletions(-)

diff -puN include/linux/swap.h~swapfile-rearrange-scan-and-swap_info include/linux/swap.h
--- a/include/linux/swap.h~swapfile-rearrange-scan-and-swap_info
+++ a/include/linux/swap.h
@@ -133,14 +133,14 @@ enum {
  * The in-memory structure used to track swap areas.
  */
 struct swap_info_struct {
-	unsigned int flags;
+	unsigned long flags;
 	int prio;			/* swap priority */
+	int next;			/* next entry on swap list */
 	struct file *swap_file;
 	struct block_device *bdev;
 	struct list_head extent_list;
 	struct swap_extent *curr_swap_extent;
-	unsigned old_block_size;
-	unsigned short * swap_map;
+	unsigned short *swap_map;
 	unsigned int lowest_bit;
 	unsigned int highest_bit;
 	unsigned int cluster_next;
@@ -148,7 +148,7 @@ struct swap_info_struct {
 	unsigned int pages;
 	unsigned int max;
 	unsigned int inuse_pages;
-	int next;			/* next entry on swap list */
+	unsigned int old_block_size;
 };
 
 struct swap_list_t {
diff -puN mm/swapfile.c~swapfile-rearrange-scan-and-swap_info mm/swapfile.c
--- a/mm/swapfile.c~swapfile-rearrange-scan-and-swap_info
+++ a/mm/swapfile.c
@@ -89,7 +89,8 @@ void swap_unplug_io_fn(struct backing_de
 
 static inline unsigned long scan_swap_map(struct swap_info_struct *si)
 {
-	unsigned long offset, last_in_cluster;
+	unsigned long offset;
+	unsigned long last_in_cluster;
 	int latency_ration = LATENCY_LIMIT;
 
 	/*
@@ -103,10 +104,13 @@ static inline unsigned long scan_swap_ma
 	 */
 
 	si->flags += SWP_SCANNING;
-	if (unlikely(!si->cluster_nr)) {
-		si->cluster_nr = SWAPFILE_CLUSTER - 1;
-		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER)
-			goto lowest;
+	offset = si->cluster_next;
+
+	if (unlikely(!si->cluster_nr--)) {
+		if (si->pages - si->inuse_pages < SWAPFILE_CLUSTER) {
+			si->cluster_nr = SWAPFILE_CLUSTER - 1;
+			goto checks;
+		}
 		spin_unlock(&swap_lock);
 
 		offset = si->lowest_bit;
@@ -118,43 +122,47 @@ static inline unsigned long scan_swap_ma
 				last_in_cluster = offset + SWAPFILE_CLUSTER;
 			else if (offset == last_in_cluster) {
 				spin_lock(&swap_lock);
-				si->cluster_next = offset-SWAPFILE_CLUSTER+1;
-				goto cluster;
+				offset -= SWAPFILE_CLUSTER - 1;
+				si->cluster_next = offset;
+				si->cluster_nr = SWAPFILE_CLUSTER - 1;
+				goto checks;
 			}
 			if (unlikely(--latency_ration < 0)) {
 				cond_resched();
 				latency_ration = LATENCY_LIMIT;
 			}
 		}
+
+		offset = si->lowest_bit;
 		spin_lock(&swap_lock);
-		goto lowest;
+		si->cluster_nr = SWAPFILE_CLUSTER - 1;
 	}
 
-	si->cluster_nr--;
-cluster:
-	offset = si->cluster_next;
-	if (offset > si->highest_bit)
-lowest:		offset = si->lowest_bit;
-checks:	if (!(si->flags & SWP_WRITEOK))
+checks:
+	if (!(si->flags & SWP_WRITEOK))
 		goto no_page;
 	if (!si->highest_bit)
 		goto no_page;
-	if (!si->swap_map[offset]) {
-		if (offset == si->lowest_bit)
-			si->lowest_bit++;
-		if (offset == si->highest_bit)
-			si->highest_bit--;
-		si->inuse_pages++;
-		if (si->inuse_pages == si->pages) {
-			si->lowest_bit = si->max;
-			si->highest_bit = 0;
-		}
-		si->swap_map[offset] = 1;
-		si->cluster_next = offset + 1;
-		si->flags -= SWP_SCANNING;
-		return offset;
+	if (offset > si->highest_bit)
+		offset = si->lowest_bit;
+	if (si->swap_map[offset])
+		goto scan;
+
+	if (offset == si->lowest_bit)
+		si->lowest_bit++;
+	if (offset == si->highest_bit)
+		si->highest_bit--;
+	si->inuse_pages++;
+	if (si->inuse_pages == si->pages) {
+		si->lowest_bit = si->max;
+		si->highest_bit = 0;
 	}
+	si->swap_map[offset] = 1;
+	si->cluster_next = offset + 1;
+	si->flags -= SWP_SCANNING;
+	return offset;
 
+scan:
 	spin_unlock(&swap_lock);
 	while (++offset <= si->highest_bit) {
 		if (!si->swap_map[offset]) {
@@ -167,7 +175,7 @@ checks:	if (!(si->flags & SWP_WRITEOK))
 		}
 	}
 	spin_lock(&swap_lock);
-	goto lowest;
+	goto checks;
 
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

