From: akpm@linux-foundation.org
Subject: + mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch added to -mm tree
Date: Fri, 13 Jan 2012 16:48:45 -0800
Message-ID: <20120114004846.94AE15C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:42007 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab2ANAss (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 19:48:48 -0500
Received: by mail-ey0-f202.google.com with SMTP id d12so30547eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 16:48:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     Subject: mm, oom: do not emit oom killer warning if chosen thread is already exiting
has been added to the -mm tree.  Its filename is
     mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, oom: do not emit oom killer warning if chosen thread is already exiting

If a thread is chosen for oom kill and is already PF_EXITING, then the oom
killer simply sets TIF_MEMDIE and returns.  This allows the thread to have
access to memory reserves so that it may quickly exit.  This logic is
preceeded with a comment saying there's no need to alarm the sysadmin. 
This patch adds truth to that statement.

There's no need to emit any warning about the oom condition if the thread
is already exiting since it will not be killed.  In this condition, just
silently return the oom killer since its only giving access to memory
reserves and is otherwise a no-op.

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting
+++ a/mm/oom_kill.c
@@ -445,9 +445,6 @@ static void oom_kill_process(struct task
 	struct mm_struct *mm;
 	unsigned int victim_points = 0;
 
-	if (printk_ratelimit())
-		dump_header(p, gfp_mask, order, memcg, nodemask);
-
 	/*
 	 * If the task is already exiting, don't alarm the sysadmin or kill
 	 * its children or threads, just set TIF_MEMDIE so it can die quickly
@@ -457,6 +454,9 @@ static void oom_kill_process(struct task
 		return;
 	}
 
+	if (printk_ratelimit())
+		dump_header(p, gfp_mask, order, memcg, nodemask);
+
 	task_lock(p);
 	pr_err("%s: Kill process %d (%s) score %d or sacrifice child\n",
 		message, task_pid_nr(p), p->comm, points);
_
Subject: Subject: mm, oom: do not emit oom killer warning if chosen thread is already exiting

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch
proc-clear_refs-do-not-clear-reserved-pages.patch
mm-oom-avoid-looping-when-chosen-thread-detaches-its-mm.patch
mm-oom-fold-oom_kill_task-into-oom_kill_process.patch
mm-oom-do-not-emit-oom-killer-warning-if-chosen-thread-is-already-exiting.patch

