From: akpm@linux-foundation.org
Subject: [merged] hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:36:47 -0700
Message-ID: <200909222036.n8MKalAh030562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41925 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752461AbZIVUiv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:38:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, agl@us.ibm.com, ak@linux.intel.com, apw@canonical.com, eric.whitney@hp.com, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stable@kernel.org, mm


The patch titled
     hugetlb: restore interleaving of bootmem huge pages (2.6.31)
has been removed from the -mm tree.  Its filename was
     hugetlb-restore-interleaving-of-bootmem-huge-pages-2631.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb: restore interleaving of bootmem huge pages (2.6.31)
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

I noticed that alloc_bootmem_huge_page() will only advance to the next
node on failure to allocate a huge page.  I asked about this on linux-mm
and linux-numa, cc'ing the usual huge page suspects.  Mel Gorman
responded:

	I strongly suspect that the same node being used until allocation
	failure instead of round-robin is an oversight and not deliberate
	at all. It appears to be a side-effect of a fix made way back in
	commit 63b4613c3f0d4b724ba259dc6c201bb68b884e1a ["hugetlb: fix
	hugepage allocation with memoryless nodes"]. Prior to that patch
	it looked like allocations would always round-robin even when
	allocation was successful.

Andy Whitcroft countered that the existing behavior looked like Andi
Kleen's original implementation and suggested that we ask him.  We did and
Andy replied that his intention was to interleave the allocations.  So,
...

This patch moves the advance of the hstate next node from which to
allocate up before the test for success of the attempted allocation.  This
will unconditionally advance the next node from which to alloc,
interleaving successful allocations over the nodes with sufficient
contiguous memory, and skipping over nodes that fail the huge page
allocation attempt.

Note that alloc_bootmem_huge_page() will only be called for huge pages of
order > MAX_ORDER.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: <stable@kernel.org>		[2.6.27.x, 2.6.28.x, 2.6.29.x, 2.6.30.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~hugetlb-restore-interleaving-of-bootmem-huge-pages-2631 mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-restore-interleaving-of-bootmem-huge-pages-2631
+++ a/mm/hugetlb.c
@@ -1011,6 +1011,7 @@ int __weak alloc_bootmem_huge_page(struc
 				NODE_DATA(h->hugetlb_next_nid),
 				huge_page_size(h), huge_page_size(h), 0);
 
+		hstate_next_node(h);
 		if (addr) {
 			/*
 			 * Use the beginning of the huge page to store the
@@ -1020,7 +1021,6 @@ int __weak alloc_bootmem_huge_page(struc
 			m = addr;
 			goto found;
 		}
-		hstate_next_node(h);
 		nr_nodes--;
 	}
 	return 0;
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
linux-next.patch

