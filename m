From: akpm@linux-foundation.org
Subject: + mm-nommu-share-the-i_mmap_rwsem.patch added to -mm tree
Date: Tue, 04 Nov 2014 15:04:56 -0800
Message-ID: <54595b98.6TDnQK7p2vNoanJJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaKDXEz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 18:04:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill.shutemov@intel.linux.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/nommu: share the i_mmap_rwsem
has been added to the -mm tree.  Its filename is
     mm-nommu-share-the-i_mmap_rwsem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-nommu-share-the-i_mmap_rwsem.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mm-nommu-share-the-i_mmap_rwsem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/nommu: share the i_mmap_rwsem

Shrinking/truncate logic can call nommu_shrink_inode_mappings() to verify
that any shared mappings of the inode in question aren't broken (dead
zone).  afaict the only user being ramfs to handle the size change
attribute.

Pretty much a no-brainer to share the lock.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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

mmfs-introduce-helpers-around-the-i_mmap_mutex.patch
mm-use-new-helper-functions-around-the-i_mmap_mutex.patch
mm-convert-i_mmap_mutex-to-rwsem.patch
mm-rmap-share-the-i_mmap_rwsem.patch
uprobes-share-the-i_mmap_rwsem.patch
mm-xip-share-the-i_mmap_rwsem.patch
mm-memory-failure-share-the-i_mmap_rwsem.patch
mm-nommu-share-the-i_mmap_rwsem.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-semc-increase-semmsl-semmni-semopm.patch
ipc-msg-increase-msgmni-remove-scaling.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch

