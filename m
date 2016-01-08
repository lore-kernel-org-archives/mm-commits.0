From: akpm@linux-foundation.org
Subject: + mm-page_alloc-remove-unused-struct-zone-z-variable.patch added
 to -mm tree
Date: Fri, 08 Jan 2016 15:33:22 -0800
Message-ID: <56904742.Mj8Rg6r4VcByzseL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50254 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbcAHXdX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jan 2016 18:33:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused struct zone *z variable
has been added to the -mm tree.  Its filename is
     mm-page_alloc-remove-unused-struct-zone-z-variable.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-remove-unused-struct-zone-z-variable.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-remove-unused-struct-zone-z-variable.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/page_alloc.c: remove unused struct zone *z variable

Remove unused struct zone *z variable which appeared in 86051ca5eaf5 ("mm:
fix usemap initialization").

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unused-struct-zone-z-variable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unused-struct-zone-z-variable
+++ a/mm/page_alloc.c
@@ -4594,7 +4594,6 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long end_pfn = start_pfn + size;
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long pfn;
-	struct zone *z;
 	unsigned long nr_initialised = 0;
 
 	if (highest_memmap_pfn < end_pfn - 1)
@@ -4607,7 +4606,6 @@ void __meminit memmap_init_zone(unsigned
 	if (altmap && start_pfn == altmap->base_pfn)
 		start_pfn += altmap->reserve;
 
-	z = &pgdat->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are

mm-memblock-remove-rgnbase-and-rgnsize-variables.patch
mm-memblock-introduce-for_each_memblock_type.patch
mm-page_alloc-remove-unused-struct-zone-z-variable.patch

