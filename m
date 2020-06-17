From: akpm@linux-foundation.org
Subject: + mm-cma-fix-the-name-of-cma-areas.patch added to -mm tree
Date: Wed, 17 Jun 2020 13:28:20 -0700
Message-ID: <20200617202820.flZDr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbgFQU2V (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 16:28:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mike.kravetz@oracle.com, guro@fb.com, song.bao.hua@hisilicon.com


The patch titled
     Subject: mm: cma: fix the name of CMA areas
has been added to the -mm tree.  Its filename is
     mm-cma-fix-the-name-of-cma-areas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-fix-the-name-of-cma-areas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-fix-the-name-of-cma-areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Barry Song <song.bao.hua@hisilicon.com>
Subject: mm: cma: fix the name of CMA areas

Patch series "mm: fix the names of general cma and hugetlb cma", v2.

The current code of CMA can only work when users pass a const string as
name parameter.  we need to fix the way to handle names in CMA.  On the
other hand, to avoid name conflicts after enabling CMA_DEBUGFS, each
hugetlb should get a different CMA name.


This patch (of 2):

If users give a name saved in stack, the current code will generate magic
pointer.  if users don't give a name(NULL), kasprintf() will always return
NULL as we are at the early stage.  that means cma_init_reserved_mem()
will return -ENOMEM if users set name parameter as NULL.

Link: http://lkml.kernel.org/r/20200616223131.33828-2-song.bao.hua@hisilicon.com
Signed-off-by: Barry Song <song.bao.hua@hisilicon.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |   13 ++++++-------
 mm/cma.h |    4 +++-
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/mm/cma.c~mm-cma-fix-the-name-of-cma-areas
+++ a/mm/cma.c
@@ -202,13 +202,12 @@ int __init cma_init_reserved_mem(phys_ad
 	 * subsystems (like slab allocator) are available.
 	 */
 	cma = &cma_areas[cma_area_count];
-	if (name) {
-		cma->name = name;
-	} else {
-		cma->name = kasprintf(GFP_KERNEL, "cma%d\n", cma_area_count);
-		if (!cma->name)
-			return -ENOMEM;
-	}
+
+	if (name)
+		snprintf(cma->name, CMA_MAX_NAME, name);
+	else
+		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
+
 	cma->base_pfn = PFN_DOWN(base);
 	cma->count = size >> PAGE_SHIFT;
 	cma->order_per_bit = order_per_bit;
--- a/mm/cma.h~mm-cma-fix-the-name-of-cma-areas
+++ a/mm/cma.h
@@ -2,6 +2,8 @@
 #ifndef __MM_CMA_H__
 #define __MM_CMA_H__
 
+#define CMA_MAX_NAME 64
+
 struct cma {
 	unsigned long   base_pfn;
 	unsigned long   count;
@@ -12,7 +14,7 @@ struct cma {
 	struct hlist_head mem_head;
 	spinlock_t mem_head_lock;
 #endif
-	const char *name;
+	char name[CMA_MAX_NAME];
 };
 
 extern struct cma cma_areas[MAX_CMA_AREAS];
_

Patches currently in -mm which might be from song.bao.hua@hisilicon.com are

mm-cma-fix-the-name-of-cma-areas.patch
mm-hugetlb-fix-the-name-of-hugetlb-cma.patch
