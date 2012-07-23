From: akpm@linux-foundation.org
Subject: [merged] bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch removed from -mm tree
Date: Mon, 23 Jul 2012 14:30:40 -0700
Message-ID: <20120723213040.7DFC81E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:50305 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2GWVal (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Jul 2012 17:30:41 -0400
Received: by yhl10 with SMTP id 10so786111yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 23 Jul 2012 14:30:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai@kernel.org, hannes@cmpxchg.org, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: bootmem: make ___alloc_bootmem_node_nopanic() really nopanic
has been removed from the -mm tree.  Its filename was
     bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yinghai Lu <yinghai@kernel.org>
Subject: bootmem: make ___alloc_bootmem_node_nopanic() really nopanic

after
| From 99ab7b19440a72ebdf225f99b20f8ef40decee86 Mon Sep 17 00:00:00 2001
| Date: Wed, 11 Jul 2012 14:02:53 -0700
| Subject: [PATCH] mm: sparse: fix usemap allocation above node descriptor
 section

Johannes said:
| while backporting the below patch, I realised that your fix busted
| f5bf18fa22f8 again.  The problem was not a panicking version on
| allocation failure but when the usemap size was too large such that
| goal + size > limit triggers the BUG_ON in the bootmem allocator.  So
| we need a version that passes limit ONLY if the usemap is smaller than
| the section.

after checking the code, the name of ___alloc_bootmem_node_nopanic() does
not reflect the fact.

Make bootmem really not panic.

Hope will kill bootmem sooner.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: <stable@vger.kernel.org>    [3.3.x, 3.4.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/bootmem.c~bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic mm/bootmem.c
--- a/mm/bootmem.c~bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic
+++ a/mm/bootmem.c
@@ -710,6 +710,10 @@ again:
 	if (ptr)
 		return ptr;
 
+	/* do not panic in alloc_bootmem_bdata() */
+	if (limit && goal + size > limit)
+		limit = 0;
+
 	ptr = alloc_bootmem_bdata(pgdat->bdata, size, align, goal, limit);
 	if (ptr)
 		return ptr;
_

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

