From: akpm@linux-foundation.org
Subject: - swapoff-scan-ptes-preemptibly.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:30:16 -0800
Message-ID: <200802052229.m15MTvFO012019@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51698 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761823AbYBEWnh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:43:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     swapoff: scan ptes preemptibly
has been removed from the -mm tree.  Its filename was
     swapoff-scan-ptes-preemptibly.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: swapoff: scan ptes preemptibly
From: Hugh Dickins <hugh@veritas.com>

Provided that CONFIG_HIGHPTE is not set, unuse_pte_range can reduce latency
in swapoff by scanning the page table preemptibly: so long as unuse_pte is
careful to recheck that entry under pte lock.

(To tell the truth, this patch was not inspired by any cries for lower
latency here: rather, this restructuring permits a future memory controller
patch to allocate with GFP_KERNEL in unuse_pte, where before it could not. 
But it would be wrong to tuck this change away inside a memcgroup patch.)

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Tested-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff -puN mm/swapfile.c~swapoff-scan-ptes-preemptibly mm/swapfile.c
--- a/mm/swapfile.c~swapoff-scan-ptes-preemptibly
+++ a/mm/swapfile.c
@@ -506,9 +506,19 @@ unsigned int count_swap_pages(int type, 
  * just let do_wp_page work it out if a write is requested later - to
  * force COW, vm_page_prot omits write permission from any private vma.
  */
-static void unuse_pte(struct vm_area_struct *vma, pte_t *pte,
+static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, swp_entry_t entry, struct page *page)
 {
+	spinlock_t *ptl;
+	pte_t *pte;
+	int found = 1;
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (unlikely(!pte_same(*pte, swp_entry_to_pte(entry)))) {
+		found = 0;
+		goto out;
+	}
+
 	inc_mm_counter(vma->vm_mm, anon_rss);
 	get_page(page);
 	set_pte_at(vma->vm_mm, addr, pte,
@@ -520,6 +530,9 @@ static void unuse_pte(struct vm_area_str
 	 * immediately swapped out again after swapon.
 	 */
 	activate_page(page);
+out:
+	pte_unmap_unlock(pte, ptl);
+	return found;
 }
 
 static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
@@ -528,22 +541,33 @@ static int unuse_pte_range(struct vm_are
 {
 	pte_t swp_pte = swp_entry_to_pte(entry);
 	pte_t *pte;
-	spinlock_t *ptl;
 	int found = 0;
 
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
-			unuse_pte(vma, pte++, addr, entry, page);
-			found = 1;
-			break;
+			pte_unmap(pte);
+			found = unuse_pte(vma, pmd, addr, entry, page);
+			if (found)
+				goto out;
+			pte = pte_offset_map(pmd, addr);
 		}
 	} while (pte++, addr += PAGE_SIZE, addr != end);
-	pte_unmap_unlock(pte - 1, ptl);
+	pte_unmap(pte - 1);
+out:
 	return found;
 }
 
_

Patches currently in -mm which might be from hugh@veritas.com are

origin.patch
git-unionfs.patch
git-x86.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop.patch
r-o-bind-mounts-track-number-of-mount-writer-fix-buggy-loop-checkpatch-fixes.patch
memcgroup-temporarily-revert-swapoff-mod.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memcgroup-reinstate-swapoff-mod.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
memory-controller-use-rcu_read_lock-in-mem_cgroup_cache_charge.patch
memcgroup-tidy-up-mem_cgroup_charge_common.patch
memcgroup-fix-hang-with-shmem-tmpfs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-tmpfs-fix.patch
add-new-string-functions-strict_strto-and-convert-kernel-params-to-use-them-fix-2.patch
prio_tree-debugging-patch.patch
