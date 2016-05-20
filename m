From: akpm@linux-foundation.org
Subject: [patch 020/162] oom: consider multi-threaded tasks in
 task_will_free_mem
Date: Fri, 20 May 2016 16:57:24 -0700
Message-ID: <573fa464.ZUAb1MYFoOKqE4cY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbcETX5Z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 19:57:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, iamjoonsoo.kim@lge.com, oleg@redhat.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com

From: Michal Hocko <mhocko@suse.com>
Subject: oom: consider multi-threaded tasks in task_will_free_mem

task_will_free_mem is a misnomer for a more complex PF_EXITING test for
early break out from the oom killer because it is believed that such a
task would release its memory shortly and so we do not have to select an
oom victim and perform a disruptive action.

Currently we make sure that the given task is not participating in the
core dumping because it might get blocked for a long time - see
d003f371b270 ("oom: don't assume that a coredumping thread will exit
soon").

The check can still do better though.  We shouldn't consider the task
unless the whole thread group is going down.  This is rather unlikely but
not impossible.  A single exiting thread would surely leave all the
address space behind.  If we are really unlucky it might get stuck on the
exit path and keep its TIF_MEMDIE and so block the oom killer.

Link: http://lkml.kernel.org/r/1460452756-15491-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem include/linux/oom.h
--- a/include/linux/oom.h~oom-consider-multi-threaded-tasks-in-task_will_free_mem
+++ a/include/linux/oom.h
@@ -110,13 +110,24 @@ extern struct task_struct *find_lock_tas
 
 static inline bool task_will_free_mem(struct task_struct *task)
 {
+	struct signal_struct *sig = task->signal;
+
 	/*
 	 * A coredumping process may sleep for an extended period in exit_mm(),
 	 * so the oom killer cannot assume that the process will promptly exit
 	 * and release memory.
 	 */
-	return (task->flags & PF_EXITING) &&
-		!(task->signal->flags & SIGNAL_GROUP_COREDUMP);
+	if (sig->flags & SIGNAL_GROUP_COREDUMP)
+		return false;
+
+	if (!(task->flags & PF_EXITING))
+		return false;
+
+	/* Make sure that the whole thread group is going down */
+	if (!thread_group_empty(task) && !(sig->flags & SIGNAL_GROUP_EXIT))
+		return false;
+
+	return true;
 }
 
 /* sysctls */
_
