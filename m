From: akpm@linux-foundation.org
Subject: [merged] make-swapin-readahead-skip-over-holes.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:17:39 -0700
Message-ID: <20120322201739.83D02A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:41893 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427Ab2CVURl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:17:41 -0400
Received: by mail-ee0-f74.google.com with SMTP id c41so136539eek.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:17:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: riel@redhat.com, hannes@cmpxchg.org, hughd@google.com, kosaki.motohiro@gmail.com, mgorman@suse.de, minchan.kim@gmail.com, z@drze.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: make swapin readahead skip over holes
has been removed from the -mm tree.  Its filename was
     make-swapin-readahead-skip-over-holes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Rik van Riel <riel@redhat.com>
Subject: mm: make swapin readahead skip over holes

Ever since abandoning the virtual scan of processes, for scalability
reasons, swap space has been a little more fragmented than before.  This
can lead to the situation where a large memory user is killed, swap space
ends up full of "holes" and swapin readahead is totally ineffective.

On my home system, after killing a leaky firefox it took over an hour to
page just under 2GB of memory back in, slowing the virtual machines down
to a crawl.

This patch makes swapin readahead simply skip over holes, instead of
stopping at them.  This allows the system to swap things back in at rates
of several MB/second, instead of a few hundred kB/second.

The checks done in valid_swaphandles are already done in
read_swap_cache_async as well, allowing us to remove a fair amount of
code.

[akpm@linux-foundation.org: fix it for page_cluster >= 32]
Signed-off-by: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Adrian Drzewiecki <z@drze.net>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 
 mm/swap_state.c      |   24 ++++++++----------
 mm/swapfile.c        |   52 -----------------------------------------
 3 files changed, 11 insertions(+), 66 deletions(-)

diff -puN include/linux/swap.h~make-swapin-readahead-skip-over-holes include/linux/swap.h
--- a/include/linux/swap.h~make-swapin-readahead-skip-over-holes
+++ a/include/linux/swap.h
@@ -329,7 +329,6 @@ extern long total_swap_pages;
 extern void si_swapinfo(struct sysinfo *);
 extern swp_entry_t get_swap_page(void);
 extern swp_entry_t get_swap_page_of_type(int);
-extern int valid_swaphandles(swp_entry_t, unsigned long *);
 extern int add_swap_count_continuation(swp_entry_t, gfp_t);
 extern void swap_shmem_alloc(swp_entry_t);
 extern int swap_duplicate(swp_entry_t);
diff -puN mm/swap_state.c~make-swapin-readahead-skip-over-holes mm/swap_state.c
--- a/mm/swap_state.c~make-swapin-readahead-skip-over-holes
+++ a/mm/swap_state.c
@@ -372,25 +372,23 @@ struct page *read_swap_cache_async(swp_e
 struct page *swapin_readahead(swp_entry_t entry, gfp_t gfp_mask,
 			struct vm_area_struct *vma, unsigned long addr)
 {
-	int nr_pages;
 	struct page *page;
-	unsigned long offset;
-	unsigned long end_offset;
+	unsigned long offset = swp_offset(entry);
+	unsigned long start_offset, end_offset;
+	unsigned long mask = (1UL << page_cluster) - 1;
 
-	/*
-	 * Get starting offset for readaround, and number of pages to read.
-	 * Adjust starting address by readbehind (for NUMA interleave case)?
-	 * No, it's very unlikely that swap layout would follow vma layout,
-	 * more likely that neighbouring swap pages came from the same node:
-	 * so use the same "addr" to choose the same node for each swap read.
-	 */
-	nr_pages = valid_swaphandles(entry, &offset);
-	for (end_offset = offset + nr_pages; offset < end_offset; offset++) {
+	/* Read a page_cluster sized and aligned cluster around offset. */
+	start_offset = offset & ~mask;
+	end_offset = offset | mask;
+	if (!start_offset)	/* First page is swap header. */
+		start_offset++;
+
+	for (offset = start_offset; offset <= end_offset ; offset++) {
 		/* Ok, do the async read-ahead now */
 		page = read_swap_cache_async(swp_entry(swp_type(entry), offset),
 						gfp_mask, vma, addr);
 		if (!page)
-			break;
+			continue;
 		page_cache_release(page);
 	}
 	lru_add_drain();	/* Push any new pages onto the LRU now */
diff -puN mm/swapfile.c~make-swapin-readahead-skip-over-holes mm/swapfile.c
--- a/mm/swapfile.c~make-swapin-readahead-skip-over-holes
+++ a/mm/swapfile.c
@@ -2288,58 +2288,6 @@ int swapcache_prepare(swp_entry_t entry)
 }
 
 /*
- * swap_lock prevents swap_map being freed. Don't grab an extra
- * reference on the swaphandle, it doesn't matter if it becomes unused.
- */
-int valid_swaphandles(swp_entry_t entry, unsigned long *offset)
-{
-	struct swap_info_struct *si;
-	int our_page_cluster = page_cluster;
-	pgoff_t target, toff;
-	pgoff_t base, end;
-	int nr_pages = 0;
-
-	if (!our_page_cluster)	/* no readahead */
-		return 0;
-
-	si = swap_info[swp_type(entry)];
-	target = swp_offset(entry);
-	base = (target >> our_page_cluster) << our_page_cluster;
-	end = base + (1 << our_page_cluster);
-	if (!base)		/* first page is swap header */
-		base++;
-
-	spin_lock(&swap_lock);
-	if (end > si->max)	/* don't go beyond end of map */
-		end = si->max;
-
-	/* Count contiguous allocated slots above our target */
-	for (toff = target; ++toff < end; nr_pages++) {
-		/* Don't read in free or bad pages */
-		if (!si->swap_map[toff])
-			break;
-		if (swap_count(si->swap_map[toff]) == SWAP_MAP_BAD)
-			break;
-	}
-	/* Count contiguous allocated slots below our target */
-	for (toff = target; --toff >= base; nr_pages++) {
-		/* Don't read in free or bad pages */
-		if (!si->swap_map[toff])
-			break;
-		if (swap_count(si->swap_map[toff]) == SWAP_MAP_BAD)
-			break;
-	}
-	spin_unlock(&swap_lock);
-
-	/*
-	 * Indicate starting offset, and return number of pages to get:
-	 * if only 1, say 0, since there's then no readahead to be done.
-	 */
-	*offset = ++toff;
-	return nr_pages? ++nr_pages: 0;
-}
