From: akpm@linux-foundation.org
Subject: - slub-core-resiliency-fixups.patch removed from -mm tree
Date: Fri, 27 Apr 2007 01:22:28 -0700
Message-ID: <200704270822.l3R8MSVN023329@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47599 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbXD0IWb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 04:22:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: resiliency fixups
has been removed from the -mm tree.  Its filename was
     slub-core-resiliency-fixups.patch

This patch was dropped because it was folded into slub-core.patch

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
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-resiliency-fixups.patch
slub-core-resiliency-fixups-fix.patch
slub-core-resiliency-test.patch
slub-core-update-cpu-after-new_slab.patch
slub-core-fix-sysfs-directory-handling.patch
slub-core-conform-more-to-slabs-slab_hwcache_align-behavior.patch
slub-core-reduce-the-order-of-allocations-to-avoid-fragmentation.patch
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
slub-validation-of-slabs-metadata-and-guard-zones-remove-duplicate-vm_bug_on.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion-fix.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_debug_initial-flag-locks-fix.patch
slab-allocators-remove-multiple-alignment-specifications.patch
slab-allocators-remove-slab_ctor_atomic.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slub-i386-support.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
readahead-state-based-method-aging-accounting.patch
