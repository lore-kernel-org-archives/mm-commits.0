From: akpm@linux-foundation.org
Subject: - swapfile-remove-v0-swap-space-message.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:19 -0800
Message-ID: <200901072213.n07MDJi4013400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57749 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761651AbZAGWN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     swapfile: remove v0 SWAP-SPACE message
has been removed from the -mm tree.  Its filename was
     swapfile-remove-v0-swap-space-message.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: remove v0 SWAP-SPACE message
From: Hugh Dickins <hugh@veritas.com>

The kernel has not supported v0 SWAP-SPACE since 2.5.22: I think we can
now safely drop its "version 0 swap is no longer supported" message - just
say "Unable to find swap-space signature" as usual.  This removes one
level of indentation from a stretch of sys_swapon().

I'd have liked to be specific, saying "Unable to find SWAPSPACE2
signature", but it's just too confusing that the version 1 signature shows
the number 2.

Irrelevant nearby cleanup: kmap(page) already gives page_address(page).

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |  146 +++++++++++++++++++++---------------------------
 1 file changed, 65 insertions(+), 81 deletions(-)

diff -puN mm/swapfile.c~swapfile-remove-v0-swap-space-message mm/swapfile.c
--- a/mm/swapfile.c~swapfile-remove-v0-swap-space-message
+++ a/mm/swapfile.c
@@ -1456,7 +1456,6 @@ asmlinkage long sys_swapon(const char __
 	int i, prev;
 	int error;
 	union swap_header *swap_header = NULL;
-	int swap_header_version;
 	unsigned int nr_good_pages = 0;
 	int nr_extents = 0;
 	sector_t span;
@@ -1553,101 +1552,86 @@ asmlinkage long sys_swapon(const char __
 		error = PTR_ERR(page);
 		goto bad_swap;
 	}
-	kmap(page);
-	swap_header = page_address(page);
+	swap_header = kmap(page);
 
-	if (!memcmp("SWAP-SPACE",swap_header->magic.magic,10))
-		swap_header_version = 1;
-	else if (!memcmp("SWAPSPACE2",swap_header->magic.magic,10))
-		swap_header_version = 2;
-	else {
+	if (memcmp("SWAPSPACE2", swap_header->magic.magic, 10)) {
 		printk(KERN_ERR "Unable to find swap-space signature\n");
 		error = -EINVAL;
 		goto bad_swap;
 	}
 
-	switch (swap_header_version) {
-	case 1:
-		printk(KERN_ERR "version 0 swap is no longer supported. "
-			"Use mkswap -v1 %s\n", name);
+	/* swap partition endianess hack... */
+	if (swab32(swap_header->info.version) == 1) {
+		swab32s(&swap_header->info.version);
+		swab32s(&swap_header->info.last_page);
+		swab32s(&swap_header->info.nr_badpages);
+		for (i = 0; i < swap_header->info.nr_badpages; i++)
+			swab32s(&swap_header->info.badpages[i]);
+	}
+	/* Check the swap header's sub-version */
+	if (swap_header->info.version != 1) {
+		printk(KERN_WARNING
+		       "Unable to handle swap header version %d\n",
+		       swap_header->info.version);
 		error = -EINVAL;
 		goto bad_swap;
-	case 2:
-		/* swap partition endianess hack... */
-		if (swab32(swap_header->info.version) == 1) {
-			swab32s(&swap_header->info.version);
-			swab32s(&swap_header->info.last_page);
-			swab32s(&swap_header->info.nr_badpages);
-			for (i = 0; i < swap_header->info.nr_badpages; i++)
-				swab32s(&swap_header->info.badpages[i]);
-		}
-		/* Check the swap header's sub-version and the size of
-                   the swap file and bad block lists */
-		if (swap_header->info.version != 1) {
-			printk(KERN_WARNING
-			       "Unable to handle swap header version %d\n",
-			       swap_header->info.version);
-			error = -EINVAL;
-			goto bad_swap;
-		}
+	}
 
-		p->lowest_bit  = 1;
-		p->cluster_next = 1;
+	p->lowest_bit  = 1;
+	p->cluster_next = 1;
 
-		/*
-		 * Find out how many pages are allowed for a single swap
-		 * device. There are two limiting factors: 1) the number of
-		 * bits for the swap offset in the swp_entry_t type and
-		 * 2) the number of bits in the a swap pte as defined by
-		 * the different architectures. In order to find the
-		 * largest possible bit mask a swap entry with swap type 0
-		 * and swap offset ~0UL is created, encoded to a swap pte,
-		 * decoded to a swp_entry_t again and finally the swap
-		 * offset is extracted. This will mask all the bits from
-		 * the initial ~0UL mask that can't be encoded in either
-		 * the swp_entry_t or the architecture definition of a
-		 * swap pte.
-		 */
-		maxpages = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0,~0UL)))) - 1;
-		if (maxpages > swap_header->info.last_page)
-			maxpages = swap_header->info.last_page;
-		p->highest_bit = maxpages - 1;
+	/*
+	 * Find out how many pages are allowed for a single swap
+	 * device. There are two limiting factors: 1) the number of
+	 * bits for the swap offset in the swp_entry_t type and
+	 * 2) the number of bits in the a swap pte as defined by
+	 * the different architectures. In order to find the
+	 * largest possible bit mask a swap entry with swap type 0
+	 * and swap offset ~0UL is created, encoded to a swap pte,
+	 * decoded to a swp_entry_t again and finally the swap
+	 * offset is extracted. This will mask all the bits from
+	 * the initial ~0UL mask that can't be encoded in either
+	 * the swp_entry_t or the architecture definition of a
+	 * swap pte.
+	 */
+	maxpages = swp_offset(pte_to_swp_entry(
+			swp_entry_to_pte(swp_entry(0, ~0UL)))) - 1;
+	if (maxpages > swap_header->info.last_page)
+		maxpages = swap_header->info.last_page;
+	p->highest_bit = maxpages - 1;
 
-		error = -EINVAL;
-		if (!maxpages)
-			goto bad_swap;
-		if (swapfilepages && maxpages > swapfilepages) {
-			printk(KERN_WARNING
-			       "Swap area shorter than signature indicates\n");
-			goto bad_swap;
-		}
-		if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
-			goto bad_swap;
-		if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
-			goto bad_swap;
+	error = -EINVAL;
+	if (!maxpages)
+		goto bad_swap;
+	if (swapfilepages && maxpages > swapfilepages) {
+		printk(KERN_WARNING
+		       "Swap area shorter than signature indicates\n");
+		goto bad_swap;
+	}
+	if (swap_header->info.nr_badpages && S_ISREG(inode->i_mode))
+		goto bad_swap;
+	if (swap_header->info.nr_badpages > MAX_SWAP_BADPAGES)
+		goto bad_swap;
 
-		/* OK, set up the swap map and apply the bad block list */
-		swap_map = vmalloc(maxpages * sizeof(short));
-		if (!swap_map) {
-			error = -ENOMEM;
-			goto bad_swap;
-		}
+	/* OK, set up the swap map and apply the bad block list */
+	swap_map = vmalloc(maxpages * sizeof(short));
+	if (!swap_map) {
+		error = -ENOMEM;
+		goto bad_swap;
+	}
 
-		error = 0;
-		memset(swap_map, 0, maxpages * sizeof(short));
-		for (i = 0; i < swap_header->info.nr_badpages; i++) {
-			int page_nr = swap_header->info.badpages[i];
-			if (page_nr <= 0 || page_nr >= swap_header->info.last_page)
-				error = -EINVAL;
-			else
-				swap_map[page_nr] = SWAP_MAP_BAD;
-		}
-		nr_good_pages = swap_header->info.last_page -
-				swap_header->info.nr_badpages -
-				1 /* header page */;
-		if (error)
+	memset(swap_map, 0, maxpages * sizeof(short));
+	for (i = 0; i < swap_header->info.nr_badpages; i++) {
+		int page_nr = swap_header->info.badpages[i];
+		if (page_nr <= 0 || page_nr >= swap_header->info.last_page) {
+			error = -EINVAL;
 			goto bad_swap;
+		}
+		swap_map[page_nr] = SWAP_MAP_BAD;
 	}
+	nr_good_pages = swap_header->info.last_page -
+			swap_header->info.nr_badpages -
+			1 /* header page */;
 
 	if (nr_good_pages) {
 		swap_map[0] = SWAP_MAP_BAD;
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

