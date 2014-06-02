From: akpm@linux-foundation.org
Subject: + hugetlb-rename-hugepage_migration_support-to-_supported.patch
 added to -mm tree
Date: Mon, 02 Jun 2014 12:53:28 -0700
Message-ID: <538cd638.GNLDJYJZrTx+LbLE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFBTx3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Jun 2014 15:53:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hughd@google.com, n-horiguchi@ah.jp.nec.com

Subject: + hugetlb-rename-hugepage_migration_support-to-_supported.patch added to -mm tree
To: n-horiguchi@ah.jp.nec.com,hughd@google.com
From: akpm@linux-foundation.org
Date: Mon, 02 Jun 2014 12:53:28 -0700


The patch titled
     Subject: hugetlb: rename hugepage_migration_support() to ..._supported()
has been added to the -mm tree.  Its filename is
     hugetlb-rename-hugepage_migration_support-to-_supported.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-rename-hugepage_migration_support-to-_supported.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-rename-hugepage_migration_support-to-_supported.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: hugetlb: rename hugepage_migration_support() to ..._supported()

We already have a function named hugepages_supported(), and the similar
name hugepage_migration_support() is a bit unconfortable, so let's rename
it hugepage_migration_supported().

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    4 ++--
 mm/hugetlb.c            |    2 +-
 mm/migrate.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/hugetlb.h~hugetlb-rename-hugepage_migration_support-to-_supported include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/include/linux/hugetlb.h
@@ -390,7 +390,7 @@ static inline pgoff_t basepage_index(str
 
 extern void dissolve_free_huge_pages(unsigned long start_pfn,
 				     unsigned long end_pfn);
-static inline int hugepage_migration_support(struct hstate *h)
+static inline int hugepage_migration_supported(struct hstate *h)
 {
 #ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
 	return huge_page_shift(h) == PMD_SHIFT;
@@ -446,7 +446,7 @@ static inline pgoff_t basepage_index(str
 	return page->index;
 }
 #define dissolve_free_huge_pages(s, e)	do {} while (0)
-#define hugepage_migration_support(h)	0
+#define hugepage_migration_supported(h)	0
 
 static inline spinlock_t *huge_pte_lockptr(struct hstate *h,
 					   struct mm_struct *mm, pte_t *pte)
diff -puN mm/hugetlb.c~hugetlb-rename-hugepage_migration_support-to-_supported mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/mm/hugetlb.c
@@ -545,7 +545,7 @@ static struct page *dequeue_huge_page_no
 /* Movability of hugepages depends on migration support. */
 static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
-	if (hugepages_treat_as_movable || hugepage_migration_support(h))
+	if (hugepages_treat_as_movable || hugepage_migration_supported(h))
 		return GFP_HIGHUSER_MOVABLE;
 	else
 		return GFP_HIGHUSER;
diff -puN mm/migrate.c~hugetlb-rename-hugepage_migration_support-to-_supported mm/migrate.c
--- a/mm/migrate.c~hugetlb-rename-hugepage_migration_support-to-_supported
+++ a/mm/migrate.c
@@ -1039,7 +1039,7 @@ static int unmap_and_move_huge_page(new_
 	 * tables or check whether the hugepage is pmd-based or not before
 	 * kicking migration.
 	 */
-	if (!hugepage_migration_support(page_hstate(hpage))) {
+	if (!hugepage_migration_supported(page_hstate(hpage))) {
 		putback_active_hugepage(hpage);
 		return -ENOSYS;
 	}
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-page-typesc-catch-sigbus-if-raced-with-truncate.patch
pass-on-hwpoison-maintainership-to-naoya-noriguchi.patch
hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v2.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagewalk-update-page-table-walker-core-fix.patch
pagewalk-add-walk_page_vma.patch
smaps-redefine-callback-functions-for-page-table-walker.patch
clear_refs-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
numa_maps-redefine-callback-functions-for-page-table-walker.patch
memcg-redefine-callback-functions-for-page-table-walker.patch
arch-powerpc-mm-subpage-protc-use-walk_page_vma-instead-of-walk_page_range.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mempolicy-apply-page-table-walker-on-queue_pages_range.patch
mm-add-pte_present-check-on-existing-hugetlb_entry-callbacks.patch
mm-pagewalkc-move-pte-null-check.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
hugetlb-prep_compound_gigantic_page-drop-__init-marker.patch
hugetlb-add-hstate_is_gigantic.patch
hugetlb-update_and_free_page-dont-clear-pg_reserved-bit.patch
hugetlb-move-helpers-up-in-the-file.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-migration-add-destination-page-freeing-callback.patch
mm-compaction-return-failed-migration-target-pages-back-to-freelist.patch
mm-compaction-add-per-zone-migration-pfn-cache-for-async-compaction.patch
mm-compaction-embed-migration-mode-in-compact_control.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-thp-avoid-excessive-compaction-latency-during-fault-fix.patch
mm-compaction-do-not-count-migratepages-when-unnecessary.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages.patch
mm-compaction-avoid-rescanning-pageblocks-in-isolate_freepages-fix.patch
mm-memory-failurec-move-comment.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention.patch
hwpoison-remove-unused-global-variable-in-do_machine_check.patch
mm-prom-pid-clear_refs-avoid-split_huge_page.patch
hugetlb-rename-hugepage_migration_support-to-_supported.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

