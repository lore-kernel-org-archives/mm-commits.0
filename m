From: akpm@linux-foundation.org
Subject: + mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:39:04 -0700
Message-ID: <20121030213905.887AE5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:60011 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3VjI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:39:08 -0400
Received: by mail-wi0-f202.google.com with SMTP id hr7so50019wib.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:39:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm, highmem: use PKMAP_NR() to calculate an index of pkmap
has been added to the -mm tree.  Its filename is
     mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm, highmem: use PKMAP_NR() to calculate an index of pkmap

To calculate an index of pkmap, using PKMAP_NR() is more understandable
and maintainable, so change it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap mm/highmem.c
--- a/mm/highmem.c~mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap
+++ a/mm/highmem.c
@@ -99,7 +99,7 @@ struct page *kmap_to_page(void *vaddr)
 	unsigned long addr = (unsigned long)vaddr;
 
 	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
-		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
+		int i = PKMAP_NR(addr);
 		return pte_page(pkmap_page_table[i]);
 	}
 
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

