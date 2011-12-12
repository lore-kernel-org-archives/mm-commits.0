From: akpm@linux-foundation.org
Subject: + procfs-add-hidepid=-and-gid=-mount-options-fix.patch added to -mm tree
Date: Mon, 12 Dec 2011 15:13:58 -0800
Message-ID: <201112122313.pBCNDwJq029798@wpaz1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:36603 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab1LLXOC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2011 18:14:02 -0500
Received: by eekc1 with SMTP id c1so17851eek.1
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2011 15:14:01 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: segoon@openwall.com, adobriyan@gmail.com, hughd@google.com


The patch titled
     Subject: proc: fix task_struct memleak
has been added to the -mm tree.  Its filename is
     procfs-add-hidepid=-and-gid=-mount-options-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -649,9 +649,14 @@ static bool has_pid_permissions(struct p
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
Subject: Subject: proc: fix task_struct memleak

Patches currently in -mm which might be from segoon@openwall.com are

arch-arm-mach-ux500-mbox-db5500c-world-writable-sysfs-fifo-file.patch
procfs-make-proc_get_link-to-use-dentry-instead-of-inode.patch
procfs-introduce-the-proc-pid-map_files-directory.patch
procfs-parse-mount-options.patch
procfs-add-hidepid=-and-gid=-mount-options.patch
procfs-remove-superfluous-debug-output.patch
procfs-add-hidepid=-and-gid=-mount-options-fix.patch
c-r-introduce-checkpoint_restore-symbol.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4.patch
c-r-procfs-add-start_data-end_data-start_brk-members-to-proc-pid-stat-v4-fix.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries.patch
c-r-prctl-add-pr_set_mm-codes-to-set-up-mm_struct-entries-fix.patch

