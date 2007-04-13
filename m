From: akpm@linux-foundation.org
Subject: + slub-remove-object-activities-out-of-checking-functions.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:39:22 -0700
Message-ID: <200704131939.l3DJdMVW007818@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932431AbXDMTjY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:39:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: remove object activities out of checking functions
has been added to the -mm tree.  Its filename is
     slub-remove-object-activities-out-of-checking-functions.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: remove object activities out of checking functions
From: Christoph Lameter <clameter@sgi.com>

Make sure that the check function really only check things and do not perform
activities.  Extract the tracing and object seeding out of the two check
functions and place them into slab_alloc and slab_free

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   41 ++++++++++++++++++++---------------------
 1 files changed, 20 insertions(+), 21 deletions(-)

diff -puN mm/slub.c~slub-remove-object-activities-out-of-checking-functions mm/slub.c
--- a/mm/slub.c~slub-remove-object-activities-out-of-checking-functions
+++ a/mm/slub.c
@@ -574,7 +574,7 @@ static int check_slab(struct kmem_cache 
 		return 0;
 	}
 	if (page->inuse > s->objects) {
-		printk(KERN_ERR "SLUB: %s Inuse %u > max %u in slab "
+		printk(KERN_ERR "SLUB: %s inuse %u > max %u in slab "
 			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
 			s->name, page->inuse, s->objects, page, page->flags,
 			page->mapping, page_count(page));
@@ -676,12 +676,13 @@ static int alloc_object_checks(struct km
 		printk(KERN_ERR "SLUB: %s Object 0x%p@0x%p "
 			"already allocated.\n",
 			s->name, object, page);
-		goto dump;
+		dump_stack();
+		goto bad;
 	}
 
 	if (!check_valid_pointer(s, page, object)) {
 		object_err(s, page, object, "Freelist Pointer check fails");
-		goto dump;
+		goto bad;
 	}
 
 	if (!object)
@@ -689,17 +690,8 @@ static int alloc_object_checks(struct km
 
 	if (!check_object(s, page, object, 0))
 		goto bad;
-	init_object(s, object, 1);
 
-	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
-			s->name, object, page->inuse,
-			page->freelist);
-		dump_stack();
-	}
 	return 1;
-dump:
-	dump_stack();
 bad:
 	if (PageSlab(page)) {
 		/*
@@ -750,20 +742,12 @@ static int free_object_checks(struct kme
 				"slab_free : no slab(NULL) for object 0x%p.\n",
 						object);
 		else
-		printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
+			printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
 				" belongs to slab %s(%d)\n",
 				s->name, s->size, object,
 				page->slab->name, page->slab->size);
 		goto fail;
 	}
-	if (s->flags & SLAB_TRACE) {
-		printk(KERN_INFO "TRACE %s free 0x%p inuse=%d fp=0x%p\n",
-			s->name, object, page->inuse,
-			page->freelist);
-		print_section("Object", object, s->objsize);
-		dump_stack();
-	}
-	init_object(s, object, 0);
 	return 1;
 fail:
 	dump_stack();
@@ -1294,6 +1278,13 @@ debug:
 		goto another_slab;
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, object, TRACK_ALLOC, addr);
+	if (s->flags & SLAB_TRACE) {
+		printk(KERN_INFO "TRACE %s alloc 0x%p inuse=%d fp=0x%p\n",
+			s->name, object, page->inuse,
+			page->freelist);
+		dump_stack();
+	}
+	init_object(s, object, 1);
 	goto have_object;
 }
 
@@ -1376,6 +1367,14 @@ debug:
 		remove_full(s, page);
 	if (s->flags & SLAB_STORE_USER)
 		set_track(s, x, TRACK_FREE, addr);
+	if (s->flags & SLAB_TRACE) {
+		printk(KERN_INFO "TRACE %s free 0x%p inuse=%d fp=0x%p\n",
+			s->name, object, page->inuse,
+			page->freelist);
+		print_section("Object", (void *)object, s->objsize);
+		dump_stack();
+	}
+	init_object(s, object, 0);
 	goto checks_ok;
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
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
