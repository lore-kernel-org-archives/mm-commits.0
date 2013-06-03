From: akpm@linux-foundation.org
Subject: +
 documentation-document-the-is_dirty_writeback-aops-callback.patch added to
 -mm tree
Date: Mon, 03 Jun 2013 14:14:31 -0700
Message-ID: <51ad0737.jqOfHmrNziacvTWK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40287 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3FCVOc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 17:14:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: + documentation-document-the-is_dirty_writeback-aops-callback.patch added to -mm tree
To: mgorman@suse.de
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 14:14:31 -0700


The patch titled
     Subject: documentation: document the is_dirty_writeback aops callback
has been added to the -mm tree.  Its filename is
     documentation-document-the-is_dirty_writeback-aops-callback.patch

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
Subject: documentation: document the is_dirty_writeback aops callback

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff -puN Documentation/filesystems/vfs.txt~documentation-document-the-is_dirty_writeback-aops-callback Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~documentation-document-the-is_dirty_writeback-aops-callback
+++ a/Documentation/filesystems/vfs.txt
@@ -577,6 +577,7 @@ struct address_space_operations {
 	int (*launder_page) (struct page *);
 	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
 					unsigned long);
+	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
 	int (*swap_activate)(struct file *);
 	int (*swap_deactivate)(struct file *);
@@ -741,6 +742,15 @@ struct address_space_operations {
 	block is up to date then the read can complete without needing the IO
 	to bring the whole page up to date.
 
+  is_dirty_writeback: Called by the VM when attempting to reclaim a page.
+	The VM uses dirty and writeback information to determine if it needs
+	to stall to allow flushers a chance to complete some IO. Ordinarily
+	it can use PageDirty and PageWriteback but some filesystems have
+	more complex state (unstable pages in NFS prevent reclaim) or
+	do not set those flags due to locking problems (jbd). This callback
+	allows a filesystem to indicate to the VM if a page should be
+	treated as dirty or writeback for the purposes of stalling.
+
   error_remove_page: normally set to generic_error_remove_page if truncation
 	is ok for this address space. Used for memory failure handling.
 	Setting this implies you deal with pages going away under you,
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
migrate-add-migrate_entry_wait_huge.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix-2.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
hugetlbfs-support-split-page-table-lock.patch
mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
documentation-update-address_space_operations.patch
documentation-document-the-is_dirty_writeback-aops-callback.patch
mm-memmap_init_zone-performance-improvement.patch

