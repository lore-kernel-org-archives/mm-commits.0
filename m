From: akpm@linux-foundation.org
Subject: + documentation-update-address_space_operations.patch added to
 -mm tree
Date: Mon, 03 Jun 2013 14:14:30 -0700
Message-ID: <51ad0736.9F/MnPVPnJDxPta/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3FCVOb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Jun 2013 17:14:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mgorman@suse.de

Subject: + documentation-update-address_space_operations.patch added to -mm tree
To: mgorman@suse.de
From: akpm@linux-foundation.org
Date: Mon, 03 Jun 2013 14:14:30 -0700


The patch titled
     Subject: documentation: update address_space_operations
has been added to the -mm tree.  Its filename is
     documentation-update-address_space_operations.patch

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
Subject: documentation: update address_space_operations

The documentation for address_space_operations is partially out of date.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/vfs.txt |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/vfs.txt~documentation-update-address_space_operations Documentation/filesystems/vfs.txt
--- a/Documentation/filesystems/vfs.txt~documentation-update-address_space_operations
+++ a/Documentation/filesystems/vfs.txt
@@ -554,7 +554,6 @@ your filesystem. The following members a
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
 	int (*readpage)(struct file *, struct page *);
-	int (*sync_page)(struct page *);
 	int (*writepages)(struct address_space *, struct writeback_control *);
 	int (*set_page_dirty)(struct page *page);
 	int (*readpages)(struct file *filp, struct address_space *mapping,
@@ -576,6 +575,8 @@ struct address_space_operations {
 	/* migrate the contents of a page to the specified target */
 	int (*migratepage) (struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
+					unsigned long);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
 	int (*swap_activate)(struct file *);
 	int (*swap_deactivate)(struct file *);
@@ -607,13 +608,6 @@ struct address_space_operations {
        In this case, the page will be relocated, relocked and if
        that all succeeds, ->readpage will be called again.
 
-  sync_page: called by the VM to notify the backing store to perform all
-  	queued I/O operations for a page. I/O operations for other pages
-	associated with this address_space object may also be performed.
-
-	This function is optional and is called only for pages with
-  	PG_Writeback set while waiting for the writeback to complete.
-
   writepages: called by the VM to write out pages associated with the
   	address_space object.  If wbc->sync_mode is WBC_SYNC_ALL, then
   	the writeback_control will specify a range of pages that must be
@@ -742,6 +736,11 @@ struct address_space_operations {
   	prevent redirtying the page, it is kept locked during the whole
 	operation.
 
+  is_partially_uptodate: Called by the VM when reading a file through the
+	pagecache when the underlying blocksize != pagesize. If the required
+	block is up to date then the read can complete without needing the IO
+	to bring the whole page up to date.
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

