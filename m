From: akpm@linux-foundation.org
Subject: [patch 055/119] mm: memory_hotplug: remove second
 __nr_to_section in register_page_bootmem_info_section()
Date: Wed, 31 Jan 2018 16:17:25 -0800
Message-ID: <20180201001725.leWjzDT1z%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34944 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBAAR1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, torvalds@linux-foundation.org, vbabka@suse.cz

From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm: memory_hotplug: remove second __nr_to_section in register_page_bootmem_info_section()

In register_page_bootmem_info_section() we call __nr_to_section() in order
to get the mem_section struct at the beginning of the function.  Since we
already got it, there is no need for a second call to __nr_to_section().

Link: http://lkml.kernel.org/r/20171207102914.GA12396@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section
+++ a/mm/memory_hotplug.c
@@ -184,7 +184,7 @@ static void register_page_bootmem_info_s
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, SECTION_INFO);
 
-	usemap = __nr_to_section(section_nr)->pageblock_flags;
+	usemap = ms->pageblock_flags;
 	page = virt_to_page(usemap);
 
 	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
@@ -207,7 +207,7 @@ static void register_page_bootmem_info_s
 
 	register_page_bootmem_memmap(section_nr, memmap, PAGES_PER_SECTION);
 
-	usemap = __nr_to_section(section_nr)->pageblock_flags;
+	usemap = ms->pageblock_flags;
 	page = virt_to_page(usemap);
 
 	mapsize = PAGE_ALIGN(usemap_size()) >> PAGE_SHIFT;
_
