From: akpm@linux-foundation.org
Subject: + mm-replace-compaction_build-with-is_enabledconfig_compaction.patch added to -mm tree
Date: Wed, 15 Feb 2012 14:50:57 -0800
Message-ID: <20120215225058.23A82A0295@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:36969 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2BOWu7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Feb 2012 17:50:59 -0500
Received: by ghrr17 with SMTP id r17so214091ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Feb 2012 14:50:58 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khlebnikov@openvz.org


The patch titled
     Subject: mm: replace COMPACTION_BUILD with IS_ENABLED(CONFIG_COMPACTION)
has been added to the -mm tree.  Its filename is
     mm-replace-compaction_build-with-is_enabledconfig_compaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: mm: replace COMPACTION_BUILD with IS_ENABLED(CONFIG_COMPACTION)

One more candidate for replacing with IS_ENABLED() macro.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    7 -------
 mm/vmscan.c            |    4 ++--
 2 files changed, 2 insertions(+), 9 deletions(-)

diff -puN include/linux/kernel.h~mm-replace-compaction_build-with-is_enabledconfig_compaction include/linux/kernel.h
--- a/include/linux/kernel.h~mm-replace-compaction_build-with-is_enabledconfig_compaction
+++ a/include/linux/kernel.h
@@ -733,13 +733,6 @@ extern int __build_bug_on_failed;
 #define NUMA_BUILD 0
 #endif
 
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
diff -puN mm/vmscan.c~mm-replace-compaction_build-with-is_enabledconfig_compaction mm/vmscan.c
--- a/mm/vmscan.c~mm-replace-compaction_build-with-is_enabledconfig_compaction
+++ a/mm/vmscan.c
@@ -374,7 +374,7 @@ static void set_reclaim_mode(int priorit
 	 * reclaim/compaction.Depending on the order, we will either set the
 	 * sync mode or just reclaim order-0 pages later.
 	 */
-	if (COMPACTION_BUILD)
+	if (IS_ENABLED(CONFIG_COMPACTION))
 		sc->reclaim_mode = RECLAIM_MODE_COMPACTION;
 	else
 		sc->reclaim_mode = RECLAIM_MODE_LUMPYRECLAIM;
@@ -2259,7 +2259,7 @@ static bool shrink_zones(int priority, s
 				continue;
 			if (zone->all_unreclaimable && priority != DEF_PRIORITY)
 				continue;	/* Let kswapd poll it */
-			if (COMPACTION_BUILD) {
+			if (IS_ENABLED(CONFIG_COMPACTION)) {
 				/*
 				 * If we already have plenty of memory free for
 				 * compaction in this zone, don't free any more.
_
Subject: Subject: mm: replace COMPACTION_BUILD with IS_ENABLED(CONFIG_COMPACTION)

Patches currently in -mm which might be from khlebnikov@openvz.org are

linux-next.patch
mm-add-rss-counters-consistency-check.patch
mm-make-get_mm_counter-static-inline.patch
mm-replace-page_migration-with-is_enabledconfig_migration.patch
mm-replace-compaction_build-with-is_enabledconfig_compaction.patch
mm-replace-numa_build-with-is_enabledconfig_numa.patch
mm-fix-page-faults-detection-in-swap-token-logic.patch
memcg-kill-dead-prev_priority-stubs.patch

