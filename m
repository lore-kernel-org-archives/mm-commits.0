From: akpm@osdl.org
Subject: - introduce-and-use-get_task_mnt_ns.patch removed from -mm tree
Date: Wed, 31 Jan 2007 17:24:43 -0800
Message-ID: <200702010125.l111Pfkp032626@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35719 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXBAB0k (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 31 Jan 2007 20:26:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Introduce and use get_task_mnt_ns()
has been removed from the -mm tree.  Its filename was
     introduce-and-use-get_task_mnt_ns.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: Introduce and use get_task_mnt_ns()
From: Alexey Dobriyan <adobriyan@openvz.org>

Similar to get_task_mm(): get a reference to task's mnt namespace if any.
Suggested by Pavel Emelianov.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c          |   15 ++-------------
 include/linux/nsproxy.h |    1 +
 kernel/nsproxy.c        |   15 +++++++++++++++
 3 files changed, 18 insertions(+), 13 deletions(-)

diff -puN fs/proc/base.c~introduce-and-use-get_task_mnt_ns fs/proc/base.c
--- a/fs/proc/base.c~introduce-and-use-get_task_mnt_ns
+++ a/fs/proc/base.c
@@ -370,13 +370,7 @@ static int mounts_open(struct inode *ino
 	int ret = -EINVAL;
 
 	if (task) {
-		task_lock(task);
-		if (task->nsproxy) {
-			ns = task->nsproxy->mnt_ns;
-			if (ns)
-				get_mnt_ns(ns);
-		}
-		task_unlock(task);
+		ns = get_task_mnt_ns(task);
 		put_task_struct(task);
 	}
 
@@ -443,12 +437,7 @@ static int mountstats_open(struct inode 
 		struct task_struct *task = get_proc_task(inode);
 
 		if (task) {
-			task_lock(task);
-			if (task->nsproxy)
-				mnt_ns = task->nsproxy->mnt_ns;
-			if (mnt_ns)
-				get_mnt_ns(mnt_ns);
-			task_unlock(task);
+			mnt_ns = get_task_mnt_ns(task);
 			put_task_struct(task);
 		}
 
diff -puN include/linux/nsproxy.h~introduce-and-use-get_task_mnt_ns include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~introduce-and-use-get_task_mnt_ns
+++ a/include/linux/nsproxy.h
@@ -35,6 +35,7 @@ struct nsproxy *dup_namespaces(struct ns
 int copy_namespaces(int flags, struct task_struct *tsk);
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
+struct mnt_namespace *get_task_mnt_ns(struct task_struct *tsk);
 
 static inline void put_nsproxy(struct nsproxy *ns)
 {
diff -puN kernel/nsproxy.c~introduce-and-use-get_task_mnt_ns kernel/nsproxy.c
--- a/kernel/nsproxy.c~introduce-and-use-get_task_mnt_ns
+++ a/kernel/nsproxy.c
@@ -147,3 +147,18 @@ void free_nsproxy(struct nsproxy *ns)
 		put_pid_ns(ns->pid_ns);
 	kfree(ns);
 }
+
+struct mnt_namespace *get_task_mnt_ns(struct task_struct *tsk)
+{
+	struct mnt_namespace *mnt_ns = NULL;
+
+	task_lock(tsk);
+	if (tsk->nsproxy) {
+		mnt_ns = tsk->nsproxy->mnt_ns;
+		if (mnt_ns)
+			get_mnt_ns(mnt_ns);
+	}
+	task_unlock(tsk);
+
+	return mnt_ns;
+}
_

Patches currently in -mm which might be from adobriyan@openvz.org are

revert-x86_64-mm-msr-on-cpu.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
sn2-use-static-proc_fops.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
introduce-and-use-get_task_mnt_ns.patch
lutimesat-simplify-utime2.patch
lutimesat-extend-do_utimes-with-flags.patch
lutimesat-actual-syscall-and-wire-up-on-i386.patch
