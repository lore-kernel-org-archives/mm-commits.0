From: akpm@linux-foundation.org
Subject: + remove-constructor-from-buffer_head.patch added to -mm tree
Date: Fri, 04 May 2007 12:54:41 -0700
Message-ID: <200705041954.l44Jsfiw012711@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39837 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161558AbXEDTyp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 15:54:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     Remove constructor from buffer_head
has been added to the -mm tree.  Its filename is
     remove-constructor-from-buffer_head.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Remove constructor from buffer_head
From: Christoph Lameter <clameter@sgi.com>

needs changelog

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff -puN fs/buffer.c~remove-constructor-from-buffer_head fs/buffer.c
--- a/fs/buffer.c~remove-constructor-from-buffer_head
+++ a/fs/buffer.c
@@ -2931,9 +2931,10 @@ static void recalc_bh_state(void)
 	
 struct buffer_head *alloc_buffer_head(gfp_t gfp_flags)
 {
-	struct buffer_head *ret = kmem_cache_alloc(bh_cachep,
+	struct buffer_head *ret = kmem_cache_zalloc(bh_cachep,
 				set_migrateflags(gfp_flags, __GFP_RECLAIMABLE));
 	if (ret) {
+		INIT_LIST_HEAD(&ret->b_assoc_buffers);
 		get_cpu_var(bh_accounting).nr++;
 		recalc_bh_state();
 		put_cpu_var(bh_accounting);
@@ -2952,17 +2953,6 @@ void free_buffer_head(struct buffer_head
 }
 EXPORT_SYMBOL(free_buffer_head);
 
-static void
-init_buffer_head(void *data, struct kmem_cache *cachep, unsigned long flags)
-{
-	if (flags & SLAB_CTOR_CONSTRUCTOR) {
-		struct buffer_head * bh = (struct buffer_head *)data;
-
-		memset(bh, 0, sizeof(*bh));
-		INIT_LIST_HEAD(&bh->b_assoc_buffers);
-	}
-}
-
 static void buffer_exit_cpu(int cpu)
 {
 	int i;
@@ -2989,12 +2979,8 @@ void __init buffer_init(void)
 {
 	int nrpages;
 
-	bh_cachep = kmem_cache_create("buffer_head",
-					sizeof(struct buffer_head), 0,
-					(SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
-					SLAB_MEM_SPREAD),
-					init_buffer_head,
-					NULL);
+	bh_cachep = KMEM_CACHE(buffer_head,
+			SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MEM_SPREAD);
 
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
slab-introduce-krealloc.patch
add-apply_to_page_range-which-applies-a-function-to-a-pte-range.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
i386-use-page-allocator-to-allocate-thread_info-structure.patch
slub-core.patch
slub-change-default-alignments.patch
powerpc-disable-slub-for-configurations-in-which-slab-page-structs-are-modified.patch
make-page-private-usable-in-compound-pages-v1.patch
optimize-compound_head-by-avoiding-a-shared-page.patch
add-virt_to_head_page-and-consolidate-code-in-slab-and-slub.patch
slub-fix-object-tracking.patch
slub-enable-tracking-of-full-slabs.patch
slub-validation-of-slabs-metadata-and-guard-zones.patch
slub-add-min_partial.patch
slub-add-ability-to-list-alloc--free-callers-per-slab.patch
slub-free-slabs-and-sort-partial-slab-lists-in-kmem_cache_shrink.patch
slub-remove-object-activities-out-of-checking-functions.patch
slub-user-documentation.patch
slub-add-slabinfo-tool.patch
quicklists-for-page-table-pages.patch
quicklist-support-for-sparc64.patch
slab-allocators-remove-obsolete-slab_must_hwcache_align.patch
kmem_cache-simplify-slab-cache-creation.patch
slab-allocators-remove-multiple-alignment-specifications.patch
fault-injection-fix-failslab-with-config_numa.patch
mm-fix-handling-of-panic_on_oom-when-cpusets-are-in-use.patch
slab-allocators-remove-slab_debug_initial-flag.patch
slab-allocators-remove-slab_ctor_atomic.patch
slab-allocators-remove-useless-__gfp_no_grow-flag.patch
page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch
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
