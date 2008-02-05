From: akpm@linux-foundation.org
Subject: - swapin-fix-valid_swaphandles-defect.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:13 -0800
Message-ID: <200802052229.m15MTsp3012016@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39194 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762615AbYBEWnt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, riel@surriel.com, mm-commits@vger.kernel.org


The patch titled
     swapin: fix valid_swaphandles defect
has been removed from the -mm tree.  Its filename was
     swapin-fix-valid_swaphandles-defect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapin: fix valid_swaphandles defect
From: Hugh Dickins <hugh@veritas.com>

valid_swaphandles is supposed to do a quick pass over the swap map entries
neigbouring the entry which swapin_readahead is targetting, to determine for
it a range worth reading all together.  But since it always starts its search
from the beginning of the swap "cluster", a reject (free entry) there
immediately curtails the readaround, and every swapin_readahead from that
cluster is for just a single page.  Instead scan forwards and backwards around
the target entry.

Use better names for some variables: a swap_info pointer is usually called
"si" not "swapdev".  And at the end, if only the target page should be read,
return count of 0 to disable readaround, to avoid the unnecessarily repeated
call to read_swap_cache_async.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   49 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff -puN mm/swapfile.c~swapin-fix-valid_swaphandles-defect mm/swapfile.c
--- a/mm/swapfile.c~swapin-fix-valid_swaphandles-defect
+++ a/mm/swapfile.c
@@ -1769,31 +1769,48 @@ get_swap_info_struct(unsigned type)
  */
 int valid_swaphandles(swp_entry_t entry, unsigned long *offset)
 {
+	struct swap_info_struct *si;
 	int our_page_cluster = page_cluster;
-	int ret = 0, i = 1 << our_page_cluster;
-	unsigned long toff;
-	struct swap_info_struct *swapdev = swp_type(entry) + swap_info;
+	pgoff_t target, toff;
+	pgoff_t base, end;
+	int nr_pages = 0;
 
 	if (!our_page_cluster)	/* no readahead */
 		return 0;
-	toff = (swp_offset(entry) >> our_page_cluster) << our_page_cluster;
-	if (!toff)		/* first page is swap header */
-		toff++, i--;
-	*offset = toff;
+
+	si = &swap_info[swp_type(entry)];
+	target = swp_offset(entry);
+	base = (target >> our_page_cluster) << our_page_cluster;
+	end = base + (1 << our_page_cluster);
+	if (!base)		/* first page is swap header */
+		base++;
 
 	spin_lock(&swap_lock);
-	do {
-		/* Don't read-ahead past the end of the swap area */
-		if (toff >= swapdev->max)
+	if (end > si->max)	/* don't go beyond end of map */
+		end = si->max;
+
+	/* Count contiguous allocated slots above our target */
+	for (toff = target; ++toff < end; nr_pages++) {
+		/* Don't read in free or bad pages */
+		if (!si->swap_map[toff])
 			break;
+		if (si->swap_map[toff] == SWAP_MAP_BAD)
+			break;
+	}
+	/* Count contiguous allocated slots below our target */
+	for (toff = target; --toff >= base; nr_pages++) {
 		/* Don't read in free or bad pages */
-		if (!swapdev->swap_map[toff])
+		if (!si->swap_map[toff])
 			break;
-		if (swapdev->swap_map[toff] == SWAP_MAP_BAD)
+		if (si->swap_map[toff] == SWAP_MAP_BAD)
 			break;
-		toff++;
-		ret++;
-	} while (--i);
+	}
 	spin_unlock(&swap_lock);
-	return ret;
+
+	/*
+	 * Indicate starting offset, and return number of pages to get:
+	 * if only 1, say 0, since there's then no readahead to be done.
+	 */
+	*offset = ++toff;
+	return nr_pages? ++nr_pages: 0;
 }
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
