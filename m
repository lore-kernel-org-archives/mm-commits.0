From: akpm@google.com
Subject: + mm-compaction-make-compact_zone_order-static.patch added to -mm tree
Date: Wed, 21 Sep 2011 15:09:35 -0700
Message-ID: <201109212209.p8LM9Z20001448@hpaq1.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47816 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1IUWJm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2011 18:09:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kyungmin.park@samsung.com, rientjes@google.com


The patch titled
     Subject: mm: compaction: make compact_zone_order() static
has been added to the -mm tree.  Its filename is
     mm-compaction-make-compact_zone_order-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Kyungmin Park <kyungmin.park@samsung.com>
Subject: mm: compaction: make compact_zone_order() static

There's no compact_zone_order() user outside file scope, so make it static.

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@google.com>
---

 include/linux/compaction.h |    8 --------
 mm/compaction.c            |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN include/linux/compaction.h~mm-compaction-make-compact_zone_order-static include/linux/compaction.h
--- a/include/linux/compaction.h~mm-compaction-make-compact_zone_order-static
+++ a/include/linux/compaction.h
@@ -24,8 +24,6 @@ extern unsigned long try_to_compact_page
 			int order, gfp_t gfp_mask, nodemask_t *mask,
 			bool sync);
 extern unsigned long compaction_suitable(struct zone *zone, int order);
-extern unsigned long compact_zone_order(struct zone *zone, int order,
-					gfp_t gfp_mask, bool sync);
 
 /* Do not skip compaction more than 64 times */
 #define COMPACT_MAX_DEFER_SHIFT 6
@@ -69,12 +67,6 @@ static inline unsigned long compaction_s
 	return COMPACT_SKIPPED;
 }
 
-static inline unsigned long compact_zone_order(struct zone *zone, int order,
-					       gfp_t gfp_mask, bool sync)
-{
-	return COMPACT_CONTINUE;
-}
-
 static inline void defer_compaction(struct zone *zone)
 {
 }
diff -puN mm/compaction.c~mm-compaction-make-compact_zone_order-static mm/compaction.c
--- a/mm/compaction.c~mm-compaction-make-compact_zone_order-static
+++ a/mm/compaction.c
@@ -587,7 +587,7 @@ out:
 	return ret;
 }
 
-unsigned long compact_zone_order(struct zone *zone,
+static unsigned long compact_zone_order(struct zone *zone,
 				 int order, gfp_t gfp_mask,
 				 bool sync)
 {
_
Subject: Subject: mm: compaction: make compact_zone_order() static

Patches currently in -mm which might be from kyungmin.park@samsung.com are

origin.patch
linux-next.patch
mm-compaction-make-compact_zone_order-static.patch
driver-misc-fsa9480c-fix-potential-null-pointer-dereference.patch

