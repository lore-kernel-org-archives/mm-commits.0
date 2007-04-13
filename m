From: akpm@linux-foundation.org
Subject: + slub-core-resiliency-fixups.patch added to -mm tree
Date: Fri, 13 Apr 2007 12:37:05 -0700
Message-ID: <200704131937.l3DJb5bo007760@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47703 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932473AbXDMThI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 15:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: resiliency fixups
has been added to the -mm tree.  Its filename is
     slub-core-resiliency-fixups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: resiliency fixups
From: Christoph Lameter <clameter@sgi.com>

Do more fixups if we detect problems in order to potentially heal problems so
that the system can continue.  This will also avoid multiple reports about the
same corruption.

Add messages what slub does to fix up things. These all begin with @@@.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  102 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 76 insertions(+), 26 deletions(-)

diff -puN mm/slub.c~slub-core-resiliency-fixups mm/slub.c
--- a/mm/slub.c~slub-core-resiliency-fixups
+++ a/mm/slub.c
@@ -193,8 +193,6 @@ static void print_section(char *text, u8
 	int newline = 1;
 	char ascii[17];
 
-	if (length > 128)
-		length = 128;
 	ascii[16] = 0;
 
 	for (i = 0; i < length; i++) {
@@ -337,13 +335,13 @@ static void object_err(struct kmem_cache
 {
 	u8 *addr = page_address(page);
 
-	printk(KERN_ERR "*** SLUB: %s in %s@0x%p Slab 0x%p\n",
+	printk(KERN_ERR "*** SLUB: %s in %s@0x%p slab 0x%p\n",
 			reason, s->name, object, page);
 	printk(KERN_ERR "    offset=%tu flags=0x%04lx inuse=%u freelist=0x%p\n",
 		object - addr, page->flags, page->inuse, page->freelist);
 	if (object > addr + 16)
 		print_section("Bytes b4", object - 16, 16);
-	print_section("Object", object, s->objsize);
+	print_section("Object", object, min(s->objsize, 128));
 	print_trailer(s, object);
 	dump_stack();
 }
@@ -422,6 +420,14 @@ static int check_valid_pointer(struct km
  * may be used with merged slabcaches.
  */
 
+static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
+						void *from, void *to)
+{
+	printk(KERN_ERR "@@@ SLUB: %s Restoring %s (0x%x) from 0x%p-0x%p\n",
+		s->name, message, data, from, to - 1);
+	memset(from, data, to - from);
+}
+
 static int check_pad_bytes(struct kmem_cache *s, struct page *page, u8 *p)
 {
 	unsigned long off = s->inuse;	/* The end of info */
@@ -441,6 +447,11 @@ static int check_pad_bytes(struct kmem_c
 		return 1;
 
 	object_err(s, page, p, "Object padding check fails");
+
+	/*
+	 * Restore padding
+	 */
+	restore_bytes(s, "object padding", POISON_INUSE, p + off, p + s->size);
 	return 0;
 }
 
@@ -461,7 +472,9 @@ static int slab_pad_check(struct kmem_ca
 	if (!check_bytes(p + length, POISON_INUSE, remainder)) {
 		printk(KERN_ERR "SLUB: %s slab 0x%p: Padding fails check\n",
 			s->name, p);
-		print_section("Slab Pad", p + length, remainder);
+		dump_stack();
+		restore_bytes(s, "slab padding", POISON_INUSE, p + length,
+			p + length + remainder);
 		return 0;
 	}
 	return 1;
@@ -474,28 +487,48 @@ static int check_object(struct kmem_cach
 	u8 *endobject = object + s->objsize;
 
 	if (s->flags & SLAB_RED_ZONE) {
-		if (!check_bytes(endobject,
-			active ? SLUB_RED_ACTIVE : SLUB_RED_INACTIVE,
-			s->inuse - s->objsize)) {
-				object_err(s, page, object,
-				active ? "Redzone Active check fails" :
-					"Redzone Inactive check fails");
-				return 0;
+		unsigned int red =
+			active ? SLUB_RED_ACTIVE : SLUB_RED_INACTIVE;
+
+		if (!check_bytes(endobject, red, s->inuse - s->objsize)) {
+			object_err(s, page, object,
+			active ? "Redzone Active" : "Redzone Inactive");
+			restore_bytes(s, "redzone", red,
+				endobject, object + s->inuse);
+			return 0;
 		}
-	} else if ((s->flags & SLAB_POISON) && s->objsize < s->inuse &&
+	} else {
+		if ((s->flags & SLAB_POISON) && s->objsize < s->inuse &&
 			!check_bytes(endobject, POISON_INUSE,
-					s->inuse - s->objsize))
+					s->inuse - s->objsize)) {
 		object_err(s, page, p, "Alignment padding check fails");
+		/*
+		 * Fix it so that there will not be another report.
+		 *
+		 * Hmmm... We may be corrupting an object that now expects
+		 * to be longer than allowed.
+		 */
+		restore_bytes(s, "alignment padding", POISON_INUSE,
+			endobject, object + s->inuse);
+		}
+	}
 
 	if (s->flags & SLAB_POISON) {
 		if (!active && (s->flags & __OBJECT_POISON) &&
 			(!check_bytes(p, POISON_FREE, s->objsize - 1) ||
 				p[s->objsize - 1] != POISON_END)) {
+
 			object_err(s, page, p, "Poison check failed");
+			restore_bytes(s, "Poison", POISON_FREE,
+						p, p + s->objsize -1);
+			restore_bytes(s, "Poison", POISON_END,
+					p + s->objsize - 1, p + s->objsize);
 			return 0;
 		}
-		if (!check_pad_bytes(s, page, p))
-			return 0;
+		/*
+		 * check_pad_bytes cleans up on its own.
+		 */
+		check_pad_bytes(s, page, p);
 	}
 
 	if (!s->offset && active)
@@ -509,9 +542,10 @@ static int check_object(struct kmem_cach
 	if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
 		object_err(s, page, p, "Freepointer corrupt");
 		/*
-		 * No choice but to zap it. This may cause
-		 * another error because the object count
-		 * is now wrong.
+		 * No choice but to zap it and thus loose the remainder
+		 * of the free objects in this slab. May cause
+		 * another error because the object count maybe
+		 * wrong now.
 		 */
 		set_freepointer(s, p, NULL);
 		return 0;
@@ -538,7 +572,8 @@ static int check_slab(struct kmem_cache 
 			page,
 			page->flags,
 			page->mapping,
-			page_count(page));
+			page_count(page));\
+		dump_stack();
 		return 0;
 	}
 	if (page->inuse > s->objects) {
@@ -546,9 +581,12 @@ static int check_slab(struct kmem_cache 
 			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
 			s->name, page->inuse, s->objects, page, page->flags,
 			page->mapping, page_count(page));
+		dump_stack();
 		return 0;
 	}
-	return slab_pad_check(s, page);
+	/* Slab_pad_check fixes things up after itself */
+	slab_pad_check(s, page);
+	return 1;
 }
 
 /*
@@ -632,9 +670,19 @@ static int alloc_object_checks(struct km
 dump:
 	dump_stack();
 bad:
-	/* Mark slab full */
-	page->inuse = s->objects;
-	page->freelist = NULL;
+	if (PageSlab(page)) {
+		/*
+		 * If this is a slab page then lets do the best we can
+		 * to avoid issues in the future. Marking all objects
+		 * as used avoids touching the remainder.
+		 */
+		printk(KERN_ERR "@@@ SLUB: %s slab 0x%p. Marking all objects used.\n",
+			s->name, page);
+		page->inuse = s->objects;
+		page->freelist = NULL;
+		/* Fix up fields that may be corrupted */
+		page->offset = s->offset / sizeof(void *);
+	}
 	return 0;
 }
 
@@ -688,6 +736,8 @@ static int free_object_checks(struct kme
 	return 1;
 fail:
 	dump_stack();
+	printk(KERN_ERR "@@@ SLUB: %s slab 0x%p object at 0x%p not freed.\n",
+		s->name, page, object);
 	return 0;
 }
 
@@ -1548,9 +1598,9 @@ static int calculate_sizes(struct kmem_c
 	 */
 	if ((flags & SLAB_POISON) && !(flags & SLAB_DESTROY_BY_RCU) &&
 			!s->ctor && !s->dtor)
-		flags |= __OBJECT_POISON;
+		s->flags |= __OBJECT_POISON;
 	else
-		flags &= ~__OBJECT_POISON;
+		s->flags &= ~__OBJECT_POISON;
 
 	/*
 	 * Round up object size to the next word boundary. We can only
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
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
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
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
remove-object-activities-out-of-checking-functions.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
