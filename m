From: akpm@linux-foundation.org
Subject: - remove-unused-variables-from-fs-proc-basec.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:53:18 -0700
Message-ID: <200710192253.l9JMrIok024415@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54224 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764829AbXJSXFQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Remove unused variables from fs/proc/base.c
has been removed from the -mm tree.  Its filename was
     remove-unused-variables-from-fs-proc-basec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Remove unused variables from fs/proc/base.c
From: Pavel Emelyanov <xemul@openvz.org>

When removing the explicit task_struct->pid usage I found that
proc_readfd_common() and proc_pident_readdir() get this field, but do not
use it at all.  So this cleanup is a cheap help with the task_struct->pid
isolation.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN fs/proc/base.c~remove-unused-variables-from-fs-proc-basec fs/proc/base.c
--- a/fs/proc/base.c~remove-unused-variables-from-fs-proc-basec
+++ a/fs/proc/base.c
@@ -1519,7 +1519,7 @@ static int proc_readfd_common(struct fil
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *p = get_proc_task(inode);
-	unsigned int fd, tid, ino;
+	unsigned int fd, ino;
 	int retval;
 	struct files_struct * files;
 	struct fdtable *fdt;
@@ -1528,7 +1528,6 @@ static int proc_readfd_common(struct fil
 	if (!p)
 		goto out_no_task;
 	retval = 0;
-	tid = p->pid;
 
 	fd = filp->f_pos;
 	switch (fd) {
@@ -1763,7 +1762,6 @@ static int proc_pident_readdir(struct fi
 		const struct pid_entry *ents, unsigned int nents)
 {
 	int i;
-	int pid;
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	struct task_struct *task = get_proc_task(inode);
@@ -1776,7 +1774,6 @@ static int proc_pident_readdir(struct fi
 		goto out_no_task;
 
 	ret = 0;
-	pid = task->pid;
 	i = filp->f_pos;
 	switch (i) {
 	case 0:
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
