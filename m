From: akpm@linux-foundation.org
Subject: [merged]
 mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch removed
 from -mm tree
Date: Mon, 27 Feb 2017 12:26:08 -0800
Message-ID: <58b48b60.Yl8XTUc6uupBorpg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60478 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbdB0U16 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Feb 2017 15:27:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, hughd@google.com, oleg@redhat.com, peterz@infradead.org, riel@redhat.com, srikar@linux.vnet.ibm.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, rmap: check all VMAs that PTE-mapped THP can be part of
has been removed from the -mm tree.  Its filename was
     mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm, rmap: check all VMAs that PTE-mapped THP can be part of

Current rmap code can miss a VMA that maps PTE-mapped THP if the first
suppage of the THP was unmapped from the VMA.

We need to walk rmap for the whole range of offsets that THP covers, not
only the first one.

vma_address() also need to be corrected to check the range instead of
the first subpage.

Link: http://lkml.kernel.org/r/20170129173858.45174-6-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h |    9 ++++++---
 mm/rmap.c     |   16 ++++++++++------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/internal.h~mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of mm/internal.h
--- a/mm/internal.h~mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of
+++ a/mm/internal.h
@@ -335,12 +335,15 @@ __vma_address(struct page *page, struct
 static inline unsigned long
 vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	unsigned long address = __vma_address(page, vma);
+	unsigned long start, end;
+
+	start = __vma_address(page, vma);
+	end = start + PAGE_SIZE * (hpage_nr_pages(page) - 1);
 
 	/* page should be within @vma mapping range */
-	VM_BUG_ON_VMA(address < vma->vm_start || address >= vma->vm_end, vma);
+	VM_BUG_ON_VMA(end < vma->vm_start || start >= vma->vm_end, vma);
 
-	return address;
+	return max(start, vma->vm_start);
 }
 
 #else /* !CONFIG_MMU */
diff -puN mm/rmap.c~mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of mm/rmap.c
--- a/mm/rmap.c~mm-rmap-check-all-vmas-that-pte-mapped-thp-can-be-part-of
+++ a/mm/rmap.c
@@ -1757,7 +1757,7 @@ static int rmap_walk_anon(struct page *p
 		bool locked)
 {
 	struct anon_vma *anon_vma;
-	pgoff_t pgoff;
+	pgoff_t pgoff_start, pgoff_end;
 	struct anon_vma_chain *avc;
 	int ret = SWAP_AGAIN;
 
@@ -1771,8 +1771,10 @@ static int rmap_walk_anon(struct page *p
 	if (!anon_vma)
 		return ret;
 
-	pgoff = page_to_pgoff(page);
-	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
+	pgoff_start = page_to_pgoff(page);
+	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
+	anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root,
+			pgoff_start, pgoff_end) {
 		struct vm_area_struct *vma = avc->vma;
 		unsigned long address = vma_address(page, vma);
 
@@ -1810,7 +1812,7 @@ static int rmap_walk_file(struct page *p
 		bool locked)
 {
 	struct address_space *mapping = page_mapping(page);
-	pgoff_t pgoff;
+	pgoff_t pgoff_start, pgoff_end;
 	struct vm_area_struct *vma;
 	int ret = SWAP_AGAIN;
 
@@ -1825,10 +1827,12 @@ static int rmap_walk_file(struct page *p
 	if (!mapping)
 		return ret;
 
-	pgoff = page_to_pgoff(page);
+	pgoff_start = page_to_pgoff(page);
+	pgoff_end = pgoff_start + hpage_nr_pages(page) - 1;
 	if (!locked)
 		i_mmap_lock_read(mapping);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
+	vma_interval_tree_foreach(vma, &mapping->i_mmap,
+			pgoff_start, pgoff_end) {
 		unsigned long address = vma_address(page, vma);
 
 		cond_resched();
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are


