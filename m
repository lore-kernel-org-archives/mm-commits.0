From: akpm@linux-foundation.org
Subject: + mm-page-remove-unused-variable-of-free_area_init_core.patch
 added to -mm tree
Date: Mon, 13 Jul 2015 14:38:00 -0700
Message-ID: <55a42fb8.Qb2oXPCt3nZSSROu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33577 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbGMViA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: weiyang@linux.vnet.ibm.com, guz.fnst@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: remove unused variable in free_area_init_core()
has been added to the -mm tree.  Its filename is
     mm-page-remove-unused-variable-of-free_area_init_core.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-remove-unused-variable-of-free_area_init_core.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-remove-unused-variable-of-free_area_init_core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: mm/page_alloc.c: remove unused variable in free_area_init_core()

commit febd5949e134 ("mm/memory hotplug: init the zone's size when
calculating node totalpages") refines the function free_area_init_core(). 
After doing so, these two parameters are not used anymore.

This patch removes these two parameters.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page-remove-unused-variable-of-free_area_init_core mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page-remove-unused-variable-of-free_area_init_core
+++ a/mm/page_alloc.c
@@ -5273,8 +5273,7 @@ static unsigned long __paginginit calc_m
  *
  * NOTE: pgdat should get zeroed by caller.
  */
-static void __paginginit free_area_init_core(struct pglist_data *pgdat,
-		unsigned long node_start_pfn, unsigned long node_end_pfn)
+static void __paginginit free_area_init_core(struct pglist_data *pgdat)
 {
 	enum zone_type j;
 	int nid = pgdat->node_id;
@@ -5437,7 +5436,7 @@ void __paginginit free_area_init_node(in
 		(unsigned long)pgdat->node_mem_map);
 #endif
 
-	free_area_init_core(pgdat, start_pfn, end_pfn);
+	free_area_init_core(pgdat);
 }
 
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

mm-memblock-warn_on-when-nid-differs-from-overlap-region.patch
mm-page-refine-the-calculation-of-highest-possible-node-id.patch
mm-page-remove-unused-variable-of-free_area_init_core.patch

