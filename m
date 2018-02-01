From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-remove-second-=5F=5Fnr=5Fto=5Fsection?=
 =?US-ASCII?Q?-in-register=5Fpage=5Fbootmem=5Finfo=5Fsection.patch?=
 removed from -mm tree
Date: Thu, 01 Feb 2018 11:31:45 -0800
Message-ID: <20180201193145.ihJpP2c3Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58130 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbeBATbr (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, vbabka@suse.cz


The patch titled
     Subject: mm: memory_hotplug: remove second __nr_to_section in register_page_bootmem_info_section()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from osalvador@techadventures.net are


