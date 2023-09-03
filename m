Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32DDC71153
	for <mm-commits@archiver.kernel.org>; Sun,  3 Sep 2023 23:51:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbjICXvF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 19:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241341AbjICXvE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 19:51:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037F6101
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 16:51:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5D0E0CE094F
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 23:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A9EC433C7;
        Sun,  3 Sep 2023 23:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785057;
        bh=nwbj7UxtRKFUC+TtIrrFoqqzsWrin6Bknz0PyClRluY=;
        h=Date:To:From:Subject:From;
        b=F/JGnqs/cmaPFHtCyJRD5UXLBn99pPmJrI3HaQwULwDC2wa8Pd1domaGQJJRyg3hO
         GYQlKVn4BOMCPeDyl17zF4RM+hJIJbK8g0G4Xzri9IDNTV1TyY0P3aWl5duuQaEvwW
         WT4nZI0FQM00uqv6s27vMjISM6BZe9lOi1prhUNw=
Date:   Sun, 03 Sep 2023 16:50:55 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com, oleg@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kill-task_struct-thread_group.patch added to mm-nonmm-unstable branch
Message-Id: <20230903235057.A7A9EC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kill task_struct->thread_group
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kill-task_struct-thread_group.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kill-task_struct-thread_group.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: kill task_struct->thread_group
Date: Sat, 26 Aug 2023 13:14:09 +0200

The last user was removed by the previous patch.

Link: https://lkml.kernel.org/r/20230826111409.GA23243@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 init/init_task.c      |    1 -
 kernel/exit.c         |    1 -
 kernel/fork.c         |    3 ---
 4 files changed, 6 deletions(-)

--- a/include/linux/sched.h~kill-task_struct-thread_group
+++ a/include/linux/sched.h
@@ -997,7 +997,6 @@ struct task_struct {
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
@@ -2575,7 +2575,6 @@ __latent_entropy struct task_struct *cop
 	p->dirty_paused_when = 0;
 
 	p->pdeath_signal = 0;
-	INIT_LIST_HEAD(&p->thread_group);
 	p->task_works = NULL;
 	clear_posix_cputimers_work(p);
 
@@ -2703,8 +2702,6 @@ __latent_entropy struct task_struct *cop
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

change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch

