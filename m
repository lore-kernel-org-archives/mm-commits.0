From: akpm@linux-foundation.org
Subject: + mm-fix-memory-hotplug-oops-from-zone_movable-changes.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:07:38 -0700
Message-ID: <200707200607.l6K67cRZ010707@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40107 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751380AbXGTGHw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:07:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, mel@csn.ul.ie


The patch titled
     mm: fix memory hotplug oops from ZONE_MOVABLE changes.
has been added to the -mm tree.  Its filename is
     mm-fix-memory-hotplug-oops-from-zone_movable-changes.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Mel Gorman <mel@csn.ul.ie>
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
mm-fix-memory-hotplug-oops-from-zone_movable-changes.patch
git-sh.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
