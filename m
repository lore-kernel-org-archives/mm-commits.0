From: akpm@linux-foundation.org
Subject: + page-migration-fix-nr_file_pages-accounting.patch added to -mm tree
Date: Fri, 20 Apr 2007 17:49:18 -0700
Message-ID: <200704210049.l3L0nI0Y027713@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40612 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932189AbXDUAuq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Apr 2007 20:50:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, mbligh@mbligh.org, solo@google.com, stable@kernel.org


The patch titled
     page migration: fix NR_FILE_PAGES accounting
has been added to the -mm tree.  Its filename is
     page-migration-fix-nr_file_pages-accounting.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: page migration: fix NR_FILE_PAGES accounting
From: Christoph Lameter <clameter@sgi.com>

NR_FILE_PAGES must be accounted for depending on the zone that the page
belongs to.  If we replace the page in the radix tree then we may have to
shift the count to another zone.

Suggested-by: Ethan Solomita <solo@google.com>
Eventually-typed-in-by: Christoph Lameter <clameter@sgi.com>
Cc: Martin Bligh <mbligh@mbligh.org>
Cc: <stable@kernel.org>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate.c |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletion(-)

diff -puN mm/migrate.c~page-migration-fix-nr_file_pages-accounting mm/migrate.c
--- a/mm/migrate.c~page-migration-fix-nr_file_pages-accounting
+++ a/mm/migrate.c
@@ -297,7 +297,7 @@ static int migrate_page_move_mapping(str
 	void **pslot;
 
 	if (!mapping) {
-		/* Anonymous page */
+		/* Anonymous page without mapping */
 		if (page_count(page) != 1)
 			return -EAGAIN;
 		return 0;
@@ -333,6 +333,19 @@ static int migrate_page_move_mapping(str
 	 */
 	__put_page(page);
 
+	/*
+	 * If moved to a different zone then also account
+	 * the page for that zone. Other VM counters will be
+	 * taken care of when we establish references to the
+	 * new page and drop references to the old page.
+	 *
+	 * Note that anonymous pages are accounted for
+	 * via NR_FILE_PAGES and NR_ANON_PAGES if they
+	 * are mapped to swap space.
+	 */
+	__dec_zone_page_state(page, NR_FILE_PAGES);
+	__inc_zone_page_state(newpage, NR_FILE_PAGES);
+
 	write_unlock_irq(&mapping->tree_lock);
 
 	return 0;
_

Patches currently in -mm which might be from clameter@sgi.com are

fix-oom-killing-processes-wrongly-thought-mpol_bind.patch
page-migration-fix-nr_file_pages-accounting.patch
slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
extend-print_symbol-capability-fix-fix.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-core-drop-version-number.patch
slub-core-tidy.patch
slub-core-tidy-2.patch
slub-core-tidy-3.patch
slub-core-tidy-4.patch
slub-core-tidy-5.patch
slub-core-tidy-6.patch
slub-core-tidy-7.patch
slub-core-tidy-8.patch
slub-core-tidy-9.patch
slub-core-we-do-not-need-ifdef-config_smp-around-bit-spinlocks.patch
slub-core-printk-facility-level-cleanup.patch
slub-core-kmem_cache_close-is-static-and-should-not-be-exported.patch
slub-core-add-explanation-for-defrag_ratio-=-100.patch
slub-core-add-explanation-for-locking.patch
slub-core-add-explanation-for-locking-fix.patch
slub-core-explain-the-64k-limits.patch
slub-core-explain-sizing-of-slabs-in-detail.patch
slub-core-explain-sizing-of-slabs-in-detail-fix.patch
slub-core-add-checks-for-interrupts-disabled.patch
slub-core-use-__print_symbol-instead-of-kallsyms_lookup.patch
slub-core-missing-inlines-and-statics.patch
slub-fix-cpu-slab-flushing-behavior-so-that-counters-match.patch
slub-extract-finish_bootstrap-function-for-clean-sysfs-boot.patch
slub-core-fix-kmem_cache_destroy.patch
slub-core-fix-validation.patch
slub-core-add-after-object-padding.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-enable-tracking-of-full-slabs-add-checks-for-interrupts-disabled.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-validation-of-slabs-metadata-and-guard-zones-fix-pageerror-checks-during-validation.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
