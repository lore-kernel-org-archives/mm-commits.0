From: akpm@linux-foundation.org
Subject: - oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:06 -0700
Message-ID: <200710180652.l9I6q6Sh030242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45233 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932510AbXJRHoR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:44:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: convert zone_scan_lock from mutex to spinlock
has been removed from the -mm tree.  Its filename was
     oom-convert-zone_scan_lock-from-mutex-to-spinlock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: convert zone_scan_lock from mutex to spinlock
From: David Rientjes <rientjes@google.com>

There's no reason to sleep in try_set_zone_oom() or clear_zonelist_oom() if
the lock can't be acquired; it will be available soon enough once the zonelist
scanning is done.  All other threads waiting for the OOM killer are also
contingent on the exiting task being able to acquire the lock in
clear_zonelist_oom() so it doesn't make sense to put it to sleep.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~oom-convert-zone_scan_lock-from-mutex-to-spinlock mm/oom_kill.c
--- a/mm/oom_kill.c~oom-convert-zone_scan_lock-from-mutex-to-spinlock
+++ a/mm/oom_kill.c
@@ -28,7 +28,7 @@
 
 int sysctl_panic_on_oom;
 int sysctl_oom_kill_allocating_task;
-static DEFINE_MUTEX(zone_scan_mutex);
+static DEFINE_SPINLOCK(zone_scan_mutex);
 /* #define DEBUG */
 
 /**
@@ -396,7 +396,7 @@ int try_set_zone_oom(struct zonelist *zo
 
 	z = zonelist->zones;
 
-	mutex_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_mutex);
 	do {
 		if (zone_is_oom_locked(*z)) {
 			ret = 0;
@@ -413,7 +413,7 @@ int try_set_zone_oom(struct zonelist *zo
 		zone_set_flag(*z, ZONE_OOM_LOCKED);
 	} while (*(++z) != NULL);
 out:
-	mutex_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_mutex);
 	return ret;
 }
 
@@ -428,11 +428,11 @@ void clear_zonelist_oom(struct zonelist 
 
 	z = zonelist->zones;
 
-	mutex_lock(&zone_scan_mutex);
+	spin_lock(&zone_scan_mutex);
 	do {
 		zone_clear_flag(*z, ZONE_OOM_LOCKED);
 	} while (*(++z) != NULL);
-	mutex_unlock(&zone_scan_mutex);
+	spin_unlock(&zone_scan_mutex);
 }
 
 /**
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memcontrol-move-oom-task-exclusion-to-tasklist-fix.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
