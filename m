From: akpm@linux-foundation.org
Subject: +
 mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch added to -mm tree
Date: Tue, 05 Dec 2017 15:57:54 -0800
Message-ID: <5a273282.jqJzf8x9Wa220N8K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752685AbdLEX5z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 5 Dec 2017 18:57:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: osalvador@techadventures.net, mhocko@suse.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory_hotplug.c: remove unnecesary check from register_page_bootmem_info_section()
has been added to the -mm tree.  Its filename is
     mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory_hotplug-remove-unnecesary-check-from-register_page_bootmem_info_section.patch

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
