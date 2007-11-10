From: akpm@linux-foundation.org
Subject: + memcgroup-reinstate-swapoff-mod.patch added to -mm tree
Date: Fri, 09 Nov 2007 17:10:23 -0800
Message-ID: <200711100110.lAA1ANiO008496@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46358 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759461AbXKJBLf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 20:11:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hugh@veritas.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au, rientjes@google.com, svaidy@linux.vnet.ibm.com, xemul@openvz.org


The patch titled
     memcgroup: reinstate swapoff mod
has been added to the -mm tree.  Its filename is
     memcgroup-reinstate-swapoff-mod.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memcgroup: reinstate swapoff mod
From: Hugh Dickins <hugh@veritas.com>

This patch reinstates the "swapoff: scan ptes preemptibly" mod we started
with: in due course it should be rendered down into the earlier patches,
leaving us with a more straightforward mem_cgroup_charge mod to unuse_pte,
allocating with GFP_KERNEL while holding no spinlock and no atomic kmap.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: David Rientjes <rientjes@google.com>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff -puN mm/swapfile.c~memcgroup-reinstate-swapoff-mod mm/swapfile.c
--- a/mm/swapfile.c~memcgroup-reinstate-swapoff-mod
+++ a/mm/swapfile.c
@@ -507,11 +507,23 @@ unsigned int count_swap_pages(int type, 
  * just let do_wp_page work it out if a write is requested later - to
  * force COW, vm_page_prot omits write permission from any private vma.
  */
-static int unuse_pte(struct vm_area_struct *vma, pte_t *pte,
+static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
+	spinlock_t *ptl;
+	pte_t *pte;
+	int ret = 1;
+
 	if (mem_cgroup_charge(page, vma->vm_mm, GFP_KERNEL))
-		return -ENOMEM;
+		ret = -ENOMEM;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
+		if (ret > 0)
+			mem_cgroup_uncharge_page(page);
+		ret = 0;
+		goto out;
+	}
 
 	inc_mm_counter(vma->vm_mm, anon_rss);
 	get_page(page);
@@ -524,7 +536,9 @@ static int unuse_pte(struct vm_area_stru
 	 * immediately swapped out again after swapon.
 	 */
 	activate_page(page);
-	return 1;
+out:
+	pte_unmap_unlock(pte, ptl);
+	return ret;
 }
 
 static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
@@ -533,21 +547,33 @@ static int unuse_pte_range(struct vm_are
 {
 	pte_t swp_pte = swp_entry_to_pte(entry);
 	pte_t *pte;
-	spinlock_t *ptl;
 	int ret = 0;
 
-	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	/*
+	 * We don't actually need pte lock while scanning for swp_pte: since
+	 * we hold page lock and mmap_sem, swp_pte cannot be inserted into the
+	 * page table while we're scanning; though it could get zapped, and on
+	 * some architectures (e.g. x86_32 with PAE) we might catch a glimpse
+	 * of unmatched parts which look like swp_pte, so unuse_pte must
+	 * recheck under pte lock.  Scanning without pte lock lets it be
+	 * preemptible whenever CONFIG_PREEMPT but not CONFIG_HIGHPTE.
+	 */
+	pte = pte_offset_map(pmd, addr);
 	do {
 		/*
 		 * swapoff spends a _lot_ of time in this loop!
 		 * Test inline before going to call unuse_pte.
 		 */
 		if (unlikely(pte_same(*pte, swp_pte))) {
-			ret = unuse_pte(vma, pte++, addr, entry, page);
-			break;
+			pte_unmap(pte);
+			ret = unuse_pte(vma, pmd, addr, entry, page);
+			if (ret)
+				goto out;
+			pte = pte_offset_map(pmd, addr);
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap(pte - 1);
+out:
 	return ret;
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
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
prio_tree-debugging-patch.patch
