From: akpm@linux-foundation.org
Subject: - shmem_getpage-return-page-locked.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:07 -0800
Message-ID: <200802052229.m15MTmAh012010@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40773 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762679AbYBEWoD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:44:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     shmem_getpage return page locked
has been removed from the -mm tree.  Its filename was
     shmem_getpage-return-page-locked.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

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
@@ -1286,12 +1288,7 @@ repeat:
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
@@ -1469,12 +1466,13 @@ shmem_write_end(struct file *file, struc
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
 
@@ -1529,6 +1527,7 @@ shmem_file_write(struct file *file, cons
 		if (err)
 			break;
 
+		unlock_page(page);
 		left = bytes;
 		if (PageHighMem(page)) {
 			volatile unsigned char dummy;
@@ -1610,6 +1609,8 @@ static void do_shmem_file_read(struct fi
 				desc->error = 0;
 			break;
 		}
+		if (page)
+			unlock_page(page);
 
 		/*
 		 * We must evaluate after, since reads (unlike writes)
@@ -1899,6 +1900,7 @@ static int shmem_symlink(struct inode *d
 			iput(inode);
 			return error;
 		}
+		unlock_page(page);
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
@@ -1926,6 +1928,8 @@ static void *shmem_follow_link(struct de
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
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
