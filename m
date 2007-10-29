From: akpm@linux-foundation.org
Subject: + proc-simplify-and-correct-proc_flush_task.patch added to -mm tree
Date: Mon, 29 Oct 2007 15:11:57 -0700
Message-ID: <200710292211.l9TMBv3a028345@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035AbXJ2WMr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Oct 2007 18:12:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, dev@sw.ru, sukadev@us.ibm.com, viro@ftp.linux.org.uk, xemul@openvz.org


The patch titled
     proc: simplify and correct proc_flush_task
has been added to the -mm tree.  Its filename is
     proc-simplify-and-correct-proc_flush_task.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: proc: simplify and correct proc_flush_task
From: Eric W. Biederman <ebiederm@xmission.com>

Currently we special case when we have only the initial pid namespace. 
Unfortunately in doing so the copied case for the other namespaces was
broken so we don't properly flush the thread directories :(

So this patch removes the unnecessary special case (removing a usage of
proc_mnt) and corrects the flushing of the thread directories.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff -puN fs/proc/base.c~proc-simplify-and-correct-proc_flush_task fs/proc/base.c
--- a/fs/proc/base.c~proc-simplify-and-correct-proc_flush_task
+++ a/fs/proc/base.c
@@ -2328,21 +2328,18 @@ out:
 
 void proc_flush_task(struct task_struct *task)
 {
-	int i, leader;
-	struct pid *pid, *tgid;
+	int i;
+	struct pid *pid, *tgid = NULL;
 	struct upid *upid;
 
-	leader = thread_group_leader(task);
-	proc_flush_task_mnt(proc_mnt, task->pid, leader ? task->tgid : 0);
 	pid = task_pid(task);
-	if (pid->level == 0)
-		return;
+	if (thread_group_leader(task))
+		tgid = task_tgid(task);
 
-	tgid = task_tgid(task);
-	for (i = 1; i <= pid->level; i++) {
+	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
-				leader ? 0 : tgid->numbers[i].nr);
+			tgid ? tgid->numbers[i].nr : 0);
 	}
 
 	upid = &pid->numbers[pid->level];
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sunrpc-fix-rpc-debugging.patch
rd-fix-data-corruption-on-memory-pressure.patch
proc-simplify-and-correct-proc_flush_task.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
introduce-flags-for-reserve_bootmem.patch
use-bootmem_exclusive-for-kdump.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
