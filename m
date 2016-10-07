From: akpm@linux-foundation.org
Subject: [patch 045/127] mm, oom: enforce exit_oom_victim on current task
Date: Fri, 07 Oct 2016 16:59:03 -0700
Message-ID: <57f836c7.uyXaxnyaLXE0lOVJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39169 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbcJHAAN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:00:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.com, oleg@redhat.com, rientjes@google.com, vdavydov@parallels.com

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: mm, oom: enforce exit_oom_victim on current task

There are no users of exit_oom_victim on !current task anymore so enforce
the API to always work on the current.

Link: http://lkml.kernel.org/r/1472119394-11342-8-git-send-email-mhocko@kernel.org
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Michal Hocko <mhocko@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/oom.h |    2 +-
 kernel/exit.c       |    2 +-
 mm/oom_kill.c       |    5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff -puN include/linux/oom.h~mm-oom-enforce-exit_oom_victim-on-current-task include/linux/oom.h
--- a/include/linux/oom.h~mm-oom-enforce-exit_oom_victim-on-current-task
+++ a/include/linux/oom.h
@@ -69,7 +69,7 @@ extern unsigned long oom_badness(struct
 
 extern bool out_of_memory(struct oom_control *oc);
 
-extern void exit_oom_victim(struct task_struct *tsk);
+extern void exit_oom_victim(void);
 
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
diff -puN kernel/exit.c~mm-oom-enforce-exit_oom_victim-on-current-task kernel/exit.c
--- a/kernel/exit.c~mm-oom-enforce-exit_oom_victim-on-current-task
+++ a/kernel/exit.c
@@ -511,7 +511,7 @@ static void exit_mm(struct task_struct *
 	mm_update_next_owner(mm);
 	mmput(mm);
 	if (test_thread_flag(TIF_MEMDIE))
-		exit_oom_victim(tsk);
+		exit_oom_victim();
 }
 
 static struct task_struct *find_alive_thread(struct task_struct *p)
diff -puN mm/oom_kill.c~mm-oom-enforce-exit_oom_victim-on-current-task mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-enforce-exit_oom_victim-on-current-task
+++ a/mm/oom_kill.c
@@ -662,10 +662,9 @@ static void mark_oom_victim(struct task_
 /**
  * exit_oom_victim - note the exit of an OOM victim
  */
-void exit_oom_victim(struct task_struct *tsk)
+void exit_oom_victim(void)
 {
-	if (!test_and_clear_tsk_thread_flag(tsk, TIF_MEMDIE))
-		return;
+	clear_thread_flag(TIF_MEMDIE);
 
 	if (!atomic_dec_return(&oom_victims))
 		wake_up_all(&oom_victims_wait);
_
