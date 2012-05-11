From: akpm@linux-foundation.org
Subject: + mm-slab-remove-duplicate-check.patch added to -mm tree
Date: Fri, 11 May 2012 14:03:15 -0700
Message-ID: <20120511210315.BB0BAA037F@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:56235 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932227Ab2EKVDR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 May 2012 17:03:17 -0400
Received: by werf13 with SMTP id f13so110685wer.1
        for <mm-commits@vger.kernel.org>; Fri, 11 May 2012 14:03:16 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org, penberg@cs.helsinki.fi


The patch titled
     Subject: mm/slab: remove duplicate check
has been added to the -mm tree.  Its filename is
     mm-slab-remove-duplicate-check.patch

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
Subject: mm/slab: remove duplicate check

While allocating pages using buddy allocator, the compound page is
probably split up to free pages.  Under these circumstances, the compound
page should be destroyed by destroy_compound_page().  However, there is a
duplicate check to judge if the page is compound.

Remove the duplicate check since the compound_order() returns 0 when the
page doesn't have PG_head set in destroy_compound_page().  That is to say,
destroy_compound_page() needn't check PageHead().

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-slab-remove-duplicate-check mm/page_alloc.c
--- a/mm/page_alloc.c~mm-slab-remove-duplicate-check
+++ a/mm/page_alloc.c
@@ -364,8 +364,7 @@ static int destroy_compound_page(struct 
 	int nr_pages = 1 << order;
 	int bad = 0;
 
-	if (unlikely(compound_order(page) != order) ||
-	    unlikely(!PageHead(page))) {
+	if (unlikely(compound_order(page) != order)) {
 		bad_page(page);
 		bad++;
 	}
_
Subject: Subject: mm/slab: remove duplicate check

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch
mm-bootmem-fix-checking-the-bitmap-when-finally-freeing-bootmem.patch
mm-bootmem-rename-alloc_bootmem_core-to-alloc_bootmem_bdata.patch
mm-bootmem-split-out-goal-to-node-mapping-from-goal-dropping.patch
mm-bootmem-allocate-in-order-nodegoal-goal-node-anywhere.patch
mm-bootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-nobootmem-panic-on-node-specific-allocation-failure.patch
mm-nobootmem-unify-allocation-policy-of-non-panicking-node-allocations.patch
mm-bootmem-pass-pgdat-instead-of-pgdat-bdata-down-the-stack.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator.patch
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix.patch

