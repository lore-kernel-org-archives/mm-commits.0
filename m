From: akpm@linux-foundation.org
Subject: + pidns-remove-unused-is_container_init.patch added to -mm tree
Date: Mon, 19 Nov 2012 13:32:27 -0800
Message-ID: <20121119213228.1C6EB20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:36739 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab2KSVca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Nov 2012 16:32:30 -0500
Received: by mail-wi0-f202.google.com with SMTP id cb5so25836wib.1
        for <mm-commits@vger.kernel.org>; Mon, 19 Nov 2012 13:32:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gaofeng@cn.fujitsu.com, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com


The patch titled
     Subject: pidns: remove unused is_container_init()
has been added to the -mm tree.  Its filename is
     pidns-remove-unused-is_container_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: pidns: remove unused is_container_init()

since commit 1cdcbec1a3 ("CRED: Neuter sys_capset()") is_container_init()
has no callers.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    6 ------
 kernel/pid.c          |   15 ---------------
 2 files changed, 21 deletions(-)

diff -puN include/linux/sched.h~pidns-remove-unused-is_container_init include/linux/sched.h
--- a/include/linux/sched.h~pidns-remove-unused-is_container_init
+++ a/include/linux/sched.h
@@ -1769,12 +1769,6 @@ static inline int is_global_init(struct 
 	return tsk->pid == 1;
 }
 
-/*
- * is_container_init:
- * check whether in the task is init in its own pid namespace.
- */
-extern int is_container_init(struct task_struct *tsk);
-
 extern struct pid *cad_pid;
 
 extern void free_task(struct task_struct *tsk);
diff -puN kernel/pid.c~pidns-remove-unused-is_container_init kernel/pid.c
--- a/kernel/pid.c~pidns-remove-unused-is_container_init
+++ a/kernel/pid.c
@@ -81,21 +81,6 @@ struct pid_namespace init_pid_ns = {
 };
 EXPORT_SYMBOL_GPL(init_pid_ns);
 
-int is_container_init(struct task_struct *tsk)
-{
-	int ret = 0;
-	struct pid *pid;
-
-	rcu_read_lock();
-	pid = task_pid(tsk);
-	if (pid != NULL && pid->numbers[pid->level].nr == 1)
-		ret = 1;
-	rcu_read_unlock();
-
-	return ret;
-}
-EXPORT_SYMBOL(is_container_init);
