From: akpm@linux-foundation.org
Subject: + thp-ksm-on-thp.patch added to -mm tree
Date: Mon, 10 Jan 2011 14:55:24 -0800
Message-ID: <201101102255.p0AMtOYL016292@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37300 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1AJW4K (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Jan 2011 17:56:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, hughd@google.com


The patch titled
     thp: KSM on THP
has been added to the -mm tree.  Its filename is
     thp-ksm-on-thp.patch

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
Subject: thp: KSM on THP
From: Andrea Arcangeli <aarcange@redhat.com>

This makes KSM full operational with THP pages.  Subpages are scanned
while the hugepage is still in place and delivering max cpu performance,
and only if there's a match and we're going to deduplicate memory, the
single hugepages with the subpage match is split.

There will be no false sharing between ksmd and khugepaged.  khugepaged
won't collapse 2m virtual regions with KSM pages inside.  ksmd also should
only split pages when the checksum matches and we're likely to split an
hugepage for some long living ksm page (usual ksm heuristic to avoid
sharing pages that get de-cowed).

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |   67 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 9 deletions(-)

diff -puN mm/ksm.c~thp-ksm-on-thp mm/ksm.c
--- a/mm/ksm.c~thp-ksm-on-thp
+++ a/mm/ksm.c
@@ -412,6 +412,29 @@ out:
 	up_read(&mm->mmap_sem);
 }
 
+static struct page *page_trans_compound_anon(struct page *page)
+{
+	if (PageTransCompound(page)) {
+		struct page *head;
+		head = compound_head(page);
+		/*
+		 * head may be a dangling pointer.
+		 * __split_huge_page_refcount clears PageTail
+		 * before overwriting first_page, so if
+		 * PageTail is still there it means the head
+		 * pointer isn't dangling.
+		 */
+		if (head != page) {
+			smp_rmb();
+			if (!PageTransCompound(page))
+				return NULL;
+		}
+		if (PageAnon(head))
+			return head;
+	}
+	return NULL;
+}
+
 static struct page *get_mergeable_page(struct rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -431,7 +454,7 @@ static struct page *get_mergeable_page(s
 	page = follow_page(vma, addr, FOLL_GET);
 	if (IS_ERR_OR_NULL(page))
 		goto out;
-	if (PageAnon(page) && !PageTransCompound(page)) {
+	if (PageAnon(page) || page_trans_compound_anon(page)) {
 		flush_anon_page(vma, page, addr);
 		flush_dcache_page(page);
 	} else {
@@ -709,6 +732,7 @@ static int write_protect_page(struct vm_
 	if (addr == -EFAULT)
 		goto out;
 
+	BUG_ON(PageTransCompound(page));
 	ptep = page_check_address(page, mm, addr, &ptl, 0);
 	if (!ptep)
 		goto out;
@@ -784,6 +808,7 @@ static int replace_page(struct vm_area_s
 		goto out;
 
 	pmd = pmd_offset(pud, addr);
+	BUG_ON(pmd_trans_huge(*pmd));
 	if (!pmd_present(*pmd))
 		goto out;
 
@@ -811,6 +836,33 @@ out:
 	return err;
 }
 
+static int page_trans_compound_anon_split(struct page *page)
+{
+	int ret = 0;
+	struct page *transhuge_head = page_trans_compound_anon(page);
+	if (transhuge_head) {
+		/* Get the reference on the head to split it. */
+		if (get_page_unless_zero(transhuge_head)) {
+			/*
+			 * Recheck we got the reference while the head
+			 * was still anonymous.
+			 */
+			if (PageAnon(transhuge_head))
+				ret = split_huge_page(transhuge_head);
+			else
+				/*
+				 * Retry later if split_huge_page run
+				 * from under us.
+				 */
+				ret = 1;
+			put_page(transhuge_head);
+		} else
+			/* Retry later if split_huge_page run from under us. */
+			ret = 1;
+	}
+	return ret;
+}
+
 /*
  * try_to_merge_one_page - take two pages and merge them into one
  * @vma: the vma that holds the pte pointing to page
@@ -831,6 +883,9 @@ static int try_to_merge_one_page(struct 
 
 	if (!(vma->vm_flags & VM_MERGEABLE))
 		goto out;
+	if (PageTransCompound(page) && page_trans_compound_anon_split(page))
+		goto out;
+	BUG_ON(PageTransCompound(page));
 	if (!PageAnon(page))
 		goto out;
 
@@ -1285,14 +1340,8 @@ next_mm:
 				cond_resched();
 				continue;
 			}
-			if (PageTransCompound(*page)) {
-				put_page(*page);
-				ksm_scan.address &= HPAGE_PMD_MASK;
-				ksm_scan.address += HPAGE_PMD_SIZE;
-				cond_resched();
-				continue;
-			}
-			if (PageAnon(*page)) {
+			if (PageAnon(*page) ||
+			    page_trans_compound_anon(*page)) {
 				flush_anon_page(vma, *page, ksm_scan.address);
 				flush_dcache_page(*page);
 				rmap_item = get_next_rmap_item(slot,
_

Patches currently in -mm which might be from aarcange@redhat.com are

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
thp-ksm-free-swap-when-swapcache-page-is-replaced.patch
thp-fix-bad_page-to-show-the-real-reason-the-page-is-bad.patch
thp-transparent-hugepage-support-documentation.patch
thp-mm-define-madv_hugepage.patch
thp-compound_lock.patch
thp-alter-compound-get_page-put_page.patch
thp-put_page-recheck-pagehead-after-releasing-the-compound_lock.patch
thp-update-futex-compound-knowledge.patch
thp-clear-compound-mapping.patch
thp-add-native_set_pmd_at.patch
thp-add-pmd-paravirt-ops.patch
thp-no-paravirt-version-of-pmd-ops.patch
thp-export-maybe_mkwrite.patch
thp-comment-reminder-in-destroy_compound_page.patch
thp-config_transparent_hugepage.patch
thp-config_transparent_hugepage-fix.patch
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um.patch
thp-add-pmd-mangling-generic-functions-fix-pgtableh-build-for-um-2patch.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-pte-alloc-trans-splitting-fix.patch
thp-pte-alloc-trans-splitting-fix-checkpatch-fixes.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-kvm-mmu-transparent-hugepage-support-fix.patch
thp-kvm-mmu-transparent-hugepage-support-bisection.patch
thp-_gfp_no_kswapd.patch
thp-dont-alloc-harder-for-gfp-nomemalloc-even-if-nowait.patch
thp-transparent-hugepage-core.patch
thp-split_huge_page-anon_vma-ordering-dependency.patch
thp-verify-pmd_trans_huge-isnt-leaking.patch
thp-madvisemadv_hugepage.patch
thp-add-pagetranscompound.patch
thp-pmd_trans_huge-migrate-bugcheck.patch
thp-memcg-compound.patch
thp-transhuge-memcg-commit-tail-pages-at-charge.patch
thp-memcg-huge-memory.patch
thp-transparent-hugepage-vmstat.patch
thp-khugepaged.patch
thp-khugepaged-vma-merge.patch
thp-skip-transhuge-pages-in-ksm-for-now.patch
thp-remove-pg_buddy.patch
thp-add-x86-32bit-support.patch
thp-mincore-transparent-hugepage-support.patch
thp-add-pmd_modify.patch
thp-mprotect-pass-vma-down-to-page-table-walkers.patch
thp-mprotect-transparent-huge-page-support.patch
thp-set-recommended-min-free-kbytes.patch
thp-enable-direct-defrag.patch
thp-add-numa-awareness-to-hugepage-allocations.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode.patch
thp-allocate-memory-in-khugepaged-outside-of-mmap_sem-write-mode-fix.patch
thp-transparent-hugepage-config-choice.patch
thp-select-config_compaction-if-transparent_hugepage-enabled.patch
thp-transhuge-isolate_migratepages.patch
thp-avoid-breaking-huge-pmd-invariants-in-case-of-vma_adjust-failures.patch
thp-dont-allow-transparent-hugepage-support-without-pse.patch
thp-mmu_notifier_test_young.patch
thp-freeze-khugepaged-and-ksmd.patch
thp-use-compaction-in-kswapd-for-gfp_atomic-order-0.patch
thp-use-compaction-for-all-allocation-orders.patch
thp-disable-transparent-hugepages-by-default-on-small-systems.patch
thp-fix-anon-memory-statistics-with-transparent-hugepages.patch
thp-scale-nr_rotated-to-balance-memory-pressure.patch
thp-transparent-hugepage-sysfs-meminfo.patch
thp-add-debug-checks-for-mapcount-related-invariants.patch
thp-fix-memory-failure-hugetlbfs-vs-thp-collision.patch
thp-compound_trans_order.patch
thp-compound_trans_order-fix.patch
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
thp-khugepaged-make-khugepaged-aware-of-madvise-fix.patch
thp-ksm-on-thp.patch
thp-add-compound_trans_head-helper.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix-fix.patch
hugetlb-fix-handling-of-parse-errors-in-sysfs.patch

