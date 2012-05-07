From: akpm@linux-foundation.org
Subject: + mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch added to -mm tree
Date: Mon, 07 May 2012 14:27:43 -0700
Message-ID: <20120507212744.32D90A0444@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:50930 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932355Ab2EGV1p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 May 2012 17:27:45 -0400
Received: by yenq5 with SMTP id q5so176327yen.1
        for <mm-commits@vger.kernel.org>; Mon, 07 May 2012 14:27:44 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, davem@davemloft.net, hannes@cmpxchg.org, tj@kernel.org, yinghai@kernel.org


The patch titled
     Subject: mm: bootmem: fix checking the bitmap when finally freeing bootmem
has been added to the -mm tree.  Its filename is
     mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: mm: bootmem: fix checking the bitmap when finally freeing bootmem

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch

