From: akpm@linux-foundation.org
Subject: + hugetlb-restore-interleaving-of-bootmem-huge-pages.patch added to -mm tree
Date: Thu, 16 Jul 2009 15:32:09 -0700
Message-ID: <200907162232.n6GMWAe9012084@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51933 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052AbZGPWct (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Jul 2009 18:32:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, andi@firstfloor.org, apw@canonical.com, lee.schermerhorn@hp.com, mel@csn.ul.ie


The patch titled
     hugetlb: restore interleaving of bootmem huge pages
has been added to the -mm tree.  Its filename is
     hugetlb-restore-interleaving-of-bootmem-huge-pages.patch

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
Subject: hugetlb: restore interleaving of bootmem huge pages
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

I noticed that alloc_bootmem_huge_page() will only advance to the next
node on failure to allocate a huge page, potentially filling nodes with
huge-pages.  I asked about this on linux-mm and linux-numa, cc'ing the
usual huge page suspects.

Mel Gorman responded:

	I strongly suspect that the same node being used until allocation
	failure instead of round-robin is an oversight and not deliberate
	at all. It appears to be a side-effect of a fix made way back in
	commit 63b4613c3f0d4b724ba259dc6c201bb68b884e1a ["hugetlb: fix
	hugepage allocation with memoryless nodes"]. Prior to that patch
	it looked like allocations would always round-robin even when
	allocation was successful.

This patch--factored out of my "hugetlb mempolicy" series--moves the
advance of the hstate next node from which to allocate up before the test
for success of the attempted allocation.

Note that alloc_bootmem_huge_page() is only used for order > MAX_ORDER
huge pages.

I'll post a separate patch for mainline/stable, as the above mentioned
"balance freeing" series renamed the next node to alloc function.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Mel Gorman <mel@csn.ul.ie>
Reviewed-by: Andy Whitcroft <apw@canonical.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-restore-interleaving-of-bootmem-huge-pages mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-restore-interleaving-of-bootmem-huge-pages
+++ a/mm/hugetlb.c
@@ -1031,6 +1031,7 @@ int __weak alloc_bootmem_huge_page(struc
 				NODE_DATA(h->next_nid_to_alloc),
 				huge_page_size(h), huge_page_size(h), 0);
 
+		hstate_next_node_to_alloc(h);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1040,7 +1041,6 @@ int __weak alloc_bootmem_huge_page(struc
 			m = addr;
 			goto found;
 		}
-		hstate_next_node_to_alloc(h);
 		nr_nodes--;
 	}
 	return 0;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

hugetlb-use-free_pool_huge_page-to-return-unused-surplus-pages-fix.patch
hugetlb-restore-interleaving-of-bootmem-huge-pages.patch

