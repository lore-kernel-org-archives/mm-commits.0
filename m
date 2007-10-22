From: akpm@linux-foundation.org
Subject: + swapin-fix-valid_swaphandles-defect.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:13:51 -0700
Message-ID: <200710222213.l9MMDpoo017653@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52977 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbXJVWPE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:15:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, riel@surriel.com


The patch titled
     swapin: fix valid_swaphandles defect
has been added to the -mm tree.  Its filename is
     swapin-fix-valid_swaphandles-defect.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
fix-mprotect-vma_wants_writenotify-prot.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
