From: akpm@linux-foundation.org
Subject: + thp-add-pmd_modify.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:37 -0800
Message-ID: <201012152357.oBFNvbdo013626@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755840Ab0LOX5u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: add pmd_modify
has been added to the -mm tree.  Its filename is
     thp-add-pmd_modify.patch

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
Subject: thp: add pmd_modify
From: Johannes Weiner <hannes@cmpxchg.org>

Add pmd_modify() for use with mprotect() on huge pmds.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/pgtable.h       |   10 ++++++++++
 arch/x86/include/asm/pgtable_types.h |    1 +
 2 files changed, 11 insertions(+)

diff -puN arch/x86/include/asm/pgtable.h~thp-add-pmd_modify arch/x86/include/asm/pgtable.h
--- a/arch/x86/include/asm/pgtable.h~thp-add-pmd_modify
+++ a/arch/x86/include/asm/pgtable.h
@@ -325,6 +325,16 @@ static inline pte_t pte_modify(pte_t pte
 	return __pte(val);
 }
 
+static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
+{
+	pmdval_t val = pmd_val(pmd);
+
+	val &= _HPAGE_CHG_MASK;
+	val |= massage_pgprot(newprot) & ~_HPAGE_CHG_MASK;
+
+	return __pmd(val);
+}
+
 /* mprotect needs to preserve PAT bits when updating vm_page_prot */
 #define pgprot_modify pgprot_modify
 static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
diff -puN arch/x86/include/asm/pgtable_types.h~thp-add-pmd_modify arch/x86/include/asm/pgtable_types.h
--- a/arch/x86/include/asm/pgtable_types.h~thp-add-pmd_modify
+++ a/arch/x86/include/asm/pgtable_types.h
@@ -72,6 +72,7 @@
 /* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_PFN_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_SPECIAL | _PAGE_ACCESSED | _PAGE_DIRTY)
+#define _HPAGE_CHG_MASK (_PAGE_CHG_MASK | _PAGE_PSE)
 
 #define _PAGE_CACHE_MASK	(_PAGE_PCD | _PAGE_PWT)
 #define _PAGE_CACHE_WB		(0)
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

