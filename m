From: akpm@linux-foundation.org
Subject: +
 oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch added to -mm tree
Date: Fri, 15 Apr 2016 14:00:08 -0700
Message-ID: <57115658.t/bx1Fi/MUqFrMQq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbcDOVAJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 17:00:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_reaper: Try to reap tasks which skip regular memcg OOM killer path
has been added to the -mm tree.  Its filename is
     oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Hocko <mhocko@suse.com>
Subject: mm, oom_reaper: Try to reap tasks which skip regular memcg OOM killer path

no reason to include memcg oom killed tasks as well.

Signed-off-by: Michal Hocko <mhocko@suse.com>
Suggested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    8 ++++++++
 mm/memcontrol.c     |    1 +
 mm/oom_kill.c       |    2 +-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff -puN include/linux/oom.h~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path include/linux/oom.h
--- a/include/linux/oom.h~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path
+++ a/include/linux/oom.h
@@ -72,6 +72,14 @@ static inline bool oom_task_origin(const
 
 extern void mark_oom_victim(struct task_struct *tsk);
 
+#ifdef CONFIG_MMU
+extern void try_oom_reaper(struct task_struct *tsk);
+#else
+static inline void try_oom_reaper(struct task_struct *tsk)
+{
+}
+#endif
+
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
diff -puN mm/memcontrol.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path mm/memcontrol.c
--- a/mm/memcontrol.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path
+++ a/mm/memcontrol.c
@@ -1287,6 +1287,7 @@ static bool mem_cgroup_out_of_memory(str
 	 */
 	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		mark_oom_victim(current);
+		try_oom_reaper(current);
 		goto unlock;
 	}
 
diff -puN mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path mm/oom_kill.c
--- a/mm/oom_kill.c~oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path
+++ a/mm/oom_kill.c
@@ -585,7 +585,7 @@ static void wake_oom_reaper(struct task_
 /* Check if we can reap the given task. This has to be called with stable
  * tsk->mm
  */
-static void try_oom_reaper(struct task_struct *tsk)
+void try_oom_reaper(struct task_struct *tsk)
 {
 	struct mm_struct *mm = tsk->mm;
 	struct task_struct *p;
_

Patches currently in -mm which might be from mhocko@suse.com are

include-linux-nodemaskh-create-next_node_in-helper-fix.patch
mm-oom-move-gfp_nofs-check-to-out_of_memory.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path.patch
oom-oom_reaper-try-to-reap-tasks-which-skip-regular-oom-killer-path-try-to-reap-tasks-which-skip-regular-memcg-oom-killer-path.patch
mm-oom_reaper-clear-tif_memdie-for-all-tasks-queued-for-oom_reaper.patch

