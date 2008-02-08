From: akpm@linux-foundation.org
Subject: - per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch removed from -mm tree
Date: Fri, 08 Feb 2008 00:04:51 -0800
Message-ID: <200802080804.m1884WwN014268@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52406 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760730AbYBHIbR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 03:31:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, a.p.zijlstra@chello.nl, balbir@linux.vnet.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, menage@google.com, nickpiggin@yahoo.com.au


The patch titled
     per-zone and reclaim enhancements for memory controller: remember reclaim priority in memory cgroup
has been removed from the -mm tree.  Its filename was
     per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: per-zone and reclaim enhancements for memory controller: remember reclaim priority in memory cgroup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Functions to remember reclaim priority per cgroup (as zone->prev_priority)

[akpm@linux-foundation.org: build fixes]
[akpm@linux-foundation.org: more build fixes]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   20 ++++++++++++++++++++
 mm/memcontrol.c            |   20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff -puN include/linux/memcontrol.h~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup
+++ a/include/linux/memcontrol.h
@@ -70,6 +70,11 @@ extern void mem_cgroup_page_migration(st
 extern int mem_cgroup_calc_mapped_ratio(struct mem_cgroup *mem);
 extern long mem_cgroup_reclaim_imbalance(struct mem_cgroup *mem);
 
+extern int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem);
+extern void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
+							int priority);
+extern void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
+							int priority);
 
 
 #else /* CONFIG_CGROUP_MEM_CONT */
@@ -153,6 +158,21 @@ static inline int mem_cgroup_reclaim_imb
 	return 0;
 }
 
+static inline int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
+{
+	return 0;
+}
+
+static inline void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem,
+						int priority)
+{
+}
+
+static inline void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem,
+						int priority)
+{
+}
+
 #endif /* CONFIG_CGROUP_MEM_CONT */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff -puN mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup
+++ a/mm/memcontrol.c
@@ -132,6 +132,7 @@ struct mem_cgroup {
 	 */
 	spinlock_t lru_lock;
 	unsigned long control_type;	/* control RSS or RSS+Pagecache */
+	int	prev_priority;	/* for recording reclaim priority */
 	/*
 	 * statistics.
 	 */
@@ -451,6 +452,25 @@ long mem_cgroup_reclaim_imbalance(struct
 	return (long) (active / (inactive + 1));
 }
 
+/*
+ * prev_priority control...this will be used in memory reclaim path.
+ */
+int mem_cgroup_get_reclaim_priority(struct mem_cgroup *mem)
+{
+	return mem->prev_priority;
+}
+
+void mem_cgroup_note_reclaim_priority(struct mem_cgroup *mem, int priority)
+{
+	if (priority < mem->prev_priority)
+		mem->prev_priority = priority;
+}
+
+void mem_cgroup_record_reclaim_priority(struct mem_cgroup *mem, int priority)
+{
+	mem->prev_priority = priority;
+}
+
 unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
enable-hotplug-memory-remove-for-ppc64.patch
add-arch-specific-walk_memory_remove-for-ppc64.patch
memory-hotplug-add-removable-to-sysfs-to-show-memblock-removability.patch
