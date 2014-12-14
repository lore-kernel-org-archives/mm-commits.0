From: akpm@linux-foundation.org
Subject: [merged] mm-nommu-share-the-i_mmap_rwsem.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:06:41 -0800
Message-ID: <548d0cd1.8VL0nocBpm2skLhj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaLNEGd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     mm-nommu-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/nommu: share the i_mmap_rwsem

Shrinking/truncate logic can call nommu_shrink_inode_mappings() to verify
that any shared mappings of the inode in question aren't broken (dead
zone).  afaict the only user being ramfs to handle the size change
attribute.

Pretty much a no-brainer to share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN mm/nommu.c~mm-nommu-share-the-i_mmap_rwsem mm/nommu.c
--- a/mm/nommu.c~mm-nommu-share-the-i_mmap_rwsem
+++ a/mm/nommu.c
@@ -2094,14 +2094,14 @@ int nommu_shrink_inode_mappings(struct i
 	high = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	down_write(&nommu_region_sem);
-	i_mmap_lock_write(inode->i_mapping);
+	i_mmap_lock_read(inode->i_mapping);
 
 	/* search for VMAs that fall within the dead zone */
 	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, low, high) {
 		/* found one - only interested if it's shared out of the page
 		 * cache */
 		if (vma->vm_flags & VM_SHARED) {
-			i_mmap_unlock_write(inode->i_mapping);
+			i_mmap_unlock_read(inode->i_mapping);
 			up_write(&nommu_region_sem);
 			return -ETXTBSY; /* not quite true, but near enough */
 		}
@@ -2113,8 +2113,7 @@ int nommu_shrink_inode_mappings(struct i
 	 * we don't check for any regions that start beyond the EOF as there
 	 * shouldn't be any
 	 */
-	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap,
-				  0, ULONG_MAX) {
+	vma_interval_tree_foreach(vma, &inode->i_mapping->i_mmap, 0, ULONG_MAX) {
 		if (!(vma->vm_flags & VM_SHARED))
 			continue;
 
@@ -2129,7 +2128,7 @@ int nommu_shrink_inode_mappings(struct i
 		}
 	}
 
-	i_mmap_unlock_write(inode->i_mapping);
+	i_mmap_unlock_read(inode->i_mapping);
 	up_write(&nommu_region_sem);
 	return 0;
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

