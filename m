From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-remove-unused-struct-zone-z-variable.patch removed from -mm tree
Date: Tue, 19 Jan 2016 12:14:11 -0800
Message-ID: <569e9913.IUXCepln2XMqusyv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbcASUOL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:14:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kuleshovmail@gmail.com, kirill.shutemov@linux.intel.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused struct zone *z variable
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-unused-struct-zone-z-variable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: mm/page_alloc.c: remove unused struct zone *z variable

Remove unused struct zone *z variable which appeared in 86051ca5eaf5 ("mm:
fix usemap initialization").

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-remove-unused-struct-zone-z-variable mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-remove-unused-struct-zone-z-variable
+++ a/mm/page_alloc.c
@@ -4490,7 +4490,6 @@ void __meminit memmap_init_zone(unsigned
 	unsigned long end_pfn = start_pfn + size;
 	pg_data_t *pgdat = NODE_DATA(nid);
 	unsigned long pfn;
-	struct zone *z;
 	unsigned long nr_initialised = 0;
 
 	if (highest_memmap_pfn < end_pfn - 1)
@@ -4503,7 +4502,6 @@ void __meminit memmap_init_zone(unsigned
 	if (altmap && start_pfn == altmap->base_pfn)
 		start_pfn += altmap->reserve;
 
-	z = &pgdat->node_zones[zone];
 	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
 		/*
 		 * There can be holes in boot-time mem_map[]s
_

Patches currently in -mm which might be from kuleshovmail@gmail.com are


