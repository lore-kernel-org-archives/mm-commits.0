From: akpm@linux-foundation.org
Subject: - page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch removed from -mm tree
Date: Mon, 07 May 2007 17:04:32 -0700
Message-ID: <200705080004.l4804Wo5009021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S967360AbXEHAFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2007 20:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, hugh@veritas.com, mm-commits@vger.kernel.org


The patch titled
     page migration: Only migrate pages if allocation in the highest zone is possible
has been removed from the -mm tree.  Its filename was
     page-migration-only-migrate-pages-if-allocation-in-the-highest-zone-is-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 14 insertions(+), 1 deletion(-)

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
