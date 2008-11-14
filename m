From: akpm@linux-foundation.org
Subject: + memcg-add-force_empty-again-in-reasonable-style.patch added to -mm tree
Date: Fri, 14 Nov 2008 15:04:57 -0800
Message-ID: <200811142304.mAEN4vUX011501@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbYKNXFO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 18:05:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: add force_empty again in reasonable style
has been added to the -mm tree.  Its filename is
     memcg-add-force_empty-again-in-reasonable-style.patch

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
Subject: memcg: add force_empty again in reasonable style
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

After memcg-move-all-accounts-to-parent-at-rmdir.patch, there is no leak
of memory usage and force_empty is removed.  force_empty allows users to
leak account.

This patch adds "force_empty" again, in reasonable style.

memory.force_empty file works when

  #echo 0 (or some) > memory.force_empty
  and have following function.

  1. only works when there are no task in this cgroup.
  2. free all page under this cgroup as much as possible.
  3. page which cannot be freed will be moved up to parent. (locked pages etc.)
  4. Then, memcg will be empty after echo returns.

This is much better behavior than old "force_empty" which just forget
all accounts. This patch also check signal_pending() and above "echo"
can be stopped by "Ctrl-C".

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |   27 ++++++++++++++++---
 mm/memcontrol.c                      |   34 ++++++++++++++++++++++---
 2 files changed, 53 insertions(+), 8 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-add-force_empty-again-in-reasonable-style Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-add-force_empty-again-in-reasonable-style
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
+  Typical usage of this interface is calling this before rmdir().
+  Because rmdir() moves all pages to parent, some out-of-use page caches can be
+  moved to the parent. If you want to avoid that, force_empty will be useful.
+
+
+6. TODO
 
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
diff -puN mm/memcontrol.c~memcg-add-force_empty-again-in-reasonable-style mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-add-force_empty-again-in-reasonable-style
+++ a/mm/memcontrol.c
@@ -1062,7 +1062,7 @@ static int mem_cgroup_force_empty_list(s
  * make mem_cgroup's charge to be 0 if there is no task.
  * This enables deleting this mem_cgroup.
  */
-static int mem_cgroup_force_empty(struct mem_cgroup *mem)
+static int mem_cgroup_force_empty(struct mem_cgroup *mem, bool free_all)
 {
 	int ret;
 	int node, zid, shrink;
@@ -1071,12 +1071,17 @@ static int mem_cgroup_force_empty(struct
 	css_get(&mem->css);
 
 	shrink = 0;
+	/* should free all ? */
+	if (free_all)
+		goto try_to_free;
 move_account:
 	while (mem->res.usage > 0) {
 		ret = -EBUSY;
 		if (atomic_read(&mem->css.cgroup->count) > 0)
 			goto out;
-
+		ret = -EINTR;
+		if (signal_pending(current))
+			goto out;
 		/* This is for making all *used* pages to be on LRU. */
 		lru_add_drain_all();
 		ret = 0;
@@ -1111,14 +1116,24 @@ try_to_free:
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
@@ -1128,6 +1143,12 @@ try_to_free:
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
@@ -1225,6 +1246,7 @@ static int mem_control_stat_show(struct 
 	return 0;
 }
 
+
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1253,6 +1275,10 @@ static struct cftype mem_cgroup_files[] 
 		.name = "stat",
 		.read_map = mem_control_stat_show,
 	},
+	{
+		.name = "force_empty",
+		.trigger = mem_cgroup_force_empty_write,
+	},
 };
 
 static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
@@ -1348,7 +1374,7 @@ static void mem_cgroup_pre_destroy(struc
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
cgroup-fix-potential-deadlock-in-pre_destroy-v2.patch
cgroups-make-cgroup-config-a-submenu.patch
memcg-introduce-charge-commit-cancel-style-of-functions.patch
memcg-introduce-charge-commit-cancel-style-of-functions-fix.patch
memcg-fix-gfp_mask-of-callers-of-charge.patch
memcg-simple-migration-handling.patch
memcg-do-not-recalculate-section-unnecessarily-in-init_section_page_cgroup.patch
memcg-move-all-acccounts-to-parent-at-rmdir.patch
memcg-add-force_empty-again-in-reasonable-style.patch

