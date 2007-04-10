From: akpm@linux-foundation.org
Subject: + slub-core-printk-facility-level-cleanup.patch added to -mm tree
Date: Tue, 10 Apr 2007 14:49:57 -0700
Message-ID: <200704102149.l3ALnvRY018447@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXDJVuA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 17:50:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: printk facility level cleanup
has been added to the -mm tree.  Its filename is
     slub-core-printk-facility-level-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: printk facility level cleanup
From: Christoph Lameter <clameter@sgi.com>

Consistently use KERN_ERR instead of KERN_CRIT.  Fixup one location where
we did not use a facility level.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/slub.c~slub-core-printk-facility-level-cleanup mm/slub.c
--- a/mm/slub.c~slub-core-printk-facility-level-cleanup
+++ a/mm/slub.c
@@ -502,14 +502,14 @@ static int check_object(struct kmem_cach
 static int check_slab(struct kmem_cache *s, struct page *page)
 {
 	if (!PageSlab(page)) {
-		printk(KERN_CRIT "SLUB: %s Not a valid slab page @0x%p "
+		printk(KERN_ERR "SLUB: %s Not a valid slab page @0x%p "
 			"flags=%lx mapping=0x%p count=%d \n",
 			s->name, page, page->flags, page->mapping,
 			page_count(page));
 		return 0;
 	}
 	if (page->offset * sizeof(void *) != s->offset) {
-		printk(KERN_CRIT "SLUB: %s Corrupted offset %lu in slab @0x%p"
+		printk(KERN_ERR "SLUB: %s Corrupted offset %lu in slab @0x%p"
 			" flags=0x%lx mapping=0x%p count=%d\n",
 			s->name,
 			(unsigned long)(page->offset * sizeof(void *)),
@@ -520,7 +520,7 @@ static int check_slab(struct kmem_cache 
 		return 0;
 	}
 	if (page->inuse > s->objects) {
-		printk(KERN_CRIT "SLUB: %s Inuse %u > max %u in slab "
+		printk(KERN_ERR "SLUB: %s Inuse %u > max %u in slab "
 			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
 			s->name, page->inuse, s->objects, page, page->flags,
 			page->mapping, page_count(page));
@@ -566,7 +566,7 @@ static int on_freelist(struct kmem_cache
 	}
 
 	if (page->inuse != s->objects - nr) {
-		printk(KERN_CRIT "slab %s: page 0x%p wrong object count."
+		printk(KERN_ERR "slab %s: page 0x%p wrong object count."
 			" counter is %d but counted were %d\n",
 			s->name, page, page->inuse,
 			s->objects - nr);
@@ -601,7 +601,7 @@ static int alloc_object_checks(struct km
 	init_object(s, object, 1);
 
 	if (s->flags & SLAB_TRACE) {
-		printk("TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
+		printk(KERN_INFO "TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
 			s->name, object, page->inuse,
 			page->freelist);
 		dump_stack();
@@ -630,7 +630,7 @@ static int free_object_checks(struct kme
 	}
 
 	if (on_freelist(s, page, object)) {
-		printk(KERN_CRIT "SLUB: %s slab 0x%p object "
+		printk(KERN_ERR "SLUB: %s slab 0x%p object "
 			"0x%p already free.\n", s->name, page, object);
 		goto fail;
 	}
@@ -640,23 +640,23 @@ static int free_object_checks(struct kme
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page))
-			printk(KERN_CRIT "slab_free %s size %d: attempt to"
+			printk(KERN_ERR "slab_free %s size %d: attempt to"
 				"free object(0x%p) outside of slab.\n",
 				s->name, s->size, object);
 		else
 		if (!page->slab)
-			printk(KERN_CRIT
+			printk(KERN_ERR
 				"slab_free : no slab(NULL) for object 0x%p.\n",
 						object);
 		else
-		printk(KERN_CRIT "slab_free %s(%d): object at 0x%p"
+		printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
 				" belongs to slab %s(%d)\n",
 				s->name, s->size, object,
 				page->slab->name, page->slab->size);
 		goto fail;
 	}
 	if (s->flags & SLAB_TRACE) {
-		printk("TRACE %s free 0x%p inuse=%d fp=0x%p\n",
+		printk(KERN_INFO "TRACE %s free 0x%p inuse=%d fp=0x%p\n",
 			s->name, object, page->inuse,
 			page->freelist);
 		print_section("Object", object, s->objsize);
@@ -1772,7 +1772,7 @@ static int __init setup_slub_debug(char 
 				slub_debug |= SLAB_TRACE;
 				break;
 			default:
-				printk(KERN_CRIT "slub_debug option '%c' "
+				printk(KERN_ERR "slub_debug option '%c' "
 					"unknown. skipped\n",*str);
 			}
 	}
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
