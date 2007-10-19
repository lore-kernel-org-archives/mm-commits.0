From: akpm@linux-foundation.org
Subject: - fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:19:22 -0700
Message-ID: <200710190419.l9J4JMK0014706@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751555AbXJSETZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:19:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, matthias.kaehlcke@gmail.com, mm-commits@vger.kernel.org


The patch titled
     fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix
has been removed from the -mm tree.  Its filename was
     fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch

This patch was dropped because it was folded into fs-superc-use-list_for_each_entry-instead-of-list_for_each.patch

------------------------------------------------------
Subject: fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix
From: Andrew Morton <akpm@linux-foundation.org>

clean up some crap while we're there.

Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix fs/super.c
--- a/fs/super.c~fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix
+++ a/fs/super.c
@@ -337,14 +337,16 @@ struct super_block *sget(struct file_sys
 
 retry:
 	spin_lock(&sb_lock);
-	if (test) list_for_each_entry(old, &type->fs_supers, s_instances) {
-		if (!test(old, data))
-			continue;
-		if (!grab_super(old))
-			goto retry;
-		if (s)
-			destroy_super(s);
-		return old;
+	if (test) {
+		list_for_each_entry(old, &type->fs_supers, s_instances) {
+			if (!test(old, data))
+				continue;
+			if (!grab_super(old))
+				goto retry;
+			if (s)
+				destroy_super(s);
+			return old;
+		}
 	}
 	if (!s) {
 		spin_unlock(&sb_lock);
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
fs-superc-use-list_for_each_entry-instead-of-list_for_each-fix.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
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
