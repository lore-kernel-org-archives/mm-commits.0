From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address.patch removed from -mm tree
Date: Mon, 19 Nov 2012 12:21:56 -0800
Message-ID: <20121119202156.B6B7B100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:39266 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754186Ab2KSUV5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 15:21:57 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so594422qcq.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 12:21:57 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: will.deacon@arm.com, mgorman@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
has been removed from the -mm tree.  Its filename was
     mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address

kmap_to_page returns the corresponding struct page for a virtual address
of an arbitrary mapping.  This works by checking whether the address falls
in the pkmap region and using the pkmap page tables instead of the linear
mapping if appropriate.

Unfortunately, the bounds checking means that PKMAP_ADDR(LAST_PKMAP) is
incorrectly treated as a highmem address and we can end up walking off the
end of pkmap_page_table and subsequently passing junk to pte_page.

This patch fixes the bound check to stay within the pkmap tables.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address mm/highmem.c
--- a/mm/highmem.c~mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address
+++ a/mm/highmem.c
@@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
 {
 	unsigned long addr = (unsigned long)vaddr;
 
-	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
 		return pte_page(pkmap_page_table[i]);
 	}
_

Patches currently in -mm which might be from will.deacon@arm.com are

linux-next.patch
mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

