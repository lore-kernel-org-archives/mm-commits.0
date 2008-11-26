From: akpm@linux-foundation.org
Subject: + swapfile-swapon-use-discard-trim.patch added to -mm tree
Date: Tue, 25 Nov 2008 17:23:34 -0800
Message-ID: <200811260123.mAQ1NYv2008591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYKZBY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 25 Nov 2008 20:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, James.Bottomley@HansenPartnership.com, djshin90@gmail.com, dwmw2@infradead.org, jens.axboe@oracle.com, joern@logfs.org, kamezawa.hiroyu@jp.fujitsu.com, matthew@wil.cx, nickpiggin@yahoo.com.au, teheo@suse.de


The patch titled
     swapfile: swapon use discard (trim)
has been added to the -mm tree.  Its filename is
     swapfile-swapon-use-discard-trim.patch

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
 
@@ -1649,6 +1680,9 @@ asmlinkage long sys_swapon(const char __
 		goto bad_swap;
 	}
 
+	if (discard_swap(p) == 0)
+		p->flags |= SWP_DISCARDABLE;
+
 	mutex_lock(&swapon_mutex);
 	spin_lock(&swap_lock);
 	if (swap_flags & SWAP_FLAG_PREFER)
@@ -1662,9 +1696,10 @@ asmlinkage long sys_swapon(const char __
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

