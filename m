From: akpm@linux-foundation.org
Subject: + slub-add-ability-to-list-alloc--free-callers-per-slab.patch added to -mm tree
Date: Tue, 10 Apr 2007 12:36:44 -0700
Message-ID: <200704101936.l3AJaiGs015679@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42709 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797AbXDJTgr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Apr 2007 15:36:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     slub: add ability to list alloc / free callers per slab
has been added to the -mm tree.  Its filename is
     slub-add-ability-to-list-alloc--free-callers-per-slab.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: slub: add ability to list alloc / free callers per slab
From: Christoph Lameter <clameter@sgi.com>

This patch enables listing the callers who allocated or freed objects in a
cache.

For example to list the allocators for kmalloc-128 do

cat /sys/slab/kmalloc-128/alloc_calls
      7 sn_io_slot_fixup+0x40/0x700
      7 sn_io_slot_fixup+0x80/0x700
      9 sn_bus_fixup+0xe0/0x380
      6 param_sysfs_setup+0xf0/0x280
    276 percpu_populate+0xf0/0x1a0
     19 __register_chrdev_region+0x30/0x360
      8 expand_files+0x2e0/0x6e0
      1 sys_epoll_create+0x60/0x200
      1 __mounts_open+0x140/0x2c0
     65 kmem_alloc+0x110/0x280
      3 alloc_disk_node+0xe0/0x200
     33 as_get_io_context+0x90/0x280
     74 kobject_kset_add_dir+0x40/0x140
     12 pci_create_bus+0x2a0/0x5c0
      1 acpi_ev_create_gpe_block+0x120/0x9e0
     41 con_insert_unipair+0x100/0x1c0
      1 uart_open+0x1c0/0xba0
      1 dma_pool_create+0xe0/0x340
      2 neigh_table_init_no_netlink+0x260/0x4c0
      6 neigh_parms_alloc+0x30/0x200
      1 netlink_kernel_create+0x130/0x320
      5 fz_hash_alloc+0x50/0xe0
      2 sn_common_hubdev_init+0xd0/0x6e0
     28 kernel_param_sysfs_setup+0x30/0x180
     72 process_zones+0x70/0x2e0

cat /sys/slab/kmalloc-128/free_calls
    558 <not-available>
      3 sn_io_slot_fixup+0x600/0x700
     84 free_fdtable_rcu+0x120/0x260
      2 seq_release+0x40/0x60
      6 kmem_free+0x70/0xc0
     24 free_as_io_context+0x20/0x200
      1 acpi_get_object_info+0x3a0/0x3e0
      1 acpi_add_single_object+0xcf0/0x1e40
      2 con_release_unimap+0x80/0x140
      1 free+0x20/0x40

SLAB_STORE_USER must be enabled for a slab cache by either booting with
"slab_debug" or enabling user tracking specifically for the slab of interest.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  184 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 181 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-add-ability-to-list-alloc--free-callers-per-slab mm/slub.c
--- a/mm/slub.c~slub-add-ability-to-list-alloc--free-callers-per-slab
+++ a/mm/slub.c
@@ -67,9 +67,6 @@
  *
  * - Support PAGE_ALLOC_DEBUG. Should be easy to do.
  *
- * - Support DEBUG_SLAB_LEAK. Trouble is we do not know where the full
- *   slabs are in SLUB.
- *
  * - SLAB_DEBUG_INITIAL is not supported but I have never seen a use of
  *   it.
  *
@@ -2407,6 +2404,169 @@ static unsigned long validate_slab_cache
 	return count;
 }
 
+/*
+ * Generate lists of locations where slabcache objects are allocated
+ * and freed.
+ */
+
+struct location {
+	unsigned long count;
+	void *addr;
+};
+
+struct loc_track {
+	unsigned long max;
+	unsigned long count;
+	struct location *loc;
+};
+
+static void free_loc_track(struct loc_track *t)
+{
+	if (t->max)
+		free_pages((unsigned long)t->loc,
+			get_order(sizeof(struct location) * t->max));
+}
+
+static int alloc_loc_track(struct loc_track *t, unsigned long max)
+{
+	struct location *l;
+	int order;
+
+	if (!max)
+		max = PAGE_SIZE / sizeof(struct location);
+
+	order = get_order(sizeof(struct location) * max);
+
+	l = (void *)__get_free_pages(GFP_KERNEL, order);
+
+	if (!l)
+		return 0;
+
+	if (t->count) {
+		memcpy(l, t->loc, sizeof(struct location) * t->count);
+		free_loc_track(t);
+	}
+	t->max = max;
+	t->loc = l;
+	return 1;
+}
+
+static int add_location(struct loc_track *t, struct kmem_cache *s,
+						void *addr)
+{
+	long start, end, pos;
+	struct location *l;
+	void *caddr;
+
+	start = -1;
+	end = t->count;
+
+	for(;;) {
+		pos = start + (end - start + 1) / 2;
+
+		/*
+		 * There is nothing at "end". If we end up there
+		 * we need to add something to before end.
+		 */
+		if (pos == end)
+			break;
+
+		caddr = t->loc[pos].addr;
+		if (addr == caddr) {
+			t->loc[pos].count++;
+			return 1;
+		}
+
+		if (addr < caddr)
+			end = pos;
+		else
+			start = pos;
+	}
+
+	/*
+	 * Not found. Insert new tracking element
+	 */
+	if (t->count >= t->max && !alloc_loc_track(t, 2 * t->max))
+		return 0;
+
+	l = t->loc + pos;
+	if (pos < t->count)
+		memmove(l + 1, l,
+			(t->count - pos) * sizeof(struct location));
+	t->count++;
+	l->count = 1;
+	l->addr = addr;
+	return 1;
+}
+
+static void process_slab(struct loc_track *t, struct kmem_cache *s,
+		struct page *page, enum track_item alloc)
+{
+	void *addr = page_address(page);
+	unsigned long map[BITS_TO_LONGS(s->objects)];
+	void *p;
+
+	bitmap_zero(map, s->objects);
+	for(p = page->freelist; p; p = get_freepointer(s, p))
+		set_bit((p - addr) / s->size, map);
+
+	for(p = addr; p < addr + s->objects * s->size; p += s->size)
+		if (!test_bit((p - addr) / s->size, map)) {
+			void *addr = get_track(s, p, alloc)->addr;
+
+			add_location(t, s, addr);
+		}
+}
+
+static int list_locations(struct kmem_cache *s, char *buf,
+					enum track_item alloc)
+{
+	int n = 0;
+	unsigned long i;
+	struct loc_track t;
+	int node;
+
+	t.count = 0;
+	t.max = 0;
+
+	/* Push back cpu slabs */
+	flush_all(s);
+
+	for_each_online_node(node) {
+		struct kmem_cache_node *n = get_node(s, node);
+		unsigned long flags;
+		struct page *page;
+
+		if (!atomic_read(&n->nr_slabs))
+			continue;
+
+		spin_lock_irqsave(&n->list_lock, flags);
+		list_for_each_entry(page, &n->partial, lru)
+			process_slab(&t, s, page, alloc);
+		list_for_each_entry(page, &n->full, lru)
+			process_slab(&t, s, page, alloc);
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	for (i = 0; i < t.count; i++) {
+		void *addr = t.loc[i].addr;
+
+		if (n > PAGE_SIZE - 100)
+			break;
+		n += sprintf(buf + n, "%7ld ", t.loc[i].count);
+		if (addr)
+			n += sprint_symbol(buf + n, (unsigned long)t.loc[i].addr);
+		else
+			n += sprintf(buf + n, "<not-available>");
+		n += sprintf(buf + n, "\n");
+	}
+
+	free_loc_track(&t);
+	if (!t.count)
+		n += sprintf(buf, "No data\n");
+	return n;
+}
+
 static unsigned long count_partial(struct kmem_cache_node *n)
 {
 	unsigned long flags;
@@ -2757,6 +2917,22 @@ static ssize_t validate_store(struct kme
 }
 SLAB_ATTR(validate);
 
+static ssize_t alloc_calls_show(struct kmem_cache *s, char *buf)
+{
+	if (!(s->flags & SLAB_STORE_USER))
+		return -ENOSYS;
+	return list_locations(s, buf, TRACK_ALLOC);
+}
+SLAB_ATTR_RO(alloc_calls);
+
+static ssize_t free_calls_show(struct kmem_cache *s, char *buf)
+{
+	if (!(s->flags & SLAB_STORE_USER))
+		return -ENOSYS;
+	return list_locations(s, buf, TRACK_FREE);
+}
+SLAB_ATTR_RO(free_calls);
+
 #ifdef CONFIG_NUMA
 static ssize_t defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
@@ -2797,6 +2973,8 @@ static struct attribute * slab_attrs[] =
 	&poison_attr.attr,
 	&store_user_attr.attr,
 	&validate_attr.attr,
+	&alloc_calls_attr.attr,
+	&free_calls_attr.attr,
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
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
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
