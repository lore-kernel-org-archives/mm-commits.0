From: akpm@linux-foundation.org
Subject: [merged] mm-try-harder-to-allocate-vmemmap-blocks.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:48:04 -0700
Message-ID: <20130430184804.9B8D85A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:35251 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab3D3SsG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:48:06 -0400
Received: by mail-qa0-f73.google.com with SMTP id p6so86531qad.0
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:48:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@decadent.org.uk, Bernhard.Schmidt@lrz.de, benh@kernel.crashing.org, davem@davemloft.net, hannes@cmpxchg.org, heiko.carstens@de.ibm.com, hpa@zytor.com, mingo@elte.hu, rmk@arm.linux.org.uk, tglx@linutronix.de, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: try harder to allocate vmemmap blocks
has been removed from the -mm tree.  Its filename was
     mm-try-harder-to-allocate-vmemmap-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ben Hutchings <ben@decadent.org.uk>
Subject: mm: try harder to allocate vmemmap blocks

Hot-adding memory on x86_64 normally requires huge page allocation.  When
this is done to a VM guest, it's usually because the system is already
tight on memory, so the request tends to fail.  Try to avoid this by
adding __GFP_REPEAT to the allocation flags.

Addresses http://bugs.debian.org/699913

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Tested-by: Bernhard Schmidt <Bernhard.Schmidt@lrz.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN mm/sparse-vmemmap.c~mm-try-harder-to-allocate-vmemmap-blocks mm/sparse-vmemmap.c
--- a/mm/sparse-vmemmap.c~mm-try-harder-to-allocate-vmemmap-blocks
+++ a/mm/sparse-vmemmap.c
@@ -53,10 +53,12 @@ void * __meminit vmemmap_alloc_block(uns
 		struct page *page;
 
 		if (node_state(node, N_HIGH_MEMORY))
-			page = alloc_pages_node(node,
-				GFP_KERNEL | __GFP_ZERO, get_order(size));
+			page = alloc_pages_node(
+				node, GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
+				get_order(size));
 		else
-			page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+			page = alloc_pages(
+				GFP_KERNEL | __GFP_ZERO | __GFP_REPEAT,
 				get_order(size));
 		if (page)
 			return page_address(page);
_

Patches currently in -mm which might be from ben@decadent.org.uk are

origin.patch
linux-next.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present.patch
dmi_scan-refactor-dmi_scan_machine-smbiosdmi_present-fix.patch

