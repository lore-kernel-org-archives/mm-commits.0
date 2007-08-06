From: akpm@linux-foundation.org
Subject: + mm-clarify-__add_to_swap_cache-locking.patch added to -mm tree
Date: Mon, 06 Aug 2007 11:41:09 -0700
Message-ID: <200708061841.l76If9hI008836@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60314 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933208AbXHFSlY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Aug 2007 14:41:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, hugh@veritas.com


The patch titled
     mm: clarify __add_to_swap_cache locking
has been added to the -mm tree.  Its filename is
     mm-clarify-__add_to_swap_cache-locking.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: clarify __add_to_swap_cache locking
From: Nick Piggin <npiggin@suse.de>

__add_to_swap_cache unconditionally sets the page locked, which can be a bit
alarming to the unsuspecting reader: in the code paths where the page is
visible to other CPUs, the page should be (and is) already locked.

Instead, just add a check to ensure the page is locked here, and teach the one
path relying on the old behaviour to call SetPageLocked itself.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking mm/swap_state.c
--- a/mm/swap_state.c~mm-clarify-__add_to_swap_cache-locking
+++ a/mm/swap_state.c
@@ -74,6 +74,7 @@ static int __add_to_swap_cache(struct pa
 {
 	int error;
 
+	BUG_ON(!PageLocked(page));
 	BUG_ON(PageSwapCache(page));
 	BUG_ON(PagePrivate(page));
 	error = radix_tree_preload(gfp_mask);
@@ -83,7 +84,6 @@ static int __add_to_swap_cache(struct pa
 						entry.val, page);
 		if (!error) {
 			page_cache_get(page);
-			SetPageLocked(page);
 			SetPageSwapCache(page);
 			set_page_private(page, entry.val);
 			total_swapcache_pages++;
@@ -338,6 +338,7 @@ struct page *read_swap_cache_async(swp_e
 								vma, addr);
 			if (!new_page)
 				break;		/* Out of memory */
+			SetPageLocked(new_page);/* could be non-atomic op */
 		}
 
 		/*
@@ -361,7 +362,9 @@ struct page *read_swap_cache_async(swp_e
 		}
 	} while (err != -ENOENT && err != -ENOMEM);
 
-	if (new_page)
+	if (new_page) {
+		ClearPageLocked(new_page);
 		page_cache_release(new_page);
+	}
 	return found_page;
 }
_

Patches currently in -mm which might be from npiggin@suse.de are

remove-zero_page.patch
mm-use-lockless-radix-tree-probe.patch
mm-improve-find_lock_page.patch
mm-clarify-__add_to_swap_cache-locking.patch
radix-tree-use-indirect-bit.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
introduce-write_begin-write_end-aops-important-fix.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext2-convert-to-new-aops-fix.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-convert-to-new-aops-fix.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
hostfs-convert-to-new-aops-fix.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
ufs-convert-to-new-aops-fix.patch
udf-convert-to-new-aops.patch
udf-convert-to-new-aops-fix.patch
sysv-convert-to-new-aops.patch
sysv-convert-to-new-aops-fix.patch
minix-convert-to-new-aops.patch
minix-convert-to-new-aops-fix.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
affs-convert-to-new-aops-fix.patch
ocfs2-convert-to-new-aops.patch
fs-remove-some-aop_truncated_page.patch
fs-remove-some-aop_truncated_page-fix.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
