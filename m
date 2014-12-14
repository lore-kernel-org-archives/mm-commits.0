From: akpm@linux-foundation.org
Subject: [merged] mm-xip-share-the-i_mmap_rwsem.patch removed from -mm
 tree
Date: Sat, 13 Dec 2014 20:06:35 -0800
Message-ID: <548d0ccb.r8HvToOhpJxE19t1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaLNEG1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:06:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/xip: share the i_mmap_rwsem
has been removed from the -mm tree.  Its filename was
     mm-xip-share-the-i_mmap_rwsem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: mm/xip: share the i_mmap_rwsem

__xip_unmap() will remove the xip sparse page from the cache and take down
pte mapping, without altering the interval tree, thus share the
i_mmap_rwsem when searching for the ptes to unmap.

Additionally, tidy up the function a bit and make variables only local to
the interval tree walk loop.

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

 mm/filemap_xip.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff -puN mm/filemap_xip.c~mm-xip-share-the-i_mmap_rwsem mm/filemap_xip.c
--- a/mm/filemap_xip.c~mm-xip-share-the-i_mmap_rwsem
+++ a/mm/filemap_xip.c
@@ -155,22 +155,14 @@ xip_file_read(struct file *filp, char __
 EXPORT_SYMBOL_GPL(xip_file_read);
 
 /*
- * __xip_unmap is invoked from xip_unmap and
- * xip_write
+ * __xip_unmap is invoked from xip_unmap and xip_write
  *
  * This function walks all vmas of the address_space and unmaps the
  * __xip_sparse_page when found at pgoff.
  */
-static void
-__xip_unmap (struct address_space * mapping,
-		     unsigned long pgoff)
+static void __xip_unmap(struct address_space * mapping, unsigned long pgoff)
 {
 	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	unsigned long address;
-	pte_t *pte;
-	pte_t pteval;
-	spinlock_t *ptl;
 	struct page *page;
 	unsigned count;
 	int locked = 0;
@@ -182,11 +174,14 @@ __xip_unmap (struct address_space * mapp
 		return;
 
 retry:
-	i_mmap_lock_write(mapping);
+	i_mmap_lock_read(mapping);
 	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		mm = vma->vm_mm;
-		address = vma->vm_start +
+		pte_t *pte, pteval;
+		spinlock_t *ptl;
+		struct mm_struct *mm = vma->vm_mm;
+		unsigned long address = vma->vm_start +
 			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
+
 		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 		pte = page_check_address(page, mm, address, &ptl, 1);
 		if (pte) {
@@ -202,7 +197,7 @@ retry:
 			page_cache_release(page);
 		}
 	}
-	i_mmap_unlock_write(mapping);
+	i_mmap_unlock_read(mapping);
 
 	if (locked) {
 		mutex_unlock(&xip_sparse_mutex);
_

Patches currently in -mm which might be from dave@stgolabs.net are

origin.patch

