From: akpm@linux-foundation.org
Subject: - create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch removed from -mm tree
Date: Wed, 09 May 2007 15:00:57 -0700
Message-ID: <200705092200.l49M0v4H003428@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbXEIWBB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 18:01:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: y-goto@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Fix section mismatch of memory hotplug related code.
has been removed from the -mm tree.  Its filename was
     create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch

This patch was dropped because it was folded into create-the-zone_movable-zone.patch

------------------------------------------------------
Subject: Fix section mismatch of memory hotplug related code.
From: Yasunori Goto <y-goto@jp.fujitsu.com>

This is to fix many section mismatches of code related to memory hotplug.
I checked compile with memory hotplug on/off on ia64 and x86-64 box.

Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2 mm/page_alloc.c
--- a/mm/page_alloc.c~create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2
+++ a/mm/page_alloc.c
@@ -2818,7 +2818,7 @@ void __init find_usable_zone_for_movable
  * highest usable zone for ZONE_MOVABLE. This preserves the assumption that
  * zones within a node are in order of monotonic increases memory addresses
  */
-void __init adjust_zone_range_for_zone_movable(int nid,
+void __meminit adjust_zone_range_for_zone_movable(int nid,
 					unsigned long zone_type,
 					unsigned long node_start_pfn,
 					unsigned long node_end_pfn,
_

Patches currently in -mm which might be from y-goto@jp.fujitsu.com are

origin.patch
early_pfn_to_nid-needs-to-be-__meminit.patch
move-free-pages-between-lists-on-steal.patch
create-the-zone_movable-zone.patch
create-the-zone_movable-zone-fix-section-mismatch-of-memory-hotplug-related-code-2.patch
handle-kernelcore=-generic.patch
