From: akpm@osdl.org
Subject: - allowing-user-processes-to-rise-their-oom_adj-value.patch removed from -mm tree
Date: Thu, 07 Dec 2006 14:56:55 -0800
Message-ID: <200612072256.kB7Mut6l029248@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:50544 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163605AbWLGW5H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 17:57:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: guillem.jover@nokia.com, andrea@novell.com, mm-commits@vger.kernel.org


The patch titled
     Allow user processes to raise their oom_adj value
has been removed from the -mm tree.  Its filename was
     allowing-user-processes-to-rise-their-oom_adj-value.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Allow user processes to raise their oom_adj value
From: Guillem Jover <guillem.jover@nokia.com>

Currently a user process cannot rise its own oom_adj value (i.e. 
unprotecting itself from the OOM killer).  As this value is stored in the
task structure it gets inherited and the unprivileged childs will be unable
to rise it.

The EPERM will be handled by the generic proc fs layer, as only processes
with the proper caps or the owner of the process will be able to write to
the file.  So we allow only the processes with CAP_SYS_RESOURCE to lower
the value, otherwise it will get an EACCES which seems more appropriate
than EPERM.

Signed-off-by: Guillem Jover <guillem.jover@nokia.com>
Acked-by: Andrea Arcangeli <andrea@novell.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/proc/base.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/proc/base.c~allowing-user-processes-to-rise-their-oom_adj-value fs/proc/base.c
--- a/fs/proc/base.c~allowing-user-processes-to-rise-their-oom_adj-value
+++ a/fs/proc/base.c
@@ -683,8 +683,6 @@ static ssize_t oom_adjust_write(struct f
 	char buffer[PROC_NUMBUF], *end;
 	int oom_adjust;
 
-	if (!capable(CAP_SYS_RESOURCE))
-		return -EPERM;
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
@@ -699,6 +697,10 @@ static ssize_t oom_adjust_write(struct f
 	task = get_proc_task(file->f_dentry->d_inode);
 	if (!task)
 		return -ESRCH;
+	if (oom_adjust < task->oomkilladj && !capable(CAP_SYS_RESOURCE)) {
+		put_task_struct(task);
+		return -EACCES;
+	}
 	task->oomkilladj = oom_adjust;
 	put_task_struct(task);
 	if (end - buffer == 0)
_

Patches currently in -mm which might be from guillem.jover@nokia.com are

origin.patch

