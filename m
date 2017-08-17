From: akpm@linux-foundation.org
Subject: + mm-vmalloc-dont-unconditonally-use-__gfp_highmem.patch added to -mm tree
Date: Thu, 17 Aug 2017 15:03:47 -0700
Message-ID: <599612c3.QhFLqlHVO8LFIzJC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbdHQWDs (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 17 Aug 2017 18:03:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: labbott@redhat.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: don't unconditonally use __GFP_HIGHMEM
has been added to the -mm tree.  Its filename is
     mm-vmalloc-dont-unconditonally-use-__gfp_highmem.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-dont-unconditonally-use-__gfp_highmem.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-dont-unconditonally-use-__gfp_highmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Laura Abbott <labbott@redhat.com>
Subject: mm/vmalloc.c: don't unconditonally use __GFP_HIGHMEM

19809c2da28a ("mm, vmalloc: use __GFP_HIGHMEM implicitly") added use of
__GFP_HIGHMEM for allocations.  vmalloc_32 may use GFP_DMA/GFP_DMA32 which
does not play nice with __GFP_HIGHMEM and will trigger a BUG in gfp_zone. 
Only add __GFP_HIGHMEM if we aren't using GFP_DMA/GFP_DMA32.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1482249
Link: http://lkml.kernel.org/r/20170816220705.31374-1-labbott@redhat.com
Fixes: 19809c2da28a ("mm, vmalloc: use __GFP_HIGHMEM implicitly")
Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-dont-unconditonally-use-__gfp_highmem mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-dont-unconditonally-use-__gfp_highmem
+++ a/mm/vmalloc.c
@@ -1671,7 +1671,10 @@ static void *__vmalloc_area_node(struct
 	struct page **pages;
 	unsigned int nr_pages, array_size, i;
 	const gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
-	const gfp_t alloc_mask = gfp_mask | __GFP_HIGHMEM | __GFP_NOWARN;
+	const gfp_t alloc_mask = gfp_mask | __GFP_NOWARN;
+	const gfp_t highmem_mask = (gfp_mask & (GFP_DMA | GFP_DMA32)) ?
+					0 :
+					__GFP_HIGHMEM;
 
 	nr_pages = get_vm_area_size(area) >> PAGE_SHIFT;
 	array_size = (nr_pages * sizeof(struct page *));
@@ -1679,7 +1682,7 @@ static void *__vmalloc_area_node(struct
 	area->nr_pages = nr_pages;
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
-		pages = __vmalloc_node(array_size, 1, nested_gfp|__GFP_HIGHMEM,
+		pages = __vmalloc_node(array_size, 1, nested_gfp|highmem_mask,
 				PAGE_KERNEL, node, area->caller);
 	} else {
 		pages = kmalloc_node(array_size, nested_gfp, node);
@@ -1700,9 +1703,9 @@ static void *__vmalloc_area_node(struct
 		}
 
 		if (node == NUMA_NO_NODE)
-			page = alloc_page(alloc_mask);
+			page = alloc_page(alloc_mask|highmem_mask);
 		else
-			page = alloc_pages_node(node, alloc_mask, 0);
+			page = alloc_pages_node(node, alloc_mask|highmem_mask, 0);
 
 		if (unlikely(!page)) {
 			/* Successfully allocated i pages, free them in __vunmap() */
@@ -1710,7 +1713,7 @@ static void *__vmalloc_area_node(struct
 			goto fail;
 		}
 		area->pages[i] = page;
-		if (gfpflags_allow_blocking(gfp_mask))
+		if (gfpflags_allow_blocking(gfp_mask|highmem_mask))
 			cond_resched();
 	}
 
_

Patches currently in -mm which might be from labbott@redhat.com are

mm-vmalloc-dont-unconditonally-use-__gfp_highmem.patch

