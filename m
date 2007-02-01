From: akpm@osdl.org
Subject: - statically-initialize-struct-pid-for-swapper.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:25:10 -0800
Message-ID: <200702010126.l111Q8SI032673@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35820 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161223AbXBAB2R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:28:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sukadev@us.ibm.com, clg@fr.ibm.com, containers@lists.osdl.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Statically initialize struct pid for swapper
has been removed from the -mm tree.  Its filename was
     statically-initialize-struct-pid-for-swapper.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Statically initialize struct pid for swapper
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Statically initialize a struct pid for the swapper process (pid_t == 0) and
attach it to init_task.  This is needed so task_pid(), task_pgrp() and
task_session() interfaces work on the swapper process also.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: <containers@lists.osdl.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/init_task.h |   27 +++++++++++++++++++++++++++
 include/linux/pid.h       |    2 ++
 kernel/pid.c              |    2 ++
 3 files changed, 31 insertions(+)

diff -puN include/linux/init_task.h~statically-initialize-struct-pid-for-swapper include/linux/init_task.h
--- a/include/linux/init_task.h~statically-initialize-struct-pid-for-swapper
+++ a/include/linux/init_task.h
@@ -90,6 +90,28 @@ extern struct nsproxy init_nsproxy;
 
 extern struct group_info init_groups;
 
+#define INIT_STRUCT_PID {						\
+	.count 		= ATOMIC_INIT(1),				\
+	.nr		= 0, 						\
+	/* Don't put this struct pid in pid_hash */			\
+	.pid_chain	= { .next = NULL, .pprev = NULL },		\
+	.tasks		= {						\
+		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
+		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
+		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
+	},								\
+	.rcu		= RCU_HEAD_INIT,				\
+}
+
+#define INIT_PID_LINK(type) 					\
+{								\
+	.node = {						\
+		.next = NULL,					\
+		.pprev = &init_struct_pid.tasks[type].first,	\
+	},							\
+	.pid = &init_struct_pid,				\
+}
+
 /*
  *  INIT_TASK is used to set up the first task table, touch at
  * your own risk!. Base=0, limit=0x1fffff (=2MB)
@@ -141,6 +163,11 @@ extern struct group_info init_groups;
 	.cpu_timers	= INIT_CPU_TIMERS(tsk.cpu_timers),		\
 	.fs_excl	= ATOMIC_INIT(0),				\
 	.pi_lock	= SPIN_LOCK_UNLOCKED,				\
+	.pids = {							\
+		[PIDTYPE_PID]  = INIT_PID_LINK(PIDTYPE_PID),		\
+		[PIDTYPE_PGID] = INIT_PID_LINK(PIDTYPE_PGID),		\
+		[PIDTYPE_SID]  = INIT_PID_LINK(PIDTYPE_SID),		\
+	},								\
 	INIT_TRACE_IRQFLAGS						\
 	INIT_LOCKDEP							\
 }
diff -puN include/linux/pid.h~statically-initialize-struct-pid-for-swapper include/linux/pid.h
--- a/include/linux/pid.h~statically-initialize-struct-pid-for-swapper
+++ a/include/linux/pid.h
@@ -51,6 +51,8 @@ struct pid
 	struct rcu_head rcu;
 };
 
+extern struct pid init_struct_pid;
+
 struct pid_link
 {
 	struct hlist_node node;
diff -puN kernel/pid.c~statically-initialize-struct-pid-for-swapper kernel/pid.c
--- a/kernel/pid.c~statically-initialize-struct-pid-for-swapper
+++ a/kernel/pid.c
@@ -27,11 +27,13 @@
 #include <linux/bootmem.h>
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
+#include <linux/init_task.h>
 
 #define pid_hashfn(nr) hash_long((unsigned long)nr, pidhash_shift)
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
 static struct kmem_cache *pid_cachep;
+struct pid init_struct_pid = INIT_STRUCT_PID;
 
 int pid_max = PID_MAX_DEFAULT;
 
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

statically-initialize-struct-pid-for-swapper.patch
explicitly-set-pgid-sid-of-init.patch
