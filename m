From: akpm@linux-foundation.org
Subject: [merged]
 =?US-ASCII?Q?mm-memory=5Fhotplug-remove-unnecesary-check-from-register?=
 =?US-ASCII?Q?=5Fpage=5Fbootmem=5Finfo=5Fsection.patch?= removed from -mm
 tree
Date: Thu, 01 Feb 2018 11:31:36 -0800
Message-ID: <20180201193136.uUhIeEcnr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57852 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753331AbeBATbh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 1 Feb 2018 14:31:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, mm-commits@vger.kernel.org, osalvador@techadventures.net, vbabka@suse.cz


The patch titled
     Subject: mm/memory_hotplug.c: remove unnecesary check from register_page_bootmem_info_section()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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
