From: akpm@linux-foundation.org
Subject: [merged] mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch removed from -mm tree
Date: Wed, 12 Dec 2012 11:58:35 -0800
Message-ID: <20121212195835.C1E0582004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:35261 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLT6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Dec 2012 14:58:37 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so117278vcd.5
        for <mm-commits@vger.kernel.org>; Wed, 12 Dec 2012 11:58:36 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, highmem: get virtual address of the page using PKMAP_ADDR()
has been removed from the -mm tree.  Its filename was
     mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, highmem: get virtual address of the page using PKMAP_ADDR()

In flush_all_zero_pkmaps(), we have an index of the pkmap associated with
the page.  Using this index, we can simply get virtual address of the
page.  So change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/highmem.c~mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr mm/highmem.c
--- a/mm/highmem.c~mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr
+++ a/mm/highmem.c
@@ -137,8 +137,7 @@ static void flush_all_zero_pkmaps(void)
 		 * So no dangers, even with speculative execution.
 		 */
 		page = pte_page(pkmap_page_table[i]);
-		pte_clear(&init_mm, (unsigned long)page_address(page),
-			  &pkmap_page_table[i]);
+		pte_clear(&init_mm, PKMAP_ADDR(i), &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
 		need_flush = 1;
_

Patches currently in -mm which might be from js1304@gmail.com are

origin.patch
bootmem-remove-not-implemented-function-call-bootmem_arch_preferred_node.patch
bootmem-remove-alloc_arch_preferred_bootmem.patch
mm-warn_on_once-if-f_op-mmap-change-vmas-start-address.patch
linux-next.patch

