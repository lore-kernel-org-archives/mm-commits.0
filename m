From: akpm@linux-foundation.org
Subject: + oom-fix-zone_scan_mutex-name.patch added to -mm tree
Date: Tue, 28 Oct 2008 14:39:04 -0700
Message-ID: <200810282139.m9SLd4Z9011134@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34204 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752251AbYJ1VjK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Oct 2008 17:39:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com


The patch titled
     oom: fix zone_scan_mutex name
has been added to the -mm tree.  Its filename is
     oom-fix-zone_scan_mutex-name.patch

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
Subject: oom: fix zone_scan_mutex name
From: David Rientjes <rientjes@google.com>

zone_scan_mutex is actually a spinlock, so name it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/oom_kill.c~oom-fix-zone_scan_mutex-name mm/oom_kill.c
--- a/mm/oom_kill.c~oom-fix-zone_scan_mutex-name
+++ a/mm/oom_kill.c
@@ -31,7 +31,7 @@
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
 int sysctl_oom_dump_tasks;
-static DEFINE_SPINLOCK(zone_scan_mutex);
+static DEFINE_SPINLOCK(zone_scan_lock);
 /* #define DEBUG */
 
 /**
@@ -471,7 +471,7 @@ int try_set_zone_oom(struct zonelist *zo
 	struct zone *zone;
 	int ret = 1;
 
-	spin_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		if (zone_is_oom_locked(zone)) {
 			ret = 0;
@@ -481,7 +481,7 @@ int try_set_zone_oom(struct zonelist *zo
 
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		/*
-		 * Lock each zone in the zonelist under zone_scan_mutex so a
+		 * Lock each zone in the zonelist under zone_scan_lock so a
 		 * parallel invocation of try_set_zone_oom() doesn't succeed
 		 * when it shouldn't.
 		 */
@@ -489,7 +489,7 @@ int try_set_zone_oom(struct zonelist *zo
 	}
 
 out:
-	spin_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_lock);
 	return ret;
 }
 
@@ -503,11 +503,11 @@ void clear_zonelist_oom(struct zonelist 
 	struct zoneref *z;
 	struct zone *zone;
 
-	spin_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		zone_clear_flag(zone, ZONE_OOM_LOCKED);
 	}
-	spin_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_lock);
 }
 
 /*
_

Patches currently in -mm which might be from rientjes@google.com are

oom-do-not-dump-task-state-for-non-thread-group-leaders.patch
vmemmap-warn-about-page_structs-with-remote-distance.patch
oom-fix-zone_scan_mutex-name.patch

