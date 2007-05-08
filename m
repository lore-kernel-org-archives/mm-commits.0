From: akpm@linux-foundation.org
Subject: - slub-validation-of-slabs-metadata-and-guard-zones.patch removed from -mm tree
Date: Mon, 07 May 2007 17:08:36 -0700
Message-ID: <200705080008.l4808aWH009393@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:44540 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967439AbXEHAI4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:08:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     slub: validation of slabs (metadata and guard zones)
has been removed from the -mm tree.  Its filename was
     slub-validation-of-slabs-metadata-and-guard-zones.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slub: validation of slabs (metadata and guard zones)
From: Christoph Lameter <clameter@sgi.com>

This enables validation of slab.  Validation means that all objects are
checked to see if there are redzone violations, if padding has been
overwritten or any pointers have been corrupted.  Also checks the consistency
of slab counters.

Validation enables the detection of metadata corruption without the kernel
having to execute code that actually uses (allocs/frees) and object.  It
allows one to make sure that the slab metainformation and the guard values
around an object have not been compromised.

A single slabcache can be checked by writing a 1 to the "validate" file.

i.e.

echo 1 >/sys/slab/kmalloc-128/validate

or use the slabinfo tool to check all slabs

slabinfo -v

Error messages will show up in the syslog.

Note that validation can only reach slabs that are on a list.  This means that
we are usually restricted to partial slabs and active slabs unless
SLAB_STORE_USER is active which will build a full slab list and allows
validation of slabs that are fully in use.  Booting with "slub_debug" set will
enable SLAB_STORE_USER and then full diagnostic are available.

Note that we attempt to push cpu slabs back to the lists when we start the
check.  If the cpu slab is reactivated before we get to it (another processor
grabs it before we get to it) then it cannot be checked.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  113 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 110 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones mm/slub.c
--- a/mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones
+++ a/mm/slub.c
@@ -670,8 +670,6 @@ static void add_full(struct kmem_cache *
 
 	VM_BUG_ON(!irqs_disabled());
 
-	VM_BUG_ON(!irqs_disabled());
-
 	if (!(s->flags & SLAB_STORE_USER))
 		return;
 
@@ -2551,6 +2549,99 @@ void *__kmalloc_node_track_caller(size_t
 
 #ifdef CONFIG_SYSFS
 
+static int validate_slab(struct kmem_cache *s, struct page *page)
+{
+	void *p;
+	void *addr = page_address(page);
+	unsigned long map[BITS_TO_LONGS(s->objects)];
+
+	if (!check_slab(s, page) ||
+			!on_freelist(s, page, NULL))
+		return 0;
+
+	/* Now we know that a valid freelist exists */
+	bitmap_zero(map, s->objects);
+
+	for(p = page->freelist; p; p = get_freepointer(s, p)) {
+		set_bit((p - addr) / s->size, map);
+		if (!check_object(s, page, p, 0))
+			return 0;
+	}
+
+	for(p = addr; p < addr + s->objects * s->size; p += s->size)
+		if (!test_bit((p - addr) / s->size, map))
+			if (!check_object(s, page, p, 1))
+				return 0;
+	return 1;
+}
+
+static void validate_slab_slab(struct kmem_cache *s, struct page *page)
+{
+	if (slab_trylock(page)) {
+		validate_slab(s, page);
+		slab_unlock(page);
+	} else
+		printk(KERN_INFO "SLUB %s: Skipped busy slab 0x%p\n",
+			s->name, page);
+
+	if (s->flags & DEBUG_DEFAULT_FLAGS) {
+		if (!PageError(page))
+			printk(KERN_ERR "SLUB %s: PageError not set "
+				"on slab 0x%p\n", s->name, page);
+	} else {
+		if (PageError(page))
+			printk(KERN_ERR "SLUB %s: PageError set on "
+				"slab 0x%p\n", s->name, page);
+	}
+}
+
+static int validate_slab_node(struct kmem_cache *s, struct kmem_cache_node *n)
+{
+	unsigned long count = 0;
+	struct page *page;
+	unsigned long flags;
+
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	list_for_each_entry(page, &n->partial, lru) {
+		validate_slab_slab(s, page);
+		count++;
+	}
+	if (count != n->nr_partial)
+		printk(KERN_ERR "SLUB %s: %ld partial slabs counted but "
+			"counter=%ld\n", s->name, count, n->nr_partial);
+
+	if (!(s->flags & SLAB_STORE_USER))
+		goto out;
+
+	list_for_each_entry(page, &n->full, lru) {
+		validate_slab_slab(s, page);
+		count++;
+	}
+	if (count != atomic_long_read(&n->nr_slabs))
+		printk(KERN_ERR "SLUB: %s %ld slabs counted but "
+			"counter=%ld\n", s->name, count,
+			atomic_long_read(&n->nr_slabs));
+
+out:
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return count;
+}
+
+static unsigned long validate_slab_cache(struct kmem_cache *s)
+{
+	int node;
+	unsigned long count = 0;
+
+	flush_all(s);
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		count += validate_slab_node(s, n);
+	}
+	return count;
+}
+
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
@@ -2680,7 +2771,6 @@ struct slab_attribute {
 	static struct slab_attribute _name##_attr =  \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
-
 static ssize_t slab_size_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", s->size);
@@ -2886,6 +2976,22 @@ static ssize_t store_user_store(struct k
 }
 SLAB_ATTR(store_user);
 
+static ssize_t validate_show(struct kmem_cache *s, char *buf)
+{
+	return 0;
+}
+
+static ssize_t validate_store(struct kmem_cache *s,
+			const char *buf, size_t length)
+{
+	if (buf[0] == '1')
+		validate_slab_cache(s);
+	else
+		return -EINVAL;
+	return length;
+}
+SLAB_ATTR(validate);
+
 #ifdef CONFIG_NUMA
 static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -2925,6 +3031,7 @@ static struct attribute * slab_attrs[] =
 	&red_zone_attr.attr,
 	&poison_attr.attr,
 	&store_user_attr.attr,
+	&validate_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
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
