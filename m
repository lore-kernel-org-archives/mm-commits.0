Return-Path: <SRS0=UrOV=CM=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A209C43461
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C22920709
	for <mm-commits@archiver.kernel.org>; Thu,  3 Sep 2020 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599169602;
	bh=KZwcaBQXjWynW8Y9yiQqG+Tkzc1+N6sui3WrLQ5lyC8=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=q6tmtW09pf1hhKgXIsIi2gw9oJ4oEglobmYEOOI/Si6DVZFnh99GX0QHvVfDzVoyt
	 rdCtGwHG0SCaQcZaNHKJmo0Obng5hHcT0NYayd4I3J1beEQozpDCM6QboYJ2EApnR4
	 DM/ziqXhmrK6UX1g5qpguVjhPSxYjvxbXzx8mOww=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgICVql (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Sep 2020 17:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgICVql (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Sep 2020 17:46:41 -0400
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B62B920639;
        Thu,  3 Sep 2020 21:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599169600;
        bh=KZwcaBQXjWynW8Y9yiQqG+Tkzc1+N6sui3WrLQ5lyC8=;
        h=Date:From:To:Subject:From;
        b=R/407hFaSMcvmTtpS6o7nc90G2bsfnGXx0DEvoDV4vdF7yWiXhmNJ3Csr46Fo45LX
         iOpJu+1JMUw28Tyx/7KmskTPNn0veYjRdRZb72LtJEqPvAG3fhnz5feKLwXQWw1GQD
         5wHjxZS4g28dJnxvRyAuR3ajLDepDjHp1lUa8V+8=
Date:   Thu, 03 Sep 2020 14:46:39 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, walken@google.com,
        timmurray@google.com, tglx@linutronix.de, shakeelb@google.com,
        peterz@infradead.org, oleg@redhat.com, mingo@kernel.org,
        minchan@kernel.org, mhocko@kernel.org, laoar.shao@gmail.com,
        john.johansen@canonical.com, gladkov.alexey@gmail.com,
        esyr@redhat.com, ebiederm@xmission.com, daniel.m.jordan@oracle.com,
        cyphar@cyphar.com, christian@kellner.me,
        christian.brauner@ubuntu.com, bernd.edlinger@hotmail.de,
        avagin@gmail.com, areber@redhat.com, adobriyan@gmail.com,
        surenb@google.com
Subject:  +
 =?us-ascii?Q?mm-oom=5Fadj-dont-loop-through-tasks-in-=5F=5Fset=5Foom?=
 =?us-ascii?Q?=5Fadj-when-not-necessary-v3.patch?= added to -mm tree
Message-ID: <20200903214639.nbC-B%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
has been added to the -mm tree.  Its filename is
     mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3.patch

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
Subject: mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3

- Addressed Eric Biederman's comments from:
https://lore.kernel.org/linux-mm/87imd6n0qk.fsf@x220.int.ebiederm.org/
-- renabled oom_adj_lock back to oom_adj_mutex
-- renamed MMF_PROC_SHARED into MMF_MULTIPROCESS and fixed its comment
- Updated description to reflect the change

Link: https://lkml.kernel.org/r/20200902012558.2335613-1-surenb@google.com
Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
Reported-by: Tim Murray <timmurray@google.com>
Debugged-by: Minchan Kim <minchan@kernel.org>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: Christian Brauner <christian.brauner@ubuntu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
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

 fs/proc/base.c                 |    6 +++---
 include/linux/oom.h            |    2 +-
 include/linux/sched/coredump.h |    2 +-
 kernel/fork.c                  |    6 +++---
 mm/oom_kill.c                  |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/proc/base.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
+++ a/fs/proc/base.c
@@ -1063,7 +1063,7 @@ static int __set_oom_adj(struct file *fi
 	if (!task)
 		return -ESRCH;
 
-	mutex_lock(&oom_adj_lock);
+	mutex_lock(&oom_adj_mutex);
 	if (legacy) {
 		if (oom_adj < task->signal->oom_score_adj &&
 				!capable(CAP_SYS_RESOURCE)) {
@@ -1094,7 +1094,7 @@ static int __set_oom_adj(struct file *fi
 		struct task_struct *p = find_lock_task_mm(task);
 
 		if (p) {
-			if (test_bit(MMF_PROC_SHARED, &p->mm->flags)) {
+			if (test_bit(MMF_MULTIPROCESS, &p->mm->flags)) {
 				mm = p->mm;
 				mmgrab(mm);
 			}
@@ -1131,7 +1131,7 @@ static int __set_oom_adj(struct file *fi
 		mmdrop(mm);
 	}
 err_unlock:
-	mutex_unlock(&oom_adj_lock);
+	mutex_unlock(&oom_adj_mutex);
 	put_task_struct(task);
 	return err;
 }
--- a/include/linux/oom.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
+++ a/include/linux/oom.h
@@ -55,7 +55,7 @@ struct oom_control {
 };
 
 extern struct mutex oom_lock;
-extern struct mutex oom_adj_lock;
+extern struct mutex oom_adj_mutex;
 
 static inline void set_current_oom_origin(void)
 {
--- a/include/linux/sched/coredump.h~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
+++ a/include/linux/sched/coredump.h
@@ -72,7 +72,7 @@ static inline int get_dumpable(struct mm
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
 #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
-#define MMF_PROC_SHARED	27	/* mm is shared while sighand is not */
+#define MMF_MULTIPROCESS	27	/* mm is shared between processes */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
--- a/kernel/fork.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
+++ a/kernel/fork.c
@@ -1819,12 +1819,12 @@ static void copy_oom_score_adj(u64 clone
 		return;
 
 	/* We need to synchronize with __set_oom_adj */
-	mutex_lock(&oom_adj_lock);
-	set_bit(MMF_PROC_SHARED, &tsk->mm->flags);
+	mutex_lock(&oom_adj_mutex);
+	set_bit(MMF_MULTIPROCESS, &tsk->mm->flags);
 	/* Update the values in case they were changed after copy_signal */
 	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
 	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
-	mutex_unlock(&oom_adj_lock);
+	mutex_unlock(&oom_adj_mutex);
 }
 
 /*
--- a/mm/oom_kill.c~mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
+++ a/mm/oom_kill.c
@@ -65,7 +65,7 @@ int sysctl_oom_dump_tasks = 1;
  */
 DEFINE_MUTEX(oom_lock);
 /* Serializes oom_score_adj and oom_score_adj_min updates */
-DEFINE_MUTEX(oom_adj_lock);
+DEFINE_MUTEX(oom_adj_mutex);
 
 static inline bool is_memcg_oom(struct oom_control *oc)
 {
_

Patches currently in -mm which might be from surenb@google.com are

mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch
mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3.patch

