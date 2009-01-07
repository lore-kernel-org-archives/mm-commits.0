From: akpm@linux-foundation.org
Subject: - oom-fix-zone_scan_mutex-name.patch removed from -mm tree
Date: Wed, 07 Jan 2009 14:11:20 -0800
Message-ID: <200901072211.n07MBKAK011581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36662 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbZAGWL1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Jan 2009 17:11:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, kosaki.motohiro@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     oom: fix zone_scan_mutex name
has been removed from the -mm tree.  Its filename was
     oom-fix-zone_scan_mutex-name.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: oom: fix zone_scan_mutex name
From: David Rientjes <rientjes@google.com>

zone_scan_mutex is actually a spinlock, so name it appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
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
@@ -470,7 +470,7 @@ int try_set_zone_oom(struct zonelist *zo
 	struct zone *zone;
 	int ret = 1;
 
-	spin_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_lock);
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		if (zone_is_oom_locked(zone)) {
 			ret = 0;
@@ -480,7 +480,7 @@ int try_set_zone_oom(struct zonelist *zo
 
 	for_each_zone_zonelist(zone, z, zonelist, gfp_zone(gfp_mask)) {
 		/*
-		 * Lock each zone in the zonelist under zone_scan_mutex so a
+		 * Lock each zone in the zonelist under zone_scan_lock so a
 		 * parallel invocation of try_set_zone_oom() doesn't succeed
 		 * when it shouldn't.
 		 */
@@ -488,7 +488,7 @@ int try_set_zone_oom(struct zonelist *zo
 	}
 
 out:
-	spin_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_lock);
 	return ret;
 }
 
@@ -502,11 +502,11 @@ void clear_zonelist_oom(struct zonelist 
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

origin.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch
memory-cgroup-hierarchy-documentation-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4.patch
memory-cgroup-resource-counters-for-hierarchy-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4.patch
memory-cgroup-hierarchical-reclaim-v4-checkpatch-fixes.patch
memory-cgroup-hierarchical-reclaim-v4-fix-for-hierarchical-reclaim.patch
memory-cgroup-hierarchy-feature-selector-v4.patch
memory-cgroup-hierarchy-feature-selector-v4-fix.patch

