From: akpm@linux-foundation.org
Subject: - pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:23:55 -0700
Message-ID: <200710190423.l9J4NtRc014915@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866AbXJSEYR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:24:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     pid-namespaces-changes-to-show-virtual-ids-to-user-fix
has been removed from the -mm tree.  Its filename was
     pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch

This patch was dropped because it was folded into pid-namespaces-changes-to-show-virtual-ids-to-user.patch

------------------------------------------------------
Subject: pid-namespaces-changes-to-show-virtual-ids-to-user-fix
From: Andrew Morton <akpm@linux-foundation.org>

unneeded casts..

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN fs/proc/base.c~pid-namespaces-changes-to-show-virtual-ids-to-user-fix fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-changes-to-show-virtual-ids-to-user-fix
+++ a/fs/proc/base.c
@@ -2293,7 +2293,7 @@ struct dentry *proc_pid_lookup(struct in
 	if (tgid == ~0U)
 		goto out;
 
-	ns = (struct pid_namespace *)dentry->d_sb->s_fs_info;
+	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tgid, ns);
 	if (task)
@@ -2374,7 +2374,7 @@ int proc_pid_readdir(struct file * filp,
 			goto out;
 	}
 
-	ns = (struct pid_namespace *)filp->f_dentry->d_sb->s_fs_info;
+	ns = filp->f_dentry->d_sb->s_fs_info;
 	tgid = filp->f_pos - TGID_OFFSET;
 	for (task = next_tgid(tgid, ns);
 	     task;
@@ -2515,7 +2515,7 @@ static struct dentry *proc_task_lookup(s
 	if (tid == ~0U)
 		goto out;
 
-	ns = (struct pid_namespace *)dentry->d_sb->s_fs_info;
+	ns = dentry->d_sb->s_fs_info;
 	rcu_read_lock();
 	task = find_task_by_pid_ns(tid, ns);
 	if (task)
@@ -2658,7 +2658,7 @@ static int proc_task_readdir(struct file
 	/* f_version caches the tgid value that the last readdir call couldn't
 	 * return. lseek aka telldir automagically resets f_version to 0.
 	 */
-	ns = (struct pid_namespace *)filp->f_dentry->d_sb->s_fs_info;
+	ns = filp->f_dentry->d_sb->s_fs_info;
 	tid = (int)filp->f_version;
 	filp->f_version = 0;
 	for (task = first_tid(leader, tid, pos - 2, ns);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
console-keyboard-events-and-accessibility.patch
add-kernel-notifierc.patch
console-events-and-accessibility.patch
fix-random-hard-freeze-with-avm-cards-using-b1dma.patch
jbd-config_jbd_debug-cannot-create-proc-entry.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
add-containerstats-v3.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
cpuset-sched_load_balance-flag-fix.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
remove-bits_to_type-macro-fix.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified-checkpatch-fixes.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
use-extended-crashkernel-command-line-on-i386.patch
hook-up-group-scheduler-with-control-groups-fix.patch
linux-kernel-markers-checkpatch-fixes.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
uninline-forkc-exitc-checkpatch-fixes.patch
