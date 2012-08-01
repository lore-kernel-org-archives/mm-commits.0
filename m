From: akpm@linux-foundation.org
Subject: [merged] mm-buddy-cleanup-on-should_fail_alloc_page.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:11:56 -0700
Message-ID: <20120801201156.B4B031E0043@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:41190 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2HAUL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:11:57 -0400
Received: by mail-ob0-f202.google.com with SMTP id wc20so5410915obb.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:11:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shangw@linux.vnet.ibm.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/buddy: cleanup on should_fail_alloc_page
has been removed from the -mm tree.  Its filename was
     mm-buddy-cleanup-on-should_fail_alloc_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: mm/buddy: cleanup on should_fail_alloc_page

Currently, function should_fail() has "bool" for its return value, so it's
reasonable to change the return value of function should_fail_alloc_page()
into "bool" as well.

The patch does cleanup on function should_fail_alloc_page() to have "bool"
for its return value.

Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN mm/page_alloc.c~mm-buddy-cleanup-on-should_fail_alloc_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-buddy-cleanup-on-should_fail_alloc_page
+++ a/mm/page_alloc.c
@@ -1529,16 +1529,16 @@ static int __init setup_fail_page_alloc(
 }
 __setup("fail_page_alloc=", setup_fail_page_alloc);
 
-static int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	if (order < fail_page_alloc.min_order)
-		return 0;
+		return false;
 	if (gfp_mask & __GFP_NOFAIL)
-		return 0;
+		return false;
 	if (fail_page_alloc.ignore_gfp_highmem && (gfp_mask & __GFP_HIGHMEM))
-		return 0;
+		return false;
 	if (fail_page_alloc.ignore_gfp_wait && (gfp_mask & __GFP_WAIT))
-		return 0;
+		return false;
 
 	return should_fail(&fail_page_alloc.attr, 1 << order);
 }
@@ -1578,9 +1578,9 @@ late_initcall(fail_page_alloc_debugfs);
 
 #else /* CONFIG_FAIL_PAGE_ALLOC */
 
-static inline int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static inline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
_

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

origin.patch
mm-slab-remove-duplicate-check.patch

