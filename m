From: akpm@linux-foundation.org
Subject: - x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management.patch removed from -mm tree
Date: Thu, 29 Mar 2007 16:39:23 -0700
Message-ID: <200703292339.l2TNdNx7015428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43203 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945946AbXC2Xj1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 19:39:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: use lru instead of page->index and page->private for pgd lists management.
has been removed from the -mm tree.  Its filename was
     x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use lru instead of page->index and page->private for pgd lists management.
From: Christoph Lameter <clameter@sgi.com>

x86_64 currently simulates a list using the index and private fields of the
page struct.  Seems that the code was inherited from i386.  But x86_64 does
not use the slab to allocate pgds and pmds etc.  So the lru field is not
used by the slab and therefore available.

This patch uses standard list operations on page->lru to realize pgd
tracking.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/fault.c       |    5 ++---
 include/asm-x86_64/pgalloc.h |   14 +++-----------
 include/asm-x86_64/pgtable.h |    2 +-
 3 files changed, 6 insertions(+), 15 deletions(-)

diff -puN arch/x86_64/mm/fault.c~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management arch/x86_64/mm/fault.c
--- a/arch/x86_64/mm/fault.c~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management
+++ a/arch/x86_64/mm/fault.c
@@ -585,7 +585,7 @@ do_sigbus:
 }
 
 DEFINE_SPINLOCK(pgd_lock);
-struct page *pgd_list;
+LIST_HEAD(pgd_list);
 
 void vmalloc_sync_all(void)
 {
@@ -605,8 +605,7 @@ void vmalloc_sync_all(void)
 			if (pgd_none(*pgd_ref))
 				continue;
 			spin_lock(&pgd_lock);
-			for (page = pgd_list; page;
-			     page = (struct page *)page->index) {
+			list_for_each_entry(page, &pgd_list, lru) {
 				pgd_t *pgd;
 				pgd = (pgd_t *)page_address(page) + pgd_index(address);
 				if (pgd_none(*pgd))
diff -puN include/asm-x86_64/pgalloc.h~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management include/asm-x86_64/pgalloc.h
--- a/include/asm-x86_64/pgalloc.h~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management
+++ a/include/asm-x86_64/pgalloc.h
@@ -44,24 +44,16 @@ static inline void pgd_list_add(pgd_t *p
 	struct page *page = virt_to_page(pgd);
 
 	spin_lock(&pgd_lock);
-	page->index = (pgoff_t)pgd_list;
-	if (pgd_list)
-		pgd_list->private = (unsigned long)&page->index;
-	pgd_list = page;
-	page->private = (unsigned long)&pgd_list;
+	list_add(&page->lru, &pgd_list);
 	spin_unlock(&pgd_lock);
 }
 
 static inline void pgd_list_del(pgd_t *pgd)
 {
-	struct page *next, **pprev, *page = virt_to_page(pgd);
+	struct page *page = virt_to_page(pgd);
 
 	spin_lock(&pgd_lock);
-	next = (struct page *)page->index;
-	pprev = (struct page **)page->private;
-	*pprev = next;
-	if (next)
-		next->private = (unsigned long)pprev;
+	list_del(&page->lru);
 	spin_unlock(&pgd_lock);
 }
 
diff -puN include/asm-x86_64/pgtable.h~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management include/asm-x86_64/pgtable.h
--- a/include/asm-x86_64/pgtable.h~x86_64-use-lru-instead-of-page-index-and-page-private-for-pgd-lists-management
+++ a/include/asm-x86_64/pgtable.h
@@ -402,7 +402,7 @@ static inline pte_t pte_modify(pte_t pte
 #define __swp_entry_to_pte(x)		((pte_t) { (x).val })
 
 extern spinlock_t pgd_lock;
-extern struct page *pgd_list;
+extern struct list_head pgd_list;
 void vmalloc_sync_all(void);
 
 #endif /* !__ASSEMBLY__ */
_

Patches currently in -mm which might be from clameter@sgi.com are

slab-introduce-krealloc.patch
slab-introduce-krealloc-fix.patch
safer-nr_node_ids-and-nr_node_ids-determination-and-initial.patch
use-zvc-counters-to-establish-exact-size-of-dirtyable-pages.patch
slab-ensure-cache_alloc_refill-terminates.patch
smaps-extract-pmd-walker-from-smaps-code.patch
smaps-add-pages-referenced-count-to-smaps.patch
smaps-add-clear_refs-file-to-clear-reference.patch
smaps-add-clear_refs-file-to-clear-reference-fix.patch
smaps-add-clear_refs-file-to-clear-reference-fix-fix.patch
slab-use-num_possible_cpus-in-enable_cpucache.patch
extend-print_symbol-capability-fix.patch
slab-shutdown-cache_reaper-when-cpu-goes-down.patch
mm-implement-swap-prefetching.patch
readahead-state-based-method-aging-accounting.patch
