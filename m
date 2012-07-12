From: akpm@linux-foundation.org
Subject: + bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch added to -mm tree
Date: Thu, 12 Jul 2012 14:18:09 -0700
Message-ID: <20120712211810.0FA3E5C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62129 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248Ab2GLVSM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Jul 2012 17:18:12 -0400
Received: by eekd4 with SMTP id d4so91589eek.1
        for <mm-commits@vger.kernel.org>; Thu, 12 Jul 2012 14:18:11 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghai@kernel.org, hannes@cmpxchg.org, stable@vger.kernel.org


The patch titled
     Subject: bootmem: make ___alloc_bootmem_node_nopanic() really nopanic
has been added to the -mm tree.  Its filename is
     bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: bootmem: make ___alloc_bootmem_node_nopanic() really nopanic

Patches currently in -mm which might be from yinghai@kernel.org are

origin.patch
linux-next.patch
bootmem-make-___alloc_bootmem_node_nopanic-to-be-real-nopanic.patch
mm-memblockc-memblock_double_array-cosmetic-cleanups.patch
mm-setup-pageblock_order-before-its-used-by-sparsemem.patch
mm-hotplug-correctly-setup-fallback-zonelists-when-creating-new-pgdat.patch
mm-hotplug-correctly-add-new-zone-to-all-other-nodes-zone-lists.patch
mm-hotplug-free-zone-pageset-when-a-zone-becomes-empty.patch
mm-hotplug-mark-memory-hotplug-code-in-page_allocc-as-__meminit.patch

