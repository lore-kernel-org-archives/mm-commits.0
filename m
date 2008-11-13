From: akpm@linux-foundation.org
Subject: + cpuset-update-top-cpusets-mems-after-adding-a-node.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:01:05 -0800
Message-ID: <200811130001.mAD015DZ006939@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40886 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206AbYKMABS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:01:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, menage@google.com, rientjes@google.com, y-goto@jp.fujitsu.com


The patch titled
     cpuset: update top cpuset's mems after adding a node
has been added to the -mm tree.  Its filename is
     cpuset-update-top-cpusets-mems-after-adding-a-node.patch

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
Subject: cpuset: update top cpuset's mems after adding a node
From: Miao Xie <miaox@cn.fujitsu.com>

After adding a node into the machine, top cpuset's mems isn't updated.

By reviewing the code, we found that the update function

  cpuset_track_online_nodes()

was invoked after node_states[N_ONLINE] changes.  It is wrong because
N_ONLINE just means node has pgdat, and if node has/added memory, we use
N_HIGH_MEMORY.  So, We should invoke the update function after
node_states[N_HIGH_MEMORY] changes, just like its commit says.

This patch fixes it.  And we use notifier of memory hotplug instead of
direct calling of cpuset_track_online_nodes().

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Paul Menage <menage@google.com
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpuset.h |    4 ----
 kernel/cpuset.c        |   19 ++++++++++++++++---
 mm/memory_hotplug.c    |    3 ---
 3 files changed, 16 insertions(+), 10 deletions(-)

diff -puN include/linux/cpuset.h~cpuset-update-top-cpusets-mems-after-adding-a-node include/linux/cpuset.h
--- a/include/linux/cpuset.h~cpuset-update-top-cpusets-mems-after-adding-a-node
+++ a/include/linux/cpuset.h
@@ -74,8 +74,6 @@ static inline int cpuset_do_slab_mem_spr
 	return current->flags & PF_SPREAD_SLAB;
 }
 
-extern void cpuset_track_online_nodes(void);
-
 extern int current_cpuset_is_being_rebound(void);
 
 extern void rebuild_sched_domains(void);
@@ -151,8 +149,6 @@ static inline int cpuset_do_slab_mem_spr
 	return 0;
 }
 
-static inline void cpuset_track_online_nodes(void) {}
-
 static inline int current_cpuset_is_being_rebound(void)
 {
 	return 0;
diff -puN kernel/cpuset.c~cpuset-update-top-cpusets-mems-after-adding-a-node kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-update-top-cpusets-mems-after-adding-a-node
+++ a/kernel/cpuset.c
@@ -36,6 +36,7 @@
 #include <linux/list.h>
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
+#include <linux/memory.h>
 #include <linux/module.h>
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -2011,12 +2012,23 @@ static int cpuset_track_online_cpus(stru
  * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
  * See also the previous routine cpuset_track_online_cpus().
  */
-void cpuset_track_online_nodes(void)
+static int cpuset_track_online_nodes(struct notifier_block *self,
+				unsigned long action, void *arg)
 {
 	cgroup_lock();
-	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
-	scan_for_empty_cpusets(&top_cpuset);
+	switch (action) {
+	case MEM_ONLINE:
+		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+		break;
+	case MEM_OFFLINE:
+		top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
+		scan_for_empty_cpusets(&top_cpuset);
+		break;
+	default:
+		break;
+	}
 	cgroup_unlock();
+	return NOTIFY_OK;
 }
 #endif
 
@@ -2032,6 +2044,7 @@ void __init cpuset_init_smp(void)
 	top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
 
 	hotcpu_notifier(cpuset_track_online_cpus, 0);
+	hotplug_memory_notifier(cpuset_track_online_nodes, 10);
 }
 
 /**
diff -puN mm/memory_hotplug.c~cpuset-update-top-cpusets-mems-after-adding-a-node mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~cpuset-update-top-cpusets-mems-after-adding-a-node
+++ a/mm/memory_hotplug.c
@@ -22,7 +22,6 @@
 #include <linux/highmem.h>
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
-#include <linux/cpuset.h>
 #include <linux/delay.h>
 #include <linux/migrate.h>
 #include <linux/page-isolation.h>
@@ -498,8 +497,6 @@ int add_memory(int nid, u64 start, u64 s
 	/* we online node here. we can't roll back from here. */
 	node_set_online(nid);
 
-	cpuset_track_online_nodes();
