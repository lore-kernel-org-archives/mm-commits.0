From: akpm@linux-foundation.org
Subject: +
 vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch added to -mm tree
Date: Fri, 19 Jul 2013 16:00:56 -0700
Message-ID: <51e9c528.B+JSONPnxzyJyEVs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52780 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3GSXA5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 19 Jul 2013 19:00:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, anton.vorontsov@linaro.org, mhocko@suse.cz

Subject: + vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch added to -mm tree
To: mhocko@suse.cz,anton.vorontsov@linaro.org,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,lizefan@huawei.com,tj@kernel.org
From: akpm@linux-foundation.org
Date: Fri, 19 Jul 2013 16:00:56 -0700


The patch titled
     Subject: vmpressure: make sure there are no events queued after memcg is offlined
has been added to the -mm tree.  Its filename is
     vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: vmpressure: make sure there are no events queued after memcg is offlined

vmpressure is called synchronously from reclaim where the target_memcg is
guaranteed to be alive but the eventfd is signaled from the work queue
context.  This means that memcg (along with vmpressure structure which is
embedded into it) might go away while the work item is pending which would
result in use-after-release bug.

We have two possible ways how to fix this.  Either vmpressure pins memcg
before it schedules vmpr->work and unpin it in vmpressure_work_fn or
explicitely flush the work item from the css_offline context (as suggested
by Tejun).

This patch implements the later one and it introduces vmpressure_cleanup
which flushes the vmpressure work queue item item.  It hooks into
mem_cgroup_css_offline after the memcg itself is cleaned up.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reported-by: Tejun Heo <tj@kernel.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Li Zefan <lizefan@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/vmpressure.h |    1 +
 mm/memcontrol.c            |    1 +
 mm/vmpressure.c            |   16 ++++++++++++++++
 3 files changed, 18 insertions(+)

diff -puN include/linux/vmpressure.h~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined include/linux/vmpressure.h
--- a/include/linux/vmpressure.h~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined
+++ a/include/linux/vmpressure.h
@@ -30,6 +30,7 @@ extern void vmpressure(gfp_t gfp, struct
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
 
 extern void vmpressure_init(struct vmpressure *vmpr);
+extern void vmpressure_cleanup(struct vmpressure * vmpr);
 extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
 extern struct cgroup_subsys_state *vmpressure_to_css(struct vmpressure *vmpr);
 extern struct vmpressure *css_to_vmpressure(struct cgroup_subsys_state *css);
diff -puN mm/memcontrol.c~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined mm/memcontrol.c
--- a/mm/memcontrol.c~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined
+++ a/mm/memcontrol.c
@@ -6335,6 +6335,7 @@ static void mem_cgroup_css_offline(struc
 	mem_cgroup_invalidate_reclaim_iterators(memcg);
 	mem_cgroup_reparent_charges(memcg);
 	mem_cgroup_destroy_all_caches(memcg);
+	vmpressure_cleanup(&memcg->vmpressure);
 }
 
 static void mem_cgroup_css_free(struct cgroup *cont)
diff -puN mm/vmpressure.c~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined mm/vmpressure.c
--- a/mm/vmpressure.c~vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined
+++ a/mm/vmpressure.c
@@ -372,3 +372,19 @@ void vmpressure_init(struct vmpressure *
 	INIT_LIST_HEAD(&vmpr->events);
 	INIT_WORK(&vmpr->work, vmpressure_work_fn);
 }
+
+/**
+ * vmpressure_cleanup() - shuts down vmpressure control structure
+ * @vmpr:	Structure to be cleaned up
+ *
+ * This function should be called before the structure in which it is
+ * embedded is cleaned up.
+ */
+void vmpressure_cleanup(struct vmpressure *vmpr)
+{
+	/*
+	 * Make sure there is no pending work before eventfd infrastructure
+	 * goes away.
+	 */
+	flush_work(&vmpr->work);
+}
_

Patches currently in -mm which might be from mhocko@suse.cz are

vmpressure-change-vmpressure-sr_lock-to-spinlock.patch
vmpressure-do-not-check-for-pending-work-to-prevent-from-new-work.patch
vmpressure-make-sure-there-are-no-events-queued-after-memcg-is-offlined.patch
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
staging-lustre-ldlm-convert-to-shrinkers-to-count-scan-api.patch
staging-lustre-obdclass-convert-lu_object-shrinker-to-count-scan-api.patch
staging-lustre-ptlrpc-convert-to-new-shrinker-api.patch
staging-lustre-libcfs-cleanup-linux-memh.patch
staging-lustre-replace-num_physpages-with-totalram_pages.patch
inode-convert-inode-lru-list-to-generic-lru-list-code-inode-move-inode-to-a-different-list-inside-lock.patch
list_lru-per-node-list-infrastructure-fix-broken-lru_retry-behaviour.patch
list_lru-remove-special-case-function-list_lru_dispose_all.patch
xfs-convert-dquot-cache-lru-to-list_lru-fix-dquot-isolation-hang.patch
list_lru-dynamically-adjust-node-arrays-super-fix-for-destroy-lrus.patch

