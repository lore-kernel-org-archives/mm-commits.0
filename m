From: akpm@linux-foundation.org
Subject: - swapfile-swapon-needs-larger-size-type.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:13 -0800
Message-ID: <200901072213.n07MDDhd013339@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39853 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756899AbZAGWNV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     swapfile: swapon needs larger size type
has been removed from the -mm tree.  Its filename was
     swapfile-swapon-needs-larger-size-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: swapon needs larger size type
From: Hugh Dickins <hugh@veritas.com>

sys_swapon()'s swapfilesize (better renamed swapfilepages) is declared as
an int, but should be an unsigned long like the maxpages it's compared
against: on 64-bit (with 4kB pages) a swapfile of 2^44 bytes was rejected
with "Swap area shorter than signature indicates".

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/swapfile.c~swapfile-swapon-needs-larger-size-type mm/swapfile.c
--- a/mm/swapfile.c~swapfile-swapon-needs-larger-size-type
+++ a/mm/swapfile.c
@@ -1461,7 +1461,7 @@ asmlinkage long sys_swapon(const char __
 	int nr_extents = 0;
 	sector_t span;
 	unsigned long maxpages = 1;
-	int swapfilesize;
+	unsigned long swapfilepages;
 	unsigned short *swap_map = NULL;
 	struct page *page = NULL;
 	struct inode *inode = NULL;
@@ -1539,7 +1539,7 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
-	swapfilesize = i_size_read(inode) >> PAGE_SHIFT;
+	swapfilepages = i_size_read(inode) >> PAGE_SHIFT;
 
 	/*
 	 * Read the swap header.
@@ -1616,7 +1616,7 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		if (!maxpages)
 			goto bad_swap;
-		if (swapfilesize && maxpages > swapfilesize) {
+		if (swapfilepages && maxpages > swapfilepages) {
 			printk(KERN_WARNING
 			       "Swap area shorter than signature indicates\n");
 			goto bad_swap;
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

