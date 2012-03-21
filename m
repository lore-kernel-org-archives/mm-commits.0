From: akpm@linux-foundation.org
Subject: + mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-fix.patch added to -mm tree
Date: Wed, 21 Mar 2012 13:45:18 -0700
Message-ID: <20120321204518.9D5CCA0308@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:34067 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760432Ab2CUUpY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Mar 2012 16:45:24 -0400
Received: by ghbz15 with SMTP id z15so242121ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 21 Mar 2012 13:45:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, msalter@redhat.com, sfr@canb.auug.org.au


The patch titled
     Subject: mm: avoid CONFIG_MMU=n build failure in pmd_none_or_trans_huge_or_clear_bad
has been added to the -mm tree.  Its filename is
     mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrea Arcangeli <aarcange@redhat.com>
Subject: mm: avoid CONFIG_MMU=n build failure in pmd_none_or_trans_huge_or_clear_bad

pmd_none_or_trans_huge_or_clear_bad must be defined after pmd_trans_huge,
so add #ifdef CONFIG_MMU around the whole block that shall not be needed
for archs without pagetables.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Reported-by: Mark Salter <msalter@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/pgtable.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/pgtable.h~mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-fix include/asm-generic/pgtable.h
--- a/include/asm-generic/pgtable.h~mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-fix
+++ a/include/asm-generic/pgtable.h
@@ -426,6 +426,8 @@ extern void untrack_pfn_vma(struct vm_ar
 				unsigned long size);
 #endif
 
+#ifdef CONFIG_MMU
+
 #ifndef CONFIG_TRANSPARENT_HUGEPAGE
 static inline int pmd_trans_huge(pmd_t pmd)
 {
@@ -442,7 +444,7 @@ static inline int pmd_write(pmd_t pmd)
 	return 0;
 }
 #endif /* __HAVE_ARCH_PMD_WRITE */
-#endif
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 /*
  * This function is meant to be used by sites walking pagetables with
@@ -501,6 +503,8 @@ static inline int pmd_trans_unstable(pmd
 #endif
 }
 
+#endif /* CONFIG_MMU */
+
 #endif /* !__ASSEMBLY__ */
 
 #endif /* _ASM_GENERIC_PGTABLE_H */
_
Subject: Subject: mm: avoid CONFIG_MMU=n build failure in pmd_none_or_trans_huge_or_clear_bad

Patches currently in -mm which might be from aarcange@redhat.com are

linux-next.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-checkpatch-fixes.patch
mm-thp-fix-pmd_bad-triggering-in-code-paths-holding-mmap_sem-read-mode-fix.patch
vmscan-reclaim-at-order-0-when-compaction-is-enabled.patch
vmscan-kswapd-carefully-call-compaction.patch
vmscan-kswapd-carefully-call-compaction-fix.patch
vmscan-only-defer-compaction-for-failed-order-and-higher.patch
mm-compaction-make-compact_control-order-signed.patch
mm-compaction-make-compact_control-order-signed-fix.patch
hugetlbfs-fix-hugetlb_get_unmapped_area.patch
hugetlb-try-to-search-again-if-it-is-really-needed.patch
hugetlb-try-to-search-again-if-it-is-really-needed-fix.patch
mm-do-not-reset-cached_hole_size-when-vma-is-unmapped.patch
mm-search-from-free_area_cache-for-the-bigger-size.patch
pagemap-avoid-splitting-thp-when-reading-proc-pid-pagemap.patch
thp-optimize-away-unnecessary-page-table-locking.patch
thp-optimize-away-unnecessary-page-table-locking-fix.patch
pagemap-export-kpf_thp.patch
pagemap-document-kpf_thp-and-make-page-types-aware-of-it.patch
pagemap-introduce-data-structure-for-pagemap-entry.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch
thp-allow-a-hwpoisoned-head-page-to-be-put-back-to-lru.patch
ksm-cleanup-introduce-find_mergeable_vma.patch
numa_emulation-fix-cpumask_of_node.patch
memcg-remove-unnecessary-thp-check-in-page-stat-accounting.patch
memcg-clean-up-existing-move-charge-code.patch
thp-add-hpage_pmd_-definitions-for-config_transparent_hugepage.patch
memcg-avoid-thp-split-in-task-migration.patch

