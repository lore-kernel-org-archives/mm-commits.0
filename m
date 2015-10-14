From: akpm@linux-foundation.org
Subject: + thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch added
 to -mm tree
Date: Wed, 14 Oct 2015 14:12:48 -0700
Message-ID: <561ec550.fNmz7uBUplf8ZyWP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754010AbbJNVMu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 14 Oct 2015 17:12:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp, mlock: do not allow huge pages in mlocked area
has been added to the -mm tree.  Its filename is
     thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch

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
Subject: thp, mlock: do not allow huge pages in mlocked area

With new refcounting THP can belong to several VMAs.  This makes tricky to
track THP pages, when they partially mlocked.  It can lead to leaking
mlocked pages to non-VM_LOCKED vmas and other problems.

With this patch we will split all pages on mlock and avoid
fault-in/collapse new THP in VM_LOCKED vmas.

I've tried alternative approach: do not mark THP pages mlocked and keep
them on normal LRUs.  This way vmscan could try to split huge pages on
memory pressure and free up subpages which doesn't belong to VM_LOCKED
vmas.  But this is user-visible change: we screw up Mlocked accouting
reported in meminfo, so I had to leave this approach aside.

We can bring something better later, but this should be good enough for
now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
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

 mm/gup.c         |    3 +-
 mm/huge_memory.c |    5 +++-
 mm/memory.c      |    3 +-
 mm/mlock.c       |   51 ++++++++++++++++-----------------------------
 4 files changed, 27 insertions(+), 35 deletions(-)

diff -puN mm/gup.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area mm/gup.c
--- a/mm/gup.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area
+++ a/mm/gup.c
@@ -927,7 +927,8 @@ long populate_vma_page_range(struct vm_a
 	gup_flags = FOLL_TOUCH | FOLL_POPULATE | FOLL_MLOCK;
 	if (vma->vm_flags & VM_LOCKONFAULT)
 		gup_flags &= ~FOLL_POPULATE;
-
+	if (vma->vm_flags & VM_LOCKED)
+		gup_flags |= FOLL_SPLIT;
 	/*
 	 * We want to touch writable mappings with a write fault in order
 	 * to break COW, except for shared mappings because these don't COW
diff -puN mm/huge_memory.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area
+++ a/mm/huge_memory.c
@@ -873,6 +873,8 @@ int do_huge_pmd_anonymous_page(struct mm
 
 	if (haddr < vma->vm_start || haddr + HPAGE_PMD_SIZE > vma->vm_end)
 		return VM_FAULT_FALLBACK;
+	if (vma->vm_flags & VM_LOCKED)
+		return VM_FAULT_FALLBACK;
 	if (unlikely(anon_vma_prepare(vma)))
 		return VM_FAULT_OOM;
 	if (unlikely(khugepaged_enter(vma, vma->vm_flags)))
@@ -2586,7 +2588,8 @@ static bool hugepage_vma_check(struct vm
 	if ((!(vma->vm_flags & VM_HUGEPAGE) && !khugepaged_always()) ||
 	    (vma->vm_flags & VM_NOHUGEPAGE))
 		return false;
-
+	if (vma->vm_flags & VM_LOCKED)
+		return false;
 	if (!vma->anon_vma || vma->vm_ops)
 		return false;
 	if (is_vma_temporary_stack(vma))
diff -puN mm/memory.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area mm/memory.c
--- a/mm/memory.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area
+++ a/mm/memory.c
@@ -2161,7 +2161,8 @@ static int wp_page_copy(struct mm_struct
 
 	pte_unmap_unlock(page_table, ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	if (old_page) {
+	/* THP pages are never mlocked */
+	if (old_page && !PageTransCompound(old_page)) {
 		/*
 		 * Don't let another task, with possibly unlocked vma,
 		 * keep the mlocked page.
diff -puN mm/mlock.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area mm/mlock.c
--- a/mm/mlock.c~thp-mlock-do-not-allow-huge-pages-in-mlocked-area
+++ a/mm/mlock.c
@@ -443,39 +443,26 @@ void munlock_vma_pages_range(struct vm_a
 		page = follow_page_mask(vma, start, FOLL_GET | FOLL_DUMP,
 				&page_mask);
 
-		if (page && !IS_ERR(page)) {
-			if (PageTransHuge(page)) {
-				lock_page(page);
-				/*
-				 * Any THP page found by follow_page_mask() may
-				 * have gotten split before reaching
-				 * munlock_vma_page(), so we need to recompute
-				 * the page_mask here.
-				 */
-				page_mask = munlock_vma_page(page);
-				unlock_page(page);
-				put_page(page); /* follow_page_mask() */
-			} else {
-				/*
-				 * Non-huge pages are handled in batches via
-				 * pagevec. The pin from follow_page_mask()
-				 * prevents them from collapsing by THP.
-				 */
-				pagevec_add(&pvec, page);
-				zone = page_zone(page);
-				zoneid = page_zone_id(page);
+		if (page && !IS_ERR(page) && !PageTransCompound(page)) {
+			/*
+			 * Non-huge pages are handled in batches via
+			 * pagevec. The pin from follow_page_mask()
+			 * prevents them from collapsing by THP.
+			 */
+			pagevec_add(&pvec, page);
+			zone = page_zone(page);
+			zoneid = page_zone_id(page);
 
-				/*
-				 * Try to fill the rest of pagevec using fast
-				 * pte walk. This will also update start to
-				 * the next page to process. Then munlock the
-				 * pagevec.
-				 */
-				start = __munlock_pagevec_fill(&pvec, vma,
-						zoneid, start, end);
-				__munlock_pagevec(&pvec, zone);
-				goto next;
-			}
+			/*
+			 * Try to fill the rest of pagevec using fast
+			 * pte walk. This will also update start to
+			 * the next page to process. Then munlock the
+			 * pagevec.
+			 */
+			start = __munlock_pagevec_fill(&pvec, vma,
+					zoneid, start, end);
+			__munlock_pagevec(&pvec, zone);
+			goto next;
 		}
 		/* It's a bug to munlock in the middle of a THP page */
 		VM_BUG_ON((start >> PAGE_SHIFT) & page_mask);
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

