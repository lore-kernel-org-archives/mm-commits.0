From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node.patch removed
 from -mm tree
Date: Tue, 31 May 2016 10:50:33 -0700
Message-ID: <574dcee9.SOvHf5ILf/naP5rj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267AbcEaRue (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 31 May 2016 13:50:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yang.shi@linaro.org, iamjoonsoo.kim@lge.com, mgorman@techsingularity.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use early_pfn_to_nid in register_page_bootmem_info_node
has been removed from the -mm tree.  Its filename was
     mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <yang.shi@linaro.org>
Subject: mm: use early_pfn_to_nid in register_page_bootmem_info_node

register_page_bootmem_info_node() is invoked in mem_init(), so it will be
called before page_alloc_init_late() if CONFIG_DEFERRED_STRUCT_PAGE_INIT
is enabled.  But, pfn_to_nid() depends on memmap which won't be fully
setup until page_alloc_init_late() is done, so replace pfn_to_nid() by
early_pfn_to_nid().

Link: http://lkml.kernel.org/r/1464210007-30930-1-git-send-email-yang.shi@linaro.org
Signed-off-by: Yang Shi <yang.shi@linaro.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory_hotplug.c~mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-early_pfn_to_nid-in-register_page_bootmem_info_node
+++ a/mm/memory_hotplug.c
@@ -300,7 +300,7 @@ void register_page_bootmem_info_node(str
 		 * multiple nodes we check that this pfn does not already
 		 * reside in some other nodes.
 		 */
-		if (pfn_valid(pfn) && (pfn_to_nid(pfn) == node))
+		if (pfn_valid(pfn) && (early_pfn_to_nid(pfn) == node))
 			register_page_bootmem_info_section(pfn);
 	}
 }
_

Patches currently in -mm which might be from yang.shi@linaro.org are

mm-check-the-return-value-of-lookup_page_ext-for-all-call-sites.patch

