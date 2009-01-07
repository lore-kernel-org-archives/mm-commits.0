From: akpm@linux-foundation.org
Subject: - swapfile-remove-surplus-whitespace.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:17 -0800
Message-ID: <200901072213.n07MDHYO013349@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761277AbZAGWNZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, kamezawa.hiroyu@jp.fujitsu.com, nickpiggin@yahoo.com.au, mm-commits@vger.kernel.org


The patch titled
     swapfile: remove surplus whitespace
has been removed from the -mm tree.  Its filename was
     swapfile-remove-surplus-whitespace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: remove surplus whitespace
From: Hugh Dickins <hugh@veritas.com>

Remove trailing whitespace from swapfile.c, and odd swap_show() alignment.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/swapfile.c~swapfile-remove-surplus-whitespace mm/swapfile.c
--- a/mm/swapfile.c~swapfile-remove-surplus-whitespace
+++ a/mm/swapfile.c
@@ -92,7 +92,7 @@ static inline unsigned long scan_swap_ma
 	unsigned long offset, last_in_cluster;
 	int latency_ration = LATENCY_LIMIT;
 
-	/* 
+	/*
 	 * We try to cluster swap pages by allocating them sequentially
 	 * in swap.  Once we've allocated SWAPFILE_CLUSTER pages this
 	 * way, however, we resort to first-free allocation, starting
@@ -269,7 +269,7 @@ bad_nofile:
 	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_file, entry.val);
 out:
 	return NULL;
-}	
+}
 
 static int swap_entry_free(struct swap_info_struct *p, unsigned long offset)
 {
@@ -736,10 +736,10 @@ static int try_to_unuse(unsigned int typ
 			break;
 		}
 
-		/* 
+		/*
 		 * Get a page for the entry, using the existing swap
 		 * cache page if there is one.  Otherwise, get a clean
-		 * page and read the swap into it. 
+		 * page and read the swap into it.
 		 */
 		swap_map = &si->swap_map[i];
 		entry = swp_entry(type, i);
@@ -1202,7 +1202,7 @@ asmlinkage long sys_swapoff(const char _
 	char * pathname;
 	int i, type, prev;
 	int err;
-	
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
@@ -1395,12 +1395,12 @@ static int swap_show(struct seq_file *sw
 	file = ptr->swap_file;
 	len = seq_path(swap, &file->f_path, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
-		       len < 40 ? 40 - len : 1, " ",
-		       S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
+			len < 40 ? 40 - len : 1, " ",
+			S_ISBLK(file->f_path.dentry->d_inode->i_mode) ?
 				"partition" : "file\t",
-		       ptr->pages << (PAGE_SHIFT - 10),
-		       ptr->inuse_pages << (PAGE_SHIFT - 10),
-		       ptr->prio);
+			ptr->pages << (PAGE_SHIFT - 10),
+			ptr->inuse_pages << (PAGE_SHIFT - 10),
+			ptr->prio);
 	return 0;
 }
 
@@ -1565,7 +1565,7 @@ asmlinkage long sys_swapon(const char __
 		error = -EINVAL;
 		goto bad_swap;
 	}
-	
+
 	switch (swap_header_version) {
 	case 1:
 		printk(KERN_ERR "version 0 swap is no longer supported. "
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

