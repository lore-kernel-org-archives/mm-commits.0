From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-remove-unused-variable-of-free_area_init_core.patch removed from
 -mm tree
Date: Wed, 09 Sep 2015 12:43:43 -0700
Message-ID: <55f08bef.gv+jplIWc/kCcE0M%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38852 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbbIITnn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:43:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, guz.fnst@cn.fujitsu.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused variable in free_area_init_core()
has been removed from the -mm tree.  Its filename was
     mm-page-remove-unused-variable-of-free_area_init_core.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: remove unused variable in free_area_init_core()

commit febd5949e134 ("mm/memory hotplug: init the zone's size when
calculating node totalpages") refines the function free_area_init_core(). 
After doing so, these two parameters are not used anymore.

This patch removes these two parameters.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page-remove-unused-variable-of-free_area_init_core mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-remove-unused-variable-of-free_area_init_core
+++ a/mm/page_alloc.c
@@ -5303,8 +5303,7 @@ static unsigned long __paginginit calc_m
  *
  * NOTE: pgdat should get zeroed by caller.
  */
-static void __paginginit free_area_init_core(struct pglist_data *pgdat,
-		unsigned long node_start_pfn, unsigned long node_end_pfn)
+static void __paginginit free_area_init_core(struct pglist_data *pgdat)
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
@@ -5467,7 +5466,7 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, start_pfn, end_pfn);
+	free_area_init_core(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are


