From: akpm@linux-foundation.org
Subject: [to-be-updated] vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch removed from -mm tree
Date: Wed, 18 May 2011 14:37:48 -0700
Message-ID: <201105182137.p4ILbm5Y025467@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35150 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755914Ab1ERVhx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
has been removed from the -mm tree.  Its filename was
     vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area
+++ a/mm/vmalloc.c
@@ -2048,9 +2048,9 @@ void  __attribute__((weak)) vmalloc_sync
 }
 
 
-static int f(pte_t *pte, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
-	/* apply_to_page_range() does all the hard work. */
+	/* apply_to_page_range_batch() does all the hard work. */
 	return 0;
 }
 
@@ -2079,8 +2079,8 @@ struct vm_struct *alloc_vm_area(size_t s
 	 * This ensures that page tables are constructed for this region
 	 * of kernel virtual address space and mapped into init_mm.
 	 */
-	if (apply_to_page_range(&init_mm, (unsigned long)area->addr,
-				area->size, f, NULL)) {
+	if (apply_to_page_range_batch(&init_mm, (unsigned long)area->addr,
+				      area->size, f, NULL)) {
 		free_vm_area(area);
 		return NULL;
 	}
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

linux-next.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch

