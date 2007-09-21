From: akpm@linux-foundation.org
Subject: + make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch added to -mm tree
Date: Fri, 21 Sep 2007 00:23:26 -0700
Message-ID: <200709210723.l8L7NQFS024424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60963 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751013AbXIUHYA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Sep 2007 03:24:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clg@fr.ibm.com, ebiederm@xmission.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     make-access-to-tasks-nsproxy-lighter.patch breaks unshare()
has been added to the -mm tree.  Its filename is
     make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: make-access-to-tasks-nsproxy-lighter.patch breaks unshare()
From: Cedric Le Goater <clg@fr.ibm.com>

make-access-to-tasks-nsproxy-lighter.patch breaks unshare()

When called from unshare(), switch_task_namespaces() takes an extra
refcount on the nsproxy, leading to a memory leak of nsproxy objects.

Now the problem is that we still need that extra ref when called
from daemonize(). Here's an ugly fix for it.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nsproxy.h |    5 +++++
 kernel/exit.c           |    5 ++++-
 kernel/nsproxy.c        |    9 ---------
 3 files changed, 9 insertions(+), 10 deletions(-)

diff -puN include/linux/nsproxy.h~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare include/linux/nsproxy.h
--- a/include/linux/nsproxy.h~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare
+++ a/include/linux/nsproxy.h
@@ -77,6 +77,11 @@ static inline void put_nsproxy(struct ns
 	}
 }
 
+static inline void get_nsproxy(struct nsproxy *ns)
+{
+	atomic_inc(&ns->count);
+}
+
 #ifdef CONFIG_CGROUP_NS
 int ns_cgroup_clone(struct task_struct *tsk);
 #else
diff -puN kernel/exit.c~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare kernel/exit.c
--- a/kernel/exit.c~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare
+++ a/kernel/exit.c
@@ -408,7 +408,10 @@ void daemonize(const char *name, ...)
 	current->fs = fs;
 	atomic_inc(&fs->count);
 
-	switch_task_namespaces(current, init_task.nsproxy);
+	if (current->nsproxy != init_task.nsproxy) {
+		get_nsproxy(init_task.nsproxy);
+		switch_task_namespaces(current, init_task.nsproxy);
+	}
 
  	exit_files(current);
 	current->files = init_task.files;
diff -puN kernel/nsproxy.c~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare kernel/nsproxy.c
--- a/kernel/nsproxy.c~make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare
+++ a/kernel/nsproxy.c
@@ -25,11 +25,6 @@ static struct kmem_cache *nsproxy_cachep
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
-static inline void get_nsproxy(struct nsproxy *ns)
-{
-	atomic_inc(&ns->count);
-}
-
 /*
  * creates a copy of "orig" with refcount 1.
  */
@@ -204,11 +199,7 @@ void switch_task_namespaces(struct task_
 	might_sleep();
 
 	ns = p->nsproxy;
-	if (ns == new)
-		return;
 
-	if (new)
-		get_nsproxy(new);
 	rcu_assign_pointer(p->nsproxy, new);
 
 	if (ns && atomic_dec_and_test(&ns->count)) {
_

Patches currently in -mm which might be from clg@fr.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
ipc-namespace-remove-config-ipc-ns-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
