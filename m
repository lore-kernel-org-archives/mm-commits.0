From: akpm@linux-foundation.org
Subject: + bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:41 -0700
Message-ID: <200806082335.m58NZfsi025628@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbYFHXjZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:39:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, andi@firstfloor.org, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     bootmem: Make __alloc_bootmem_low_node fall back to other nodes
has been added to the -mm tree.  Its filename is
     bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch

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
Subject: bootmem: Make __alloc_bootmem_low_node fall back to other nodes
From: Johannes Weiner <hannes@saeurebad.de>

__alloc_bootmem_node already does this, make the interface consistent.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff -puN mm/bootmem.c~bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes mm/bootmem.c
--- a/mm/bootmem.c~bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes
+++ a/mm/bootmem.c
@@ -587,6 +587,19 @@ void * __init __alloc_bootmem(unsigned l
 	return ___alloc_bootmem(size, align, goal, 0);
 }
 
+static void * __init ___alloc_bootmem_node(bootmem_data_t *bdata,
+				unsigned long size, unsigned long align,
+				unsigned long goal, unsigned long limit)
+{
+	void *ptr;
+
+	ptr = alloc_bootmem_core(bdata, size, align, goal, limit);
+	if (ptr)
+		return ptr;
+
+	return ___alloc_bootmem(size, align, goal, limit);
+}
+
 /**
  * __alloc_bootmem_node - allocate boot memory from a specific node
  * @pgdat: node to allocate from
@@ -605,13 +618,7 @@ void * __init __alloc_bootmem(unsigned l
 void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 				   unsigned long align, unsigned long goal)
 {
-	void *ptr;
-
-	ptr = alloc_bootmem_core(pgdat->bdata, size, align, goal, 0);
-	if (ptr)
-		return ptr;
-
-	return __alloc_bootmem(size, align, goal);
+	return ___alloc_bootmem_node(pgdat->bdata, size, align, goal, 0);
 }
 
 #ifdef CONFIG_SPARSEMEM
@@ -705,6 +712,6 @@ void * __init __alloc_bootmem_low(unsign
 void * __init __alloc_bootmem_low_node(pg_data_t *pgdat, unsigned long size,
 				       unsigned long align, unsigned long goal)
 {
-	return alloc_bootmem_core(pgdat->bdata, size, align, goal,
-				ARCH_LOW_ADDRESS_LIMIT);
+	return ___alloc_bootmem_node(pgdat->bdata, size, align,
+				goal, ARCH_LOW_ADDRESS_LIMIT);
 }
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

