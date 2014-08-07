From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-constify-allocation-mask.patch removed from
 -mm tree
Date: Thu, 07 Aug 2014 13:05:01 -0700
Message-ID: <53e3dbed.Wky3u77L3jZHKSRq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:40593 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaHGUFC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:05:02 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1175307pab.5
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:05:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, vmalloc: constify allocation mask
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-constify-allocation-mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, vmalloc: constify allocation mask

tmp_mask in the __vmalloc_area_node() iteration never changes so it can be
moved into function scope and marked with const.  This causes the movl and
orl to only be done once per call rather than area->nr_pages times.

nested_gfp can also be marked const.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-constify-allocation-mask mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-constify-allocation-mask
+++ a/mm/vmalloc.c
@@ -1566,7 +1566,8 @@ static void *__vmalloc_area_node(struct
 	const int order = 0;
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
-	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
+	const gfp_t alloc_mask = gfp_mask | __GFP_NOWARN;
 
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1589,12 +1590,11 @@ static void *__vmalloc_area_node(struct
 
 	for (i = 0; i < area->nr_pages; i++) {
 		struct page *page;
-		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_page(tmp_mask);
+			page = alloc_page(alloc_mask);
 		else
-			page = alloc_pages_node(node, tmp_mask, order);
+			page = alloc_pages_node(node, alloc_mask, order);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

