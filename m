From: akpm@linux-foundation.org
Subject: - slub-core-sysfs-support-fix-unique-id-generation.patch removed from -mm tree
Date: Mon, 30 Apr 2007 11:52:58 -0700
Message-ID: <200704301852.l3UIqwkZ011960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48917 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423628AbXD3SxC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Apr 2007 14:53:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     SLUB sysfs support: fix unique id generation
has been removed from the -mm tree.  Its filename was
     slub-core-sysfs-support-fix-unique-id-generation.patch

This patch was dropped because it was folded into slub-core.patch

------------------------------------------------------
Subject: SLUB sysfs support: fix unique id generation
From: Christoph Lameter <clameter@sgi.com>

Generate a unique id for mergeable slabs through combining the slab size with
the flags that distinguish slabs of the same size.  That yields a unique id
that is fairly short and descriptive.  It no longer includes the kmem_cache
address.

Extract slab_unmergable() from find_mergeable and use that in sysfs_add_slab
to make handling more consistent.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   48 +++++++++++++++++++++++++++++-------------------
 1 files changed, 29 insertions(+), 19 deletions(-)

diff -puN mm/slub.c~slub-core-sysfs-support-fix-unique-id-generation mm/slub.c
--- a/mm/slub.c~slub-core-sysfs-support-fix-unique-id-generation
+++ a/mm/slub.c
@@ -2268,6 +2268,17 @@ void __init kmem_cache_init(void)
 /*
  * Find a mergeable slab cache
  */
+static int slab_unmergeable(struct kmem_cache *s)
+{
+	if (slub_nomerge || (s->flags & SLUB_NEVER_MERGE))
+		return 1;
+
+	if (s->ctor || s->dtor)
+		return 1;
+
+	return 0;
+}
+
 static struct kmem_cache *find_mergeable(size_t size,
 		size_t align, unsigned long flags,
 		void (*ctor)(void *, struct kmem_cache *, unsigned long),
@@ -2289,13 +2300,10 @@ static struct kmem_cache *find_mergeable
 		struct kmem_cache *s =
 			container_of(h, struct kmem_cache, list);
 
-		if (size > s->size)
-			continue;
-
-		if (s->flags & SLUB_NEVER_MERGE)
+		if (slab_unmergeable(s))
 			continue;
 
-		if (s->dtor || s->ctor)
+		if (size > s->size)
 			continue;
 
 		if (((flags | slub_debug) & SLUB_MERGE_SAME) !=
@@ -3066,23 +3074,21 @@ static char *create_unique_id(struct kme
 
 	*p++ = ':';
 	/*
-	 * First flags affecting slabcache operations */
+	 * First flags affecting slabcache operations. We will only
+	 * get here for aliasable slabs so we do not need to support
+	 * too many flags. The flags here must cover all flags that
+	 * are matched during merging to guarantee that the id is
+	 * unique.
+	 */
 	if (s->flags & SLAB_CACHE_DMA)
 		*p++ = 'd';
 	if (s->flags & SLAB_RECLAIM_ACCOUNT)
 		*p++ = 'a';
-	if (s->flags & SLAB_DESTROY_BY_RCU)
-		*p++ = 'r';\
-	/* Debug flags */
-	if (s->flags & SLAB_RED_ZONE)
-		*p++ = 'Z';
-	if (s->flags & SLAB_POISON)
-		*p++ = 'P';
-	if (s->flags & SLAB_STORE_USER)
-		*p++ = 'U';
+	if (s->flags & SLAB_DEBUG_FREE)
+		*p++ = 'F';
 	if (p != name + 1)
 		*p++ = '-';
-	p += sprintf(p,"%07d:0x%p" ,s->size, s);
+	p += sprintf(p, "%07d", s->size);
 	BUG_ON(p > name + ID_STR_LENGTH - 1);
 	return name;
 }
@@ -3091,12 +3097,14 @@ static int sysfs_slab_add(struct kmem_ca
 {
 	int err;
 	const char *name;
+	int unmergeable;
 
 	if (slab_state < SYSFS)
 		/* Defer until later */
 		return 0;
 
-	if (s->flags & SLUB_NEVER_MERGE) {
+	unmergeable = slab_unmergeable(s);
+	if (unmergeable) {
 		/*
 		 * Slabcache can never be merged so we can use the name proper.
 		 * This is typically the case for debug situations. In that
@@ -3104,12 +3112,13 @@ static int sysfs_slab_add(struct kmem_ca
 		 */
 		sysfs_remove_link(&slab_subsys.kset.kobj, s->name);
 		name = s->name;
-	} else
+	} else {
 		/*
 		 * Create a unique name for the slab as a target
 		 * for the symlinks.
 		 */
 		name = create_unique_id(s);
+	}
 
 	kobj_set_kset_s(s, slab_subsys);
 	kobject_set_name(&s->kobj, name);
@@ -3122,7 +3131,8 @@ static int sysfs_slab_add(struct kmem_ca
 	if (err)
 		return err;
 	kobject_uevent(&s->kobj, KOBJ_ADD);
-	if (!(s->flags & SLUB_NEVER_MERGE)) {
+	if (!unmergeable) {
+		/* Setup first alias */
 		sysfs_slab_alias(s, s->name);
 		kfree(name);
 	}
_

Patches currently in -mm which might be from clameter@sgi.com are

extend-print_symbol-capability.patch
slab-introduce-krealloc.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix.patch
ia64-sn-xpc-convert-to-use-kthread-api-fix-2.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-core-sysfs-support-fix-unique-id-generation.patch
slub-core-printk-cleanup-object_err.patch
slub-core-printk-cleanup-add-slab_err.patch
slub-core-printk-cleanup-fix-up-printks-in-the-resiliency-check.patch
slub-core-fix-slab-validation-error-in-bootstrap-cache.patch
slub-core-remove-per-cpu-flusher.patch
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
slub-validation-of-slabs-metadata-and-guard-zones-printk-cleanup-slab-validation-printks.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-add-ability-to-list-alloc--free-callers-per-slab-tidy.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink-fixes-to-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-remove-object-activities-out-of-checking-functions-printk-cleanup-diagnostic-functions.patch
slub-user-documentation.patch
slub-user-documentation-fix.patch
slub-add-slabinfo-tool.patch
slub-add-slabinfo-tool-update-slabinfoc.patch
slub-major-slabinfo-update.patch
slub-slabinfo-remove-hackname.patch
slub-slabinfo-more-statistic-fixes-and-handling-fixes.patch
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
vmstat-use-our-own-timer-events.patch
readahead-state-based-method-aging-accounting.patch
