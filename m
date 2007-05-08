From: akpm@linux-foundation.org
Subject: - slub-remove-object-activities-out-of-checking-functions.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:53 -0700
Message-ID: <200705080008.l4808rLk009407@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39710 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967442AbXEHAJQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:09:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: remove object activities out of checking functions
has been removed from the -mm tree.  Its filename was
     slub-remove-object-activities-out-of-checking-functions.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: remove object activities out of checking functions
From: Christoph Lameter <clameter@sgi.com>

Make sure that the check function really only check things and do not perform
activities.  Extract the tracing and object seeding out of the two check
functions and place them into slab_alloc and slab_free

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  108 ++++++++++++++++++++++------------------------------
 1 files changed, 47 insertions(+), 61 deletions(-)

diff -puN mm/slub.c~slub-remove-object-activities-out-of-checking-functions mm/slub.c
--- a/mm/slub.c~slub-remove-object-activities-out-of-checking-functions
+++ a/mm/slub.c
@@ -459,7 +459,7 @@ static int check_valid_pointer(struct km
 static void restore_bytes(struct kmem_cache *s, char *message, u8 data,
 						void *from, void *to)
 {
-	printk(KERN_ERR "@@@ SLUB: %s Restoring %s (0x%x) from 0x%p-0x%p\n",
+	printk(KERN_ERR "@@@ SLUB %s: Restoring %s (0x%x) from 0x%p-0x%p\n",
 		s->name, message, data, from, to - 1);
 	memset(from, data, to - from);
 }
@@ -506,9 +506,7 @@ static int slab_pad_check(struct kmem_ca
 		return 1;
 
 	if (!check_bytes(p + length, POISON_INUSE, remainder)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p: Padding fails check\n",
-			s->name, p);
-		dump_stack();
+		slab_err(s, page, "Padding check failed");
 		restore_bytes(s, "slab padding", POISON_INUSE, p + length,
 			p + length + remainder);
 		return 0;
@@ -594,30 +592,25 @@ static int check_slab(struct kmem_cache 
 	VM_BUG_ON(!irqs_disabled());
 
 	if (!PageSlab(page)) {
-		printk(KERN_ERR "SLUB: %s Not a valid slab page @0x%p "
-			"flags=%lx mapping=0x%p count=%d \n",
-			s->name, page, page->flags, page->mapping,
+		slab_err(s, page, "Not a valid slab page flags=%lx "
+			"mapping=0x%p count=%d", page->flags, page->mapping,
 			page_count(page));
 		return 0;
 	}
 	if (page->offset * sizeof(void *) != s->offset) {
-		printk(KERN_ERR "SLUB: %s Corrupted offset %lu in slab @0x%p"
-			" flags=0x%lx mapping=0x%p count=%d\n",
-			s->name,
+		slab_err(s, page, "Corrupted offset %lu flags=0x%lx "
+			"mapping=0x%p count=%d",
 			(unsigned long)(page->offset * sizeof(void *)),
-			page,
 			page->flags,
 			page->mapping,
 			page_count(page));
-		dump_stack();
 		return 0;
 	}
 	if (page->inuse > s->objects) {
-		printk(KERN_ERR "SLUB: %s Inuse %u > max %u in slab "
-			"page @0x%p flags=%lx mapping=0x%p count=%d\n",
-			s->name, page->inuse, s->objects, page, page->flags,
+		slab_err(s, page, "inuse %u > max %u @0x%p flags=%lx "
+			"mapping=0x%p count=%d",
+			s->name, page->inuse, s->objects, page->flags,
 			page->mapping, page_count(page));
-		dump_stack();
 		return 0;
 	}
 	/* Slab_pad_check fixes things up after itself */
@@ -646,12 +639,13 @@ static int on_freelist(struct kmem_cache
 				set_freepointer(s, object, NULL);
 				break;
 			} else {
-				printk(KERN_ERR "SLUB: %s slab 0x%p "
-					"freepointer 0x%p corrupted.\n",
-					s->name, page, fp);
-				dump_stack();
+				slab_err(s, page, "Freepointer 0x%p corrupt",
+									fp);
 				page->freelist = NULL;
 				page->inuse = s->objects;
+				printk(KERN_ERR "@@@ SLUB %s: Freelist "
+					"cleared. Slab 0x%p\n",
+					s->name, page);
 				return 0;
 			}
 			break;
@@ -662,11 +656,12 @@ static int on_freelist(struct kmem_cache
 	}
 
 	if (page->inuse != s->objects - nr) {
-		printk(KERN_ERR "slab %s: page 0x%p wrong object count."
-			" counter is %d but counted were %d\n",
-			s->name, page, page->inuse,
-			s->objects - nr);
+		slab_err(s, page, "Wrong object count. Counter is %d but "
+			"counted were %d", s, page, page->inuse,
+							s->objects - nr);
 		page->inuse = s->objects - nr;
+		printk(KERN_ERR "@@@ SLUB %s: Object count adjusted. "
+			"Slab @0x%p\n", s->name, page);
 	}
 	return search == NULL;
 }
@@ -702,15 +697,13 @@ static int alloc_object_checks(struct km
 		goto bad;
 
 	if (object && !on_freelist(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s Object 0x%p@0x%p "
-			"already allocated.\n",
-			s->name, object, page);
-		goto dump;
+		slab_err(s, page, "Object 0x%p already allocated", object);
+		goto bad;
 	}
 
 	if (!check_valid_pointer(s, page, object)) {
 		object_err(s, page, object, "Freelist Pointer check fails");
-		goto dump;
+		goto bad;
 	}
 
 	if (!object)
@@ -718,17 +711,8 @@ static int alloc_object_checks(struct km
 
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
@@ -753,15 +737,12 @@ static int free_object_checks(struct kme
 		goto fail;
 
 	if (!check_valid_pointer(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p invalid "
-			"object pointer 0x%p\n",
-			s->name, page, object);
+		slab_err(s, page, "Invalid object pointer 0x%p", object);
 		goto fail;
 	}
 
 	if (on_freelist(s, page, object)) {
-		printk(KERN_ERR "SLUB: %s slab 0x%p object "
-			"0x%p already free.\n", s->name, page, object);
+		slab_err(s, page, "Object 0x%p already free", object);
 		goto fail;
 	}
 
@@ -770,32 +751,22 @@ static int free_object_checks(struct kme
 
 	if (unlikely(s != page->slab)) {
 		if (!PageSlab(page))
-			printk(KERN_ERR "slab_free %s size %d: attempt to"
-				"free object(0x%p) outside of slab.\n",
-				s->name, s->size, object);
+			slab_err(s, page, "Attempt to free object(0x%p) "
+				"outside of slab", object);
 		else
-		if (!page->slab)
+		if (!page->slab) {
 			printk(KERN_ERR
-				"slab_free : no slab(NULL) for object 0x%p.\n",
+				"SLUB <none>: no slab for object 0x%p.\n",
 						object);
+			dump_stack();
+		}
 		else
-		printk(KERN_ERR "slab_free %s(%d): object at 0x%p"
-				" belongs to slab %s(%d)\n",
-				s->name, s->size, object,
-				page->slab->name, page->slab->size);
+			slab_err(s, page, "object at 0x%p belongs "
+				"to slab %s", object, page->slab->name);
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
-	dump_stack();
 	printk(KERN_ERR "@@@ SLUB: %s slab 0x%p object at 0x%p not freed.\n",
 		s->name, page, object);
 	return 0;
@@ -1294,6 +1265,13 @@ debug:
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
 
@@ -1376,6 +1354,14 @@ debug:
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

origin.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
slub-exploit-page-mobility-to-increase-allocation-order.patch
slub-mm-only-make-slub-the-default-slab-allocator.patch
slub-i386-support.patch
remove-constructor-from-buffer_head.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
revoke-core-code-slab-allocators-remove-slab_debug_initial-flag-revoke.patch
vmstat-use-our-own-timer-events.patch
make-vm-statistics-update-interval-configurable.patch
make-vm-statistics-update-interval-configurable-fix.patch
readahead-state-based-method-aging-accounting.patch
