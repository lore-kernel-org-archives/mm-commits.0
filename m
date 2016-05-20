From: akpm@linux-foundation.org
Subject: [merged]
 huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch removed from
 -mm tree
Date: Fri, 20 May 2016 14:05:47 -0700
Message-ID: <573f7c2b.Nt8Ip05v3CllXPfX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172AbcETVFs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, aarcange@redhat.com, andreslc@google.com, kirill.shutemov@linux.intel.com, koct9i@gmail.com, mgorman@techsingularity.net, quning@gmail.com, yang.shi@linaro.org, mm-commits@vger.kernel.org


The patch titled
     Subject: huge pagecache: extend mremap pmd rmap lockout to files
has been removed from the -mm tree.  Its filename was
     huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: huge pagecache: extend mremap pmd rmap lockout to files

Whatever huge pagecache implementation we go with, file rmap locking must
be added to anon rmap locking, when mremap's move_page_tables() finds a
pmd_trans_huge pmd entry: a simple change, let's do it now.

Factor out take_rmap_locks() and drop_rmap_locks() to handle the locking
for make move_ptes() and move_page_tables(), and delete the VM_BUG_ON_VMA
which rejected vm_file and required anon_vma.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Yang Shi <yang.shi@linaro.org>
Cc: Ning Qu <quning@gmail.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andres Lagar-Cavilla <andreslc@google.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |   42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff -puN mm/mremap.c~huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files mm/mremap.c
--- a/mm/mremap.c~huge-pagecache-extend-mremap-pmd-rmap-lockout-to-files
+++ a/mm/mremap.c
@@ -70,6 +70,22 @@ static pmd_t *alloc_new_pmd(struct mm_st
 	return pmd;
 }
 
+static void take_rmap_locks(struct vm_area_struct *vma)
+{
+	if (vma->vm_file)
+		i_mmap_lock_write(vma->vm_file->f_mapping);
+	if (vma->anon_vma)
+		anon_vma_lock_write(vma->anon_vma);
+}
+
+static void drop_rmap_locks(struct vm_area_struct *vma)
+{
+	if (vma->anon_vma)
+		anon_vma_unlock_write(vma->anon_vma);
+	if (vma->vm_file)
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+}
+
 static pte_t move_soft_dirty_pte(pte_t pte)
 {
 	/*
@@ -90,8 +106,6 @@ static void move_ptes(struct vm_area_str
 		struct vm_area_struct *new_vma, pmd_t *new_pmd,
 		unsigned long new_addr, bool need_rmap_locks)
 {
-	struct address_space *mapping = NULL;
-	struct anon_vma *anon_vma = NULL;
 	struct mm_struct *mm = vma->vm_mm;
 	pte_t *old_pte, *new_pte, pte;
 	spinlock_t *old_ptl, *new_ptl;
@@ -114,16 +128,8 @@ static void move_ptes(struct vm_area_str
 	 *   serialize access to individual ptes, but only rmap traversal
 	 *   order guarantees that we won't miss both the old and new ptes).
 	 */
-	if (need_rmap_locks) {
-		if (vma->vm_file) {
-			mapping = vma->vm_file->f_mapping;
-			i_mmap_lock_write(mapping);
-		}
-		if (vma->anon_vma) {
-			anon_vma = vma->anon_vma;
-			anon_vma_lock_write(anon_vma);
-		}
-	}
+	if (need_rmap_locks)
+		take_rmap_locks(vma);
 
 	/*
 	 * We don't have to worry about the ordering of src and dst
@@ -151,10 +157,8 @@ static void move_ptes(struct vm_area_str
 		spin_unlock(new_ptl);
 	pte_unmap(new_pte - 1);
 	pte_unmap_unlock(old_pte - 1, old_ptl);
-	if (anon_vma)
-		anon_vma_unlock_write(anon_vma);
-	if (mapping)
-		i_mmap_unlock_write(mapping);
+	if (need_rmap_locks)
+		drop_rmap_locks(vma);
 }
 
 #define LATENCY_LIMIT	(64 * PAGE_SIZE)
@@ -193,15 +197,13 @@ unsigned long move_page_tables(struct vm
 		if (pmd_trans_huge(*old_pmd)) {
 			if (extent == HPAGE_PMD_SIZE) {
 				bool moved;
-				VM_BUG_ON_VMA(vma->vm_file || !vma->anon_vma,
-					      vma);
 				/* See comment in move_ptes() */
 				if (need_rmap_locks)
-					anon_vma_lock_write(vma->anon_vma);
+					take_rmap_locks(vma);
 				moved = move_huge_pmd(vma, old_addr, new_addr,
 						    old_end, old_pmd, new_pmd);
 				if (need_rmap_locks)
-					anon_vma_unlock_write(vma->anon_vma);
+					drop_rmap_locks(vma);
 				if (moved) {
 					need_flush = true;
 					continue;
_

Patches currently in -mm which might be from hughd@google.com are

radix-tree-rewrite-radix_tree_locate_item-fix.patch

