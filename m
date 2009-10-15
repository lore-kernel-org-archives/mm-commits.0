From: akpm@linux-foundation.org
Subject: + swap_info-private-to-swapfilec.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:45:32 -0700
Message-ID: <200910151945.n9FJjWul024800@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935319AbZJOTqs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, ncunningham@crca.org.au, riel@redhat.com


The patch titled
     swap_info: private to swapfile.c
has been added to the -mm tree.  Its filename is
     swap_info-private-to-swapfilec.patch

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
Subject: swap_info: private to swapfile.c
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

The swap_info_struct is mostly private to mm/swapfile.c, with only
one other in-tree user: get_swap_bio().  Adjust its interface to
map_swap_page(), so that we can then remove get_swap_info_struct().

But there is a popular user out-of-tree, TuxOnIce: so leave the
declaration of swap_info_struct in linux/swap.h.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Nigel Cunningham <ncunningham@crca.org.au>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/swap.h~swap_info-private-to-swapfilec include/linux/swap.h
--- a/include/linux/swap.h~swap_info-private-to-swapfilec
+++ a/include/linux/swap.h
@@ -318,9 +318,8 @@ extern void swapcache_free(swp_entry_t, 
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
-extern sector_t map_swap_page(struct swap_info_struct *, pgoff_t);
+extern sector_t map_swap_page(swp_entry_t, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
-extern struct swap_info_struct *get_swap_info_struct(unsigned);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
 struct backing_dev_info;
diff -puN mm/page_io.c~swap_info-private-to-swapfilec mm/page_io.c
--- a/mm/page_io.c~swap_info-private-to-swapfilec
+++ a/mm/page_io.c
@@ -19,20 +19,17 @@
 #include <linux/writeback.h>
 #include <asm/pgtable.h>
 
-static struct bio *get_swap_bio(gfp_t gfp_flags, pgoff_t index,
+static struct bio *get_swap_bio(gfp_t gfp_flags,
 				struct page *page, bio_end_io_t end_io)
 {
 	struct bio *bio;
 
 	bio = bio_alloc(gfp_flags, 1);
 	if (bio) {
-		struct swap_info_struct *sis;
-		swp_entry_t entry = { .val = index, };
-
-		sis = get_swap_info_struct(swp_type(entry));
-		bio->bi_sector = map_swap_page(sis, swp_offset(entry)) *
-					(PAGE_SIZE >> 9);
-		bio->bi_bdev = sis->bdev;
+		swp_entry_t entry;
+		entry.val = page_private(page);
+		bio->bi_sector = map_swap_page(entry, &bio->bi_bdev);
+		bio->bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_io_vec[0].bv_page = page;
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
 		bio->bi_io_vec[0].bv_offset = 0;
@@ -102,8 +99,7 @@ int swap_writepage(struct page *page, st
 		unlock_page(page);
 		goto out;
 	}
-	bio = get_swap_bio(GFP_NOIO, page_private(page), page,
-				end_swap_bio_write);
+	bio = get_swap_bio(GFP_NOIO, page, end_swap_bio_write);
 	if (bio == NULL) {
 		set_page_dirty(page);
 		unlock_page(page);
@@ -127,8 +123,7 @@ int swap_readpage(struct page *page)
 
 	VM_BUG_ON(!PageLocked(page));
 	VM_BUG_ON(PageUptodate(page));
-	bio = get_swap_bio(GFP_KERNEL, page_private(page), page,
-				end_swap_bio_read);
+	bio = get_swap_bio(GFP_KERNEL, page, end_swap_bio_read);
 	if (bio == NULL) {
 		unlock_page(page);
 		ret = -ENOMEM;
diff -puN mm/swapfile.c~swap_info-private-to-swapfilec mm/swapfile.c
--- a/mm/swapfile.c~swap_info-private-to-swapfilec
+++ a/mm/swapfile.c
@@ -1284,12 +1284,22 @@ static void drain_mmlist(void)
 
 /*
  * Use this swapdev's extent info to locate the (PAGE_SIZE) block which
- * corresponds to page offset `offset'.
+ * corresponds to page offset `offset'.  Note that the type of this function
+ * is sector_t, but it returns page offset into the bdev, not sector offset.
  */
-sector_t map_swap_page(struct swap_info_struct *sis, pgoff_t offset)
+sector_t map_swap_page(swp_entry_t entry, struct block_device **bdev)
 {
-	struct swap_extent *se = sis->curr_swap_extent;
-	struct swap_extent *start_se = se;
+	struct swap_info_struct *sis;
+	struct swap_extent *start_se;
+	struct swap_extent *se;
+	pgoff_t offset;
+
+	sis = swap_info + swp_type(entry);
+	*bdev = sis->bdev;
+
+	offset = swp_offset(entry);
+	start_se = sis->curr_swap_extent;
+	se = start_se;
 
 	for ( ; ; ) {
 		struct list_head *lh;
@@ -1315,12 +1325,14 @@ sector_t map_swap_page(struct swap_info_
 sector_t swapdev_block(int swap_type, pgoff_t offset)
 {
 	struct swap_info_struct *sis;
+	struct block_device *bdev;
 
 	if (swap_type >= nr_swapfiles)
 		return 0;
 
 	sis = swap_info + swap_type;
-	return (sis->flags & SWP_WRITEOK) ? map_swap_page(sis, offset) : 0;
+	return (sis->flags & SWP_WRITEOK) ?
+		map_swap_page(swp_entry(swap_type, offset), &bdev) : 0;
 }
 #endif /* CONFIG_HIBERNATION */
 
@@ -2160,13 +2172,6 @@ int swapcache_prepare(swp_entry_t entry)
 	return __swap_duplicate(entry, SWAP_CACHE);
 }
 
-
-struct swap_info_struct *
-get_swap_info_struct(unsigned type)
-{
-	return &swap_info[type];
-}
-
 /*
  * swap_lock prevents swap_map being freed. Don't grab an extra
  * reference on the swaphandle, it doesn't matter if it becomes unused.
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

