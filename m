From: akpm@linux-foundation.org
Subject: + page_allocc-remove-add_from_early_node_map.patch added to -mm tree
Date: Tue, 13 Mar 2012 14:04:03 -0700
Message-ID: <20120313210404.42CF5A0186@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gx0-f202.google.com ([209.85.161.202]:42088 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754625Ab2CMVEF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 13 Mar 2012 17:04:05 -0400
Received: by ggnd2 with SMTP id d2so187152ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 13 Mar 2012 14:04:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: consul.kautuk@gmail.com, rientjes@google.com


The patch titled
     Subject: page_alloc.c: remove add_from_early_node_map()
has been added to the -mm tree.  Its filename is
     page_allocc-remove-add_from_early_node_map.patch

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
Subject: page_alloc.c: remove add_from_early_node_map()

add_from_early_node_map() is unused.

Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/page_alloc.c    |   12 ------------
 2 files changed, 14 deletions(-)

diff -puN include/linux/mm.h~page_allocc-remove-add_from_early_node_map include/linux/mm.h
--- a/include/linux/mm.h~page_allocc-remove-add_from_early_node_map
+++ a/include/linux/mm.h
@@ -1296,8 +1296,6 @@ extern void get_pfn_range_for_nid(unsign
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
-int add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid);
 extern void sparse_memory_present_with_active_regions(int nid);
 
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
diff -puN mm/page_alloc.c~page_allocc-remove-add_from_early_node_map mm/page_alloc.c
--- a/mm/page_alloc.c~page_allocc-remove-add_from_early_node_map
+++ a/mm/page_alloc.c
@@ -3940,18 +3940,6 @@ void __init free_bootmem_with_active_reg
 	}
 }
 
-int __init add_from_early_node_map(struct range *range, int az,
-				   int nr_range, int nid)
-{
-	unsigned long start_pfn, end_pfn;
-	int i;
-
-	/* need to go over early_node_map to find out good range for node */
-	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL)
-		nr_range = add_range(range, az, nr_range, start_pfn, end_pfn);
-	return nr_range;
-}
