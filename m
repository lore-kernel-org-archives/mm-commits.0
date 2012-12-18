From: akpm@linux-foundation.org
Subject: [merged] pidns-remove-unused-is_container_init.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:25 -0800
Message-ID: <20121218200925.ABABC82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:53948 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2LRUJ0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:26 -0500
Received: by mail-ye0-f201.google.com with SMTP id r11so126065yen.2
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:26 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gaofeng@cn.fujitsu.com, dhowells@redhat.com, ebiederm@xmission.com, jmorris@namei.org, serge.hallyn@canonical.com, mm-commits@vger.kernel.org


The patch titled
     Subject: pidns: remove unused is_container_init()
has been removed from the -mm tree.  Its filename was
     pidns-remove-unused-is_container_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: pidns: remove unused is_container_init()

Since commit 1cdcbec1a3 ("CRED: Neuter sys_capset()") is_container_init()
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
@@ -1778,12 +1778,6 @@ static inline int is_global_init(struct 
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
