From: akpm@linux-foundation.org
Subject: + page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch added to -mm tree
Date: Wed, 02 May 2007 15:06:57 -0700
Message-ID: <200705022206.l42M6voW031254@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993187AbXEBWHf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 May 2007 18:07:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, hugh@veritas.com


The patch titled
     page migration: Only migrate pages if allocation in the highest zone is possible
has been added to the -mm tree.  Its filename is
     page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: page migration: Only migrate pages if allocation in the highest zone is possible
From: Christoph Lameter <clameter@sgi.com>

Address spaces contain an allocation flag that specifies restriction on the
zone for pages placed in the mapping.  I.e.  some device may require pages
to be allocated from a DMA zone.  Block devices may not be able to use
pages from HIGHMEM.

Memory policies and the common use of page migration works only on the
highest zone.  If the address space does not allow allocation from the
highest zone then the pages in the address space are not migratable simply
because we can only allocate memory for a specified node if we allow
allocation for the highest zone on each node.

Acked-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/migrate.h |   15 ++++++++++++++-
 1 files changed, 14 insertions(+), 1 deletion(-)

diff -puN include/linux/migrate.h~page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible include/linux/migrate.h
--- a/include/linux/migrate.h~page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible
+++ a/include/linux/migrate.h
@@ -2,18 +2,29 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/mempolicy.h>
+#include <linux/pagemap.h>
 
 typedef struct page *new_page_t(struct page *, unsigned long private, int **);
 
+#ifdef CONFIG_MIGRATION
 /* Check if a vma is migratable */
 static inline int vma_migratable(struct vm_area_struct *vma)
 {
 	if (vma->vm_flags & (VM_IO|VM_HUGETLB|VM_PFNMAP|VM_RESERVED))
 		return 0;
+	/*
+	 * Migration allocates pages in the highest zone. If we cannot
+	 * do so then migration (at least from node to node) is not
+	 * possible.
+	 */
+	if (vma->vm_file &&
+		gfp_zone(mapping_gfp_mask(vma->vm_file->f_mapping))
+								< policy_zone)
+			return 0;
 	return 1;
 }
 
-#ifdef CONFIG_MIGRATION
 extern int isolate_lru_page(struct page *p, struct list_head *pagelist);
 extern int putback_lru_pages(struct list_head *l);
 extern int migrate_page(struct address_space *,
@@ -28,6 +39,8 @@ extern int migrate_vmas(struct mm_struct
 		const nodemask_t *from, const nodemask_t *to,
 		unsigned long flags);
 #else
+static inline int vma_migratable(struct vm_area_struct *vma)
+					{ return 0; }
 
 static inline int isolate_lru_page(struct page *p, struct list_head *list)
 					{ return -ENOSYS; }
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
