From: akpm@linux-foundation.org
Subject: + mm-buddy-cleanup-on-should_fail_alloc_page.patch added to -mm tree
Date: Mon, 11 Jun 2012 14:35:03 -0700
Message-ID: <20120611213503.AACC4A011A@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:45098 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab2FKVfF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 11 Jun 2012 17:35:05 -0400
Received: by wibhn6 with SMTP id hn6so235723wib.1
        for <mm-commits@vger.kernel.org>; Mon, 11 Jun 2012 14:35:04 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shangw@linux.vnet.ibm.com, rientjes@google.com


The patch titled
     Subject: mm/buddy: cleanup on should_fail_alloc_page
has been added to the -mm tree.  Its filename is
     mm-buddy-cleanup-on-should_fail_alloc_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1527,16 +1527,16 @@ static int __init setup_fail_page_alloc(
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
@@ -1576,9 +1576,9 @@ late_initcall(fail_page_alloc_debugfs);
 
 #else /* CONFIG_FAIL_PAGE_ALLOC */
 
-static inline int should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+static inline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
-	return 0;
+	return false;
 }
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
_
Subject: Subject: mm/buddy: cleanup on should_fail_alloc_page

Patches currently in -mm which might be from shangw@linux.vnet.ibm.com are

mm-slab-remove-duplicate-check.patch
mm-buddy-cleanup-on-should_fail_alloc_page.patch

