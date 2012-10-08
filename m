From: akpm@linux-foundation.org
Subject: [folded-dropped] mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch removed from -mm tree
Date: Mon, 08 Oct 2012 16:14:01 -0700
Message-ID: <20121008231402.3122A200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:41301 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab2JHXOE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Oct 2012 19:14:04 -0400
Received: by mail-fa0-f74.google.com with SMTP id t1so291399fae.1
        for <mm-commits@vger.kernel.org>; Mon, 08 Oct 2012 16:14:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@suse.de, fengguang.wu@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: compaction: Restart compaction from near where it left off -fix
has been removed from the -mm tree.  Its filename was
     mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch

This patch was dropped because it was folded into mm-compaction-restart-compaction-from-near-where-it-left-off.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: compaction: Restart compaction from near where it left off -fix

Fengguang Wu reported the following

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.5
head:   a1e6f861ce9bd58373728fe2de149eaf766238ae
commit: c5e47c8e10f4f45effb589de310b124b4c8cd501 [192/198] mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix
config: i386-randconfig-b083 (attached as .config)

All error/warnings:

mm/compaction.c: In function 'isolate_freepages_block':
mm/compaction.c:346:3: warning: passing argument 1 of 'update_pageblock_skip' from incompatible pointer type [enabled by default]
mm/compaction.c:137:13: note: expected 'struct page *' but argument is of type 'struct compact_control *'
mm/compaction.c:346:3: warning: passing argument 2 of 'update_pageblock_skip' makes integer from pointer without a cast [enabled by default]
mm/compaction.c:137:13: note: expected 'long unsigned int' but argument is of type 'struct page *'
mm/compaction.c:346:3: error: too many arguments to function 'update_pageblock_skip'
mm/compaction.c:137:13: note: declared here
mm/compaction.c: In function 'isolate_migratepages_range':
mm/compaction.c:639:3: warning: passing argument 1 of 'update_pageblock_skip' from incompatible pointer type [enabled by default]
mm/compaction.c:137:13: note: expected 'struct page *' but argument is of type 'struct compact_control *'
mm/compaction.c:639:3: warning: passing argument 2 of 'update_pageblock_skip' makes integer from pointer without a cast [enabled by default]
mm/compaction.c:137:13: note: expected 'long unsigned int' but argument is of type 'struct page *'
mm/compaction.c:639:3: error: too many arguments to function 'update_pageblock_skip'
mm/compaction.c:137:13: note: declared here
mm/compaction.c: At top level:
mm/compaction.c:206:13: warning: 'compact_capture_page' defined but not used [-Wunused-function]

This is a fix for
mm-compaction-restart-compaction-from-near-where-it-left-off.patch that
became necessary after
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix
was merged but I missed the follow-up.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/compaction.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN mm/compaction.c~mm-compaction-restart-compaction-from-near-where-it-left-off-fix mm/compaction.c
--- a/mm/compaction.c~mm-compaction-restart-compaction-from-near-where-it-left-off-fix
+++ a/mm/compaction.c
@@ -137,7 +137,9 @@ static inline bool isolation_suitable(st
 	return true;
 }
 
-static void update_pageblock_skip(struct page *page, unsigned long nr_isolated)
+static void update_pageblock_skip(struct compact_control *cc,
+			struct page *page, unsigned long nr_isolated,
+			bool migrate_scanner)
 {
 }
 #endif /* CONFIG_COMPACTION */
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
mm-compaction-restart-compaction-from-near-where-it-left-off.patch
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

