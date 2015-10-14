From: akpm@linux-foundation.org
Subject: +
 s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch added to
 -mm tree
Date: Wed, 14 Oct 2015 14:13:25 -0700
Message-ID: <561ec575.6rZymk07bOF0gD6m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbJNVN1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:13:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: s390, thp: remove infrastructure for handling splitting PMDs
has been added to the -mm tree.  Its filename is
     s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch

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
Subject: s390, thp: remove infrastructure for handling splitting PMDs

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

 arch/s390/include/asm/pgtable.h |   15 +--------------
 arch/s390/mm/gup.c              |   11 +----------
 arch/s390/mm/pgtable.c          |   16 ----------------
 3 files changed, 2 insertions(+), 40 deletions(-)

diff -puN arch/s390/include/asm/pgtable.h~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/include/asm/pgtable.h
--- a/arch/s390/include/asm/pgtable.h~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/include/asm/pgtable.h
@@ -280,7 +280,6 @@ static inline int is_module_addr(void *a
 
 #define _SEGMENT_ENTRY_DIRTY	0x2000	/* SW segment dirty bit */
 #define _SEGMENT_ENTRY_YOUNG	0x1000	/* SW segment young bit */
-#define _SEGMENT_ENTRY_SPLIT	0x0800	/* THP splitting bit */
 #define _SEGMENT_ENTRY_LARGE	0x0400	/* STE-format control, large page */
 #define _SEGMENT_ENTRY_READ	0x0002	/* SW segment read bit */
 #define _SEGMENT_ENTRY_WRITE	0x0001	/* SW segment write bit */
@@ -306,8 +305,6 @@ static inline int is_module_addr(void *a
  * SW-bits: y young, d dirty, r read, w write
  */
 
-#define _SEGMENT_ENTRY_SPLIT_BIT 11	/* THP splitting bit number */
-
 /* Page status table bits for virtualization */
 #define PGSTE_ACC_BITS	0xf000000000000000UL
 #define PGSTE_FP_BIT	0x0800000000000000UL
@@ -511,10 +508,6 @@ static inline int pmd_bad(pmd_t pmd)
 	return (pmd_val(pmd) & ~_SEGMENT_ENTRY_BITS) != 0;
 }
 
-#define __HAVE_ARCH_PMDP_SPLITTING_FLUSH
-extern void pmdp_splitting_flush(struct vm_area_struct *vma,
-				 unsigned long addr, pmd_t *pmdp);
-
 #define  __HAVE_ARCH_PMDP_SET_ACCESS_FLAGS
 extern int pmdp_set_access_flags(struct vm_area_struct *vma,
 				 unsigned long address, pmd_t *pmdp,
@@ -1371,7 +1364,7 @@ static inline pmd_t pmd_modify(pmd_t pmd
 	if (pmd_large(pmd)) {
 		pmd_val(pmd) &= _SEGMENT_ENTRY_ORIGIN_LARGE |
 			_SEGMENT_ENTRY_DIRTY | _SEGMENT_ENTRY_YOUNG |
-			_SEGMENT_ENTRY_LARGE | _SEGMENT_ENTRY_SPLIT;
+			_SEGMENT_ENTRY_LARGE;
 		pmd_val(pmd) |= massage_pgprot_pmd(newprot);
 		if (!(pmd_val(pmd) & _SEGMENT_ENTRY_DIRTY))
 			pmd_val(pmd) |= _SEGMENT_ENTRY_PROTECT;
@@ -1479,12 +1472,6 @@ extern void pgtable_trans_huge_deposit(s
 #define __HAVE_ARCH_PGTABLE_WITHDRAW
 extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 
-static inline int pmd_trans_splitting(pmd_t pmd)
-{
-	return (pmd_val(pmd) & _SEGMENT_ENTRY_LARGE) &&
-		(pmd_val(pmd) & _SEGMENT_ENTRY_SPLIT);
-}
-
 static inline void set_pmd_at(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t entry)
 {
diff -puN arch/s390/mm/gup.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/mm/gup.c
--- a/arch/s390/mm/gup.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/mm/gup.c
@@ -105,16 +105,7 @@ static inline int gup_pmd_range(pud_t *p
 		pmd = *pmdp;
 		barrier();
 		next = pmd_addr_end(addr, end);
-		/*
-		 * The pmd_trans_splitting() check below explains why
-		 * pmdp_splitting_flush() has to serialize with
-		 * smp_call_function() against our disabled IRQs, to stop
-		 * this gup-fast code from running while we set the
-		 * splitting bit in the pmd. Returning zero will take
-		 * the slow path that will call wait_split_huge_page()
-		 * if the pmd is still in splitting state.
-		 */
-		if (pmd_none(pmd) || pmd_trans_splitting(pmd))
+		if (pmd_none(pmd))
 			return 0;
 		if (unlikely(pmd_large(pmd))) {
 			/*
diff -puN arch/s390/mm/pgtable.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds arch/s390/mm/pgtable.c
--- a/arch/s390/mm/pgtable.c~s390-thp-remove-infrastructure-for-handling-splitting-pmds
+++ a/arch/s390/mm/pgtable.c
@@ -1308,22 +1308,6 @@ int pmdp_set_access_flags(struct vm_area
 	return 1;
 }
 
-static void pmdp_splitting_flush_sync(void *arg)
-{
-	/* Simply deliver the interrupt */
-}
-
-void pmdp_splitting_flush(struct vm_area_struct *vma, unsigned long address,
-			  pmd_t *pmdp)
-{
-	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
-	if (!test_and_set_bit(_SEGMENT_ENTRY_SPLIT_BIT,
-			      (unsigned long *) pmdp)) {
-		/* need to serialize against gup-fast (IRQ disabled) */
-		smp_call_function(pmdp_splitting_flush_sync, NULL, 1);
-	}
-}
-
 void pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
 				pgtable_t pgtable)
 {
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

