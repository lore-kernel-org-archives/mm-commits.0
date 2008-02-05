From: akpm@linux-foundation.org
Subject: - slub-fix-coding-style-violations.patch removed from -mm tree
Date: Mon, 04 Feb 2008 18:53:45 -0800
Message-ID: <200802050253.m152rQeg031502@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55589 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbYBECxc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2008 21:53:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penberg@cs.helsinki.fi, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: fix coding style violations
has been removed from the -mm tree.  Its filename was
     slub-fix-coding-style-violations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: slub: fix coding style violations
From: Pekka Enberg <penberg@cs.helsinki.fi>

This fixes most of the obvious coding style violations in mm/slub.c as
reported by checkpatch.

[akpm@linux-foundation.org: err, coding-style fixes]
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff -puN mm/slub.c~slub-fix-coding-style-violations mm/slub.c
--- a/mm/slub.c~slub-fix-coding-style-violations
+++ a/mm/slub.c
@@ -354,22 +354,22 @@ static void print_section(char *text, u8
 			printk(KERN_ERR "%8s 0x%p: ", text, addr + i);
 			newline = 0;
 		}
-		printk(" %02x", addr[i]);
+		printk(KERN_CONT " %02x", addr[i]);
 		offset = i % 16;
 		ascii[offset] = isgraph(addr[i]) ? addr[i] : '.';
 		if (offset == 15) {
-			printk(" %s\n",ascii);
+			printk(KERN_CONT " %s\n", ascii);
 			newline = 1;
 		}
 	}
 	if (!newline) {
 		i %= 16;
 		while (i < 16) {
-			printk("   ");
+			printk(KERN_CONT "   ");
 			ascii[i] = ' ';
 			i++;
 		}
-		printk(" %s\n", ascii);
+		printk(KERN_CONT " %s\n", ascii);
 	}
 }
 
@@ -529,7 +529,7 @@ static void init_object(struct kmem_cach
 
 	if (s->flags & __OBJECT_POISON) {
 		memset(p, POISON_FREE, s->objsize - 1);
-		p[s->objsize -1] = POISON_END;
+		p[s->objsize - 1] = POISON_END;
 	}
 
 	if (s->flags & SLAB_RED_ZONE)
@@ -558,7 +558,7 @@ static void restore_bytes(struct kmem_ca
 
 static int check_bytes_and_report(struct kmem_cache *s, struct page *page,
 			u8 *object, char *what,
-			u8* start, unsigned int value, unsigned int bytes)
+			u8 *start, unsigned int value, unsigned int bytes)
 {
 	u8 *fault;
 	u8 *end;
@@ -692,7 +692,7 @@ static int check_object(struct kmem_cach
 			(!check_bytes_and_report(s, page, p, "Poison", p,
 					POISON_FREE, s->objsize - 1) ||
 			 !check_bytes_and_report(s, page, p, "Poison",
-			 	p + s->objsize -1, POISON_END, 1)))
+					p + s->objsize - 1, POISON_END, 1)))
 			return 0;
 		/*
 		 * check_pad_bytes cleans up on its own.
@@ -900,8 +900,7 @@ static int free_debug_processing(struct 
 				"SLUB <none>: no slab for object 0x%p.\n",
 						object);
 			dump_stack();
-		}
-		else
+		} else
 			object_err(s, page, object,
 					"page slab pointer corrupt.");
 		goto fail;
@@ -947,7 +946,7 @@ static int __init setup_slub_debug(char 
 	/*
 	 * Determine which debug features should be switched on
 	 */
-	for ( ;*str && *str != ','; str++) {
+	for (; *str && *str != ','; str++) {
 		switch (tolower(*str)) {
 		case 'f':
 			slub_debug |= SLAB_DEBUG_FREE;
@@ -966,7 +965,7 @@ static int __init setup_slub_debug(char 
 			break;
 		default:
 			printk(KERN_ERR "slub_debug option '%c' "
-				"unknown. skipped\n",*str);
+				"unknown. skipped\n", *str);
 		}
 	}
 
@@ -1039,7 +1038,7 @@ static inline unsigned long kmem_cache_f
  */
 static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
-	struct page * page;
+	struct page *page;
 	int pages = 1 << s->order;
 
 	if (s->order)
@@ -1135,7 +1134,7 @@ static void __free_slab(struct kmem_cach
 	mod_zone_page_state(page_zone(page),
 		(s->flags & SLAB_RECLAIM_ACCOUNT) ?
 		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE,
-		- pages);
+		-pages);
 
 	__free_pages(page, s->order);
 }
@@ -1539,7 +1538,7 @@ debug:
  *
  * Otherwise we can simply pick the next object from the lockless free list.
  */
-static void __always_inline *slab_alloc(struct kmem_cache *s,
+static __always_inline void *slab_alloc(struct kmem_cache *s,
 		gfp_t gfpflags, int node, void *addr)
 {
 	void **object;
@@ -1647,7 +1646,7 @@ debug:
  * If fastpath is not possible then fall back to __slab_free where we deal
  * with all sorts of special processing.
  */
-static void __always_inline slab_free(struct kmem_cache *s,
+static __always_inline void slab_free(struct kmem_cache *s,
 			struct page *page, void *x, void *addr)
 {
 	void **object = (void *)x;
@@ -2228,7 +2227,7 @@ error:
  */
 int kmem_ptr_validate(struct kmem_cache *s, const void *object)
 {
-	struct page * page;
+	struct page *page;
 
 	page = get_object_page(object);
 
@@ -2341,7 +2340,7 @@ static struct kmem_cache *kmalloc_caches
 
 static int __init setup_slub_min_order(char *str)
 {
-	get_option (&str, &slub_min_order);
+	get_option(&str, &slub_min_order);
 
 	return 1;
 }
@@ -2350,7 +2349,7 @@ __setup("slub_min_order=", setup_slub_mi
 
 static int __init setup_slub_max_order(char *str)
 {
-	get_option (&str, &slub_max_order);
+	get_option(&str, &slub_max_order);
 
 	return 1;
 }
@@ -2359,7 +2358,7 @@ __setup("slub_max_order=", setup_slub_ma
 
 static int __init setup_slub_min_objects(char *str)
 {
-	get_option (&str, &slub_min_objects);
+	get_option(&str, &slub_min_objects);
 
 	return 1;
 }
@@ -2944,7 +2943,7 @@ static struct kmem_cache *find_mergeable
 		 * Check if alignment is compatible.
 		 * Courtesy of Adrian Drzewiecki
 		 */
-		if ((s->size & ~(align -1)) != s->size)
+		if ((s->size & ~(align - 1)) != s->size)
 			continue;
 
 		if (s->size - size >= sizeof(void *))
@@ -3053,8 +3052,9 @@ static int __cpuinit slab_cpuup_callback
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata slab_notifier =
-	{ &slab_cpuup_callback, NULL, 0 };
+static struct notifier_block __cpuinitdata slab_notifier = {
+	&slab_cpuup_callback, NULL, 0
+};
 
 #endif
 
@@ -3865,7 +3865,7 @@ static ssize_t remote_node_defrag_ratio_
 SLAB_ATTR(remote_node_defrag_ratio);
 #endif
 
-static struct attribute * slab_attrs[] = {
+static struct attribute *slab_attrs[] = {
 	&slab_size_attr.attr,
 	&object_size_attr.attr,
 	&objs_per_slab_attr.attr,
_

Patches currently in -mm which might be from penberg@cs.helsinki.fi are

origin.patch
git-unionfs.patch
slab-leaks3-default-y.patch
