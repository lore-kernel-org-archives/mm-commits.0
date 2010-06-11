From: akpm@linux-foundation.org
Subject: + mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch added to -mm tree
Date: Fri, 11 Jun 2010 13:43:51 -0700
Message-ID: <201006112043.o5BKhpv1018668@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38999 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932376Ab0FKUn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jun 2010 16:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: minchan.kim@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, rientjes@google.com


The patch titled
     mm: rename try_set_zone_oom() to try_set_zonelist_oom()
has been added to the -mm tree.  Its filename is
     mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch

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
Subject: mm: rename try_set_zone_oom() to try_set_zonelist_oom()
From: Minchan Kim <minchan.kim@gmail.com>

We have been used naming try_set_zone_oom and clear_zonelist_oom.
The role of functions is to lock of zonelist for preventing parallel
OOM. So clear_zonelist_oom makes sense but try_set_zone_oome is rather
awkward and unmatched with clear_zonelist_oom.

Let's change it with try_set_zonelist_oom.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 +-
 mm/oom_kill.c       |    4 ++--
 mm/page_alloc.c     |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/oom.h~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom include/linux/oom.h
--- a/include/linux/oom.h~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom
+++ a/include/linux/oom.h
@@ -25,7 +25,7 @@ enum oom_constraint {
 	CONSTRAINT_MEMCG,
 };
 
-extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
+extern int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
diff -puN mm/oom_kill.c~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom mm/oom_kill.c
--- a/mm/oom_kill.c~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom
+++ a/mm/oom_kill.c
@@ -549,7 +549,7 @@ EXPORT_SYMBOL_GPL(unregister_oom_notifie
  * if a parallel OOM killing is already taking place that includes a zone in
  * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
  */
-int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_mask)
+int try_set_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_mask)
 {
 	struct zoneref *z;
 	struct zone *zone;
@@ -566,7 +566,7 @@ int try_set_zone_oom(struct zonelist *zo
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		/*
 		 * Lock each zone in the zonelist under zone_scan_lock so a
-		 * parallel invocation of try_set_zone_oom() doesn't succeed
+		 * parallel invocation of try_set_zonelist_oom() doesn't succeed
 		 * when it shouldn't.
 		 */
 		zone_set_flag(zone, ZONE_OOM_LOCKED);
diff -puN mm/page_alloc.c~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom mm/page_alloc.c
--- a/mm/page_alloc.c~mm-rename-try_set_zone_oom-to-try_set_zonelist_oom
+++ a/mm/page_alloc.c
@@ -1738,7 +1738,7 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	struct page *page;
 
 	/* Acquire the OOM killer lock for the zones in zonelist */
-	if (!try_set_zone_oom(zonelist, gfp_mask)) {
+	if (!try_set_zonelist_oom(zonelist, gfp_mask)) {
 		schedule_timeout_uninterruptible(1);
 		return NULL;
 	}
_

Patches currently in -mm which might be from minchan.kim@gmail.com are

mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-track-the-root-oldest-anon_vma-fix.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
mm-use-for_each_online_cpu-in-vmstat.patch

