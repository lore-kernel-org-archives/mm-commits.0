From: akpm@linux-foundation.org
Subject: [merged] page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:18 -0700
Message-ID: <20120322201918.69B74A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:56636 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030610Ab2CVUTT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:19:19 -0400
Received: by mail-gx0-f202.google.com with SMTP id d2so401558ggn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:19:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: consul.kautuk@gmail.com, mel@csn.ul.ie, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: page_alloc: remove unused find_zone_movable_pfns_for_nodes() argument
has been removed from the -mm tree.  Its filename was
     page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kautuk Consul <consul.kautuk@gmail.com>
Subject: page_alloc: remove unused find_zone_movable_pfns_for_nodes() argument

find_zone_movable_pfns_for_nodes() does not use its argument.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument mm/page_alloc.c
--- a/mm/page_alloc.c~page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument
+++ a/mm/page_alloc.c
@@ -4524,7 +4524,7 @@ static unsigned long __init early_calcul
  * memory. When they don't, some nodes will have more kernelcore than
  * others
  */
-static void __init find_zone_movable_pfns_for_nodes(unsigned long *movable_pfn)
+static void __init find_zone_movable_pfns_for_nodes(void)
 {
 	int i, nid;
 	unsigned long usable_startpfn;
@@ -4716,7 +4716,7 @@ void __init free_area_init_nodes(unsigne
 
 	/* Find the PFNs that ZONE_MOVABLE begins at in each node */
 	memset(zone_movable_pfn, 0, sizeof(zone_movable_pfn));
-	find_zone_movable_pfns_for_nodes(zone_movable_pfn);
+	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
 	printk("Zone PFN ranges:\n");
_

Patches currently in -mm which might be from consul.kautuk@gmail.com are

origin.patch
um-kernel-trapc-port-oom-changes-to-handle_page_fault.patch

