From: akpm@linux-foundation.org
Subject: [folded-merged]
 oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch removed
 from -mm tree
Date: Fri, 12 Dec 2014 16:42:15 -0800
Message-ID: <548b8b67.fWBLCQYt0G2LVS2L%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLMAmQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 12 Dec 2014 19:42:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mhocko@suse.cz, rientjes@google.com, rjw@rjwysocki.net, tj@kernel.org, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
has been removed from the -mm tree.  Its filename was
     oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2.patch

This patch was dropped because it was folded into oom-dont-assume-that-a-coredumping-thread-will-exit-soon.patch

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2

The patch is basically the same, but as Michal pointed out
mem_cgroup_out_of_memory() can use the new helper too, it can face the
same problems.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    6 ++++++
 mm/memcontrol.c     |    2 +-
 mm/oom_kill.c       |    6 ------
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 include/linux/oom.h
--- a/include/linux/oom.h~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/include/linux/oom.h
@@ -87,6 +87,12 @@ static inline void oom_killer_enable(voi
 
 extern struct task_struct *find_lock_task_mm(struct task_struct *p);
 
+static inline bool task_will_free_mem(struct task_struct *task)
+{
+	return (task->flags & PF_EXITING) &&
+		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+}
+
 /* sysctls */
 extern int sysctl_oom_dump_tasks;
 extern int sysctl_oom_kill_allocating_task;
diff -puN mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 mm/memcontrol.c
--- a/mm/memcontrol.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/mm/memcontrol.c
@@ -1559,7 +1559,7 @@ static void mem_cgroup_out_of_memory(str
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
 	 */
-	if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
diff -puN mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2 mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-assume-that-a-coredumping-thread-will-exit-soon-v2
+++ a/mm/oom_kill.c
@@ -254,12 +254,6 @@ static enum oom_constraint constrained_a
 }
 #endif
 
-static inline bool task_will_free_mem(struct task_struct *task)
-{
-	return (task->flags & PF_EXITING) &&
-		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
-}
