From: akpm@linux-foundation.org
Subject: + oom-make-oom_reaper_list-single-linked.patch added to -mm tree
Date: Tue, 01 Mar 2016 13:48:54 -0800
Message-ID: <56d60e46.WrC8dsjjKQniedKR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbcCAVsz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2016 16:48:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@virtuozzo.com, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: make oom_reaper_list single linked
has been added to the -mm tree.  Its filename is
     oom-make-oom_reaper_list-single-linked.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-make-oom_reaper_list-single-linked.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-make-oom_reaper_list-single-linked.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: oom: make oom_reaper_list single linked

Entries are only added/removed from oom_reaper_list at head so we can use
a single linked list and hence save a word in task_struct.

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    2 +-
 mm/oom_kill.c         |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff -puN include/linux/sched.h~oom-make-oom_reaper_list-single-linked include/linux/sched.h
--- a/include/linux/sched.h~oom-make-oom_reaper_list-single-linked
+++ a/include/linux/sched.h
@@ -1834,7 +1834,7 @@ struct task_struct {
 #endif
 	int pagefault_disabled;
 #ifdef CONFIG_MMU
-	struct list_head oom_reaper_list;
+	struct task_struct *oom_reaper_list;
 #endif
 /* CPU-specific state of this task */
 	struct thread_struct thread;
diff -puN mm/oom_kill.c~oom-make-oom_reaper_list-single-linked mm/oom_kill.c
--- a/mm/oom_kill.c~oom-make-oom_reaper_list-single-linked
+++ a/mm/oom_kill.c
@@ -423,7 +423,7 @@ bool oom_killer_disabled __read_mostly;
  */
 static struct task_struct *oom_reaper_th;
 static DECLARE_WAIT_QUEUE_HEAD(oom_reaper_wait);
-static LIST_HEAD(oom_reaper_list);
+static struct task_struct *oom_reaper_list;
 static DEFINE_SPINLOCK(oom_reaper_lock);
 
 
@@ -530,13 +530,11 @@ static int oom_reaper(void *unused)
 	while (true) {
 		struct task_struct *tsk = NULL;
 
-		wait_event_freezable(oom_reaper_wait,
-				     (!list_empty(&oom_reaper_list)));
+		wait_event_freezable(oom_reaper_wait, oom_reaper_list != NULL);
 		spin_lock(&oom_reaper_lock);
-		if (!list_empty(&oom_reaper_list)) {
-			tsk = list_first_entry(&oom_reaper_list,
-					struct task_struct, oom_reaper_list);
-			list_del(&tsk->oom_reaper_list);
+		if (oom_reaper_list != NULL) {
+			tsk = oom_reaper_list;
+			oom_reaper_list = tsk->oom_reaper_list;
 		}
 		spin_unlock(&oom_reaper_lock);
 
@@ -555,7 +553,8 @@ static void wake_oom_reaper(struct task_
 	get_task_struct(tsk);
 
 	spin_lock(&oom_reaper_lock);
-	list_add(&tsk->oom_reaper_list, &oom_reaper_list);
+	tsk->oom_reaper_list = oom_reaper_list;
+	oom_reaper_list = tsk;
 	spin_unlock(&oom_reaper_lock);
 	wake_up(&oom_reaper_wait);
 }
_

Patches currently in -mm which might be from vdavydov@virtuozzo.com are

mm-vmscan-do-not-clear-shrinker_numa_aware-if-nr_node_ids-==-1.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix-2.patch
mm-memcontrol-do-not-bypass-slab-charge-if-memcg-is-offline.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats.patch
mm-memcontrol-make-tree_statevents-fetch-all-stats-fix.patch
mm-memcontrol-report-slab-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat.patch
mm-memcontrol-report-kernel-stack-usage-in-cgroup2-memorystat-v2.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix.patch
tools-vm-page-typesc-add-memory-cgroup-dumping-and-filtering-fix.patch
mm-memcontrol-enable-kmem-accounting-for-all-cgroups-in-the-legacy-hierarchy.patch
mm-vmscan-pass-root_mem_cgroup-instead-of-null-to-memcg-aware-shrinker.patch
mm-memcontrol-zap-memcg_kmem_online-helper.patch
radix-tree-account-radix_tree_node-to-memory-cgroup.patch
mm-workingset-size-shadow-nodes-lru-basing-on-file-cache-size.patch
mm-workingset-make-shadow-node-shrinker-memcg-aware.patch
mm-memcontrol-cleanup-css_reset-callback.patch
oom-make-oom_reaper_list-single-linked.patch

