Return-Path: <SRS0=GeP8=CC=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECB5C433DF
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:18:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973672074D
	for <mm-commits@archiver.kernel.org>; Mon, 24 Aug 2020 18:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598293115;
	bh=91pyHX8xDpU4WVtHqy/9DCLCw5/vUVCpLzyTCOEsowc=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=PY5WIcxozAeBC7IBCX/EAUv6gQldKNGFhfcKQIXufN0Sm8ltx+OFhLyrd9nF2HX7H
	 /Q31QA8xag2tDJLEyVZ4pUOm7ZPGHiNDh0g/2N3viCEAok+eBkSYGMexJkp9S5CRBJ
	 XwHe6/l+ttVsZ2hEHcb+fXW0SObJRBUV21nW8r5c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgHXSSf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 24 Aug 2020 14:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726578AbgHXSSe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 24 Aug 2020 14:18:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0927C206BE;
        Mon, 24 Aug 2020 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598293112;
        bh=91pyHX8xDpU4WVtHqy/9DCLCw5/vUVCpLzyTCOEsowc=;
        h=Date:From:To:Subject:From;
        b=z/Ak2CH2lD5qYx1pb6IZVx05jcYsRn27GKpS8DKLkZiouJZTTe+9xoqxGlxYQ5w84
         R8GpzAG2Bu5hRJleroWINxYvp7A1GkOFqrU7n/tYS1fikhF32Tndr9sRKtkzcCUSJV
         zPgLTyLb6I4k+C2bsVf8p3f8D8L9CdTbWmmFJ4CI=
Date:   Mon, 24 Aug 2020 11:18:31 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, areber@redhat.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, christian.brauner@ubuntu.com,
        christian@kellner.me, cyphar@cyphar.com,
        daniel.m.jordan@oracle.com, ebiederm@xmission.com, esyr@redhat.com,
        gladkov.alexey@gmail.com, john.johansen@canonical.com,
        laoar.shao@gmail.com, mhocko@kernel.org, minchan@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        peterz@infradead.org, shakeelb@google.com, surenb@google.com,
        tglx@linutronix.de, timmurray@google.com, walken@google.com
Subject:  +
 =?US-ASCII?Q?mm-oom=5Fadj-dont-loop-through-tasks-in-=5F=5Fset=5Foom=5F?=
 =?US-ASCII?Q?adj-when-not-necessary.patch?= added to -mm tree
Message-ID: <20200824181831.67ecIenxt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary
has been added to the -mm tree.  Its filename is
     mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Suren Baghdasaryan <surenb@google.com>
Subject: mm, oom_adj: don't loop through tasks in __set_oom_adj when not necessary

Currently __set_oom_adj loops through all processes in the system to keep
oom_score_adj and oom_score_adj_min in sync between processes sharing
their mm.  This is done for any task with more that one mm_users, which
includes processes with multiple threads (sharing mm and signals). 
However for such processes the loop is unnecessary because their signal
structure is shared as well.

Android updates oom_score_adj whenever a tasks changes its role
(background/foreground/...) or binds to/unbinds from a service, making it
more/less important.  Such operation can happen frequently.  We noticed
that updates to oom_score_adj became more expensive and after further
investigation found out that the patch mentioned in "Fixes" introduced a
regression.  Using Pixel 4 with a typical Android workload, write time to
oom_score_adj increased from ~3.57us to ~362us.  Moreover this regression
linearly depends on the number of multi-threaded processes running on the
system.

Mark the mm with a new MMF_PROC_SHARED flag bit when task is created with
(CLONE_VM && !CLONE_THREAD && !CLONE_VFORK).  Change __set_oom_adj to use
MMF_PROC_SHARED instead of mm_users to decide whether oom_score_adj update
should be synchronized between multiple processes.  To prevent races
between clone() and __set_oom_adj(), when oom_score_adj of the process
being cloned might be modified from userspace, we use oom_adj_mutex.  Its
scope is changed to global and it is renamed into oom_adj_lock for naming
consistency with oom_lock.

The combination of (CLONE_VM && !CLONE_THREAD) is rarely used except for
the case of vfork().  To prevent performance regressions of vfork(), we
skip taking oom_adj_lock and setting MMF_PROC_SHARED when CLONE_VFORK is
specified.  Clearing the MMF_PROC_SHARED flag (when the last process
sharing the mm exits) is left out of this patch to keep it simple and
because it is believed that this threading model is rare.  Should there
ever be a need for optimizing that case as well, it can be done by hooking
into the exit path, likely following the mm_update_next_owner pattern.

With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
quite rare, the regression is gone after the change is applied.

Link: https://lkml.kernel.org/r/20200824153036.3201505-1-surenb@google.com
Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Tim Murray <timmurray@google.com>
Debugged-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Christian Kellner <christian@kellner.me>
Cc: Adrian Reber <areber@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Cc: Tim Murray <timmurray@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                 |    7 +++----
 include/linux/oom.h            |    1 +
 include/linux/sched/coredump.h |    1 +
 kernel/fork.c                  |   21 +++++++++++++++++++++
 mm/oom_kill.c                  |    2 ++
 5 files changed, 28 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/fs/proc/base.c
@@ -1055,7 +1055,6 @@ static ssize_t oom_adj_read(struct file
 
 static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 {
-	static DEFINE_MUTEX(oom_adj_mutex);
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	int err = 0;
@@ -1064,7 +1063,7 @@ static int __set_oom_adj(struct file *fi
 	if (!task)
 		return -ESRCH;
 
-	mutex_lock(&oom_adj_mutex);
+	mutex_lock(&oom_adj_lock);
 	if (legacy) {
 		if (oom_adj < task->signal->oom_score_adj &&
 				!capable(CAP_SYS_RESOURCE)) {
@@ -1095,7 +1094,7 @@ static int __set_oom_adj(struct file *fi
 		struct task_struct *p = find_lock_task_mm(task);
 
 		if (p) {
-			if (atomic_read(&p->mm->mm_users) > 1) {
+			if (test_bit(MMF_PROC_SHARED, &p->mm->flags)) {
 				mm = p->mm;
 				mmgrab(mm);
 			}
@@ -1132,7 +1131,7 @@ static int __set_oom_adj(struct file *fi
 		mmdrop(mm);
 	}
 err_unlock:
-	mutex_unlock(&oom_adj_mutex);
+	mutex_unlock(&oom_adj_lock);
 	put_task_struct(task);
 	return err;
 }
--- a/include/linux/oom.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/include/linux/oom.h
@@ -55,6 +55,7 @@ struct oom_control {
 };
 
 extern struct mutex oom_lock;
+extern struct mutex oom_adj_lock;
 
 static inline void set_current_oom_origin(void)
 {
--- a/include/linux/sched/coredump.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/include/linux/sched/coredump.h
@@ -72,6 +72,7 @@ static inline int get_dumpable(struct mm
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
 #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
+#define MMF_PROC_SHARED	27	/* mm is shared while sighand is not */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
--- a/kernel/fork.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/kernel/fork.c
@@ -1808,6 +1808,25 @@ static __always_inline void delayed_free
 		free_task(tsk);
 }
 
+static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
+{
+	/* Skip if kernel thread */
+	if (!tsk->mm)
+		return;
+
+	/* Skip if spawning a thread or using vfork */
+	if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
+		return;
+
+	/* We need to synchronize with __set_oom_adj */
+	mutex_lock(&oom_adj_lock);
+	set_bit(MMF_PROC_SHARED, &tsk->mm->flags);
+	/* Update the values in case they were changed after copy_signal */
+	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
+	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
+	mutex_unlock(&oom_adj_lock);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -2280,6 +2299,8 @@ static __latent_entropy struct task_stru
 	trace_task_newtask(p, clone_flags);
 	uprobe_copy_process(p, clone_flags);
 
+	copy_oom_score_adj(clone_flags, p);
+
 	return p;
 
 bad_fork_cancel_cgroup:
--- a/mm/oom_kill.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/mm/oom_kill.c
@@ -64,6 +64,8 @@ int sysctl_oom_dump_tasks = 1;
  * and mark_oom_victim
  */
 DEFINE_MUTEX(oom_lock);
+/* Serializes oom_score_adj and oom_score_adj_min updates */
+DEFINE_MUTEX(oom_adj_lock);
 
 static inline bool is_memcg_oom(struct oom_control *oc)
 {
_

Patches currently in -mm which might be from surenb@google.com are

mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch

