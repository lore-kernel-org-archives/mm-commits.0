From: akpm@linux-foundation.org
Subject: + tmpfs-no-need-to-use-i_lock.patch added to -mm tree
Date: Thu, 09 Jun 2011 15:42:46 -0700
Message-ID: <201106092242.p59MgkPO005076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53251 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756994Ab1FIWnU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Jun 2011 18:43:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, tim.c.chen@linux.intel.com


The patch titled
     tmpfs: no need to use i_lock
has been added to the -mm tree.  Its filename is
     tmpfs-no-need-to-use-i_lock.patch

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
Subject: tmpfs: no need to use i_lock
From: Hugh Dickins <hughd@google.com>

2.6.36's 7e496299d4d2 ("tmpfs: make tmpfs scalable with percpu_counter for
used blocks") to make tmpfs scalable with percpu_counter used
inode->i_lock in place of sbinfo->stat_lock around i_blocks updates; but
that was adverse to scalability, and unnecessary, since info->lock is
already held there in the fast paths.

Remove those uses of i_lock, and add info->lock in the three error paths
where it's then needed across shmem_free_blocks().  It's not actually
needed across shmem_unacct_blocks(), but they're so often paired that it
looks wrong to split them apart.

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/shmem.c~tmpfs-no-need-to-use-i_lock mm/shmem.c
--- a/mm/shmem.c~tmpfs-no-need-to-use-i_lock
+++ a/mm/shmem.c
@@ -241,9 +241,7 @@ static void shmem_free_blocks(struct ino
 	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	if (sbinfo->max_blocks) {
 		percpu_counter_add(&sbinfo->used_blocks, -pages);
-		spin_lock(&inode->i_lock);
 		inode->i_blocks -= pages*BLOCKS_PER_PAGE;
-		spin_unlock(&inode->i_lock);
 	}
 }
 
@@ -432,9 +430,7 @@ static swp_entry_t *shmem_swp_alloc(stru
 						sbinfo->max_blocks - 1) >= 0)
 				return ERR_PTR(-ENOSPC);
 			percpu_counter_inc(&sbinfo->used_blocks);
-			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&inode->i_lock);
 		}
 
 		spin_unlock(&info->lock);
@@ -1421,9 +1417,7 @@ repeat:
 			    shmem_acct_block(info->flags))
 				goto nospace;
 			percpu_counter_inc(&sbinfo->used_blocks);
-			spin_lock(&inode->i_lock);
 			inode->i_blocks += BLOCKS_PER_PAGE;
-			spin_unlock(&inode->i_lock);
 		} else if (shmem_acct_block(info->flags))
 			goto nospace;
 
@@ -1434,8 +1428,10 @@ repeat:
 				spin_unlock(&info->lock);
 				filepage = shmem_alloc_page(gfp, info, idx);
 				if (!filepage) {
+					spin_lock(&info->lock);
 					shmem_unacct_blocks(info->flags, 1);
 					shmem_free_blocks(inode, 1);
+					spin_unlock(&info->lock);
 					error = -ENOMEM;
 					goto failed;
 				}
@@ -1449,8 +1445,10 @@ repeat:
 					current->mm, GFP_KERNEL);
 				if (error) {
 					page_cache_release(filepage);
+					spin_lock(&info->lock);
 					shmem_unacct_blocks(info->flags, 1);
 					shmem_free_blocks(inode, 1);
+					spin_unlock(&info->lock);
 					filepage = NULL;
 					goto failed;
 				}
@@ -1480,10 +1478,10 @@ repeat:
 			 * be done automatically.
 			 */
 			if (ret) {
-				spin_unlock(&info->lock);
-				page_cache_release(filepage);
 				shmem_unacct_blocks(info->flags, 1);
 				shmem_free_blocks(inode, 1);
+				spin_unlock(&info->lock);
+				page_cache_release(filepage);
 				filepage = NULL;
 				if (error)
 					goto failed;
_

Patches currently in -mm which might be from hughd@google.com are

mm-fix-wrong-kunmap_atomic-pointer.patch
mm-migratec-dont-account-swapcache-as-shmem.patch
linux-next.patch
mm-move-vmtruncate_range-to-truncatec.patch
mm-move-shmem-prototypes-to-shmem_fsh.patch
tmpfs-take-control-of-its-truncate_range.patch
tmpfs-add-shmem_read_mapping_page_gfp.patch
drm-ttm-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_read_mapping_page.patch
drm-i915-use-shmem_truncate_range.patch
drm-i915-more-struct_mutex-locking.patch
mm-cleanup-descriptions-of-filler-arg.patch
mm-truncate-functions-are-in-truncatec.patch
mm-tidy-vmtruncate_range-and-related-functions.patch
mm-consistent-truncate-and-invalidate-loops.patch
mm-pincer-in-truncate_inode_pages_range.patch
tmpfs-no-need-to-use-i_lock.patch
prio_tree-debugging-patch.patch

