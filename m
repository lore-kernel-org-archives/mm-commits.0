From: akpm@linux-foundation.org
Subject: [merged] swap_info-miscellaneous-minor-cleanups.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:51:42 -0800
Message-ID: <200912152151.nBFLpgKW015127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36982 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755768AbZLOWR2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:17:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     swap_info: miscellaneous minor cleanups
has been removed from the -mm tree.  Its filename was
     swap_info-miscellaneous-minor-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swap_info: miscellaneous minor cleanups
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Move CONFIG_HIBERNATION's swapdev_block() into the main CONFIG_HIBERNATION
block, remove extraneous whitespace and return, fix typo in a comment.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   51 ++++++++++++++++++++++--------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff -puN mm/swapfile.c~swap_info-miscellaneous-minor-cleanups mm/swapfile.c
--- a/mm/swapfile.c~swap_info-miscellaneous-minor-cleanups
+++ a/mm/swapfile.c
@@ -519,9 +519,9 @@ swp_entry_t get_swap_page_of_type(int ty
 	return (swp_entry_t) {0};
 }
 
-static struct swap_info_struct * swap_info_get(swp_entry_t entry)
+static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	unsigned long offset, type;
 
 	if (!entry.val)
@@ -599,7 +599,7 @@ static int swap_entry_free(struct swap_i
  */
 void swap_free(swp_entry_t entry)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 
 	p = swap_info_get(entry);
 	if (p) {
@@ -629,7 +629,6 @@ void swapcache_free(swp_entry_t entry, s
 		}
 		spin_unlock(&swap_lock);
 	}
-	return;
 }
 
 /*
@@ -783,6 +782,21 @@ int swap_type_of(dev_t device, sector_t 
 }
 
 /*
+ * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
+ * corresponding to given index in swap_info (swap type).
+ */
+sector_t swapdev_block(int type, pgoff_t offset)
+{
+	struct block_device *bdev;
+
+	if ((unsigned int)type >= nr_swapfiles)
+		return 0;
+	if (!(swap_info[type]->flags & SWP_WRITEOK))
+		return 0;
+	return map_swap_page(swp_entry(type, offset), &bdev);
+}
+
+/*
  * Return either the total number of swap pages of given type, or the number
  * of free pages of that type (depending on @free)
  *
@@ -805,7 +819,7 @@ unsigned int count_swap_pages(int type, 
 	spin_unlock(&swap_lock);
 	return n;
 }
-#endif
+#endif /* CONFIG_HIBERNATION */
 
 /*
  * No need to decide whether this PTE shares the swap entry with others,
@@ -1316,23 +1330,6 @@ sector_t map_swap_page(swp_entry_t entry
 	}
 }
 
-#ifdef CONFIG_HIBERNATION
-/*
- * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
- * corresponding to given index in swap_info (swap type).
- */
-sector_t swapdev_block(int type, pgoff_t offset)
-{
-	struct block_device *bdev;
-
-	if ((unsigned int)type >= nr_swapfiles)
-		return 0;
-	if (!(swap_info[type]->flags & SWP_WRITEOK))
-		return 0;
-	return map_swap_page(swp_entry(type, offset), &bdev);
-}
-#endif /* CONFIG_HIBERNATION */
-
 /*
  * Free all of a swapdev's extent information
  */
@@ -1523,12 +1520,12 @@ bad_bmap:
 
 SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 {
-	struct swap_info_struct * p = NULL;
+	struct swap_info_struct *p = NULL;
 	unsigned short *swap_map;
 	struct file *swap_file, *victim;
 	struct address_space *mapping;
 	struct inode *inode;
-	char * pathname;
+	char *pathname;
 	int i, type, prev;
 	int err;
 
@@ -1780,7 +1777,7 @@ late_initcall(max_swapfiles_check);
  */
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	char *name = NULL;
 	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
@@ -2116,7 +2113,7 @@ void si_swapinfo(struct sysinfo *val)
  */
 static int __swap_duplicate(swp_entry_t entry, bool cache)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	unsigned long offset, type;
 	int result = -EINVAL;
 	int count;
@@ -2185,7 +2182,7 @@ void swap_duplicate(swp_entry_t entry)
 /*
  * @entry: swap entry for which we allocate swap cache.
  *
- * Called when allocating swap cache for exising swap entry,
+ * Called when allocating swap cache for existing swap entry,
  * This can return error codes. Returns 0 at success.
  * -EBUSY means there is a swap cache.
  * Note: return code is different from swap_duplicate().
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

