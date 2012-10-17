From: akpm@linux-foundation.org
Subject: + mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch added to -mm tree
Date: Wed, 17 Oct 2012 15:03:07 -0700
Message-ID: <20121017220307.A5AA0100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:36904 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2JQWDJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Oct 2012 18:03:09 -0400
Received: by mail-gh0-f202.google.com with SMTP id z15so999320ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 17 Oct 2012 15:03:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kirill.shutemov@linux.intel.com, minchan@kernel.org, rientjes@google.com


The patch titled
     Subject: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD
has been added to the -mm tree.  Its filename is
     mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: use IS_ENABLED(CONFIG_COMPACTION) instead of COMPACTION_BUILD

We don't need custom COMPACTION_BUILD anymore, since we have handy
IS_ENABLED().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    7 -------
 mm/vmscan.c            |    8 ++++----
 2 files changed, 4 insertions(+), 11 deletions(-)

diff -puN include/linux/kernel.h~mm-use-is_enabledconfig_compaction-instead-of-compaction_build include/linux/kernel.h
--- a/include/linux/kernel.h~mm-use-is_enabledconfig_compaction-instead-of-compaction_build
+++ a/include/linux/kernel.h
@@ -687,13 +687,6 @@ static inline void ftrace_dump(enum ftra
 /* Trap pasters of __FUNCTION__ at compile-time */
 #define __FUNCTION__ (__func__)
 
-/* This helps us avoid #ifdef CONFIG_COMPACTION */
-#ifdef CONFIG_COMPACTION
-#define COMPACTION_BUILD 1
-#else
-#define COMPACTION_BUILD 0
-#endif
-
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
diff -puN mm/vmscan.c~mm-use-is_enabledconfig_compaction-instead-of-compaction_build mm/vmscan.c
--- a/mm/vmscan.c~mm-use-is_enabledconfig_compaction-instead-of-compaction_build
+++ a/mm/vmscan.c
@@ -1752,7 +1752,7 @@ out:
 /* Use reclaim/compaction for costly allocs or under memory pressure */
 static bool in_reclaim_compaction(struct scan_control *sc)
 {
-	if (COMPACTION_BUILD && sc->order &&
+	if (IS_ENABLED(CONFIG_COMPACTION) && sc->order &&
 			(sc->order > PAGE_ALLOC_COSTLY_ORDER ||
 			 sc->priority < DEF_PRIORITY - 2))
 		return true;
@@ -2036,7 +2036,7 @@ static bool shrink_zones(struct zonelist
 			if (zone->all_unreclaimable &&
 					sc->priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			if (COMPACTION_BUILD) {
+			if (IS_ENABLED(CONFIG_COMPACTION)) {
 				/*
 				 * If we already have plenty of memory free for
 				 * compaction in this zone, don't free any more.
@@ -2687,7 +2687,7 @@ loop_again:
 			 * Do not reclaim more than needed for compaction.
 			 */
 			testorder = order;
-			if (COMPACTION_BUILD && order &&
+			if (IS_ENABLED(CONFIG_COMPACTION) && order &&
 					compaction_suitable(zone, order) !=
 						COMPACT_SKIPPED)
 				testorder = 0;
@@ -2833,7 +2833,7 @@ out:
 				continue;
 
 			/* Would compaction fail due to lack of free memory? */
-			if (COMPACTION_BUILD &&
+			if (IS_ENABLED(CONFIG_COMPACTION) &&
 			    compaction_suitable(zone, order) == COMPACT_SKIPPED)
 				goto loop_again;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-use-is_enabledconfig_numa-instead-of-numa_build.patch
mm-use-is_enabledconfig_compaction-instead-of-compaction_build.patch

