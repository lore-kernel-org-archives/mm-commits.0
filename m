From: akpm@linux-foundation.org
Subject: + mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch added to -mm tree
Date: Tue, 30 Oct 2012 14:39:19 -0700
Message-ID: <20121030213919.DB04620004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:33673 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232Ab2J3VjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Oct 2012 17:39:23 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so49766lah.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Oct 2012 14:39:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: js1304@gmail.com, a.p.zijlstra@chello.nl, mel@csn.ul.ie, minchan@kernel.org


The patch titled
     Subject: mm, highmem: get virtual address of the page using PKMAP_ADDR()
has been added to the -mm tree.  Its filename is
     mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

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
@@ -138,8 +138,7 @@ static int flush_all_zero_pkmaps(void)
 		 * So no dangers, even with speculative execution.
 		 */
 		page = pte_page(pkmap_page_table[i]);
-		pte_clear(&init_mm, (unsigned long)page_address(page),
-			  &pkmap_page_table[i]);
+		pte_clear(&init_mm, PKMAP_ADDR(i), &pkmap_page_table[i]);
 
 		set_page_address(page, NULL);
 		index = i;
_

Patches currently in -mm which might be from js1304@gmail.com are

linux-next.patch
mm-highmem-use-pkmap_nr-to-calculate-an-index-of-pkmap.patch
mm-highmem-remove-useless-pool_lock.patch
mm-highmem-remove-page_address_pool-list.patch
mm-highmem-makes-flush_all_zero_pkmaps-return-index-of-last-flushed-entry.patch
mm-highmem-get-virtual-address-of-the-page-using-pkmap_addr.patch

