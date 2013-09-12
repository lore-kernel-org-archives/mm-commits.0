From: akpm@linux-foundation.org
Subject: [merged]
 include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:41:57 -0700
Message-ID: <52321905.Z4wQa3f/VKWlDwyb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab3ILTl6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:41:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu, mhocko@suse.cz, ebiederm@xmission.com, dserrg@gmail.com, a.p.zijlstra@chello.nl, oleg@redhat.com

Subject: [merged] include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch removed from -mm tree
To: oleg@redhat.com,a.p.zijlstra@chello.nl,dserrg@gmail.com,ebiederm@xmission.com,mhocko@suse.cz,mingo@elte.hu,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:41:57 -0700


The patch titled
     Subject: include/linux/sched.h: don't use task->pid/tgid in same_thread_group/has_group_leader_pid
has been removed from the -mm tree.  Its filename was
     include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: include/linux/sched.h: don't use task->pid/tgid in same_thread_group/has_group_leader_pid

task_struct->pid/tgid should go away.

1. Change same_thread_group() to use task->signal for comparison.

2. Change has_group_leader_pid(task) to compare task_pid(task) with
   signal->leader_pid.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Sergey Dyasly <dserrg@gmail.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN include/linux/sched.h~include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid include/linux/sched.h
--- a/include/linux/sched.h~include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid
+++ a/include/linux/sched.h
@@ -2169,15 +2169,15 @@ static inline bool thread_group_leader(s
  * all we care about is that we have a task with the appropriate
  * pid, we don't actually care if we have the right task.
  */
-static inline int has_group_leader_pid(struct task_struct *p)
+static inline bool has_group_leader_pid(struct task_struct *p)
 {
-	return p->pid == p->tgid;
+	return task_pid(p) == p->signal->leader_pid;
 }
 
 static inline
-int same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->tgid == p2->tgid;
+	return p1->signal == p2->signal;
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
anon_inodefs-forbid-open-via-proc.patch
autofs4-allow-autofs-to-work-outside-the-initial-pid-namespace.patch
autofs4-translate-pids-to-the-right-namespace-for-the-daemon.patch
signals-eventpoll-set-saved_sigmask-at-the-start.patch

