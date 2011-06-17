From: akpm@linux-foundation.org
Subject: + tmpfs-simplify-prealloc_page.patch added to -mm tree
Date: Fri, 17 Jun 2011 16:39:36 -0700
Message-ID: <201106172339.p5HNdacU008226@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35060 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758044Ab1FQXjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Jun 2011 19:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, shaohua.li@intel.com, tim.c.chen@linux.intel.com, yanmin.zhang@intel.com


The patch titled
     tmpfs: simplify prealloc_page
has been added to the -mm tree.  Its filename is
     tmpfs-simplify-prealloc_page.patch

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
Subject: tmpfs: simplify prealloc_page
From: Hugh Dickins <hughd@google.com>

The prealloc_page handling in shmem_getpage_gfp() is unnecessarily
complicated: first simplify that before going on to filepage/swappage.

That's right, don't report ENOMEM when the preallocation fails: we may or
may not need the page.  But simply report ENOMEM once we find we do need
it, instead of dropping lock, repeating allocation, unwinding on failure
etc.  And leave the out label on the fast path, don't goto.

Fix something that looks like a bug but turns out not to be: set
PageSwapBacked on prealloc_page before its mem_cgroup_cache_charge(), as
the removed case was doing.  That's important before adding to LRU
(determines which LRU the page goes on), and does affect which path it
takes through memcontrol.c, but in the end MEM_CGROUP_CHANGE_TYPE_ SHMEM
is handled no differently from CACHE.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Shaohua Li <shaohua.li@intel.com>
Cc: "Zhang, Yanmin" <yanmin.zhang@intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   60 +++++++++++++--------------------------------------
 1 file changed, 16 insertions(+), 44 deletions(-)

diff -puN mm/shmem.c~tmpfs-simplify-prealloc_page mm/shmem.c
--- a/mm/shmem.c~tmpfs-simplify-prealloc_page
+++ a/mm/shmem.c
@@ -1269,9 +1269,9 @@ repeat:
 			goto failed;
 		radix_tree_preload_end();
 		if (sgp != SGP_READ && !prealloc_page) {
-			/* We don't care if this fails */
 			prealloc_page = shmem_alloc_page(gfp, info, idx);
 			if (prealloc_page) {
+				SetPageSwapBacked(prealloc_page);
 				if (mem_cgroup_cache_charge(prealloc_page,
 						current->mm, GFP_KERNEL)) {
 					page_cache_release(prealloc_page);
@@ -1403,7 +1403,8 @@ repeat:
 			goto repeat;
 		}
 		spin_unlock(&info->lock);
-	} else {
+
+	} else if (prealloc_page) {
 		shmem_swp_unmap(entry);
 		sbinfo = SHMEM_SB(inode->i_sb);
 		if (sbinfo->max_blocks) {
@@ -1419,41 +1420,8 @@ repeat:
 		if (!filepage) {
 			int ret;
 
-			if (!prealloc_page) {
-				spin_unlock(&info->lock);
-				filepage = shmem_alloc_page(gfp, info, idx);
-				if (!filepage) {
-					spin_lock(&info->lock);
-					shmem_unacct_blocks(info->flags, 1);
-					shmem_free_blocks(inode, 1);
-					spin_unlock(&info->lock);
-					error = -ENOMEM;
-					goto failed;
-				}
-				SetPageSwapBacked(filepage);
-
-				/*
-				 * Precharge page while we can wait, compensate
-				 * after
-				 */
-				error = mem_cgroup_cache_charge(filepage,
-					current->mm, GFP_KERNEL);
-				if (error) {
-					page_cache_release(filepage);
-					spin_lock(&info->lock);
-					shmem_unacct_blocks(info->flags, 1);
-					shmem_free_blocks(inode, 1);
-					spin_unlock(&info->lock);
-					filepage = NULL;
-					goto failed;
-				}
-
-				spin_lock(&info->lock);
-			} else {
-				filepage = prealloc_page;
-				prealloc_page = NULL;
-				SetPageSwapBacked(filepage);
-			}
+			filepage = prealloc_page;
+			prealloc_page = NULL;
 
 			entry = shmem_swp_alloc(info, idx, sgp, gfp);
 			if (IS_ERR(entry))
@@ -1492,11 +1460,20 @@ repeat:
 		SetPageUptodate(filepage);
 		if (sgp == SGP_DIRTY)
 			set_page_dirty(filepage);
+	} else {
+		spin_unlock(&info->lock);
+		error = -ENOMEM;
+		goto out;
 	}
 done:
 	*pagep = filepage;
 	error = 0;
-	goto out;
+out:
+	if (prealloc_page) {
+		mem_cgroup_uncharge_cache_page(prealloc_page);
+		page_cache_release(prealloc_page);
+	}
+	return error;
 
 nospace:
 	/*
@@ -1520,12 +1497,7 @@ failed:
 		unlock_page(filepage);
 		page_cache_release(filepage);
 	}
-out:
-	if (prealloc_page) {
-		mem_cgroup_uncharge_cache_page(prealloc_page);
-		page_cache_release(prealloc_page);
-	}
-	return error;
+	goto out;
 }
 
 static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
drm-i915-more-struct_mutex-locking-fix.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
linux-next.patch
tmpfs-clone-shmem_file_splice_read.patch
tmpfs-refine-shmem_file_splice_read.patch
tmpfs-pass-gfp-to-shmem_getpage_gfp.patch
tmpfs-remove_shmem_readpage.patch
tmpfs-simplify-prealloc_page.patch
tmpfs-simplify-filepage-swappage.patch
tmpfs-simplify-unuse-and-writepage.patch
radix_tree-exceptional-entries-and-indices.patch
mm-let-swap-use-exceptional-entries.patch
tmpfs-demolish-old-swap-vector-support.patch
tmpfs-miscellaneous-trivial-cleanups.patch
tmpfs-copy-truncate_inode_pages_range.patch
tmpfs-convert-shmem_truncate_range-to-radix-swap.patch
tmpfs-convert-shmem_unuse_inode-to-radix-swap.patch
tmpfs-convert-shmem_getpage_gfp-to-radix-swap.patch
tmpfs-convert-mem_cgroup-shmem-to-radix-swap.patch
tmpfs-convert-shmem_writepage-and-enable-swap.patch
tmpfs-use-kmemdup-for-short-symlinks.patch
mm-a-few-small-updates-for-radix-swap.patch
prio_tree-debugging-patch.patch

