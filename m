From: akpm@linux-foundation.org
Subject: + xen-grant-table-use-apply_to_page_range_batch.patch added to -mm tree
Date: Thu, 27 Jan 2011 16:17:57 -0800
Message-ID: <201101280017.p0S0HvcO008252@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38434 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674Ab1A1AVn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Jan 2011 19:21:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk


The patch titled
     xen/grant-table: use apply_to_page_range_batch()
has been added to the -mm tree.  Its filename is
     xen-grant-table-use-apply_to_page_range_batch.patch

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
Subject: xen/grant-table: use apply_to_page_range_batch()
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

No need to call the callback per-pte.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/xen/grant-table.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN arch/x86/xen/grant-table.c~xen-grant-table-use-apply_to_page_range_batch arch/x86/xen/grant-table.c
--- a/arch/x86/xen/grant-table.c~xen-grant-table-use-apply_to_page_range_batch
+++ a/arch/x86/xen/grant-table.c
@@ -44,19 +44,27 @@
 
 #include <asm/pgtable.h>
 
-static int map_pte_fn(pte_t *pte, unsigned long addr, void *data)
+static int map_pte_fn(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
 	unsigned long **frames = (unsigned long **)data;
 
-	set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
-	(*frames)++;
+	while (count--) {
+		set_pte_at(&init_mm, addr, pte, mfn_pte((*frames)[0], PAGE_KERNEL));
+		(*frames)++;
+		pte++;
+		addr += PAGE_SIZE;
+	}
 	return 0;
 }
 
-static int unmap_pte_fn(pte_t *pte, unsigned long addr, void *data)
+static int unmap_pte_fn(pte_t *pte, unsigned count, unsigned long addr, void *data)
 {
+	while (count--) {
+		pte_clear(&init_mm, addr, pte);
+		addr += PAGE_SIZE;
+		pte++;
+	}
 
-	set_pte_at(&init_mm, addr, pte, __pte(0));
 	return 0;
 }
 
@@ -75,15 +83,15 @@ int arch_gnttab_map_shared(unsigned long
 		*__shared = shared;
 	}
 
-	rc = apply_to_page_range(&init_mm, (unsigned long)shared,
-				 PAGE_SIZE * nr_gframes,
-				 map_pte_fn, &frames);
+	rc = apply_to_page_range_batch(&init_mm, (unsigned long)shared,
+				       PAGE_SIZE * nr_gframes,
+				       map_pte_fn, &frames);
 	return rc;
 }
 
 void arch_gnttab_unmap_shared(struct grant_entry *shared,
 			      unsigned long nr_gframes)
 {
-	apply_to_page_range(&init_mm, (unsigned long)shared,
-			    PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
+	apply_to_page_range_batch(&init_mm, (unsigned long)shared,
+				  PAGE_SIZE * nr_gframes, unmap_pte_fn, NULL);
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

