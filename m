Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FCBC433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9CA022246
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633519;
	bh=vHkszeT497Hfdw31ZobwtgJ+T8Ek9qSAToqfxQZgrdQ=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=Pwkd/Lp6tcsgGrzAwZLinqioOckUnoVyl0yLZ+mLP8PizJc/ZPVhIEg2xK+/lj6F3
	 6T8NzkTYAoNX5dRlWB9MygmVnX/txJNgGgF+ZeRY+5p/EAZvUuqi1MdPGmt/vQ6ubX
	 C4FORvoAnBtBW/TnbQMgpLWKKwVa4kC2rAYTXXt8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389379AbgJMX6j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:58:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387851AbgJMX6j (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:58:39 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B97221FC;
        Tue, 13 Oct 2020 23:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633516;
        bh=vHkszeT497Hfdw31ZobwtgJ+T8Ek9qSAToqfxQZgrdQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vDgL760UvLNs6o0dY0q7uqD61SnM4ImkztaMl9OdGJ9+6Uf4mBPohV86TEWdqxzpW
         Q0r2Zu/g2tgv5Xw+UBOjMHfXf/9E3ZBLqlLdaJQvj+vu/w6ec0QeRL12QwOpHZ8liR
         7lW6Ie95Myz0LOXXuri2oJOXUCzucEULR+vCAb+o=
Date:   Tue, 13 Oct 2020 16:58:35 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, akpm@linux-foundation.org, areber@redhat.com,
        avagin@gmail.com, bernd.edlinger@hotmail.de,
        christian.brauner@ubuntu.com, christian@kellner.me,
        cyphar@cyphar.com, daniel.m.jordan@oracle.com,
        ebiederm@xmission.com, esyr@redhat.com, gladkov.alexey@gmail.com,
        john.johansen@canonical.com, laoar.shao@gmail.com,
        linux-mm@kvack.org, mhocko@kernel.org, mhocko@suse.com,
        minchan@kernel.org, mingo@kernel.org, mm-commits@vger.kernel.org,
        oleg@redhat.com, peterz@infradead.org, shakeelb@google.com,
        surenb@google.com, tglx@linutronix.de, timmurray@google.com,
        torvalds@linux-foundation.org, walken@google.com
Subject:  [patch 179/181] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20201013235835.v8dhPkqWt%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

Mark the mm with a new MMF_MULTIPROCESS flag bit when task is created with
(CLONE_VM && !CLONE_THREAD && !CLONE_VFORK).  Change __set_oom_adj to use
MMF_MULTIPROCESS instead of mm_users to decide whether oom_score_adj
update should be synchronized between multiple processes.  To prevent
races between clone() and __set_oom_adj(), when oom_score_adj of the
process being cloned might be modified from userspace, we use
oom_adj_mutex.  Its scope is changed to global.

The combination of (CLONE_VM && !CLONE_THREAD) is rarely used except for
the case of vfork().  To prevent performance regressions of vfork(), we
skip taking oom_adj_mutex and setting MMF_MULTIPROCESS when CLONE_VFORK is
specified.  Clearing the MMF_MULTIPROCESS flag (when the last process
sharing the mm exits) is left out of this patch to keep it simple and
because it is believed that this threading model is rare.  Should there
ever be a need for optimizing that case as well, it can be done by hooking
into the exit path, likely following the mm_update_next_owner pattern.

With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
quite rare, the regression is gone after the change is applied.

[surenb@google.com: v3]
  Link: https://lkml.kernel.org/r/20200902012558.2335613-1-surenb@google.com
Link: https://lkml.kernel.org/r/20200824153036.3201505-1-surenb@google.com
Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Tim Murray <timmurray@google.com>
Debugged-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Christian Kellner <christian@kellner.me>
Cc: Adrian Reber <areber@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c                 |    3 +--
 include/linux/oom.h            |    1 +
 include/linux/sched/coredump.h |    1 +
 kernel/fork.c                  |   21 +++++++++++++++++++++
 mm/oom_kill.c                  |    2 ++
 5 files changed, 26 insertions(+), 2 deletions(-)

--- a/fs/proc/base.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/fs/proc/base.c
@@ -1055,7 +1055,6 @@ static ssize_t oom_adj_read(struct file
 
 static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 {
-	static DEFINE_MUTEX(oom_adj_mutex);
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	int err = 0;
@@ -1095,7 +1094,7 @@ static int __set_oom_adj(struct file *fi
 		struct task_struct *p = find_lock_task_mm(task);
 
 		if (p) {
-			if (atomic_read(&p->mm->mm_users) > 1) {
+			if (test_bit(MMF_MULTIPROCESS, &p->mm->flags)) {
 				mm = p->mm;
 				mmgrab(mm);
 			}
--- a/include/linux/oom.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/include/linux/oom.h
@@ -55,6 +55,7 @@ struct oom_control {
 };
 
 extern struct mutex oom_lock;
+extern struct mutex oom_adj_mutex;
 
 static inline void set_current_oom_origin(void)
 {
--- a/include/linux/sched/coredump.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/include/linux/sched/coredump.h
@@ -72,6 +72,7 @@ static inline int get_dumpable(struct mm
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
 #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
+#define MMF_MULTIPROCESS	27	/* mm is shared between processes */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
--- a/kernel/fork.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary
+++ a/kernel/fork.c
@@ -1812,6 +1812,25 @@ static __always_inline void delayed_free
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
+	mutex_lock(&oom_adj_mutex);
+	set_bit(MMF_MULTIPROCESS, &tsk->mm->flags);
+	/* Update the values in case they were changed after copy_signal */
+	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
+	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
+	mutex_unlock(&oom_adj_mutex);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -2288,6 +2307,8 @@ static __latent_entropy struct task_stru
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
+DEFINE_MUTEX(oom_adj_mutex);
 
 static inline bool is_memcg_oom(struct oom_control *oc)
 {
_
