From: akpm@linux-foundation.org
Subject: [merged] swap-rework-map_swap_page-again.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:00 -0800
Message-ID: <200912152152.nBFLq0n1015152@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41432 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933877AbZLOWOM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:14:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     swap: rework map_swap_page() again
has been removed from the -mm tree.  Its filename was
     swap-rework-map_swap_page-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap: rework map_swap_page() again
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Seems that page_io.c doesn't really need to know that page_private(page)
is the swp_entry 'val'.  Rework map_swap_page() to do what its name says
and map a page to a page offset in the swap space.

The only other caller of map_swap_page() is internal to mm/swapfile.c and
it does want to map a swap entry to the 'sector'.  So rename
map_swap_page() to map_swap_entry(), make it 'static' and and implement
map_swap_page() as a wrapper around that.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 mm/page_io.c         |    4 +---
 mm/swapfile.c        |   20 ++++++++++++++++----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff -puN include/linux/swap.h~swap-rework-map_swap_page-again include/linux/swap.h
--- a/include/linux/swap.h~swap-rework-map_swap_page-again
+++ a/include/linux/swap.h
@@ -325,7 +325,7 @@ extern void swapcache_free(swp_entry_t, 
 extern int free_swap_and_cache(swp_entry_t);
 extern int swap_type_of(dev_t, sector_t, struct block_device **);
 extern unsigned int count_swap_pages(int, int);
-extern sector_t map_swap_page(swp_entry_t, struct block_device **);
+extern sector_t map_swap_page(struct page *, struct block_device **);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int reuse_swap_page(struct page *);
 extern int try_to_free_swap(struct page *);
diff -puN mm/page_io.c~swap-rework-map_swap_page-again mm/page_io.c
--- a/mm/page_io.c~swap-rework-map_swap_page-again
+++ a/mm/page_io.c
@@ -26,9 +26,7 @@ static struct bio *get_swap_bio(gfp_t gf
 
 	bio = bio_alloc(gfp_flags, 1);
 	if (bio) {
-		swp_entry_t entry;
-		entry.val = page_private(page);
-		bio->bi_sector = map_swap_page(entry, &bio->bi_bdev);
+		bio->bi_sector = map_swap_page(page, &bio->bi_bdev);
 		bio->bi_sector <<= PAGE_SHIFT - 9;
 		bio->bi_io_vec[0].bv_page = page;
 		bio->bi_io_vec[0].bv_len = PAGE_SIZE;
diff -puN mm/swapfile.c~swap-rework-map_swap_page-again mm/swapfile.c
--- a/mm/swapfile.c~swap-rework-map_swap_page-again
+++ a/mm/swapfile.c
@@ -38,6 +38,7 @@
 static bool swap_count_continued(struct swap_info_struct *, pgoff_t,
 				 unsigned char);
 static void free_swap_count_continuations(struct swap_info_struct *);
+static sector_t map_swap_entry(swp_entry_t, struct block_device**);
 
 static DEFINE_SPINLOCK(swap_lock);
 static unsigned int nr_swapfiles;
@@ -782,7 +783,7 @@ sector_t swapdev_block(int type, pgoff_t
 		return 0;
 	if (!(swap_info[type]->flags & SWP_WRITEOK))
 		return 0;
-	return map_swap_page(swp_entry(type, offset), &bdev);
+	return map_swap_entry(swp_entry(type, offset), &bdev);
 }
 
 /*
@@ -1249,10 +1250,11 @@ static void drain_mmlist(void)
 
 /*
  * Use this swapdev's extent info to locate the (PAGE_SIZE) block which
- * corresponds to page offset `offset'.  Note that the type of this function
- * is sector_t, but it returns page offset into the bdev, not sector offset.
+ * corresponds to page offset for the specified swap entry.
+ * Note that the type of this function is sector_t, but it returns page offset
+ * into the bdev, not sector offset.
  */
-sector_t map_swap_page(swp_entry_t entry, struct block_device **bdev)
+static sector_t map_swap_entry(swp_entry_t entry, struct block_device **bdev)
 {
 	struct swap_info_struct *sis;
 	struct swap_extent *start_se;
@@ -1281,6 +1283,16 @@ sector_t map_swap_page(swp_entry_t entry
 }
 
 /*
+ * Returns the page offset into bdev for the specified page's swap entry.
+ */
+sector_t map_swap_page(struct page *page, struct block_device **bdev)
+{
+	swp_entry_t entry;
+	entry.val = page_private(page);
+	return map_swap_entry(entry, bdev);
+}
+
+/*
  * Free all of a swapdev's extent information
  */
 static void destroy_swap_extents(struct swap_info_struct *sis)
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
acpi-remove-nid_inval.patch

