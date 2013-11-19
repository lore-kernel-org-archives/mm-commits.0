From: akpm@linux-foundation.org
Subject: [to-be-updated]
 mm-memcg-add-memoryoom_control-notification-for-system-oom.patch removed
 from -mm tree
Date: Tue, 19 Nov 2013 13:38:14 -0800
Message-ID: <528bda46.YlEwHwHdykzBNvfr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41284 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSViP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Nov 2013 16:38:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, rientjes@google.com

Subject: [to-be-updated] mm-memcg-add-memoryoom_control-notification-for-system-oom.patch removed from -mm tree
To: rientjes@google.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 19 Nov 2013 13:38:14 -0800


The patch titled
     Subject: mm, memcg: add memory.oom_control notification for system oom
has been removed from the -mm tree.  Its filename was
     mm-memcg-add-memoryoom_control-notification-for-system-oom.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, memcg: add memory.oom_control notification for system oom

A subset of applications that wait on memory.oom_control don't disable the
oom killer for that memcg and simply log or cleanup after the kernel oom
killer kills a process to free memory.

We need the ability to do this for system oom conditions as well, i.e. 
when the system is depleted of all memory and must kill a process.  For
convenience, this can use memcg since oom notifiers are already present.

When a userspace process waits on the root memcg's memory.oom_control, it
will wake up anytime there is a system oom condition so that it can log
the event, including what process was killed and the stack, or cleanup
after the kernel oom killer has killed something.

This is a special case of oom notifiers since it doesn't subsequently
notify all memcgs under the root memcg (all memcgs on the system).  We
don't want to trigger those oom handlers which are set aside specifically
for true memcg oom notifications that disable their own oom killers to
enforce their own oom policy, for example.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/memory.txt |   11 ++++++-----
 include/linux/memcontrol.h       |    5 +++++
 mm/memcontrol.c                  |    9 +++++++++
 mm/oom_kill.c                    |    4 ++++
 4 files changed, 24 insertions(+), 5 deletions(-)

diff -puN Documentation/cgroups/memory.txt~mm-memcg-add-memoryoom_control-notification-for-system-oom Documentation/cgroups/memory.txt
--- a/Documentation/cgroups/memory.txt~mm-memcg-add-memoryoom_control-notification-for-system-oom
+++ a/Documentation/cgroups/memory.txt
@@ -743,18 +743,19 @@ delivery and gets notification when OOM
 
 To register a notifier, an application must:
  - create an eventfd using eventfd(2)
- - open memory.oom_control file
+ - open memory.oom_control file for reading
  - write string like "<event_fd> <fd of memory.oom_control>" to
    cgroup.event_control
 
-The application will be notified through eventfd when OOM happens.
-OOM notification doesn't work for the root cgroup.
+The application will be notified through eventfd when OOM happens, including
+on system oom when used with the root memcg.
 
 You can disable the OOM-killer by writing "1" to memory.oom_control file, as:
 
-	#echo 1 > memory.oom_control
+	# echo 1 > memory.oom_control
 
-This operation is only allowed to the top cgroup of a sub-hierarchy.
+This operation is only allowed to the top cgroup of a sub-hierarchy and does
+not include the root memcg.
 If OOM-killer is disabled, tasks under cgroup will hang/sleep
 in memory cgroup's OOM-waitqueue when they request accountable memory.
 
diff -puN include/linux/memcontrol.h~mm-memcg-add-memoryoom_control-notification-for-system-oom include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~mm-memcg-add-memoryoom_control-notification-for-system-oom
+++ a/include/linux/memcontrol.h
@@ -155,6 +155,7 @@ static inline bool task_in_memcg_oom(str
 }
 
 bool mem_cgroup_oom_synchronize(bool wait);
+void mem_cgroup_root_oom_notify(void);
 
 #ifdef CONFIG_MEMCG_SWAP
 extern int do_swap_account;
@@ -397,6 +398,10 @@ static inline bool mem_cgroup_oom_synchr
 	return false;
 }
 
+static inline void mem_cgroup_root_oom_notify(void)
+{
+}
+
 static inline void mem_cgroup_inc_page_stat(struct page *page,
 					    enum mem_cgroup_stat_index idx)
 {
diff -puN mm/memcontrol.c~mm-memcg-add-memoryoom_control-notification-for-system-oom mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-add-memoryoom_control-notification-for-system-oom
+++ a/mm/memcontrol.c
@@ -5648,6 +5648,15 @@ static void mem_cgroup_oom_notify(struct
 		mem_cgroup_oom_notify_cb(iter);
 }
 
+/*
+ * Notify any process waiting on the root memcg's memory.oom_control, but do not
+ * notify any child memcgs to avoid triggering their per-memcg oom handlers.
+ */
+void mem_cgroup_root_oom_notify(void)
+{
+	mem_cgroup_oom_notify_cb(root_mem_cgroup);
+}
+
 static int mem_cgroup_usage_register_event(struct cgroup_subsys_state *css,
 	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
 {
diff -puN mm/oom_kill.c~mm-memcg-add-memoryoom_control-notification-for-system-oom mm/oom_kill.c
--- a/mm/oom_kill.c~mm-memcg-add-memoryoom_control-notification-for-system-oom
+++ a/mm/oom_kill.c
@@ -632,6 +632,10 @@ void out_of_memory(struct zonelist *zone
 		return;
 	}
 
+	/* Avoid waking up processes for oom kills triggered by sysrq */
+	if (!force_kill)
+		mem_cgroup_root_oom_notify();
+
 	/*
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-srat-use-numa_no_node.patch
mm-memcg-avoid-oom-notification-when-current-needs-access-to-memory-reserves.patch

