Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9D9C433E7
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89B4F21D7B
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602630948;
	bh=71QjZ/lS/kcUzHw6NUroEe7IZrVhKrLzRqqRtb6CooU=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=zbvkJB1c10w5V+QTUjzFVRklRFAiYX+nnoYJACMncC1vB1Z5kBZIUgfTn5vNMlS5X
	 rnrI4rzbtk8vALSgQVyaA5U0D/URr6vMWi7JvnhemZ3T7ZLlsdLEC+hnShIZLoTp5J
	 1y08TXL7Q+i+MOP26sFBzDS7S7x89pLH4yFFzEYY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388559AbgJMXPs (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:48106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388353AbgJMXPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:15:47 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB2A20B1F;
        Tue, 13 Oct 2020 23:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602630947;
        bh=71QjZ/lS/kcUzHw6NUroEe7IZrVhKrLzRqqRtb6CooU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=owUDNxej3YsVwtNxVns7v/8xASBNB2rXr56zyNRhk5q1CvcKwDU4gLLlI7TlSPUPA
         YrL4Kh1Y09gWGw5+VYXQVWt9tkhMh3WbQZgQ4DFBRyOS18fI5hEzOOHTBytQQiZ09k
         IOzdKWX9UrICEDdIJ6zLMYSq/SgsqHwfMPPX6vDA=
Date:   Tue, 13 Oct 2020 16:15:45 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     adobriyan@gmail.com, areber@redhat.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, christian.brauner@ubuntu.com,
        christian@kellner.me, cyphar@cyphar.com,
        daniel.m.jordan@oracle.com, ebiederm@xmission.com, esyr@redhat.com,
        gladkov.alexey@gmail.com, john.johansen@canonical.com,
        laoar.shao@gmail.com, mhocko@kernel.org, minchan@kernel.org,
        mingo@kernel.org, mm-commits@vger.kernel.org, oleg@redhat.com,
        peterz@infradead.org, shakeelb@google.com, surenb@google.com,
        tglx@linutronix.de, timmurray@google.com, walken@google.com
Subject:  [folded-merged]
 =?US-ASCII?Q?mm-oom=5Fadj-dont-loop-through-tasks-in-=5F=5Fset=5Foom?=
 =?US-ASCII?Q?=5Fadj-when-not-necessary-v3.patch?= removed from -mm tree
Message-ID: <20201013231545.XrZVxr2ws%akpm@linux-foundation.org>
In-Reply-To: <20201010231559.e148a66f744d0b4870301450@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3
has been removed from the -mm tree.  Its filename was
     mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary-v3.patch

This patch was dropped because it was folded into mm-oom_adj-dont-loop-through-tasks-in-__set_oom_adj-when-not-necessary.patch

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
@@ -1821,12 +1821,12 @@ static void copy_oom_score_adj(u64 clone
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

