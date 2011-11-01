From: akpm@linux-foundation.org
Subject: [merged] mm-vmallocc-report-more-vmalloc-failures.patch removed from -mm tree
Date: Tue, 01 Nov 2011 14:10:51 -0700
Message-ID: <201111012110.pA1LAp9Q004747@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:29143 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753705Ab1KAVKz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Nov 2011 17:10:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: report more vmalloc failures
has been removed from the -mm tree.  Its filename was
     mm-vmallocc-report-more-vmalloc-failures.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Joe Perches <joe@perches.com>
Subject: mm/vmalloc.c: report more vmalloc failures

Some vmalloc failure paths do not report OOM conditions.

Add warn_alloc_failed, which also does a dump_stack, to those failure
paths.

This allows more site specific vmalloc failure logging message printks to
be removed.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmallocc-report-more-vmalloc-failures mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmallocc-report-more-vmalloc-failures
+++ a/mm/vmalloc.c
@@ -1625,13 +1625,12 @@ void *__vmalloc_node_range(unsigned long
 
 	size = PAGE_ALIGN(size);
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
-		return NULL;
+		goto fail;
 
 	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
 				  start, end, node, gfp_mask, caller);
-
 	if (!area)
-		return NULL;
+		goto fail;
 
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 
@@ -1649,6 +1648,12 @@ void *__vmalloc_node_range(unsigned long
 	kmemleak_alloc(addr, real_size, 3, gfp_mask);
 
 	return addr;
+
+fail:
+	warn_alloc_failed(gfp_mask, 0,
+			  "vmalloc: allocation failure: %lu bytes\n",
+			  real_size);
+	return NULL;
 }
 
 /**
_

Patches currently in -mm which might be from joe@perches.com are

origin.patch
linux-next.patch

