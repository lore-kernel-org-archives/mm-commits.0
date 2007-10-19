From: akpm@linux-foundation.org
Subject: - uninline-forkc-exitc-checkpatch-fixes.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:37:14 -0700
Message-ID: <200710190437.l9J4bEw6015425@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753600AbXJSEiI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:38:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@sw.ru, arjan@infradead.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     uninline-forkc-exitc-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     uninline-forkc-exitc-checkpatch-fixes.patch

This patch was dropped because it was folded into uninline-forkc-exitc.patch

------------------------------------------------------
Subject: uninline-forkc-exitc-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#85: FILE: kernel/fork.c:624:
+static int copy_fs(unsigned long clone_flags, struct task_struct * tsk)

ERROR: "foo * bar" should be "foo *bar"
#94: FILE: kernel/fork.c:827:
+static int copy_sighand(unsigned long clone_flags, struct task_struct * tsk)

ERROR: "foo * bar" should be "foo *bar"
#103: FILE: kernel/fork.c:850:
+static int copy_signal(unsigned long clone_flags, struct task_struct * tsk)

WARNING: no space between function name and open parenthesis '('
#139: FILE: kernel/fork.c:1396:
+static int fork_traceflag (unsigned clone_flags)

Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/fork.c~uninline-forkc-exitc-checkpatch-fixes kernel/fork.c
--- a/kernel/fork.c~uninline-forkc-exitc-checkpatch-fixes
+++ a/kernel/fork.c
@@ -621,7 +621,7 @@ struct fs_struct *copy_fs_struct(struct 
 
 EXPORT_SYMBOL_GPL(copy_fs_struct);
 
-static int copy_fs(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
 {
 	if (clone_flags & CLONE_FS) {
 		atomic_inc(&current->fs->count);
@@ -824,7 +824,7 @@ int unshare_files(void)
 
 EXPORT_SYMBOL(unshare_files);
 
-static int copy_sighand(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_sighand(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct sighand_struct *sig;
 
@@ -847,7 +847,7 @@ void __cleanup_sighand(struct sighand_st
 		kmem_cache_free(sighand_cachep, sighand);
 }
 
-static int copy_signal(unsigned long clone_flags, struct task_struct * tsk)
+static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
 	int ret;
@@ -1387,7 +1387,7 @@ struct task_struct * __cpuinit fork_idle
 	return task;
 }
 
-static int fork_traceflag (unsigned clone_flags)
+static int fork_traceflag(unsigned clone_flags)
 {
 	if (clone_flags & CLONE_UNTRACED)
 		return 0;
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
cpuset-sched_load_balance-flag.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
remove-bits_to_type-macro.patch
use-helpers-to-obtain-task-pid-in-printks.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
cpu-hotplug-avoid-hotadd-when-proper-possible_map-isnt-specified.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
hook-up-group-scheduler-with-control-groups.patch
linux-kernel-markers.patch
linux-kernel-markers-samples.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
