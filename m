From: akpm@linux-foundation.org
Subject: + tmpfs-avoid-a-little-creat-and-stat-slowdown.patch added to -mm tree
Date: Thu, 05 Nov 2015 02:39:13 -0800
Message-ID: <563b31d1.RX7lwtNac+RdB9b4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57171 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031853AbbKEKjP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Nov 2015 05:39:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, jbacik@fb.com, ying.huang@linux.intel.com, yuzhao@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tmpfs: avoid a little creat and stat slowdown
has been added to the -mm tree.  Its filename is
     tmpfs-avoid-a-little-creat-and-stat-slowdown.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tmpfs-avoid-a-little-creat-and-stat-slowdown.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tmpfs-avoid-a-little-creat-and-stat-slowdown.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: tmpfs: avoid a little creat and stat slowdown

LKP reports that v4.2 commit afa2db2fb6f1 ("tmpfs: truncate prealloc
blocks past i_size") causes a 14.5% slowdown in the AIM9 creat-clo
benchmark.

creat-clo does just what you'd expect from the name, and creat's O_TRUNC
on 0-length file does indeed get into more overhead now shmem_setattr()
tests "0 <= 0" instead of "0 < 0".

I'm not sure how much we care, but I think it would not be too VW-like to
add in a check for whether any pages (or swap) are allocated: if none are
allocated, there's none to remove from the radix_tree.  At first I thought
that check would be good enough for the unmaps too, but no: we should not
skip the unlikely case of unmapping pages beyond the new EOF, which were
COWed from holes which have now been reclaimed, leaving none.

This gives me an 8.5% speedup: on Haswell instead of LKP's Westmere, and
running a debug config before and after: I hope those account for the
lesser speedup.

And probably someone has a benchmark where a thousand threads keep on
stat'ing the same file repeatedly: forestall that report by adjusting v4.3
commit 44a30220bc0a ("shmem: recalculate file inode when fstat") not to
take the spinlock in shmem_getattr() when there's no work to do.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Ying Huang <ying.huang@linux.intel.com>
Tested-by: Ying Huang <ying.huang@linux.intel.com>
Cc: Josef Bacik <jbacik@fb.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff -puN mm/shmem.c~tmpfs-avoid-a-little-creat-and-stat-slowdown mm/shmem.c
--- a/mm/shmem.c~tmpfs-avoid-a-little-creat-and-stat-slowdown
+++ a/mm/shmem.c
@@ -550,12 +550,12 @@ static int shmem_getattr(struct vfsmount
 	struct inode *inode = dentry->d_inode;
 	struct shmem_inode_info *info = SHMEM_I(inode);
 
-	spin_lock(&info->lock);
-	shmem_recalc_inode(inode);
-	spin_unlock(&info->lock);
-
+	if (info->alloced - info->swapped != inode->i_mapping->nrpages) {
+		spin_lock(&info->lock);
+		shmem_recalc_inode(inode);
+		spin_unlock(&info->lock);
+	}
 	generic_fillattr(inode, stat);
-
 	return 0;
 }
 
@@ -588,10 +588,16 @@ static int shmem_setattr(struct dentry *
 		}
 		if (newsize <= oldsize) {
 			loff_t holebegin = round_up(newsize, PAGE_SIZE);
-			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
-			shmem_truncate_range(inode, newsize, (loff_t)-1);
+			if (oldsize > holebegin)
+				unmap_mapping_range(inode->i_mapping,
+							holebegin, 0, 1);
+			if (info->alloced)
+				shmem_truncate_range(inode,
+							newsize, (loff_t)-1);
 			/* unmap again to remove racily COWed private pages */
-			unmap_mapping_range(inode->i_mapping, holebegin, 0, 1);
+			if (oldsize > holebegin)
+				unmap_mapping_range(inode->i_mapping,
+							holebegin, 0, 1);
 		}
 	}
 
_

Patches currently in -mm which might be from hughd@google.com are

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
tmpfs-avoid-a-little-creat-and-stat-slowdown.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

