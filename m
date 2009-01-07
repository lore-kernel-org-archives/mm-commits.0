From: akpm@linux-foundation.org
Subject: - swapfile-swapon-use-discard-trim.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:13:23 -0800
Message-ID: <200901072213.n07MDNhH013487@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758974AbZAGWNz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:13:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx


The patch titled
     swapfile: swapon use discard (trim)
has been removed from the -mm tree.  Its filename was
     swapfile-swapon-use-discard-trim.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapfile: swapon use discard (trim)
From: Hugh Dickins <hugh@veritas.com>

When adding swap, all the old data on swap can be forgotten: sys_swapon()
discard all but the header page of the swap partition (or every extent but
the header of the swap file), to give a solidstate swap device the
opportunity to optimize its wear-levelling.

If that succeeds, note SWP_DISCARDABLE for later use, and report it with a
"D" at the right end of the kernel's "Adding ...  swap" message.  Perhaps
something should be shown in /proc/swaps (swapon -s), but we have to be
more cautious before making any addition to that format.

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

 include/linux/swap.h |    1 +
 mm/swapfile.c        |   39 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 38 insertions(+), 2 deletions(-)

diff -puN include/linux/swap.h~swapfile-swapon-use-discard-trim include/linux/swap.h
--- a/include/linux/swap.h~swapfile-swapon-use-discard-trim
+++ a/include/linux/swap.h
@@ -120,6 +120,7 @@ struct swap_extent {
 enum {
 	SWP_USED	= (1 << 0),	/* is slot in swap_info[] used? */
 	SWP_WRITEOK	= (1 << 1),	/* ok to write to this swap?	*/
+	SWP_DISCARDABLE = (1 << 2),	/* blkdev supports discard */
 					/* add others here before... */
 	SWP_SCANNING	= (1 << 8),	/* refcount in scan_swap_map */
 };
diff -puN mm/swapfile.c~swapfile-swapon-use-discard-trim mm/swapfile.c
--- a/mm/swapfile.c~swapfile-swapon-use-discard-trim
+++ a/mm/swapfile.c
@@ -84,6 +84,37 @@ void swap_unplug_io_fn(struct backing_de
 	up_read(&swap_unplug_sem);
 }
 
+/*
+ * swapon tell device that all the old swap contents can be discarded,
+ * to allow the swap device to optimize its wear-levelling.
+ */
+static int discard_swap(struct swap_info_struct *si)
+{
+	struct swap_extent *se;
+	int err = 0;
+
+	list_for_each_entry(se, &si->extent_list, list) {
+		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
+		pgoff_t nr_blocks = se->nr_pages << (PAGE_SHIFT - 9);
+
+		if (se->start_page == 0) {
+			/* Do not discard the swap header page! */
+			start_block += 1 << (PAGE_SHIFT - 9);
+			nr_blocks -= 1 << (PAGE_SHIFT - 9);
+			if (!nr_blocks)
+				continue;
+		}
+
+		err = blkdev_issue_discard(si->bdev, start_block,
+						nr_blocks, GFP_KERNEL);
+		if (err)
+			break;
+
+		cond_resched();
+	}
+	return err;		/* That will often be -EOPNOTSUPP */
+}
+
 #define SWAPFILE_CLUSTER	256
 #define LATENCY_LIMIT		256
 
@@ -1658,6 +1689,9 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
+	if (discard_swap(p) == 0)
+		p->flags |= SWP_DISCARDABLE;
+
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
 	if (swap_flags & SWAP_FLAG_PREFER)
@@ -1671,9 +1705,10 @@ asmlinkage long sys_swapon(const char __
 	total_swap_pages += nr_good_pages;
 
 	printk(KERN_INFO "Adding %uk swap on %s.  "
-			"Priority:%d extents:%d across:%lluk\n",
+			"Priority:%d extents:%d across:%lluk%s\n",
 		nr_good_pages<<(PAGE_SHIFT-10), name, p->prio,
-		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10));
+		nr_extents, (unsigned long long)span<<(PAGE_SHIFT-10),
+		(p->flags & SWP_DISCARDABLE) ? " D" : "");
 
 	/* insert swap space into swap_list: */
 	prev = -1;
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

