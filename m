From: akpm@linux-foundation.org
Subject: [to-be-updated] vmalloc-use-plain-pte_clear-for-unmaps.patch removed from -mm tree
Date: Wed, 18 May 2011 14:37:42 -0700
Message-ID: <201105182137.p4ILbg44025456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755307Ab1ERVhs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 May 2011 17:37:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeremy.fitzhardinge@citrix.com, hugh.dickins@tiscali.co.uk, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     vmalloc: use plain pte_clear() for unmaps
has been removed from the -mm tree.  Its filename was
     vmalloc-use-plain-pte_clear-for-unmaps.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vmalloc: use plain pte_clear() for unmaps
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

ptep_get_and_clear() is potentially moderately expensive (at least an
atomic operation, or potentially a trap-and-fault when virtualized) so use
a plain pte_clear().

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/vmalloc.c~vmalloc-use-plain-pte_clear-for-unmaps mm/vmalloc.c
--- a/mm/vmalloc.c~vmalloc-use-plain-pte_clear-for-unmaps
+++ a/mm/vmalloc.c
@@ -39,8 +39,9 @@ static void vunmap_pte_range(pmd_t *pmd,
 
 	pte = pte_offset_kernel(pmd, addr);
 	do {
-		pte_t ptent = ptep_get_and_clear(&init_mm, addr, pte);
+		pte_t ptent = *pte;
 		WARN_ON(!pte_none(ptent) && !pte_present(ptent));
+		pte_clear(&init_mm, addr, pte);
 	} while (pte++, addr += PAGE_SIZE, addr != end);
 }
 
_

Patches currently in -mm which might be from jeremy.fitzhardinge@citrix.com are

linux-next.patch
vmalloc-use-apply_to_page_range_batch-for-vunmap_page_range.patch
vmalloc-use-apply_to_page_range_batch-for-vmap_page_range_noflush.patch
vmalloc-use-apply_to_page_range_batch-in-alloc_vm_area.patch
xen-mmu-use-apply_to_page_range_batch-in-xen_remap_domain_mfn_range.patch
xen-grant-table-use-apply_to_page_range_batch.patch

