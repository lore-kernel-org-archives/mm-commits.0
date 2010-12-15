From: akpm@linux-foundation.org
Subject: + thp-mincore-transparent-hugepage-support.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:35 -0800
Message-ID: <201012152357.oBFNvZWV013620@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51395 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755791Ab0LOX5m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: mincore transparent hugepage support
has been added to the -mm tree.  Its filename is
     thp-mincore-transparent-hugepage-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thp: mincore transparent hugepage support
From: Johannes Weiner <hannes@cmpxchg.org>

Handle transparent huge page pmd entries natively instead of splitting
them into subpages.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/huge_mm.h |    3 +++
 mm/huge_memory.c        |   25 +++++++++++++++++++++++++
 mm/mincore.c            |    8 +++++++-
 3 files changed, 35 insertions(+), 1 deletion(-)

diff -puN include/linux/huge_mm.h~thp-mincore-transparent-hugepage-support include/linux/huge_mm.h
--- a/include/linux/huge_mm.h~thp-mincore-transparent-hugepage-support
+++ a/include/linux/huge_mm.h
@@ -19,6 +19,9 @@ extern struct page *follow_trans_huge_pm
 extern int zap_huge_pmd(struct mmu_gather *tlb,
 			struct vm_area_struct *vma,
 			pmd_t *pmd);
+extern int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+			unsigned long addr, unsigned long end,
+			unsigned char *vec);
 
 enum transparent_hugepage_flag {
 	TRANSPARENT_HUGEPAGE_FLAG,
diff -puN mm/huge_memory.c~thp-mincore-transparent-hugepage-support mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mincore-transparent-hugepage-support
+++ a/mm/huge_memory.c
@@ -923,6 +923,31 @@ int zap_huge_pmd(struct mmu_gather *tlb,
 	return ret;
 }
 
+int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
+		unsigned long addr, unsigned long end,
+		unsigned char *vec)
+{
+	int ret = 0;
+
+	spin_lock(&vma->vm_mm->page_table_lock);
+	if (likely(pmd_trans_huge(*pmd))) {
+		ret = !pmd_trans_splitting(*pmd);
+		spin_unlock(&vma->vm_mm->page_table_lock);
+		if (unlikely(!ret))
+			wait_split_huge_page(vma->anon_vma, pmd);
+		else {
+			/*
+			 * All logical pages in the range are present
+			 * if backed by a huge page.
+			 */
+			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
+		}
+	} else
+		spin_unlock(&vma->vm_mm->page_table_lock);
+
+	return ret;
+}
+
 pmd_t *page_check_address_pmd(struct page *page,
 			      struct mm_struct *mm,
 			      unsigned long address,
diff -puN mm/mincore.c~thp-mincore-transparent-hugepage-support mm/mincore.c
--- a/mm/mincore.c~thp-mincore-transparent-hugepage-support
+++ a/mm/mincore.c
@@ -154,7 +154,13 @@ static void mincore_pmd_range(struct vm_
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);
-		split_huge_page_pmd(vma->vm_mm, pmd);
+		if (pmd_trans_huge(*pmd)) {
+			if (mincore_huge_pmd(vma, pmd, addr, next, vec)) {
+				vec += (next - addr) >> PAGE_SHIFT;
+				continue;
+			}
+			/* fall through */
+		}
 		if (pmd_none_or_clear_bad(pmd))
 			mincore_unmapped_range(vma, addr, next, vec);
 		else
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-compactionc-avoid-double-mem_cgroup_del_lru.patch
writeback-integrated-background-writeback-work.patch
writeback-trace-wakeup-event-for-background-writeback.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works.patch
writeback-stop-background-kupdate-works-from-livelocking-other-works-update.patch
writeback-avoid-livelocking-wb_sync_all-writeback.patch
writeback-avoid-livelocking-wb_sync_all-writeback-update.patch
writeback-check-skipped-pages-on-wb_sync_all.patch
writeback-check-skipped-pages-on-wb_sync_all-update.patch
writeback-check-skipped-pages-on-wb_sync_all-update-fix.patch
mm-compaction-add-trace-events-for-memory-compaction-activity.patch
mm-vmscan-convert-lumpy_mode-into-a-bitmask.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim-fix.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path-fix.patch
mm-migration-cleanup-migrate_pages-api-by-matching-types-for-offlining-and-sync.patch
mm-compaction-perform-a-faster-migration-scan-when-migrating-asynchronously.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode.patch
mm-vmscan-rename-lumpy_mode-to-reclaim_mode-fix.patch
mm-deactivate-invalidated-pages.patch
mm-deactivate-invalidated-pages-fix.patch
mm-kswapd-stop-high-order-balancing-when-any-suitable-zone-is-balanced.patch
mm-kswapd-keep-kswapd-awake-for-high-order-allocations-until-a-percentage-of-the-node-is-balanced.patch
mm-kswapd-use-the-order-that-kswapd-was-reclaiming-at-for-sleeping_prematurely.patch
mm-kswapd-reset-kswapd_max_order-and-classzone_idx-after-reading.patch
mm-kswapd-treat-zone-all_unreclaimable-in-sleeping_prematurely-similar-to-balance_pgdat.patch
mm-kswapd-use-the-classzone-idx-that-kswapd-was-using-for-sleeping_prematurely.patch
thp-split_huge_page_mm-vma.patch
thp-transparent-hugepage-core.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
memcg-fix-unit-mismatch-in-memcg-oom-limit-calculation.patch

