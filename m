From: akpm@linux-foundation.org
Subject: + memcgroup-temporarily-revert-swapoff-mod.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:05:59 -0800
Message-ID: <200711100105.lAA15xH1008325@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58142 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762357AbXKJBGi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:06:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcgroup: temporarily revert swapoff mod
has been added to the -mm tree.  Its filename is
     memcgroup-temporarily-revert-swapoff-mod.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memcgroup: temporarily revert swapoff mod
From: Hugh Dickins <hugh@veritas.com>

This patch precisely reverts the "swapoff: scan ptes preemptibly" patch
just presented.  It's a temporary measure to allow existing memory
controller patches to apply without rejects: in due course they should be
rendered down into one sensible patch, and this reversion disappear.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 +++++++-------------------------------
 1 file changed, 7 insertions(+), 31 deletions(-)

diff -puN mm/swapfile.c~memcgroup-temporarily-revert-swapoff-mod mm/swapfile.c
--- a/mm/swapfile.c~memcgroup-temporarily-revert-swapoff-mod
+++ a/mm/swapfile.c
@@ -506,19 +506,9 @@ unsigned int count_swap_pages(int type, 
  * just let do_wp_page work it out if a write is requested later - to
  * force COW, vm_page_prot omits write permission from any private vma.
  */
-static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
+static void unuse_pte(struct vm_area_struct *vma, pte_t *pte,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
-	spinlock_t *ptl;
-	pte_t *pte;
-	int found = 1;
-
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
-	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
-		found = 0;
-		goto out;
-	}
-
 	inc_mm_counter(vma->vm_mm, anon_rss);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
@@ -530,9 +520,6 @@ static int unuse_pte(struct vm_area_stru
 	 * immediately swapped out again after swapon.
 	 */
 	activate_page(page);
-out:
-	pte_unmap_unlock(pte, ptl);
-	return found;
 }
 
 static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
@@ -541,33 +528,22 @@ static int unuse_pte_range(struct vm_are
 {
 	pte_t swp_pte = swp_entry_to_pte(entry);
 	pte_t *pte;
+	spinlock_t *ptl;
 	int found = 0;
 
-	/*
-	 * We don't actually need pte lock while scanning for swp_pte: since
-	 * we hold page lock and mmap_sem, swp_pte cannot be inserted into the
-	 * page table while we're scanning; though it could get zapped, and on
-	 * some architectures (e.g. x86_32 with PAE) we might catch a glimpse
-	 * of unmatched parts which look like swp_pte, so unuse_pte must
-	 * recheck under pte lock.  Scanning without pte lock lets it be
-	 * preemptible whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
-	 */
-	pte = pte_offset_map(pmd, addr);
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
 	do {
 		/*
 		 * swapoff spends a _lot_ of time in this loop!
 		 * Test inline before going to call unuse_pte.
 		 */
 		if (unlikely(pte_same(*pte, swp_pte))) {
-			pte_unmap(pte);
-			found = unuse_pte(vma, pmd, addr, entry, page);
-			if (found)
-				goto out;
-			pte = pte_offset_map(pmd, addr);
+			unuse_pte(vma, pte++, addr, entry, page);
+			found = 1;
+			break;
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap(pte - 1);
-out:
+	pte_unmap_unlock(pte - 1, ptl);
 	return found;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
i386-and-x86_64-randomize-brk-fix-2.patch
swapin_readahead-excise-numa-bogosity.patch
swapin_readahead-move-and-rearrange-args.patch
swapin-needs-gfp_mask-for-loop-on-tmpfs.patch
shmem-sgp_quick-and-sgp_fault-redundant.patch
shmem_getpage-return-page-locked.patch
shmem_file_write-is-redundant.patch
swapin-fix-valid_swaphandles-defect.patch
swapoff-scan-ptes-preemptibly.patch
maps4-add-proportional-set-size-accounting-in-smaps.patch
tmpfs-fix-mounts-when-size-is-less-than-the-page-size.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
prio_tree-debugging-patch.patch
