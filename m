From: akpm@linux-foundation.org
Subject: - procfs-fix-listing-of-proc-not_a_tgid-task.patch removed from -mm tree
Date: Fri, 02 Feb 2007 13:37:52 -0800
Message-ID: <200702022137.l12Lbqw5018544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41563 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946121AbXBBViH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Feb 2007 16:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guichaz@yahoo.fr, ebiederm@xmission.com, oleg@tv-sign.ru, mm-commits@vger.kernel.org


The patch titled
     procfs: Fix listing of /proc/NOT_A_TGID/task
has been removed from the -mm tree.  Its filename was
     procfs-fix-listing-of-proc-not_a_tgid-task.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: procfs: Fix listing of /proc/NOT_A_TGID/task
From: Guillaume Chazarain <guichaz@yahoo.fr>

Listing /proc/PID/task were PID is not a TGID should not result in
duplicated entries.

[g ~]$ pidof thunderbird-bin
2751
[g ~]$ ls /proc/2751/task
2751  2770  2771  2824  2826  2834  2835  2851  2853
[g ~]$ ls /proc/2770/task
2751  2770  2771  2824  2826  2834  2835  2851  2853
2770  2771  2824  2826  2834  2835  2851  2853
[g ~]$

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff -puN fs/proc/base.c~procfs-fix-listing-of-proc-not_a_tgid-task fs/proc/base.c
--- a/fs/proc/base.c~procfs-fix-listing-of-proc-not_a_tgid-task
+++ a/fs/proc/base.c
@@ -2328,13 +2328,23 @@ static int proc_task_readdir(struct file
 {
 	struct dentry *dentry = filp->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
-	struct task_struct *leader = get_proc_task(inode);
+	struct task_struct *leader = NULL;
 	struct task_struct *task;
 	int retval = -ENOENT;
 	ino_t ino;
 	int tid;
 	unsigned long pos = filp->f_pos;  /* avoiding "long long" filp->f_pos */
 
+	task = get_proc_task(inode);
+	if (!task)
+		goto out_no_task;
+	rcu_read_lock();
+	if (pid_alive(task)) {
+		leader = task->group_leader;
+		get_task_struct(leader);
+	}
+	rcu_read_unlock();
+	put_task_struct(task);
 	if (!leader)
 		goto out_no_task;
 	retval = 0;
_

Patches currently in -mm which might be from guichaz@yahoo.fr are

origin.patch
factor-outstanding-i-o-error-handling.patch
factor-outstanding-i-o-error-handling-tidy.patch
sync_sb_inodes-propagate-errors.patch
block_write_full_page-handle-enospc.patch
