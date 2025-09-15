Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC3729617D
	for <mm-commits@vger.kernel.org>; Mon, 15 Sep 2025 22:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757976210; cv=none; b=BdfDvilxTsRz70mF9p9MXd3M7DqdfI6s8A2Oaq5Vd50JA8/t0j/893VhCmtvqIzX8I21qJt5NqW0fBD9AeCd8qWyM9bWCnw1GoW3YjZfKJiLz7MTYEEIh6EVEoTTaqs+eOcyoGM04HZDLXFmy/LYIN5FV8za7XQlgtg8ZbnyOXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757976210; c=relaxed/simple;
	bh=34eBJSqgCU5DXUgp94mVofzr3LoNAXsipWPmUDl3LAg=;
	h=Date:To:From:Subject:Message-Id; b=UXp2r/wj/o9+eoCO6naZQ0zUTViyJatg95Sb7J/MFRcRbIk+bBYM0QJCj0/c4uJM2Nqh74hw5tEzaMwmwJ/BGHZspziqc1TUiCS0vm4sHaD85VXUV0nt3uB8JUvY/bDG0k11g5PXLuVkFX9vylaqVxk62x9Glnw/YvcFOjqKpCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pPlqjmOz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pPlqjmOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3597C4CEF1;
	Mon, 15 Sep 2025 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757976208;
	bh=34eBJSqgCU5DXUgp94mVofzr3LoNAXsipWPmUDl3LAg=;
	h=Date:To:From:Subject:From;
	b=pPlqjmOzxNdQ5C5X3I18Kj6uMskNUonNkbYK+8dZ0nMhpaAE2V2EfcoOzWP7TSdTm
	 7t90CWZBhszdG8vnGeuKd3U6DnZb59kmC3+mMG1L/y3QqNTpseLPtUl+d8raZuzKFq
	 rP2DGpKZxelHz4M1D6Fyso58c5567ylzA49u/6gM=
Date: Mon, 15 Sep 2025 15:43:28 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,surenb@google.com,shakeel.butt@linux.dev,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,lenb@kernel.org,zhongjinji@honor.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-oom_kill-thaw-the-entire-oom-victim-process.patch added to mm-new branch
Message-Id: <20250915224328.C3597C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/oom_kill: thaw the entire OOM victim process
has been added to the -mm mm-new branch.  Its filename is
     mm-oom_kill-thaw-the-entire-oom-victim-process.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-oom_kill-thaw-the-entire-oom-victim-process.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
Cc: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
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

mm-oom_kill-thaw-the-entire-oom-victim-process.patch
mm-oom_kill-the-oom-reaper-traverses-the-vma-maple-tree-in-reverse-order.patch

