From: akpm@linux-foundation.org
Subject: + mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch added to -mm tree
Date: Thu, 17 May 2012 16:41:54 -0700
Message-ID: <20120517234154.9C60AA03CD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:45212 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2EQXl5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 May 2012 19:41:57 -0400
Received: by faaa25 with SMTP id a25so125506faa.1
        for <mm-commits@vger.kernel.org>; Thu, 17 May 2012 16:41:55 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, hannes@cmpxchg.org


The patch titled
     Subject: mm/bootmem.c: cleanup on addition to bootmem data list
has been added to the -mm tree.  Its filename is
     mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch

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
Subject: mm/bootmem.c: cleanup on addition to bootmem data list

The objects of "struct bootmem_data_t" are linked together to form
double-linked list sequentially based on its minimal page frame number. 

The current implementation implicitly supports the following cases, which
means the inserting point for current bootmem data depends on how
"list_for_each" works.  That makes the code a little hard to read. 
Besides, "list_for_each" and "list_entry" can be replaced with
"list_for_each_entry".

        - The linked list is empty.
        - There has no entry in the linked list, whose minimal page
          frame number is bigger than current one.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-cleanup-on-addition-to-bootmem-data-list mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-cleanup-on-addition-to-bootmem-data-list
+++ a/mm/bootmem.c
@@ -77,16 +77,16 @@ unsigned long __init bootmem_bootmap_pag
  */
 static void __init link_bootmem(bootmem_data_t *bdata)
 {
-	struct list_head *iter;
+	bootmem_data_t *ent;
 
-	list_for_each(iter, &bdata_list) {
-		bootmem_data_t *ent;
-
-		ent = list_entry(iter, bootmem_data_t, list);
-		if (bdata->node_min_pfn < ent->node_min_pfn)
-			break;
+	list_for_each_entry(ent, &bdata_list, list) {
+		if (bdata->node_min_pfn < ent->node_min_pfn) {
+			list_add_tail(&bdata->list, &ent->list);
+			return;
+		}
 	}
-	list_add_tail(&bdata->list, iter);
+
+	list_add_tail(&bdata->list, &bdata_list);
 }
 
 /*
_
Subject: Subject: mm/bootmem.c: cleanup on addition to bootmem data list

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

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
mm-remove-sparsemem-allocation-details-from-the-bootmem-allocator-fix-2.patch
mm-buddy-dump-pg_compound_lock-page-flag.patch
mm-page_alloc-catch-out-of-date-list-of-page-flag-names.patch
mm-page_allocc-cleanups.patch
mm-bootmemc-cleanup-on-addition-to-bootmem-data-list.patch

