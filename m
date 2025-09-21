Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B712C0F78
	for <mm-commits@vger.kernel.org>; Sun, 21 Sep 2025 21:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758490007; cv=none; b=he83VZthQljuES22rmINFBzIIs5CQY9NcGU3ADMIwr2WUkU1s9IIlBD+wnOnETkH9BepmHIRp3JfCmD89plwCstyKcEP91w2mCiCw39NibVnVonFhtXFVl4zZMlwC7ex/dx+yoi8JXlqZLnK6omPsMdfyX2mqsK03A+wAP/Zz0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758490007; c=relaxed/simple;
	bh=L4qg877n7OjMOmH48HXfOUBqajQ99eggjm0kHX9E1iU=;
	h=Date:To:From:Subject:Message-Id; b=ZiyJK7JvCuhbXgeXBO18sUnlAvey5Dy/fXGBzzrbeZte6zNOJgmIdZJUoR+pBGf6QwQo4fui8cTc76ZZEgOqYjLlxBLrkdz7aT2bilx5ufJio/i7+3NyfYQz9M/hibL74/FHmuWRL/Pcvxo3z7LtTz7s/L6XI8BZoe9yUjwD1M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YXx+WCN4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YXx+WCN4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1618C4CEE7;
	Sun, 21 Sep 2025 21:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758490007;
	bh=L4qg877n7OjMOmH48HXfOUBqajQ99eggjm0kHX9E1iU=;
	h=Date:To:From:Subject:From;
	b=YXx+WCN4FO0miOGuGPxK39s/2D5to13DNgnGNMPl+wOH9qcec+GkYz2g0/URw4pr3
	 7BojHTRZIP96n7OSBzOO/P/Cpu/AhMwDvizOjBnK0UH0X91/JD5HoFWm1X63OvoHxw
	 9t3t3jUSCgnSQcbox0B1tG1VXiBGh2JNEpnnyPQc=
Date: Sun, 21 Sep 2025 14:26:46 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,Liam.Howlett@oracle.com,lenb@kernel.org,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-oom_kill-thaw-the-entire-oom-victim-process.patch removed from -mm tree
Message-Id: <20250921212646.F1618C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/oom_kill: thaw the entire OOM victim process
has been removed from the -mm tree.  Its filename was
     mm-oom_kill-thaw-the-entire-oom-victim-process.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: zhongjinji <zhongjinji@honor.com>
Subject: mm/oom_kill: thaw the entire OOM victim process
Date: Tue, 16 Sep 2025 00:29:45 +0800

Patch series "Improvements to Victim Process Thawing and OOM Reaper
Traversal Order", v10.

This patch series focuses on optimizing victim process thawing and
refining the traversal order of the OOM reaper.  Since __thaw_task() is
used to thaw a single thread of the victim, thawing only one thread cannot
guarantee the exit of the OOM victim when it is frozen.  Patch 1 thaw the
entire process of the OOM victim to ensure that OOM victims are able to
terminate themselves.  Even if the oom_reaper is delayed, patch 2 is still
beneficial for reaping processes with a large address space footprint, and
it also greatly improves process_mrelease.


This patch (of 10):

OOM killer is a mechanism that selects and kills processes when the system
runs out of memory to reclaim resources and keep the system stable.  But
the oom victim cannot terminate on its own when it is frozen, even if the
OOM victim task is thawed through __thaw_task().  This is because
__thaw_task() can only thaw a single OOM victim thread, and cannot thaw
the entire OOM victim process.

In addition, freezing_slow_path() determines whether a task is an OOM
victim by checking the task's TIF_MEMDIE flag.  When a task is identified
as an OOM victim, the freezer bypasses both PM freezing and cgroup
freezing states to thaw it.

Historically, TIF_MEMDIE was a "this is the oom victim & it has access to
memory reserves" flag in the past.  It has that thread vs.  process
problems and tsk_is_oom_victim was introduced later to get rid of them and
other issues as well as the guarantee that we can identify the oom
victim's mm reliably for other oom_reaper.

Therefore, thaw_process() is introduced to unfreeze all threads within the
OOM victim process, ensuring that every thread is properly thawed.  The
freezer now uses tsk_is_oom_victim() to determine OOM victim status,
allowing all victim threads to be unfrozen as necessary.

With this change, the entire OOM victim process will be thawed when an OOM
event occurs, ensuring that the victim can terminate on its own.

Link: https://lkml.kernel.org/r/20250915162946.5515-1-zhongjinji@honor.com
Link: https://lkml.kernel.org/r/20250915162946.5515-2-zhongjinji@honor.com
Signed-off-by: zhongjinji <zhongjinji@honor.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/freezer.h |    2 ++
 kernel/freezer.c        |   20 +++++++++++++++++++-
 mm/oom_kill.c           |   10 +++++-----
 3 files changed, 26 insertions(+), 6 deletions(-)

--- a/include/linux/freezer.h~mm-oom_kill-thaw-the-entire-oom-victim-process
+++ a/include/linux/freezer.h
@@ -47,6 +47,7 @@ extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
 extern void thaw_kernel_threads(void);
+extern void thaw_process(struct task_struct *p);
 
 static inline bool try_to_freeze(void)
 {
@@ -80,6 +81,7 @@ static inline int freeze_processes(void)
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
 static inline void thaw_kernel_threads(void) {}
+static inline void thaw_process(struct task_struct *p) {}
 
 static inline bool try_to_freeze(void) { return false; }
 
--- a/kernel/freezer.c~mm-oom_kill-thaw-the-entire-oom-victim-process
+++ a/kernel/freezer.c
@@ -10,6 +10,7 @@
 #include <linux/export.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/oom.h>
 #include <linux/kthread.h>
 
 /* total number of freezing conditions in effect */
@@ -40,7 +41,7 @@ bool freezing_slow_path(struct task_stru
 	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
 		return false;
 
-	if (test_tsk_thread_flag(p, TIF_MEMDIE))
+	if (tsk_is_oom_victim(p))
 		return false;
 
 	if (pm_nosig_freezing || cgroup_freezing(p))
@@ -206,6 +207,23 @@ void __thaw_task(struct task_struct *p)
 		wake_up_state(p, TASK_FROZEN);
 }
 
+/*
+ * thaw_process - Thaw a frozen process
+ * @p: the process to be thawed
+ *
+ * Iterate over all threads of @p and call __thaw_task() on each.
+ */
+void thaw_process(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	rcu_read_lock();
+	for_each_thread(p, t) {
+		__thaw_task(t);
+	}
+	rcu_read_unlock();
+}
+
 /**
  * set_freezable - make %current freezable
  *
--- a/mm/oom_kill.c~mm-oom_kill-thaw-the-entire-oom-victim-process
+++ a/mm/oom_kill.c
@@ -772,12 +772,12 @@ static void mark_oom_victim(struct task_
 		mmgrab(tsk->signal->oom_mm);
 
 	/*
-	 * Make sure that the task is woken up from uninterruptible sleep
-	 * if it is frozen because OOM killer wouldn't be able to free
-	 * any memory and livelock. freezing_slow_path will tell the freezer
-	 * that TIF_MEMDIE tasks should be ignored.
+	 * Make sure that the process is woken up from uninterruptible sleep
+	 * if it is frozen because OOM killer wouldn't be able to free any
+	 * memory and livelock. The freezer will thaw the tasks that are OOM
+	 * victims regardless of the PM freezing and cgroup freezing states.
 	 */
-	__thaw_task(tsk);
+	thaw_process(tsk);
 	atomic_inc(&oom_victims);
 	cred = get_task_cred(tsk);
 	trace_mark_victim(tsk, cred->uid.val);
_

Patches currently in -mm which might be from zhongjinji@honor.com are


