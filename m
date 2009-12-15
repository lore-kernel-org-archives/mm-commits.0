From: akpm@linux-foundation.org
Subject: [merged] mm-pass-address-down-to-rmap-ones.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:52:30 -0800
Message-ID: <200912152152.nBFLqUgE015198@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934025AbZLOWVB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:21:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com, aarcange@redhat.com, andi@firstfloor.org, fengguang.wu@intel.com, ieidus@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohi


The patch titled
     mm: pass address down to rmap ones
has been removed from the -mm tree.  Its filename was
     mm-pass-address-down-to-rmap-ones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: pass address down to rmap ones
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

KSM swapping will know where page_referenced_one() and try_to_unmap_one()
should look.  It could hack page->index to get them to do what it wants,
but it seems cleaner now to pass the address down to them.

Make the same change to page_mkclean_one(), since it follows the same
pattern; but there's no real need in its case.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Izik Eidus <ieidus@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   53 ++++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 26 deletions(-)

diff -puN mm/rmap.c~mm-pass-address-down-to-rmap-ones mm/rmap.c
--- a/mm/rmap.c~mm-pass-address-down-to-rmap-ones
+++ a/mm/rmap.c
@@ -336,21 +336,15 @@ int page_mapped_in_vma(struct page *page
  * Subfunctions of page_referenced: page_referenced_one called
  * repeatedly from either page_referenced_anon or page_referenced_file.
  */
-static int page_referenced_one(struct page *page,
-			       struct vm_area_struct *vma,
-			       unsigned int *mapcount,
+static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
+			       unsigned long address, unsigned int *mapcount,
 			       unsigned long *vm_flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long address;
 	pte_t *pte;
 	spinlock_t *ptl;
 	int referenced = 0;
 
-	address = vma_address(page, vma);
-	if (address == -EFAULT)
-		goto out;
-
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
@@ -409,6 +403,9 @@ static int page_referenced_anon(struct p
 
 	mapcount = page_mapcount(page);
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
 		/*
 		 * If we are reclaiming on behalf of a cgroup, skip
 		 * counting on behalf of references from different
@@ -416,7 +413,7 @@ static int page_referenced_anon(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma,
+		referenced += page_referenced_one(page, vma, address,
 						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
@@ -474,6 +471,9 @@ static int page_referenced_file(struct p
 	mapcount = page_mapcount(page);
 
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
 		/*
 		 * If we are reclaiming on behalf of a cgroup, skip
 		 * counting on behalf of references from different
@@ -481,7 +481,7 @@ static int page_referenced_file(struct p
 		 */
 		if (mem_cont && !mm_match_cgroup(vma->vm_mm, mem_cont))
 			continue;
-		referenced += page_referenced_one(page, vma,
+		referenced += page_referenced_one(page, vma, address,
 						  &mapcount, vm_flags);
 		if (!mapcount)
 			break;
@@ -535,18 +535,14 @@ int page_referenced(struct page *page,
 	return referenced;
 }
 
-static int page_mkclean_one(struct page *page, struct vm_area_struct *vma)
+static int page_mkclean_one(struct page *page, struct vm_area_struct *vma,
+			    unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long address;
 	pte_t *pte;
 	spinlock_t *ptl;
 	int ret = 0;
 
-	address = vma_address(page, vma);
-	if (address == -EFAULT)
-		goto out;
-
 	pte = page_check_address(page, mm, address, &ptl, 1);
 	if (!pte)
 		goto out;
@@ -578,8 +574,12 @@ static int page_mkclean_file(struct addr
 
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
-		if (vma->vm_flags & VM_SHARED)
-			ret += page_mkclean_one(page, vma);
+		if (vma->vm_flags & VM_SHARED) {
+			unsigned long address = vma_address(page, vma);
+			if (address == -EFAULT)
+				continue;
+			ret += page_mkclean_one(page, vma, address);
+		}
 	}
 	spin_unlock(&mapping->i_mmap_lock);
 	return ret;
@@ -761,19 +761,14 @@ void page_remove_rmap(struct page *page)
  * repeatedly from either try_to_unmap_anon or try_to_unmap_file.
  */
 static int try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
-				enum ttu_flags flags)
+			    unsigned long address, enum ttu_flags flags)
 {
 	struct mm_struct *mm = vma->vm_mm;
-	unsigned long address;
 	pte_t *pte;
 	pte_t pteval;
 	spinlock_t *ptl;
 	int ret = SWAP_AGAIN;
 
-	address = vma_address(page, vma);
-	if (address == -EFAULT)
-		goto out;
-
 	pte = page_check_address(page, mm, address, &ptl, 0);
 	if (!pte)
 		goto out;
@@ -1018,7 +1013,10 @@ static int try_to_unmap_anon(struct page
 		return ret;
 
 	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		ret = try_to_unmap_one(page, vma, flags);
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
+		ret = try_to_unmap_one(page, vma, address, flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			break;
 	}
@@ -1056,7 +1054,10 @@ static int try_to_unmap_file(struct page
 
 	spin_lock(&mapping->i_mmap_lock);
 	vma_prio_tree_foreach(vma, &iter, &mapping->i_mmap, pgoff, pgoff) {
-		ret = try_to_unmap_one(page, vma, flags);
+		unsigned long address = vma_address(page, vma);
+		if (address == -EFAULT)
+			continue;
+		ret = try_to_unmap_one(page, vma, address, flags);
 		if (ret != SWAP_AGAIN || !page_mapped(page))
 			goto out;
 	}
_

Patches currently in -mm which might be from hugh.dickins@tiscali.co.uk are

origin.patch
linux-next.patch
vfs-fsstack-handle-32-bit-smp-preempt-large-files-in-fsstack_copy_inode_size.patch
ksm-memory-hotremove-migration-only-fix.patch
elf-kill-use_elf_core_dump.patch
prio_tree-debugging-patch.patch

