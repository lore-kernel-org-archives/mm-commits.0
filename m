From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
 removed from -mm tree
Date: Mon, 21 Mar 2016 11:38:14 -0700
Message-ID: <56f03f96.+Zy3zfHfPJyLzx32%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53452 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757675AbcCUT4T (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Mar 2016 15:56:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, benh@kernel.crashing.org, borntraeger@de.ibm.com, cl@linux.com, cmetcalf@ezchip.com, penberg@kernel.org, rientjes@google.com, tiwai@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmalloc: query dynamic DEBUG_PAGEALLOC setting

As CONFIG_DEBUG_PAGEALLOC can be enabled/disabled via kernel parameters we
can optimize some cases by checking the enablement state.

This is follow-up work for Christian's Optimize CONFIG_DEBUG_PAGEALLOC:
https://lkml.org/lkml/2016/1/27/194

Remaining work is to make sparc to be aware of this but it looks not easy
for me so I skip that in this series.


This patch (of 5):

We can disable debug_pagealloc processing even if the code is complied
with CONFIG_DEBUG_PAGEALLOC. This patch changes the code to query
whether it is enabled or not in runtime.

[akpm@linux-foundation.org: update comment, per David.  Adjust comment to use 80 cols]
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-query-dynamic-debug_pagealloc-setting
+++ a/mm/vmalloc.c
@@ -531,22 +531,21 @@ static void unmap_vmap_area(struct vmap_
 static void vmap_debug_free_range(unsigned long start, unsigned long end)
 {
 	/*
-	 * Unmap page tables and force a TLB flush immediately if
-	 * CONFIG_DEBUG_PAGEALLOC is set. This catches use after free
-	 * bugs similarly to those in linear kernel virtual address
-	 * space after a page has been freed.
+	 * Unmap page tables and force a TLB flush immediately if pagealloc
+	 * debugging is enabled.  This catches use after free bugs similarly to
+	 * those in linear kernel virtual address space after a page has been
+	 * freed.
 	 *
-	 * All the lazy freeing logic is still retained, in order to
-	 * minimise intrusiveness of this debugging feature.
+	 * All the lazy freeing logic is still retained, in order to minimise
+	 * intrusiveness of this debugging feature.
 	 *
-	 * This is going to be *slow* (linear kernel virtual address
-	 * debugging doesn't do a broadcast TLB flush so it is a lot
-	 * faster).
+	 * This is going to be *slow* (linear kernel virtual address debugging
+	 * doesn't do a broadcast TLB flush so it is a lot faster).
 	 */
-#ifdef CONFIG_DEBUG_PAGEALLOC
-	vunmap_page_range(start, end);
-	flush_tlb_kernel_range(start, end);
-#endif
+	if (debug_pagealloc_enabled()) {
+		vunmap_page_range(start, end);
+		flush_tlb_kernel_range(start, end);
+	}
 }
 
 /*
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


