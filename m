From: akpm@linux-foundation.org
Subject: +
 mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch added
 to -mm tree
Date: Thu, 30 Nov 2017 12:39:45 -0800
Message-ID: <5a206c91.qdvSBA/Oj/wWyPrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751394AbdK3Ujq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:39:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guro@fb.com, hannes@cmpxchg.org, mhocko@kernel.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, tj@kernel.org, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: implement mem_cgroup_scan_tasks() for the root memory cgroup
has been added to the -mm tree.  Its filename is
     mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Gushchin <guro@fb.com>
Subject: mm: implement mem_cgroup_scan_tasks() for the root memory cgroup

Implement mem_cgroup_scan_tasks() functionality for the root memory cgroup
to use this function for looking for a OOM victim task in the root memory
cgroup by the cgroup-ware OOM killer.

The root memory cgroup is treated as a leaf cgroup, so only tasks which
are directly belonging to the root cgroup are iterated over.

This patch doesn't introduce any functional change as
mem_cgroup_scan_tasks() is never called for the root memcg.  This is
preparatory work for the cgroup-aware OOM killer, which will use this
function to iterate over tasks belonging to the root memcg.

Link: http://lkml.kernel.org/r/20171130152824.1591-3-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup mm/memcontrol.c
--- a/mm/memcontrol.c~mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup
+++ a/mm/memcontrol.c
@@ -888,7 +888,8 @@ static void invalidate_reclaim_iterators
  * value, the function breaks the iteration loop and returns the value.
  * Otherwise, it will iterate over all tasks and return 0.
  *
- * This function must not be called for the root memory cgroup.
+ * If memcg is the root memory cgroup, this function will iterate only
+ * over tasks belonging directly to the root memory cgroup.
  */
 int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 			  int (*fn)(struct task_struct *, void *), void *arg)
@@ -896,8 +897,6 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 	struct mem_cgroup *iter;
 	int ret = 0;
 
-	BUG_ON(memcg == root_mem_cgroup);
-
 	for_each_mem_cgroup_tree(iter, memcg) {
 		struct css_task_iter it;
 		struct task_struct *task;
@@ -906,7 +905,7 @@ int mem_cgroup_scan_tasks(struct mem_cgr
 		while (!ret && (task = css_task_iter_next(&it)))
 			ret = fn(task, arg);
 		css_task_iter_end(&it);
-		if (ret) {
+		if (ret || memcg == root_mem_cgroup) {
 			mem_cgroup_iter_break(memcg, iter);
 			break;
 		}
_

Patches currently in -mm which might be from guro@fb.com are

mm-show-total-hugetlb-memory-consumption-in-proc-meminfo.patch
mm-oom-refactor-the-oom_kill_process-function.patch
mm-implement-mem_cgroup_scan_tasks-for-the-root-memory-cgroup.patch
mm-oom-cgroup-aware-oom-killer.patch
mm-oom-introduce-memoryoom_group.patch
mm-oom-add-cgroup-v2-mount-option-for-cgroup-aware-oom-killer.patch
mm-oom-docs-describe-the-cgroup-aware-oom-killer.patch
cgroup-list-groupoom-in-cgroup-features.patch

