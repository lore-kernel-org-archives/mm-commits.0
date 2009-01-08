From: akpm@linux-foundation.org
Subject: - memcg-new-force_empty-to-free-pages-under-group.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:48:14 -0800
Message-ID: <200901082248.n08MmEtu027596@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763510AbZAHWvO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:51:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: new force_empty to free pages under group
has been removed from the -mm tree.  Its filename was
     memcg-new-force_empty-to-free-pages-under-group.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: new force_empty to free pages under group
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

By memcg-move-all-accounts-to-parent-at-rmdir.patch, there is no leak of
memory usage and force_empty is removed.

This patch adds "force_empty" again, in reasonable manner.

memory.force_empty file works when

  #echo 0 (or some) > memory.force_empty
  and have following function.

  1. only works when there are no task in this cgroup.
  2. free all page under this cgroup as much as possible.
  3. page which cannot be freed will be moved up to parent.
  4. Then, memcg will be empty after above echo returns.

This is much better behavior than old "force_empty" which just forget
all accounts. This patch also check signal_pending() and above "echo"
can be stopped by "Ctrl-C".

[akpm@linux-foundation.org: cleanup]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   27 ++++++++++++++--
 mm/memcontrol.c                      |   41 ++++++++++++++++++++-----
 2 files changed, 57 insertions(+), 11 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-new-force_empty-to-free-pages-under-group Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-new-force_empty-to-free-pages-under-group
+++ a/Documentation/controllers/memory.txt
@@ -237,11 +237,30 @@ reclaimed.
 A cgroup can be removed by rmdir, but as discussed in sections 4.1 and 4.2, a
 cgroup might have some charge associated with it, even though all
 tasks have migrated away from it.
-Such charges are moved to its parent as much as possible and freed if parent
-is full. Both of RSS and CACHES are moved to parent.
-If both of them are busy, rmdir() returns -EBUSY.
+Such charges are freed(at default) or moved to its parent. When moved,
+both of RSS and CACHES are moved to parent.
+If both of them are busy, rmdir() returns -EBUSY. See 5.1 Also.
 
-5. TODO
+5. Misc. interfaces.
+
+5.1 force_empty
+  memory.force_empty interface is provided to make cgroup's memory usage empty.
+  You can use this interface only when the cgroup has no tasks.
+  When writing anything to this
+
+  # echo 0 > memory.force_empty
+
+  Almost all pages tracked by this memcg will be unmapped and freed. Some of
+  pages cannot be freed because it's locked or in-use. Such pages are moved
+  to parent and this cgroup will be empty. But this may return -EBUSY in
+  some too busy case.
+
+  Typical use case of this interface is that calling this before rmdir().
+  Because rmdir() moves all pages to parent, some out-of-use page caches can be
+  moved to the parent. If you want to avoid that, force_empty will be useful.
+
+
+6. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
diff -puN mm/memcontrol.c~memcg-new-force_empty-to-free-pages-under-group mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-new-force_empty-to-free-pages-under-group
+++ a/mm/memcontrol.c
@@ -1062,21 +1062,27 @@ static int mem_cgroup_force_empty_list(s
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-static int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool free_all)
 {
 	int ret;
 	int node, zid, shrink;
 	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
+	struct cgroup *cgrp = mem->css.cgroup;
 
 	css_get(&mem->css);
 
 	shrink = 0;
+	/* should free all ? */
+	if (free_all)
+		goto try_to_free;
 move_account:
 	while (mem->res.usage > 0) {
 		ret = -EBUSY;
-		if (atomic_read(&mem->css.cgroup->count) > 0)
+		if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children))
+			goto out;
+		ret = -EINTR;
+		if (signal_pending(current))
 			goto out;
-
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		ret = 0;
@@ -1106,19 +1112,29 @@ out:
 	return ret;
 
 try_to_free:
-	/* returns EBUSY if we come here twice. */
-	if (shrink)  {
+	/* returns EBUSY if there is a task or if we come here twice. */
+	if (cgroup_task_count(cgrp) || !list_empty(&cgrp->children) || shrink) {
 		ret = -EBUSY;
 		goto out;
 	}
+	/* we call try-to-free pages for make this cgroup empty */
+	lru_add_drain_all();
 	/* try to free all pages in this cgroup */
 	shrink = 1;
 	while (nr_retries && mem->res.usage > 0) {
 		int progress;
+
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			goto out;
+		}
 		progress = try_to_free_mem_cgroup_pages(mem,
 						  GFP_HIGHUSER_MOVABLE);
-		if (!progress)
+		if (!progress) {
 			nr_retries--;
+			/* maybe some writeback is necessary */
+			congestion_wait(WRITE, HZ/10);
+		}
 
 	}
 	/* try move_account...there may be some *locked* pages. */
@@ -1128,6 +1144,12 @@ try_to_free:
 	goto out;
 }
 
+int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
+{
+	return mem_cgroup_force_empty(mem_cgroup_from_cont(cont), true);
+}
+
+
 static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
@@ -1225,6 +1247,7 @@ static int mem_control_stat_show(struct 
 	return 0;
 }
 
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1253,6 +1276,10 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+	{
+		.name = "force_empty",
+		.trigger = mem_cgroup_force_empty_write,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1350,7 +1377,7 @@ static void mem_cgroup_pre_destroy(struc
 					struct cgroup *cont)
 {
 	struct mem_cgroup *mem = mem_cgroup_from_cont(cont);
-	mem_cgroup_force_empty(mem);
+	mem_cgroup_force_empty(mem, false);
 }
 
 static void mem_cgroup_destroy(struct cgroup_subsys *ss,
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

