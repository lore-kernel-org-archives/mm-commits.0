From: akpm@linux-foundation.org
Subject: [merged] mm-bootmemc-remove-unused-local-map.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:39:10 -0800
Message-ID: <5283e36e./DkIIA4oJRSFj5pt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab3KMUjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:39:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, daeseok.youn@gmail.com

Subject: [merged] mm-bootmemc-remove-unused-local-map.patch removed from -mm tree
To: daeseok.youn@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:39:10 -0800


The patch titled
     Subject: mm/bootmem.c: remove unused local `map'
has been removed from the -mm tree.  Its filename was
     mm-bootmemc-remove-unused-local-map.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: mm/bootmem.c: remove unused local `map'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/bootmem.c~mm-bootmemc-remove-unused-local-map mm/bootmem.c
--- a/mm/bootmem.c~mm-bootmemc-remove-unused-local-map
+++ a/mm/bootmem.c
@@ -172,11 +172,12 @@ void __init free_bootmem_late(unsigned l
 static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
-	unsigned long start, end, pages, count = 0;
+	unsigned long *map, start, end, pages, count = 0;
 
 	if (!bdata->node_bootmem_map)
 		return 0;
 
+	map = bdata->node_bootmem_map;
 	start = bdata->node_min_pfn;
 	end = bdata->node_low_pfn;
 
@@ -184,10 +185,9 @@ static unsigned long __init free_all_boo
 		bdata - bootmem_node_data, start, end);
 
 	while (start < end) {
-		unsigned long *map, idx, vec;
+		unsigned long idx, vec;
 		unsigned shift;
 
-		map = bdata->node_bootmem_map;
 		idx = start - bdata->node_min_pfn;
 		shift = idx & (BITS_PER_LONG - 1);
 		/*
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch

