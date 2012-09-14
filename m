From: akpm@linux-foundation.org
Subject: + memory-hotplug-fix-a-double-register-section-info-bug.patch added to -mm tree
Date: Fri, 14 Sep 2012 13:14:40 -0700
Message-ID: <20120914201441.B3B985C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:39212 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2INUOp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Sep 2012 16:14:45 -0400
Received: by eekd4 with SMTP id d4so277573eek.1
        for <mm-commits@vger.kernel.org>; Fri, 14 Sep 2012 13:14:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: qiuxishi@gmail.com, isimatu.yasuaki@jp.fujitsu.com, jiang.liu@huawei.com, mgorman@suse.de, qiuxishi@huawei.com, stable@vger.kernel.org, tony.luck@intel.com


The patch titled
     Subject: memory hotplug: fix section info double registration bug
has been added to the -mm tree.  Its filename is
     memory-hotplug-fix-a-double-register-section-info-bug.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: qiuxishi <qiuxishi@gmail.com>
Subject: memory hotplug: fix section info double registration bug

There may be a bug when registering section info.  For example, on my
Itanium platform, the pfn range of node0 includes the other nodes, so
other nodes' section info will be double registered, and memmap's page
count will equal to 3.

node0: start_pfn=0x100,    spanned_pfn=0x20fb00, present_pfn=0x7f8a3, => 0x000100-0x20fc00
node1: start_pfn=0x80000,  spanned_pfn=0x80000,  present_pfn=0x80000, => 0x080000-0x100000
node2: start_pfn=0x100000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x100000-0x180000
node3: start_pfn=0x180000, spanned_pfn=0x80000,  present_pfn=0x80000, => 0x180000-0x200000

free_all_bootmem_node()
	register_page_bootmem_info_node()
		register_page_bootmem_info_section()

When hot remove memory, we can't free the memmap's page because
page_count() is 2 after put_page_bootmem().

sparse_remove_one_section()
	free_section_usemap()
		free_map_bootmem()
			put_page_bootmem()

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN mm/memory_hotplug.c~memory-hotplug-fix-a-double-register-section-info-bug mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-hotplug-fix-a-double-register-section-info-bug
+++ a/mm/memory_hotplug.c
@@ -126,9 +126,6 @@ static void register_page_bootmem_info_s
 	struct mem_section *ms;
 	struct page *page, *memmap;
 
-	if (!pfn_valid(start_pfn))
-		return;
-
 	section_nr = pfn_to_section_nr(start_pfn);
 	ms = __nr_to_section(section_nr);
 
@@ -187,9 +184,10 @@ void register_page_bootmem_info_node(str
 	end_pfn = pfn + pgdat->node_spanned_pages;
 
 	/* register_section info */
-	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION)
-		register_page_bootmem_info_section(pfn);
