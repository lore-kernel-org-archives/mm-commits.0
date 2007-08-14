From: akpm@linux-foundation.org
Subject: + pid-namespaces-move-exit_task_namespaces.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:46 -0700
Message-ID: <200708142004.l7EK4kvA018586@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53934 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764782AbXHNUFV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: move exit_task_namespaces()
has been added to the -mm tree.  Its filename is
     pid-namespaces-move-exit_task_namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: move exit_task_namespaces()
From: Pavel Emelyanov <xemul@openvz.org>

Make task release its namespaces after it has reparented all his children to
child_reaper, but before it notifies its parent about its death.

The reason to release namespaces after reparenting is that when task exits it
may send a signal to its parent (SIGCHLD), but if the parent has already
exited its namespaces there will be no way to decide what pid to dever to him
- parent can be from different namespace.

The reason to release namespace before notifying the parent it that when task
sends a SIGCHLD to parent it can call wait() on this taks and release it.  But
releasing the mnt namespace implies dropping of all the mounts in the mnt
namespace and NFS expects the task to have valid sighand pointer.

Thanks to Oleg for pointing out some races that can apear and helping with
patches and fixes.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~pid-namespaces-move-exit_task_namespaces kernel/exit.c
--- a/kernel/exit.c~pid-namespaces-move-exit_task_namespaces
+++ a/kernel/exit.c
@@ -780,6 +780,7 @@ static void exit_notify(struct task_stru
 	 *	jobs, send them a SIGHUP and then a SIGCONT.  (POSIX 3.2.2.2)
 	 */
 	forget_original_parent(tsk);
+	exit_task_namespaces(tsk);
 
 	write_lock_irq(&tasklist_lock);
 	/*
@@ -983,7 +984,6 @@ fastcall NORET_TYPE void do_exit(long co
 
 	tsk->exit_code = code;
 	proc_exit_connector(tsk);
-	exit_task_namespaces(tsk);
 	exit_notify(tsk);
 #ifdef CONFIG_NUMA
 	mpol_free(tsk->mempolicy);
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
