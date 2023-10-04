Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F8B5E936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245005AbjJDUYl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245013AbjJDUX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:28 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C816126
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741D1C433CB;
        Wed,  4 Oct 2023 20:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451004;
        bh=TUSrNRyYZoOa15XtU3rC05oeR8dF4acivkRg8UFbG4Y=;
        h=Date:To:From:Subject:From;
        b=0iO7SU8WyvXa7cLG0yZew0uDpZnwxLiqw6MLh2zBR4VtP/+cElGojwf0ds9Ec331J
         9t0SkjOryMGLZFklLtnkHSyGYsSjHxnno9yVyQyIG2zxF+UEvk/ix3rqGe+WF4jhGz
         vhPw0THHgzAi89+t56+nRUU5pycdIjVnm48npDYs=
Date:   Wed, 04 Oct 2023 13:23:23 -0700
To:     mm-commits@vger.kernel.org, peterz@infradead.org,
        ebiederm@xmission.com, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kill-task_struct-thread_group.patch removed from -mm tree
Message-Id: <20231004202324.741D1C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kill task_struct->thread_group
has been removed from the -mm tree.  Its filename was
     kill-task_struct-thread_group.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: kill task_struct->thread_group
Date: Sat, 26 Aug 2023 13:14:09 +0200

The last user was removed by the previous patch.

Link: https://lkml.kernel.org/r/20230826111409.GA23243@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 init/init_task.c      |    1 -
 kernel/exit.c         |    1 -
 kernel/fork.c         |    3 ---
 4 files changed, 6 deletions(-)

--- a/include/linux/sched.h~kill-task_struct-thread_group
+++ a/include/linux/sched.h
@@ -1002,7 +1002,6 @@ struct task_struct {
 	/* PID/PID hash table linkage. */
 	struct pid			*thread_pid;
 	struct hlist_node		pid_links[PIDTYPE_MAX];
-	struct list_head		thread_group;
 	struct list_head		thread_node;
 
 	struct completion		*vfork_done;
--- a/init/init_task.c~kill-task_struct-thread_group
+++ a/init/init_task.c
@@ -132,7 +132,6 @@ struct task_struct init_task
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
 	.timer_slack_ns = 50000, /* 50 usec default slack */
 	.thread_pid	= &init_struct_pid,
-	.thread_group	= LIST_HEAD_INIT(init_task.thread_group),
 	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
 #ifdef CONFIG_AUDIT
 	.loginuid	= INVALID_UID,
--- a/kernel/exit.c~kill-task_struct-thread_group
+++ a/kernel/exit.c
@@ -133,7 +133,6 @@ static void __unhash_process(struct task
 		list_del_init(&p->sibling);
 		__this_cpu_dec(process_counts);
 	}
-	list_del_rcu(&p->thread_group);
 	list_del_rcu(&p->thread_node);
 }
 
--- a/kernel/fork.c~kill-task_struct-thread_group
+++ a/kernel/fork.c
@@ -2576,7 +2576,6 @@ __latent_entropy struct task_struct *cop
 	p->dirty_paused_when = 0;
 
 	p->pdeath_signal = 0;
-	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 	clear_posix_cputimers_work(p);
 
@@ -2704,8 +2703,6 @@ __latent_entropy struct task_struct *cop
 			atomic_inc(&current->signal->live);
 			refcount_inc(&current->signal->sigcnt);
 			task_join_group_stop(p);
-			list_add_tail_rcu(&p->thread_group,
-					  &p->group_leader->thread_group);
 			list_add_tail_rcu(&p->thread_node,
 					  &p->signal->thread_head);
 		}
_

Patches currently in -mm which might be from oleg@redhat.com are


