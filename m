From: akpm@linux-foundation.org
Subject: - pidns-make-pid-level-and-pid_ns-level-unsigned.patch removed from -mm tree
Date: Thu, 01 May 2008 02:31:36 -0700
Message-ID: <200805010931.m419Vah6030887@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757263AbYEAJbj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:31:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     pidns: make pid->level and pid_ns->level unsigned
has been removed from the -mm tree.  Its filename was
     pidns-make-pid-level-and-pid_ns-level-unsigned.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pidns: make pid->level and pid_ns->level unsigned
From: Pavel Emelyanov <xemul@openvz.org>

These values represent the nesting level of a namespace and pids living in it,
and it's always non-negative.

Turning this from int to unsigned int saves some space in pid.c (11 bytes on
x86 and 64 on ia64) by letting the compiler optimize the pid_nr_ns a bit. 
E.g.  on ia64 this removes the sign extension calls, which compiler adds to
optimize access to pid->nubers[ns->level].

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid.h           |    2 +-
 include/linux/pid_namespace.h |    2 +-
 kernel/pid_namespace.c        |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN include/linux/pid.h~pidns-make-pid-level-and-pid_ns-level-unsigned include/linux/pid.h
--- a/include/linux/pid.h~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/include/linux/pid.h
@@ -60,7 +60,7 @@ struct pid
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
-	int level;
+	unsigned int level;
 	struct upid numbers[1];
 };
 
diff -puN include/linux/pid_namespace.h~pidns-make-pid-level-and-pid_ns-level-unsigned include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/include/linux/pid_namespace.h
@@ -20,7 +20,7 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
-	int level;
+	unsigned int level;
 	struct pid_namespace *parent;
 #ifdef CONFIG_PROC_FS
 	struct vfsmount *proc_mnt;
diff -puN kernel/pid_namespace.c~pidns-make-pid-level-and-pid_ns-level-unsigned kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~pidns-make-pid-level-and-pid_ns-level-unsigned
+++ a/kernel/pid_namespace.c
@@ -66,7 +66,7 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(int level)
+static struct pid_namespace *create_pid_namespace(unsigned int level)
 {
 	struct pid_namespace *ns;
 	int i;
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
disable-the-memory-controller-by-default-v3.patch
reiser4.patch
put_pid-make-sure-we-dont-free-the-live-pid.patch

