From: akpm@linux-foundation.org
Subject: + pid-namespaces-move-alloc_pid-to-copy_process.patch added to -mm tree
Date: Fri, 20 Jul 2007 15:41:43 -0700
Message-ID: <200707202241.l6KMfhYG020291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938539AbXGTWnD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 18:43:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, serue@us.ibm.com, xemul@openvz.org


The patch titled
     pid namespaces: move alloc_pid() to copy_process()
has been added to the -mm tree.  Its filename is
     pid-namespaces-move-alloc_pid-to-copy_process.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: move alloc_pid() to copy_process()
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Move alloc_pid() into copy_process().  This will keep all pid and pid
namespace code together and simplify error handling when we support multiple
pid namespaces.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzel <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff -puN kernel/fork.c~pid-namespaces-move-alloc_pid-to-copy_process kernel/fork.c
--- a/kernel/fork.c~pid-namespaces-move-alloc_pid-to-copy_process
+++ a/kernel/fork.c
@@ -1027,6 +1027,12 @@ static struct task_struct *copy_process(
 	if (p->binfmt && !try_module_get(p->binfmt->module))
 		goto bad_fork_cleanup_put_domain;
 
+	if (pid != &init_struct_pid) {
+		pid = alloc_pid();
+		if (!pid)
+			goto bad_fork_put_binfmt_module;
+	}
+
 	p->did_exec = 0;
 	delayacct_tsk_init(p);	/* Must remain after dup_task_struct() */
 	copy_flags(clone_flags, p);
@@ -1315,6 +1321,9 @@ bad_fork_cleanup_container:
 #endif
 	container_exit(p, container_callbacks_done);
 	delayacct_tsk_free(p);
+	if (pid != &init_struct_pid)
+		free_pid(pid);
+bad_fork_put_binfmt_module:
 	if (p->binfmt)
 		module_put(p->binfmt->module);
 bad_fork_cleanup_put_domain:
@@ -1379,19 +1388,16 @@ long do_fork(unsigned long clone_flags,
 {
 	struct task_struct *p;
 	int trace = 0;
-	struct pid *pid = alloc_pid();
 	long nr;
 
-	if (!pid)
-		return -EAGAIN;
-	nr = pid->nr;
 	if (unlikely(current->ptrace)) {
 		trace = fork_traceflag (clone_flags);
 		if (trace)
 			clone_flags |= CLONE_PTRACE;
 	}
 
-	p = copy_process(clone_flags, stack_start, regs, stack_size, parent_tidptr, child_tidptr, pid);
+	p = copy_process(clone_flags, stack_start, regs, stack_size,
+			parent_tidptr, child_tidptr, NULL);
 	/*
 	 * Do this prior waking up the new thread - the thread pointer
 	 * might get invalid after that point, if the thread exits quickly.
@@ -1399,6 +1405,8 @@ long do_fork(unsigned long clone_flags,
 	if (!IS_ERR(p)) {
 		struct completion vfork;
 
+		nr = pid_nr(task_pid(p));
+
 		if (clone_flags & CLONE_VFORK) {
 			p->vfork_done = &vfork;
 			init_completion(&vfork);
@@ -1432,7 +1440,6 @@ long do_fork(unsigned long clone_flags,
 			}
 		}
 	} else {
-		free_pid(pid);
 		nr = PTR_ERR(p);
 	}
 	return nr;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
