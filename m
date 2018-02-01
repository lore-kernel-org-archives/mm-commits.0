From: akpm@linux-foundation.org
Subject: [patch 052/119] mm/memory_hotplug.c: remove unnecesary
 check from register_page_bootmem_info_section()
Date: Wed, 31 Jan 2018 16:17:14 -0800
Message-ID: <20180201001714.HoSYgj6Bn%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751563AbeBAARP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:17:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, torvalds@linux-foundation.org, vbabka@suse.cz

From: Oscar Salvador <osalvador@techadventures.net>
Subject: mm/memory_hotplug.c: remove unnecesary check from register_page_bootmem_info_section()

When we call register_page_bootmem_info_section() having
CONFIG_SPARSEMEM_VMEMMAP enabled, we check if the pfn is valid.  This
check is redundant as we already checked this in
register_page_bootmem_info_node() before calling
register_page_bootmem_info_section(), so let's get rid of it.

Link: http://lkml.kernel.org/r/20171205143422.GA31458@techadventures.net
Signed-off-by: Oscar Salvador <osalvador@techadventures.net>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN mm/memory_hotplug.c~mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section
+++ a/mm/memory_hotplug.c
@@ -200,9 +200,6 @@ static void register_page_bootmem_info_s
 	struct mem_section *ms;
 	struct page *page, *memmap;
 
-	if (!pfn_valid(start_pfn))
-		return;
