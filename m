From: akpm@linux-foundation.org
Subject: + thp-pmd_trans_huge-migrate-bugcheck.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:13 -0800
Message-ID: <201012152357.oBFNvDT8013578@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886Ab0LOX5x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, riel@redhat.com


The patch titled
     thp: pmd_trans_huge migrate bugcheck
has been added to the -mm tree.  Its filename is
     thp-pmd_trans_huge-migrate-bugcheck.patch

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
Subject: thp: pmd_trans_huge migrate bugcheck
From: Andrea Arcangeli <aarcange@redhat.com>

No pmd_trans_huge should ever materialize in migration ptes areas, because
we split the hugepage before migration ptes are instantiated.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    1 +
 mm/memory.c        |    5 +++++
 mm/migrate.c       |    7 ++++++-
 3 files changed, 12 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~thp-pmd_trans_huge-migrate-bugcheck include/linux/mm.h
--- a/include/linux/mm.h~thp-pmd_trans_huge-migrate-bugcheck
+++ a/include/linux/mm.h
@@ -1495,6 +1495,7 @@ struct page *follow_page(struct vm_area_
 #define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
 #define FOLL_MINOR	0x20	/* do only minor page faults */
 #define FOLL_MLOCK	0x40	/* mark page as mlocked */
+#define FOLL_SPLIT	0x80	/* don't return transhuge pages, split them */
 
 typedef int (*pte_fn_t)(pte_t *pte, pgtable_t token, unsigned long addr,
 			void *data);
diff -puN mm/memory.c~thp-pmd_trans_huge-migrate-bugcheck mm/memory.c
--- a/mm/memory.c~thp-pmd_trans_huge-migrate-bugcheck
+++ a/mm/memory.c
@@ -1305,6 +1305,10 @@ struct page *follow_page(struct vm_area_
 		goto out;
 	}
 	if (pmd_trans_huge(*pmd)) {
+		if (flags & FOLL_SPLIT) {
+			split_huge_page_pmd(mm, pmd);
+			goto split_fallthrough;
+		}
 		spin_lock(&mm->page_table_lock);
 		if (likely(pmd_trans_huge(*pmd))) {
 			if (unlikely(pmd_trans_splitting(*pmd))) {
@@ -1320,6 +1324,7 @@ struct page *follow_page(struct vm_area_
 			spin_unlock(&mm->page_table_lock);
 		/* fall through */
 	}
+split_fallthrough:
 	if (unlikely(pmd_bad(*pmd)))
 		goto no_page_table;
 
diff -puN mm/migrate.c~thp-pmd_trans_huge-migrate-bugcheck mm/migrate.c
--- a/mm/migrate.c~thp-pmd_trans_huge-migrate-bugcheck
+++ a/mm/migrate.c
@@ -113,6 +113,8 @@ static int remove_migration_pte(struct p
 			goto out;
 
 		pmd = pmd_offset(pud, addr);
+		if (pmd_trans_huge(*pmd))
+			goto out;
 		if (!pmd_present(*pmd))
 			goto out;
 
@@ -632,6 +634,9 @@ static int unmap_and_move(new_page_t get
 		/* page was freed from under us. So we are done. */
 		goto move_newpage;
 	}
+	if (unlikely(PageTransHuge(page)))
+		if (unlikely(split_huge_page(page)))
+			goto move_newpage;
 
 	/* prepare cgroup just returns 0 or -ENOMEM */
 	rc = -EAGAIN;
@@ -1046,7 +1051,7 @@ static int do_move_page_to_node_array(st
 		if (!vma || pp->addr < vma->vm_start || !vma_migratable(vma))
 			goto set_status;
 
-		page = follow_page(vma, pp->addr, FOLL_GET);
+		page = follow_page(vma, pp->addr, FOLL_GET|FOLL_SPLIT);
 
 		err = PTR_ERR(page);
 		if (IS_ERR(page))
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
thp-special-pmd_trans_-functions.patch
thp-add-pmd-mangling-generic-functions.patch
thp-add-pmd-mangling-functions-to-x86.patch
thp-bail-out-gup_fast-on-splitting-pmd.patch
thp-pte-alloc-trans-splitting.patch
thp-add-pmd-mmu_notifier-helpers.patch
thp-clear-page-compound.patch
thp-add-pmd_huge_pte-to-mm_struct.patch
thp-split_huge_page_mm-vma.patch
thp-split_huge_page-paging.patch
thp-clear_copy_huge_page.patch
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
thp-mm-define-madv_nohugepage.patch
thp-madvisemadv_nohugepage.patch

