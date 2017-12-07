From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch added to -mm tree
Date: Thu, 07 Dec 2017 15:46:41 -0800
Message-ID: <5a29d2e1.KfvNtttpsw4D4D8M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57494 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751904AbdLGXqm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Dec 2017 18:46:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memory_hotplug: remove second __nr_to_section in register_page_bootmem_info_section()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch
mm-memory_hotplug-remove-second-__nr_to_section-in-register_page_bootmem_info_section.patch

