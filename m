From: akpm@linux-foundation.org
Subject: - mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:12:25 -0800
Message-ID: <200901072212.n07MCPWq012624@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755927AbZAGWMb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:12:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: julia@diku.dk, mm-commits@vger.kernel.org


The patch titled
     mm/page_alloc.c: eliminate NULL test and memset after alloc_bootmem
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/page_alloc.c: eliminate NULL test and memset after alloc_bootmem
From: Julia Lawall <julia@diku.dk>

As noted by Akinobu Mita in patch b1fceac2b9e04d278316b2faddf276015fc06e3b,
alloc_bootmem and related functions never return NULL and always return a
zeroed region of memory.  Thus a NULL test or memset after calls to these
functions is unnecessary.

This was fixed using the following semantic patch.
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E;
statement S;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
(
- BUG_ON (E == NULL);
|
- if (E == NULL) S
)

@@
expression E,E1;
@@

E = \(alloc_bootmem\|alloc_bootmem_low\|alloc_bootmem_pages\|alloc_bootmem_low_pages\|alloc_bootmem_node\|alloc_bootmem_low_pages_node\|alloc_bootmem_pages_node\)(...)
... when != E
- memset(E,0,E1);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-eliminate-null-test-and-memset-after-alloc_bootmem
+++ a/mm/page_alloc.c
@@ -3381,10 +3381,8 @@ static void __init setup_usemap(struct p
 {
 	unsigned long usemapsize = usemap_size(zonesize);
 	zone->pageblock_flags = NULL;
-	if (usemapsize) {
+	if (usemapsize)
 		zone->pageblock_flags = alloc_bootmem_node(pgdat, usemapsize);
-		memset(zone->pageblock_flags, 0, usemapsize);
-	}
 }
 #else
 static void inline setup_usemap(struct pglist_data *pgdat,
_

Patches currently in -mm which might be from julia@diku.dk are

origin.patch
linux-next.patch
powerpc-powermac-add-missing-of_node_put.patch
net-tipc-bcasth-use-array_size.patch
net-bridge-netfilter-move-a-dereference-below-a-null-test.patch
drivers-isdn-hardware-misdn-move-a-dereference-below-a-null-test.patch
drivers-net-hamradio-6packc-move-a-dereference-below-a-null-test.patch
drivers-net-wireless-libertas-move-a-dereference-below-a-null-test.patch

