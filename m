From: akpm@linux-foundation.org
Subject: + slub-validation-of-slabs-metadata-and-guard-zones.patch added to -mm tree
Date: Tue, 10 Apr 2007 12:35:57 -0700
Message-ID: <200704101935.l3AJZvhp015676@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42698 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781AbXDJTgB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 15:36:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: validation of slabs (metadata and guard zones)
has been added to the -mm tree.  Its filename is
     slub-validation-of-slabs-metadata-and-guard-zones.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 mm/slub.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 103 insertions(+), 1 deletion(-)

diff -puN mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones mm/slub.c
--- a/mm/slub.c~slub-validation-of-slabs-metadata-and-guard-zones
+++ a/mm/slub.c
@@ -2321,6 +2321,92 @@ void *__kmalloc_node_track_caller(size_t
 
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
+		printk(KERN_INFO "SLUB: %s Skipped busy slab %p\n",
+			s->name, page);
+
+	if (!PageError(page))
+		printk(KERN_ERR "SLUB: %s PageError not set on slab %p\n",
+			s->name, page);
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
+		printk("SLUB: %s %ld partial slabs counted but counter=%ld\n",
+			s->name, count, n->nr_partial);
+
+	if (!(s->flags & SLAB_STORE_USER))
+		goto out;
+
+	list_for_each_entry(page, &n->full, lru) {
+		validate_slab_slab(s, page);
+		count++;
+	}
+	if (count != atomic_long_read(&n->nr_slabs))
+		printk("SLUB: %s %ld slabs counted but counter=%ld\n",
+		s->name, count, atomic_long_read(&n->nr_slabs));
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
@@ -2450,7 +2536,6 @@ struct slab_attribute {
 	static struct slab_attribute _name##_attr =  \
 	__ATTR(_name, 0644, _name##_show, _name##_store)
 
-
 static ssize_t slab_size_show(struct kmem_cache *s, char *buf)
 {
 	return sprintf(buf, "%d\n", s->size);
@@ -2656,6 +2741,22 @@ static ssize_t store_user_store(struct k
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
@@ -2695,6 +2796,7 @@ static struct attribute * slab_attrs[] =
 	&red_zone_attr.attr,
 	&poison_attr.attr,
 	&store_user_attr.attr,
+	&validate_attr.attr,
 #ifdef CONFIG_ZONE_DMA
 	&cache_dma_attr.attr,
 #endif
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
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-fix-numa-bootstrap.patch
slub-use-correct-flags-to-check-for-dma-cache.patch
slub-treat-slab_hwcache_align-as-a-mininum-and-not-as-the-alignment.patch
slub-core-minor-fixes.patch
slub-core-use-enum-for-tracking-modes-instead-of-integers.patch
slub-core-fix-another-numa-bootstrap-issue.patch
slub-core-fix-object-counting.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
make-page-private-usable-in-compound-pages-v1.patch
make-page-private-usable-in-compound-pages-v1-hugetlb-fix.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
add-ability-to-list-alloc--free-callers-per-slab.patch
drop-version-number.patch
quicklists-for-page-table-pages.patch
quicklists-for-page-table-pages-avoid-useless-virt_to_page-conversion.patch
quicklist-support-for-ia64.patch
quicklist-support-for-x86_64.patch
quicklist-support-for-sparc64.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
