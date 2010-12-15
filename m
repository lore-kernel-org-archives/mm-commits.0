From: akpm@linux-foundation.org
Subject: + thp-split_huge_page-anon_vma-ordering-dependency.patch added to -mm tree
Date: Wed, 15 Dec 2010 15:57:05 -0800
Message-ID: <201012152357.oBFNv55p013564@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46172 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab0LOX5t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Dec 2010 18:57:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     thp: split_huge_page anon_vma ordering dependency
has been added to the -mm tree.  Its filename is
     thp-split_huge_page-anon_vma-ordering-dependency.patch

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
Subject: thp: split_huge_page anon_vma ordering dependency
From: Andrea Arcangeli <aarcange@redhat.com>

This documents how split_huge_page is safe vs new vma inserctions into the
anon_vma that may have already released the anon_vma->lock but not
established pmds yet when split_huge_page starts.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++++++++++++++
 mm/rmap.c        |    4 ++++
 2 files changed, 20 insertions(+)

diff -puN mm/huge_memory.c~thp-split_huge_page-anon_vma-ordering-dependency mm/huge_memory.c
--- a/mm/huge_memory.c~thp-split_huge_page-anon_vma-ordering-dependency
+++ a/mm/huge_memory.c
@@ -841,6 +841,19 @@ static void __split_huge_page(struct pag
 			continue;
 		mapcount += __split_huge_page_splitting(page, vma, addr);
 	}
+	/*
+	 * It is critical that new vmas are added to the tail of the
+	 * anon_vma list. This guarantes that if copy_huge_pmd() runs
+	 * and establishes a child pmd before
+	 * __split_huge_page_splitting() freezes the parent pmd (so if
+	 * we fail to prevent copy_huge_pmd() from running until the
+	 * whole __split_huge_page() is complete), we will still see
+	 * the newly established pmd of the child later during the
+	 * walk, to be able to set it as pmd_trans_splitting too.
+	 */
+	if (mapcount != page_mapcount(page))
+		printk(KERN_ERR "mapcount %d page_mapcount %d\n",
+		       mapcount, page_mapcount(page));
 	BUG_ON(mapcount != page_mapcount(page));
 
 	__split_huge_page_refcount(page);
@@ -854,6 +867,9 @@ static void __split_huge_page(struct pag
 			continue;
 		mapcount2 += __split_huge_page_map(page, vma, addr);
 	}
+	if (mapcount != mapcount2)
+		printk(KERN_ERR "mapcount %d mapcount2 %d page_mapcount %d\n",
+		       mapcount, mapcount2, page_mapcount(page));
 	BUG_ON(mapcount != mapcount2);
 }
 
diff -puN mm/rmap.c~thp-split_huge_page-anon_vma-ordering-dependency mm/rmap.c
--- a/mm/rmap.c~thp-split_huge_page-anon_vma-ordering-dependency
+++ a/mm/rmap.c
@@ -177,6 +177,10 @@ static void anon_vma_chain_link(struct v
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
 
 	anon_vma_lock(anon_vma);
+	/*
+	 * It's critical to add new vmas to the tail of the anon_vma,
+	 * see comment in huge_memory.c:__split_huge_page().
+	 */
 	list_add_tail(&avc->same_anon_vma, &anon_vma->head);
 	anon_vma_unlock(anon_vma);
 }
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

