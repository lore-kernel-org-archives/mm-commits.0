From: akpm@osdl.org
Subject: + introduce-and-use-get_task_mnt_ns.patch added to -mm tree
Date: Thu, 25 Jan 2007 22:35:15 -0800
Message-ID: <200701260635.l0Q6ZFIo009494@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48213 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030794AbXAZGfu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jan 2007 01:35:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@openvz.org, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     Introduce and use get_task_mnt_ns()
has been added to the -mm tree.  Its filename is
     introduce-and-use-get_task_mnt_ns.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
 kernel/nsproxy.c        |   14 ++++++++++++++
 3 files changed, 17 insertions(+), 13 deletions(-)

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
@@ -36,6 +36,7 @@ int copy_namespaces(int flags, struct ta
 void get_task_namespaces(struct task_struct *tsk);
 void free_nsproxy(struct nsproxy *ns);
 struct nsproxy *put_nsproxy(struct nsproxy *ns);
+struct mnt_namespace *get_task_mnt_ns(struct task_struct *tsk);
 
 static inline void finalize_put_nsproxy(struct nsproxy *ns)
 {
diff -puN kernel/nsproxy.c~introduce-and-use-get_task_mnt_ns kernel/nsproxy.c
--- a/kernel/nsproxy.c~introduce-and-use-get_task_mnt_ns
+++ a/kernel/nsproxy.c
@@ -161,3 +161,17 @@ void free_nsproxy(struct nsproxy *ns)
 		put_pid_ns(ns->pid_ns);
 	kfree(ns);
 }
+
+struct mnt_namespace * get_task_mnt_ns(struct task_struct *tsk)
+{
+	struct mnt_namespace *mnt_ns = NULL;
+
+	task_lock(tsk);
+	if (tsk->nsproxy)
+		mnt_ns = tsk->nsproxy->mnt_ns;
+	if (mnt_ns)
+		get_mnt_ns(mnt_ns);
+	task_unlock(tsk);
+
+	return mnt_ns;
+}
_

Patches currently in -mm which might be from adobriyan@openvz.org are

fix-null-nsproxy-dereference-in-proc-mounts.patch
core-dumping-unreadable-binaries-via-pt_interp.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
consolidate-default-sched_clock.patch
fix-rmmod-read-write-races-in-proc-entries.patch
consolidate-bust_spinlocks.patch
extract-and-use-wake_up_klogd.patch
introduce-and-use-get_task_mnt_ns.patch
introduce-and-use-get_task_mnt_ns-tweaks.patch
