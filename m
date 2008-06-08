From: akpm@linux-foundation.org
Subject: + bootmem-revisit-alloc_bootmem_section.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:43 -0700
Message-ID: <200806082335.m58NZhl5025631@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49556 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754562AbYFHXiO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:38:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, y-goto@jp.fujitsu.com


The patch titled
     bootmem: revisit alloc_bootmem_section
has been added to the -mm tree.  Its filename is
     bootmem-revisit-alloc_bootmem_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: revisit alloc_bootmem_section
From: Johannes Weiner <hannes@saeurebad.de>

Since alloc_bootmem_core does no goal-fallback anymore and just returns
NULL if the allocation fails, we might now use it in alloc_bootmem_section
without all the fixup code for a misplaced allocation.

Also, the limit can be the first PFN of the next section as the semantics
is that the limit is _above_ the allocated region, not within.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff -puN mm/bootmem.c~bootmem-revisit-alloc_bootmem_section mm/bootmem.c
--- a/mm/bootmem.c~bootmem-revisit-alloc_bootmem_section
+++ a/mm/bootmem.c
@@ -632,30 +632,15 @@ void * __init __alloc_bootmem_node(pg_da
 void * __init alloc_bootmem_section(unsigned long size,
 				    unsigned long section_nr)
 {
-	void *ptr;
-	unsigned long limit, goal, start_nr, end_nr, pfn;
-	struct pglist_data *pgdat;
+	bootmem_data_t *bdata;
+	unsigned long pfn, goal, limit;
 
 	pfn = section_nr_to_pfn(section_nr);
-	goal = PFN_PHYS(pfn);
-	limit = PFN_PHYS(section_nr_to_pfn(section_nr + 1)) - 1;
-	pgdat = NODE_DATA(early_pfn_to_nid(pfn));
-	ptr = alloc_bootmem_core(pgdat->bdata, size, SMP_CACHE_BYTES, goal,
-				limit);
-
-	if (!ptr)
-		return NULL;
-
-	start_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr)));
-	end_nr = pfn_to_section_nr(PFN_DOWN(__pa(ptr) + size));
-	if (start_nr != section_nr || end_nr != section_nr) {
-		printk(KERN_WARNING "alloc_bootmem failed on section %ld.\n",
-		       section_nr);
-		free_bootmem_node(pgdat, __pa(ptr), size);
-		ptr = NULL;
-	}
+	goal = pfn << PAGE_SHIFT;
+	limit = section_nr_to_pfn(section_nr + 1) << PAGE_SHIFT;
+	bdata = &bootmem_node_data[early_pfn_to_nid(pfn)];
 
-	return ptr;
+	return alloc_bootmem_core(bdata, size, SMP_CACHE_BYTES, goal, limit);
 }
 #endif
 
_

Patches currently in -mm which might be from hannes@saeurebad.de are

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

