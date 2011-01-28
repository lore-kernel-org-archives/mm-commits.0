From: akpm@linux-foundation.org
Subject: + vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:53 -0800
Message-ID: <201101280017.p0S0HrJD008246@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780Ab1A1AVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
has been added to the -mm tree.  Its filename is
     vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -2045,9 +2045,9 @@ void  __attribute__((weak)) vmalloc_sync
 }
 
 
-static int f(pte_t *pte, unsigned long addr, void *data)
+static int f(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
-	/* apply_to_page_range() does all the hard work. */
+	/* apply_to_page_range_batch() does all the hard work. */
 	return 0;
 }
 
@@ -2076,8 +2076,8 @@ struct vm_struct *alloc_vm_area(size_t s
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
mm-remove-unused-token-argument-from-apply_to_page_range-callback.patch
mm-add-apply_to_page_range_batch.patch
ioremap-use-apply_to_page_range_batch-for-ioremap_page_range.patch
vmalloc-use-plain-pte_clear-for-unmaps.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch

