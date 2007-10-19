From: akpm@linux-foundation.org
Subject: - pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:51:48 -0700
Message-ID: <200710192251.l9JMpmlg024212@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764443AbXJSXG0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     pid namespaces: make proc_flush_task() actually from entries from multiple namespaces
has been removed from the -mm tree.  Its filename was
     pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 16 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces fs/proc/base.c
--- a/fs/proc/base.c~pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces
+++ a/fs/proc/base.c
@@ -2259,8 +2259,22 @@ out:
 
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

origin.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
