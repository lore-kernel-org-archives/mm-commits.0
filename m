From: akpm@linux-foundation.org
Subject: + page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch added to -mm tree
Date: Tue, 13 Mar 2012 14:04:05 -0700
Message-ID: <20120313210406.12C4DA0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:48756 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857Ab2CMVEI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Mar 2012 17:04:08 -0400
Received: by laai8 with SMTP id i8so48023laa.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 14:04:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, mel@csn.ul.ie, rientjes@google.com


The patch titled
     Subject: page_alloc: remove unused find_zone_movable_pfns_for_nodes() argument
has been added to the -mm tree.  Its filename is
     page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: page_alloc: remove unused find_zone_movable_pfns_for_nodes() argument

Patches currently in -mm which might be from consul.kautuk@gmail.com are

rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
page_allocc-remove-add_from_early_node_map.patch
page_alloc-remove-unused-find_zone_movable_pfns_for_nodes-argument.patch

