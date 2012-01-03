From: akpm@linux-foundation.org
Subject: [folded] procfs-add-hidepid=-and-gid=-mount-options-fix.patch removed from -mm tree
Date: Tue, 03 Jan 2012 13:57:23 -0800
Message-ID: <20120103215723.E2F2C1E0058@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:38398 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2ACV5Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jan 2012 16:57:24 -0500
Received: by yenm5 with SMTP id m5so2051158yen.1
        for <mm-commits@vger.kernel.org>; Tue, 03 Jan 2012 13:57:24 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: segoon@openwall.com, adobriyan@gmail.com, hughd@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix task_struct memleak
has been removed from the -mm tree.  Its filename was
     procfs-add-hidepid=-and-gid=-mount-options-fix.patch

This patch was dropped because it was folded into procfs-add-hidepid=-and-gid=-mount-options.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Vasiliy Kulikov <segoon@openwall.com>
Subject: proc: fix task_struct memleak

proc_pid_permission() doesn't put task_struct on every /proc/$pid/
access.  A demo from Hugh Dickins:

while :; do ps; grep KernelStack /proc/meminfo; sleep 1; done

Reported-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~procfs-add-hidepid=-and-gid=-mount-options-fix fs/proc/base.c
--- a/fs/proc/base.c~procfs-add-hidepid=-and-gid=-mount-options-fix
+++ a/fs/proc/base.c
@@ -650,9 +650,14 @@ static bool has_pid_permissions(struct p
 static int proc_pid_permission(struct inode *inode, int mask)
 {
 	struct pid_namespace *pid = inode->i_sb->s_fs_info;
-	struct task_struct *task = get_proc_task(inode);
+	struct task_struct *task;
+	bool has_perms;
+
+	task = get_proc_task(inode);
+	has_perms = has_pid_permissions(pid, task, 1);
+	put_task_struct(task);
 
-	if (!has_pid_permissions(pid, task, 1)) {
+	if (!has_perms) {
 		if (pid->hide_pid == 2) {
 			/*
 			 * Let's make getdents(), stat(), and open()
_

Patches currently in -mm which might be from segoon@openwall.com are

arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-introduce-the-proc-pid-map_files-directory-make-proc-pid-map_files-being-checkpoint_restore-dependent.patch
procfs-parse-mount-options.patch
procfs-parse-mount-options-fix.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

