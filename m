From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch removed from -mm tree
Date: Mon, 07 Apr 2014 14:57:23 -0700
Message-ID: <53431f43.2I8p/K/IluWsiCCJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39853 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbaDGV5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Apr 2014 17:57:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, mgorman@suse.de

Subject: [folded-merged] mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch removed from -mm tree
To: mgorman@suse.de,riel@redhat.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 14:57:23 -0700


The patch titled
     Subject: mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix
has been removed from the -mm tree.  Its filename was
     mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix.patch

This patch was dropped because it was folded into mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mprotect.c |   40 ++++++++++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 10 deletions(-)

diff -puN mm/mprotect.c~mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix mm/mprotect.c
--- a/mm/mprotect.c~mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes-fix
+++ a/mm/mprotect.c
@@ -36,6 +36,34 @@ static inline pgprot_t pgprot_modify(pgp
 }
 #endif
 
+/*
+ * For a prot_numa update we only hold mmap_sem for read so there is a
+ * potential race with faulting where a pmd was temporarily none. This
+ * function checks for a transhuge pmd under the appropriate lock. It
+ * returns a pte if it was successfully locked or NULL if it raced with
+ * a transhuge insertion.
+ */
+static pte_t *lock_pte_protection(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, int prot_numa, spinlock_t **ptl)
+{
+	pte_t *pte;
+	spinlock_t *pmdl;
+
+	/* !prot_numa is protected by mmap_sem held for write */
+	if (!prot_numa)
+		return pte_offset_map_lock(vma->vm_mm, pmd, addr, ptl);
+
+	pmdl = pmd_lock(vma->vm_mm, pmd);
+	if (unlikely(pmd_trans_huge(*pmd) || pmd_none(*pmd))) {
+		spin_unlock(pmdl);
+		return NULL;
+	}
+
+	pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, ptl);
+	spin_unlock(pmdl);
+	return pte;
+}
+
 static unsigned long change_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 		unsigned long addr, unsigned long end, pgprot_t newprot,
 		int dirty_accountable, int prot_numa)
@@ -45,17 +73,9 @@ static unsigned long change_pte_range(st
 	spinlock_t *ptl;
 	unsigned long pages = 0;
 
-	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
-
-	/*
-	 * For a prot_numa update we only hold mmap_sem for read so there is a
-	 * potential race with faulting where a pmd was temporarily none so
-	 * recheck it under the lock and bail if we race
-	 */
-	if (prot_numa && unlikely(pmd_trans_huge(*pmd))) {
-		pte_unmap_unlock(pte, ptl);
+	pte = lock_pte_protection(vma, pmd, addr, prot_numa, &ptl);
+	if (!pte)
 		return 0;
-	}
 
 	arch_enter_lazy_mmu_mode();
 	do {
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-hugetlbc-add-null-check-of-return-value-of-huge_pte_offset.patch
mm-numa-recheck-for-transhuge-pages-under-lock-during-protection-changes.patch
mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
mm-exclude-memory-less-nodes-from-zone_reclaim.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
mm-introduce-vm_ops-map_pages.patch
mm-implement-map_pages-for-page-cache.patch
mm-cleanup-size-checks-in-filemap_fault-and-filemap_map_pages.patch
mm-add-debugfs-tunable-for-fault_around_order.patch
mm-implement-map_pages-for-shmem-tmpfs.patch
fork-collapse-copy_flags-into-copy_process.patch
mm-mempolicy-rename-slab_node-for-clarity.patch
mm-mempolicy-remove-per-process-flag.patch
res_counter-remove-interface-for-locked-charging-and-uncharging.patch
mm-compaction-determine-isolation-mode-only-once.patch
mm-page_alloc-spill-to-remote-nodes-before-waking-kswapd.patch
mm-try_to_unmap_cluster-should-lock_page-before-mlocking.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch

