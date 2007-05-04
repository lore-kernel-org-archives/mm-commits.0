From: akpm@linux-foundation.org
Subject: + slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch added to -mm tree
Date: Fri, 04 May 2007 14:37:08 -0700
Message-ID: <200705042137.l44Lb88N014593@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031708AbXEDVhM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 May 2007 17:37:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com


The patch titled
     SLUB: allocate smallest object size if the user asks for 0 bytes
has been added to the -mm tree.  Its filename is
     slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: SLUB: allocate smallest object size if the user asks for 0 bytes
From: Christoph Lameter <clameter@sgi.com>

Makes SLUB behave like SLAB in this area to avoid issues....

Throw a stack dump to alert people.

At some point the behavior should be switched back.  NULL is no memory as
far as I can tell and if the use asked for 0 bytes then he need to get no
memory.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slub_def.h |    8 ++++++--
 mm/slub.c                |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff -puN include/linux/slub_def.h~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes include/linux/slub_def.h
--- a/include/linux/slub_def.h~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes
+++ a/include/linux/slub_def.h
@@ -80,8 +80,12 @@ extern struct kmem_cache kmalloc_caches[
  */
 static inline int kmalloc_index(int size)
 {
-	if (size == 0)
-		return 0;
+	/*
+	 * We should return 0 if size == 0 but we use the smallest object
+	 * here for SLAB legacy reasons.
+	 */
+	WARN_ON(size == 0);
+
 	if (size > 64 && size <= 96)
 		return 1;
 	if (size > 128 && size <= 192)
diff -puN mm/slub.c~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes mm/slub.c
--- a/mm/slub.c~slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes
+++ a/mm/slub.c
@@ -1979,7 +1979,7 @@ static struct kmem_cache *get_slab(size_
 {
 	int index = kmalloc_index(size);
 
-	if (!size)
+	if (!index)
 		return NULL;
 
 	/* Allocation too large? */
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
slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes.patch
slub-allocate-smallest-object-size-if-the-user-asks-for-0-bytes-fix.patch
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
