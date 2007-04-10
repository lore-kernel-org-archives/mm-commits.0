From: akpm@linux-foundation.org
Subject: + slub-core-explain-the-64k-limits.patch added to -mm tree
Date: Tue, 10 Apr 2007 16:38:56 -0700
Message-ID: <200704102339.l3ANd1hJ023164@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:52208 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161107AbXDJXjE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 19:39:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: Explain the 64k limits
has been added to the -mm tree.  Its filename is
     slub-core-explain-the-64k-limits.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: Explain the 64k limits
From: Christoph Lameter <clameter@sgi.com>

Note that these limits could now be removed since we no longer use
page->private for compound pages.  But I think this is fine for now.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++++++++++++-
 1 files changed, 21 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-core-explain-the-64k-limits mm/slub.c
--- a/mm/slub.c~slub-core-explain-the-64k-limits
+++ a/mm/slub.c
@@ -1571,6 +1571,12 @@ static int calculate_sizes(struct kmem_c
 		return 0;
 
 	s->objects = (PAGE_SIZE << s->order) / size;
+
+	/*
+	 * Verify that the number of objects is within permitted limits.
+	 * The page->inuse field is only 16 bit wide! So we cannot have
+	 * more than 64k objects per slab.
+	 */
 	if (!s->objects || s->objects > 65535)
 		return 0;
 	return 1;
@@ -1593,9 +1599,23 @@ static int kmem_cache_open(struct kmem_c
 
 	BUG_ON(flags & SLUB_UNIMPLEMENTED);
 
-	if (s->size >= 65535 * sizeof(void *))
+	/*
+	 * The page->offset field is only 16 bit wide. This is an offset
+	 * in units of words from the beginning of an object. If the slab
+	 * size is bigger then we cannot move the free pointer behind the
+	 * object anymore.
+	 *
+	 * On 32 bit platforms the limit is 256k. On 64bit platforms
+	 * the limit is 512k.
+	 *
+	 * Debugging or ctor/dtors may create a need to move the free
+	 * pointer. Fail if this happens.
+	 */
+	if (s->size >= 65535 * sizeof(void *)) {
 		BUG_ON(flags & (SLAB_RED_ZONE | SLAB_POISON |
 				SLAB_STORE_USER | SLAB_DESTROY_BY_RCU));
+		BUG_ON(ctor || dtor);
+	}
 	else
 		/*
 		 * Enable debugging if selected on the kernel commandline.
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
paravirt_ops-allow-paravirt-backend-to-choose-kernel-pmd-sharing.patch
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
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-enable-tracking-of-full-slabs-fix.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
