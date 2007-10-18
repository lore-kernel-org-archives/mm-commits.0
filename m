From: akpm@linux-foundation.org
Subject: - oom-add-per-zone-locking.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:51:43 -0700
Message-ID: <200710180651.l9I6phEL030211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34177 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761391AbXJRHpk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:45:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, andrea@suse.de, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     oom: add per-zone locking
has been removed from the -mm tree.  Its filename was
     oom-add-per-zone-locking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: oom: add per-zone locking
From: David Rientjes <rientjes@google.com>

OOM killer synchronization should be done with zone granularity so that memory
policy and cpuset allocations may have their corresponding zones locked and
allow parallel kills for other OOM conditions that may exist elsewhere in the
system.  DMA allocations can be targeted at the zone level, which would not be
possible if locking was done in nodes or globally.

Synchronization shall be done with a variation of "trylocks." The goal is to
put the current task to sleep and restart the failed allocation attempt later
if the trylock fails.  Otherwise, the OOM killer is invoked.

Each zone in the zonelist that __alloc_pages() was called with is checked for
the newly-introduced ZONE_OOM_LOCKED flag.  If any zone has this flag present,
the "trylock" to serialize the OOM killer fails and returns zero.  Otherwise,
all the zones have ZONE_OOM_LOCKED set and the try_set_zone_oom() function
returns non-zero.

Cc: Andrea Arcangeli <andrea@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    5 +++
 include/linux/oom.h    |    3 ++
 mm/oom_kill.c          |   52 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)

diff -puN include/linux/mmzone.h~oom-add-per-zone-locking include/linux/mmzone.h
--- a/include/linux/mmzone.h~oom-add-per-zone-locking
+++ a/include/linux/mmzone.h
@@ -344,6 +344,7 @@ struct zone {
 typedef enum {
 	ZONE_ALL_UNRECLAIMABLE,		/* all pages pinned */
 	ZONE_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	ZONE_OOM_LOCKED,		/* zone is in OOM killer zonelist */
 } zone_flags_t;
 
 static inline void zone_set_flag(struct zone *zone, zone_flags_t flag)
@@ -363,6 +364,10 @@ static inline int zone_is_reclaim_locked
 {
 	return test_bit(ZONE_RECLAIM_LOCKED, &zone->flags);
 }
+static inline int zone_is_oom_locked(const struct zone *zone)
+{
+	return test_bit(ZONE_OOM_LOCKED, &zone->flags);
+}
 
 /*
  * The "priority" of VM scanning is how much of the queues we will scan in one
diff -puN include/linux/oom.h~oom-add-per-zone-locking include/linux/oom.h
--- a/include/linux/oom.h~oom-add-per-zone-locking
+++ a/include/linux/oom.h
@@ -20,6 +20,9 @@ enum oom_constraint {
 	CONSTRAINT_MEMORY_POLICY,
 };
 
+extern int try_set_zone_oom(struct zonelist *zonelist);
+extern void clear_zonelist_oom(struct zonelist *zonelist);
+
 extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
diff -puN mm/oom_kill.c~oom-add-per-zone-locking mm/oom_kill.c
--- a/mm/oom_kill.c~oom-add-per-zone-locking
+++ a/mm/oom_kill.c
@@ -27,6 +27,7 @@
 #include <linux/notifier.h>
 
 int sysctl_panic_on_oom;
+static DEFINE_MUTEX(zone_scan_mutex);
 /* #define DEBUG */
 
 /**
@@ -374,6 +375,57 @@ int unregister_oom_notifier(struct notif
 }
 EXPORT_SYMBOL_GPL(unregister_oom_notifier);
 
+/*
+ * Try to acquire the OOM killer lock for the zones in zonelist.  Returns zero
+ * if a parallel OOM killing is already taking place that includes a zone in
+ * the zonelist.  Otherwise, locks all zones in the zonelist and returns 1.
+ */
+int try_set_zone_oom(struct zonelist *zonelist)
+{
+	struct zone **z;
+	int ret = 1;
+
+	z = zonelist->zones;
+
+	mutex_lock(&zone_scan_mutex);
+	do {
+		if (zone_is_oom_locked(*z)) {
+			ret = 0;
+			goto out;
+		}
+	} while (*(++z) != NULL);
+
+	/*
+	 * Lock each zone in the zonelist under zone_scan_mutex so a parallel
+	 * invocation of try_set_zone_oom() doesn't succeed when it shouldn't.
+	 */
+	z = zonelist->zones;
+	do {
+		zone_set_flag(*z, ZONE_OOM_LOCKED);
+	} while (*(++z) != NULL);
+out:
+	mutex_unlock(&zone_scan_mutex);
+	return ret;
+}
+
+/*
+ * Clears the ZONE_OOM_LOCKED flag for all zones in the zonelist so that failed
+ * allocation attempts with zonelists containing them may now recall the OOM
+ * killer, if necessary.
+ */
+void clear_zonelist_oom(struct zonelist *zonelist)
+{
+	struct zone **z;
+
+	z = zonelist->zones;
+
+	mutex_lock(&zone_scan_mutex);
+	do {
+		zone_clear_flag(*z, ZONE_OOM_LOCKED);
+	} while (*(++z) != NULL);
+	mutex_unlock(&zone_scan_mutex);
+}
+
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  *
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
