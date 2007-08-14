From: akpm@linux-foundation.org
Subject: + pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:15 -0700
Message-ID: <200708142005.l7EK5FFV018696@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45955 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483AbXHNUKh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:10:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: make proc_flush_task() actually from entries from multiple namespaces
has been added to the -mm tree.  Its filename is
     pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: make proc_flush_task() actually from entries from multiple namespaces
From: Pavel Emelyanov <xemul@openvz.org>

This means that proc_flush_task_mnt() is to be called for many proc mounts and
with different ids, depending on the namespace this pid is to be flushed from.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces
+++ a/fs/proc/base.c
@@ -2177,8 +2177,22 @@ out:
 
 void proc_flush_task(struct task_struct *task)
 {
-	proc_flush_task_mnt(proc_mnt, task->pid,
-			thread_group_leader(task) ? 0 : task->tgid);
+	int i, leader;
+	struct pid *pid, *tgid;
+	struct upid *upid;
+
+	leader = thread_group_leader(task);
+	proc_flush_task_mnt(proc_mnt, task->pid, leader ? task->tgid : 0);
+	pid = task_pid(task);
+	if (pid->level == 0)
+		return;
+
+	tgid = task_tgid(task);
+	for (i = 1; i <= pid->level; i++) {
+		upid = &pid->numbers[i];
+		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
+				leader ? 0 : tgid->numbers[i].nr);
+	}
 }
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
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
