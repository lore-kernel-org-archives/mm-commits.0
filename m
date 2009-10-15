From: akpm@linux-foundation.org
Subject: + swap_info-miscellaneous-minor-cleanups.patch added to -mm tree
Date: Thu, 15 Oct 2009 12:45:45 -0700
Message-ID: <200910151945.n9FJjjko025273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34029 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935351AbZJOTq5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 15:46:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com


The patch titled
     swap_info: miscellaneous minor cleanups
has been added to the -mm tree.  Its filename is
     swap_info-miscellaneous-minor-cleanups.patch

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
Subject: swap_info: miscellaneous minor cleanups
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Move CONFIG_MIGRATION's swapdev_block() into the main CONFIG_MIGRATION
block, remove extraneous whitespace and return, fix typo in a comment.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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
@@ -1317,23 +1331,6 @@ sector_t map_swap_page(swp_entry_t entry
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
@@ -1525,12 +1522,12 @@ bad_bmap:
 
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
 
@@ -1782,7 +1779,7 @@ late_initcall(max_swapfiles_check);
  */
 SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	char *name = NULL;
 	struct block_device *bdev = NULL;
 	struct file *swap_file = NULL;
@@ -2117,7 +2114,7 @@ void si_swapinfo(struct sysinfo *val)
  */
 static int __swap_duplicate(swp_entry_t entry, bool cache)
 {
-	struct swap_info_struct * p;
+	struct swap_info_struct *p;
 	unsigned long offset, type;
 	int result = -EINVAL;
 	int count;
@@ -2186,7 +2183,7 @@ void swap_duplicate(swp_entry_t entry)
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

