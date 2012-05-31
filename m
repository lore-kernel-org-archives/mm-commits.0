From: akpm@linux-foundation.org
Subject: [merged] mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch removed from -mm tree
Date: Thu, 31 May 2012 12:15:00 -0700
Message-ID: <20120531191500.7A144A0203@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35330 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932837Ab2EaTPC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 15:15:02 -0400
Received: by eeit10 with SMTP id t10so76273eei.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 12:15:01 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, davem@davemloft.net, hannes@cmpxchg.org, tj@kernel.org, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: bootmem: fix checking the bitmap when finally freeing bootmem
has been removed from the -mm tree.  Its filename was
     mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm: bootmem: fix checking the bitmap when finally freeing bootmem

When bootmem releases an unaligned chunk of memory at the beginning of a
node to the page allocator, it iterates from that unaligned PFN but checks
an aligned word of the page bitmap.  The checked bits do not correspond to
the PFNs and, as a result, reserved pages can be freed.

Properly shift the bitmap word so that the lowest bit corresponds to the
starting PFN before entering the freeing loop.

This bug has been around since 41546c1 ("bootmem: clean up
free_all_bootmem_core") (2.6.27) without known reports.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: David S. Miller <davem@davemloft.net>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/bootmem.c~mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem
+++ a/mm/bootmem.c
@@ -203,6 +203,7 @@ static unsigned long __init free_all_boo
 		} else {
 			unsigned long off = 0;
 
+			vec >>= start & (BITS_PER_LONG - 1);
 			while (vec && off < BITS_PER_LONG) {
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

