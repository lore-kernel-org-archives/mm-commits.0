From: akpm@linux-foundation.org
Subject: + mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch added to -mm tree
Date: Thu, 27 Sep 2012 14:06:20 -0700
Message-ID: <20120927210621.3E2EE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:62692 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754844Ab2I0VGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 27 Sep 2012 17:06:23 -0400
Received: by wibhr7 with SMTP id hr7so164388wib.1
        for <mm-commits@vger.kernel.org>; Thu, 27 Sep 2012 14:06:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, fengguang.wu@intel.com


The patch titled
     Subject: mm: compaction: Restart compaction from near where it left off -fix
has been added to the -mm tree.  Its filename is
     mm-compaction-restart-compaction-from-near-where-it-left-off-fix.patch

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

thp-avoid-vm_bug_on-page_countpage-false-positives-in-__collapse_huge_page_copy.patch
mm-remove-__gfp_no_kswapd.patch
mm-compaction-update-comment-in-try_to_compact_pages.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-compaction-capture-a-suitable-high-order-page-immediately-when-it-is-made-available.patch
revert-mm-mempolicy-let-vma_merge-and-vma_split-handle-vma-vm_policy-linkages.patch
mempolicy-remove-mempolicy-sharing.patch
mempolicy-fix-a-race-in-shared_policy_replace.patch
mempolicy-fix-refcount-leak-in-mpol_set_shared_policy.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma.patch
mempolicy-fix-a-memory-corruption-by-refcount-imbalance-in-alloc_pages_vma-v2.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix.patch
mm-fix-tracing-in-free_pcppages_bulk.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-fix-counting-of-isolated-pages.patch
cma-count-free-cma-pages.patch
cma-count-free-cma-pages-fix.patch
cma-fix-watermark-checking.patch
cma-fix-watermark-checking-fix.patch
mm-page_alloc-use-get_freepage_migratetype-instead-of-page_private.patch
mm-remain-migratetype-in-freed-page.patch
memory-hotplug-bug-fix-race-between-isolation-and-allocation.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failing.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-compaction-move-fatal-signal-check-out-of-compact_checklock_irqsave.patch
mm-compaction-update-try_to_compact_pageskerneldoc-comment.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix.patch
mm-compaction-acquire-the-zone-lru_lock-as-late-as-possible-fix-fix.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible.patch
mm-compaction-acquire-the-zone-lock-as-late-as-possible-fix-2.patch
revert-mm-have-order-0-compaction-start-off-where-it-left.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix.patch
mm-compaction-cache-if-a-pageblock-was-scanned-and-no-pages-were-isolated-fix2.patch
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
cma-decrease-ccnr_migratepages-after-reclaiming-pagelist.patch

