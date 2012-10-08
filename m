From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:12:58 -0700
Message-ID: <20121008231259.23B825C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62226 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:13:02 -0400
Received: by mail-ee0-f74.google.com with SMTP id b57so293853eek.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:13:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, aquini@redhat.com, dan.carpenter@oracle.com, fengguang.wu@intel.com, mhocko@suse.cz, riel@redhat.com, shli@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch

This patch was dropped because it was folded into mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix

Fengguang Wu reported the following

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.5
head:   2f641f902ca76711e47e8d3b18004f0e46ca3d9b
commit: 7faeb2a39c789f1bac69014cc468677a60b73395 [184/186] mm:
compaction: cache if a pageblock was scanned and no pages were isolated
config: i386-randconfig-b083 (attached as .config)

All error/warnings:

mm/compaction.c: In function 'isolation_suitable':
mm/compaction.c:60:2: error: implicit declaration of function 'get_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: In function 'reset_isolation_suitable':
mm/compaction.c:94:3: error: implicit declaration of function 'clear_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: In function 'update_pageblock_skip':
mm/compaction.c:108:3: error: implicit declaration of function 'set_pageblock_skip' [-Werror=implicit-function-declaration]
mm/compaction.c: At top level:
mm/compaction.c:68:13: warning: 'reset_isolation_suitable' defined but not used [-Wunused-function]
mm/compaction.c:177:13: warning: 'compact_capture_page' defined but not used [-Wunused-function]
cc1: some warnings being treated as errors

Michal Hocko suggested implementing !CONFIG_COMPACTION versions of these
functions but that still leaves the dead version of
reset_isolation_suitable in the !CONFIG_COMPACTION && CONFIG_CMA case.
Create !CONFIG_COMPACTION versions of isolation_suitable() and
update_pageblock_skip() instead.

This is a fix for
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Rafael Aquini <aquini@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix
+++ a/mm/compaction.c
@@ -50,6 +50,7 @@ static inline bool migrate_async_suitabl
 	return is_migrate_cma(migratetype) || migratetype == MIGRATE_MOVABLE;
 }
 
+#ifdef CONFIG_COMPACTION
 /* Returns true if the pageblock should be scanned for pages to isolate. */
 static inline bool isolation_suitable(struct compact_control *cc,
 					struct page *page)
@@ -107,6 +108,17 @@ static void update_pageblock_skip(struct
 	if (!nr_isolated)
 		set_pageblock_skip(page);
 }
+#else
+static inline bool isolation_suitable(struct compact_control *cc,
+					struct page *page)
+{
+	return true;
+}
+
+static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+{
+}
+#endif /* CONFIG_COMPACTION */
 
 static inline bool should_release_lock(spinlock_t *lock)
 {
_

Patches currently in -mm which might be from mgorman@suse.de are

mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-fix-watermark-checking.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix3.patch
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch
mm-compaction-clear-pg_migrate_skip-based-on-compaction-and-reclaim-activity.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix-fix.patch
mm-thp-fix-pmd_present-for-split_huge_page-and-prot_none-with-thp.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range.patch
mm-revert-0def08e3-mm-mempolicyc-check-return-code-of-check_range-fix.patch
cma-migrate-mlocked-pages.patch
cma-migrate-mlocked-pages-fix.patch
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch
make-gfp_notrack-definition-unconditional.patch

