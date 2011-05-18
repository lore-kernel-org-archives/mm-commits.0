From: akpm@linux-foundation.org
Subject: [to-be-updated] xen-grant-table-use-apply_to_page_range_batch.patch removed from -mm tree
Date: Wed, 18 May 2011 14:37:52 -0700
Message-ID: <201105182137.p4ILbqsU025475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1ERVh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     xen/grant-table: use apply_to_page_range_batch()
has been removed from the -mm tree.  Its filename was
     xen-grant-table-use-apply_to_page_range_batch.patch

This patch was dropped because an updated version will be merged

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

