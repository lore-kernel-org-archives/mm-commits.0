From: akpm@linux-foundation.org
Subject: + arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch added to -mm tree
Date: Wed, 14 Oct 2015 14:13:16 -0700
Message-ID: <561ec56c.eS/d28eegKfI97/b%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50157 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbbJNVNR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:13:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: arm, thp: remove infrastructure for handling splitting PMDs
has been added to the -mm tree.  Its filename is
     arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: arm, thp: remove infrastructure for handling splitting PMDs

With new refcounting we don't need to mark PMDs splitting. Let's drop
code to handle this.

pmdp_splitting_flush() is not needed too: on splitting PMD we will do
pmdp_clear_flush() + set_pte_at(). pmdp_clear_flush() will do IPI as
needed for fast_gup.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/include/asm/pgtable-3level.h |   10 ----------
 arch/arm/lib/uaccess_with_memcpy.c    |    5 ++---
 arch/arm/mm/flush.c                   |   15 ---------------
 3 files changed, 2 insertions(+), 28 deletions(-)

diff -puN arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/include/asm/pgtable-3level.h
--- a/arch/arm/include/asm/pgtable-3level.h~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/include/asm/pgtable-3level.h
@@ -88,7 +88,6 @@
 
 #define L_PMD_SECT_VALID	(_AT(pmdval_t, 1) << 0)
 #define L_PMD_SECT_DIRTY	(_AT(pmdval_t, 1) << 55)
-#define L_PMD_SECT_SPLITTING	(_AT(pmdval_t, 1) << 56)
 #define L_PMD_SECT_NONE		(_AT(pmdval_t, 1) << 57)
 #define L_PMD_SECT_RDONLY	(_AT(pteval_t, 1) << 58)
 
@@ -232,21 +231,12 @@ static inline pte_t pte_mkspecial(pte_t
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define pmd_trans_huge(pmd)	(pmd_val(pmd) && !pmd_table(pmd))
-#define pmd_trans_splitting(pmd) (pmd_isset((pmd), L_PMD_SECT_SPLITTING))
-
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp);
-#endif
-#endif
 
 #define PMD_BIT_FUNC(fn,op) \
 static inline pmd_t pmd_##fn(pmd_t pmd) { pmd_val(pmd) op; return pmd; }
 
 PMD_BIT_FUNC(wrprotect,	|= L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkold,	&= ~PMD_SECT_AF);
-PMD_BIT_FUNC(mksplitting, |= L_PMD_SECT_SPLITTING);
 PMD_BIT_FUNC(mkwrite,   &= ~L_PMD_SECT_RDONLY);
 PMD_BIT_FUNC(mkdirty,   |= L_PMD_SECT_DIRTY);
 PMD_BIT_FUNC(mkyoung,   |= PMD_SECT_AF);
diff -puN arch/arm/lib/uaccess_with_memcpy.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/lib/uaccess_with_memcpy.c
--- a/arch/arm/lib/uaccess_with_memcpy.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/lib/uaccess_with_memcpy.c
@@ -52,14 +52,13 @@ pin_page_for_write(const void __user *_a
 	 *
 	 * Lock the page table for the destination and check
 	 * to see that it's still huge and whether or not we will
-	 * need to fault on write, or if we have a splitting THP.
+	 * need to fault on write.
 	 */
 	if (unlikely(pmd_thp_or_huge(*pmd))) {
 		ptl = &current->mm->page_table_lock;
 		spin_lock(ptl);
 		if (unlikely(!pmd_thp_or_huge(*pmd)
-			|| pmd_hugewillfault(*pmd)
-			|| pmd_trans_splitting(*pmd))) {
+			|| pmd_hugewillfault(*pmd))) {
 			spin_unlock(ptl);
 			return 0;
 		}
diff -puN arch/arm/mm/flush.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~arm-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/arm/mm/flush.c
@@ -415,18 +415,3 @@ void __flush_anon_page(struct vm_area_st
 	 */
 	__cpuc_flush_dcache_area(page_address(page), PAGE_SIZE);
 }
-
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-#ifdef CONFIG_HAVE_RCU_TABLE_FREE
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp)
-{
-	pmd_t pmd = pmd_mksplitting(*pmdp);
-	VM_BUG_ON(address & ~PMD_MASK);
-	set_pmd_at(vma->vm_mm, address, pmdp, pmd);
-
-	/* dummy IPI to serialise against fast_gup */
-	kick_all_cpus_sync();
-}
-#endif /* CONFIG_HAVE_RCU_TABLE_FREE */
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

rcu-force-alignment-on-struct-callback_head-rcu_head.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
mm-drop-page-slab_page.patch
slab-slub-use-page-rcu_head-instead-of-page-lru-plus-cast.patch
zsmalloc-use-page-private-instead-of-page-first_page.patch
mm-pack-compound_dtor-and-compound_order-into-one-word-in-struct-page.patch
mm-make-compound_head-robust.patch
mm-make-compound_head-robust-fix.patch
mm-use-unsigned-int-for-page-order.patch
mm-use-unsigned-int-for-compound_dtor-compound_order-on-64bit.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-fix.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages-fix-3.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages-fix.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-support-madvisemadv_free-fix-3.patch

