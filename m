From: akpm@linux-foundation.org
Subject: + shmem_getpage-return-page-locked.patch added to -mm tree
Date: Mon, 22 Oct 2007 15:13:45 -0700
Message-ID: <200710222213.l9MMDj0u017646@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46500 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbXJVWOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Oct 2007 18:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com


The patch titled
     shmem_getpage return page locked
has been added to the -mm tree.  Its filename is
     shmem_getpage-return-page-locked.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: shmem_getpage return page locked
From: Hugh Dickins <hugh@veritas.com>

In the new aops, write_begin is supposed to return the page locked: though
I've seen no ill effects, that's been overlooked in the case of
shmem_write_begin, and should be fixed.  Then shmem_write_end must unlock the
page: do so _after_ updating i_size, as we found to be important in other
filesystems (though since shmem pages don't go the usual writeback route, they
never suffered from that corruption).

For shmem_write_begin to return the page locked, we need shmem_getpage to
return the page locked in SGP_WRITE case as well as SGP_CACHE case: let's
simplify the interface and return it locked even when SGP_READ.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff -puN mm/shmem.c~shmem_getpage-return-page-locked mm/shmem.c
--- a/mm/shmem.c~shmem_getpage-return-page-locked
+++ a/mm/shmem.c
@@ -729,6 +729,8 @@ static int shmem_notify_change(struct de
 				(void) shmem_getpage(inode,
 					attr->ia_size>>PAGE_CACHE_SHIFT,
 						&page, SGP_READ, NULL);
+				if (page)
+					unlock_page(page);
 			}
 			/*
 			 * Reset SHMEM_PAGEIN flag so that shmem_truncate can
@@ -1270,12 +1272,7 @@ repeat:
 		SetPageUptodate(filepage);
 	}
 done:
-	if (*pagep != filepage) {
-		*pagep = filepage;
-		if (sgp != SGP_CACHE)
-			unlock_page(filepage);
-
-	}
+	*pagep = filepage;
 	return 0;
 
 failed:
@@ -1453,12 +1450,13 @@ shmem_write_end(struct file *file, struc
 {
 	struct inode *inode = mapping->host;
 
+	if (pos + copied > inode->i_size)
+		i_size_write(inode, pos + copied);
+
+	unlock_page(page);
 	set_page_dirty(page);
 	page_cache_release(page);
 
-	if (pos+copied > inode->i_size)
-		i_size_write(inode, pos+copied);
-
 	return copied;
 }
 
@@ -1513,6 +1511,7 @@ shmem_file_write(struct file *file, cons
 		if (err)
 			break;
 
+		unlock_page(page);
 		left = bytes;
 		if (PageHighMem(page)) {
 			volatile unsigned char dummy;
@@ -1594,6 +1593,8 @@ static void do_shmem_file_read(struct fi
 				desc->error = 0;
 			break;
 		}
+		if (page)
+			unlock_page(page);
 
 		/*
 		 * We must evaluate after, since reads (unlike writes)
@@ -1883,6 +1884,7 @@ static int shmem_symlink(struct inode *d
 			iput(inode);
 			return error;
 		}
+		unlock_page(page);
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
@@ -1910,6 +1912,8 @@ static void *shmem_follow_link(struct de
 	struct page *page = NULL;
 	int res = shmem_getpage(dentry->d_inode, 0, &page, SGP_READ, NULL);
 	nd_set_link(nd, res ? ERR_PTR(res) : kmap(page));
+	if (page)
+		unlock_page(page);
 	return page;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
exportfs-add-fid-type.patch
exportfs-add-new-methods.patch
shmem-new-export-ops.patch
exportfs-remove-old-methods.patch
exportfs-make-struct-export_operations-const.patch
exportfs-update-documentation.patch
fix-mprotect-vma_wants_writenotify-prot.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
