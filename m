From: akpm@linux-foundation.org
Subject: + swap_info-include-first_swap_extent.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:45:41 -0700
Message-ID: <200910151945.n9FJjfp0025059@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44275 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935357AbZJOTq7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     swap_info: include first_swap_extent
has been added to the -mm tree.  Its filename is
     swap_info-include-first_swap_extent.patch

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
Subject: swap_info: include first_swap_extent
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Make better use of the space by folding first swap_extent into its
swap_info_struct, instead of just the list_head: swap partitions need
only that one, and for others it's used as a circular list anyway.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/swap.h~swap_info-include-first_swap_extent include/linux/swap.h
--- a/include/linux/swap.h~swap_info-include-first_swap_extent
+++ a/include/linux/swap.h
@@ -165,7 +165,7 @@ struct swap_info_struct {
 	signed char	next;		/* next type on the swap list */
 	struct file *swap_file;
 	struct block_device *bdev;
-	struct list_head extent_list;
+	struct swap_extent first_swap_extent;
 	struct swap_extent *curr_swap_extent;
 	unsigned short *swap_map;
 	unsigned int lowest_bit;
diff -puN mm/swapfile.c~swap_info-include-first_swap_extent mm/swapfile.c
--- a/mm/swapfile.c~swap_info-include-first_swap_extent
+++ a/mm/swapfile.c
@@ -145,23 +145,28 @@ void swap_unplug_io_fn(struct backing_de
 static int discard_swap(struct swap_info_struct *si)
 {
 	struct swap_extent *se;
+	sector_t start_block;
+	sector_t nr_blocks;
 	int err = 0;
 
-	list_for_each_entry(se, &si->extent_list, list) {
-		sector_t start_block = se->start_block << (PAGE_SHIFT - 9);
-		sector_t nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
-
-		if (se->start_page == 0) {
-			/* Do not discard the swap header page! */
-			start_block += 1 << (PAGE_SHIFT - 9);
-			nr_blocks -= 1 << (PAGE_SHIFT - 9);
-			if (!nr_blocks)
-				continue;
-		}
+	/* Do not discard the swap header page! */
+	se = &si->first_swap_extent;
+	start_block = (se->start_block + 1) << (PAGE_SHIFT - 9);
+	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
+	if (nr_blocks) {
+		err = blkdev_issue_discard(si->bdev, start_block,
+				nr_blocks, GFP_KERNEL, DISCARD_FL_BARRIER);
+		if (err)
+			return err;
+		cond_resched();
+	}
+
+	list_for_each_entry(se, &si->first_swap_extent.list, list) {
+		start_block = se->start_block << (PAGE_SHIFT - 9);
+		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-						nr_blocks, GFP_KERNEL,
-						DISCARD_FL_BARRIER);
+				nr_blocks, GFP_KERNEL, DISCARD_FL_BARRIER);
 		if (err)
 			break;
 
@@ -200,14 +205,11 @@ static void discard_swap_cluster(struct 
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-							nr_blocks, GFP_NOIO,
-							DISCARD_FL_BARRIER))
+				    nr_blocks, GFP_NOIO, DISCARD_FL_BARRIER))
 				break;
 		}
 
 		lh = se->list.next;
-		if (lh == &si->extent_list)
-			lh = lh->next;
 		se = list_entry(lh, struct swap_extent, list);
 	}
 }
@@ -761,10 +763,8 @@ int swap_type_of(dev_t device, sector_t 
 			return type;
 		}
 		if (bdev == sis->bdev) {
-			struct swap_extent *se;
+			struct swap_extent *se = &sis->first_swap_extent;
 
-			se = list_entry(sis->extent_list.next,
-					struct swap_extent, list);
 			if (se->start_block == offset) {
 				if (bdev_p)
 					*bdev_p = bdgrab(sis->bdev);
@@ -1311,8 +1311,6 @@ sector_t map_swap_page(swp_entry_t entry
 			return se->start_block + (offset - se->start_page);
 		}
 		lh = se->list.next;
-		if (lh == &sis->extent_list)
-			lh = lh->next;
 		se = list_entry(lh, struct swap_extent, list);
 		sis->curr_swap_extent = se;
 		BUG_ON(se == start_se);		/* It *must* be present */
@@ -1341,10 +1339,10 @@ sector_t swapdev_block(int type, pgoff_t
  */
 static void destroy_swap_extents(struct swap_info_struct *sis)
 {
-	while (!list_empty(&sis->extent_list)) {
+	while (!list_empty(&sis->first_swap_extent.list)) {
 		struct swap_extent *se;
 
-		se = list_entry(sis->extent_list.next,
+		se = list_entry(sis->first_swap_extent.list.next,
 				struct swap_extent, list);
 		list_del(&se->list);
 		kfree(se);
@@ -1365,8 +1363,16 @@ add_swap_extent(struct swap_info_struct 
 	struct swap_extent *new_se;
 	struct list_head *lh;
 
-	lh = sis->extent_list.prev;	/* The highest page extent */
-	if (lh != &sis->extent_list) {
+	if (start_page == 0) {
+		se = &sis->first_swap_extent;
+		sis->curr_swap_extent = se;
+		INIT_LIST_HEAD(&se->list);
+		se->start_page = 0;
+		se->nr_pages = nr_pages;
+		se->start_block = start_block;
+		return 1;
+	} else {
+		lh = sis->first_swap_extent.list.prev;	/* Highest extent */
 		se = list_entry(lh, struct swap_extent, list);
 		BUG_ON(se->start_page + se->nr_pages != start_page);
 		if (se->start_block + se->nr_pages == start_block) {
@@ -1386,7 +1392,7 @@ add_swap_extent(struct swap_info_struct 
 	new_se->nr_pages = nr_pages;
 	new_se->start_block = start_block;
 
-	list_add_tail(&new_se->list, &sis->extent_list);
+	list_add_tail(&new_se->list, &sis->first_swap_extent.list);
 	return 1;
 }
 
@@ -1438,7 +1444,7 @@ static int setup_swap_extents(struct swa
 	if (S_ISBLK(inode->i_mode)) {
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
-		goto done;
+		goto out;
 	}
 
 	blkbits = inode->i_blkbits;
@@ -1509,15 +1515,12 @@ reprobe:
 	sis->max = page_no;
 	sis->pages = page_no - 1;
 	sis->highest_bit = page_no - 1;
-done:
-	sis->curr_swap_extent = list_entry(sis->extent_list.prev,
-					struct swap_extent, list);
-	goto out;
+out:
+	return ret;
 bad_bmap:
 	printk(KERN_ERR "swapon: swapfile has holes\n");
 	ret = -EINVAL;
-out:
-	return ret;
+	goto out;
 }
 
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
@@ -1816,7 +1819,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		kfree(p);
 		goto out;
 	}
-	INIT_LIST_HEAD(&p->extent_list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
hwpoison-fix-oops-on-ksm-pages.patch
hwpoison-fix-proc-meminfo-alignment.patch
vmscan-limit-vm_exec-protection-to-file-pages.patch
mm-order-evictable-rescue-in-lru-putback.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap.patch
mmap-dont-return-enomem-when-mapcount-is-temporarily-exceeded-in-munmap-checkpatch-fixes.patch
vmalloc-adjust-gfp-mask-passed-on-nested-vmalloc-invocation.patch
swap_info-private-to-swapfilec.patch
swap_info-change-to-array-of-pointers.patch
swap_info-include-first_swap_extent.patch
swap_info-miscellaneous-minor-cleanups.patch
swap_info-swap_has_cache-cleanups.patch
swap_info-swap_map-of-chars-not-shorts.patch
swap_info-swap-count-continuations.patch
swap_info-note-swap_map_shmem.patch
swap_info-reorder-its-fields.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

