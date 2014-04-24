From: akpm@linux-foundation.org
Subject: +
 mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch added to -mm tree
Date: Thu, 24 Apr 2014 10:50:56 -0700
Message-ID: <53594f00.qKnSNVhDgBT6pWBe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaDXRu5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Apr 2014 13:50:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, riel@redhat.com, hughd@google.com, mgorman@suse.de

Subject: + mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch added to -mm tree
To: mgorman@suse.de,hughd@google.com,riel@redhat.com,sasha.levin@oracle.com
From: akpm@linux-foundation.org
Date: Thu, 24 Apr 2014 10:50:56 -0700


The patch titled
     Subject: mm: numa: add migrated transhuge pages to LRU the same way as base pages
has been added to the -mm tree.  Its filename is
     mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: numa: add migrated transhuge pages to LRU the same way as base pages

Migration of misplaced transhuge pages uses page_add_new_anon_rmap() when
putting the page back as it avoided an atomic operations and added the new
page to the correct LRU.  A side-effect is that the page gets marked
activated as part of the migration meaning that transhuge and base pages
are treated differently from an aging perspective than base page
migration.

This patch uses page_add_anon_rmap() and putback_lru_page() on completion
of a transhuge migration similar to base page migration.  It would require
fewer atomic operations to use lru_cache_add without taking an additional
reference to the page.  The downside would be that it's still different to
base page migration and unevictable pages may be added to the wrong LRU
for cleaning up later.  Testing of the usual workloads did not show any
adverse impact to the change.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages mm/migrate.c
--- a/mm/migrate.c~mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages
+++ a/mm/migrate.c
@@ -1852,7 +1852,7 @@ fail_putback:
 	 * guarantee the copy is visible before the pagetable update.
 	 */
 	flush_cache_range(vma, mmun_start, mmun_end);
-	page_add_new_anon_rmap(new_page, vma, mmun_start);
+	page_add_anon_rmap(new_page, vma, mmun_start);
 	pmdp_clear_flush(vma, mmun_start, pmd);
 	set_pmd_at(mm, mmun_start, pmd, entry);
 	flush_tlb_range(vma, mmun_start, mmun_end);
@@ -1877,6 +1877,10 @@ fail_putback:
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
 
+	/* Take an "isolate" reference and put new page on the LRU. */
+	get_page(new_page);
+	putback_lru_page(new_page);
+
 	unlock_page(new_page);
 	unlock_page(page);
 	put_page(page);			/* Drop the rmap reference */
_

Patches currently in -mm which might be from mgorman@suse.de are

hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix-fix.patch
mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
mm-disable-zone_reclaim_mode-by-default.patch
mm-page_alloc-do-not-cache-reclaim-distances.patch
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-fix.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
linux-next.patch

