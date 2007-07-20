From: akpm@linux-foundation.org
Subject: - mm-fix-memory-hotplug-oops-from-zone_movable-changes.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:41:49 -0700
Message-ID: <200707201941.l6KJfnDl012973@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760442AbXGTTmC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: fix memory hotplug oops from ZONE_MOVABLE changes.
has been removed from the -mm tree.  Its filename was
     mm-fix-memory-hotplug-oops-from-zone_movable-changes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mm: fix memory hotplug oops from ZONE_MOVABLE changes.
From: Paul Mundt <lethal@linux-sh.org>

zone_movable_pfn is presently marked as __initdata and referenced from
adjust_zone_range_for_zone_movable(), which in turn is referenced by
zone_spanned_pages_in_node().  Both of these are __meminit annotated.  When
memory hotplug is enabled, this will oops on a hot-add, due to
zone_movable_pfn having been freed.

__meminitdata annotation gives the desired behaviour.

This will only impact platforms that enable both memory hotplug
and ARCH_POPULATES_NODE_MAP.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-memory-hotplug-oops-from-zone_movable-changes mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-memory-hotplug-oops-from-zone_movable-changes
+++ a/mm/page_alloc.c
@@ -138,7 +138,7 @@ static unsigned long __meminitdata dma_r
 #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
   unsigned long __initdata required_kernelcore;
   unsigned long __initdata required_movablecore;
-  unsigned long __initdata zone_movable_pfn[MAX_NUMNODES];
+  unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
   /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
   int movable_zone;
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
nommu-vmalloc_32_user-vm_insert_page-and-symbol-exports.patch
fix-dma-on-dreamcast.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
