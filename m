From: akpm@linux-foundation.org
Subject: [merged] proc-fix-null-pointer-deref-in-proc_pid_permission.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:31:21 -0800
Message-ID: <20120113203122.2B0B020004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:56633 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759018Ab2AMUbZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:31:25 -0500
Received: by eeke50 with SMTP id e50so23612eek.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:31:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xtfeng@gmail.com, dannyfeng@tencent.com, rientjes@google.com, segoon@openwall.com, viro@zeniv.linux.org.uk, wilsons@start.ca, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: fix null pointer deref in proc_pid_permission()
has been removed from the -mm tree.  Its filename was
     proc-fix-null-pointer-deref-in-proc_pid_permission.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Xiaotian Feng <xtfeng@gmail.com>
Subject: proc: fix null pointer deref in proc_pid_permission()

get_proc_task() can fail to search the task and return NULL,
put_task_struct() will then bomb the kernel with following oops:

[ 1870.574045] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
[ 1870.574065] IP: [<ffffffff81217d34>] proc_pid_permission+0x64/0xe0
[ 1870.574088] PGD 112075067 PUD 112814067 PMD 0
[ 1870.574106] Oops: 0002 [#1] PREEMPT SMP

This is a regression introduced by commit 0499680a ("procfs: add hidepid=
and gid= mount options").  The kernel should return -ESRCH if
get_proc_task() failed.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Stephen Wilson <wilsons@start.ca>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/proc/base.c~proc-fix-null-pointer-deref-in-proc_pid_permission fs/proc/base.c
--- a/fs/proc/base.c~proc-fix-null-pointer-deref-in-proc_pid_permission
+++ a/fs/proc/base.c
@@ -654,6 +654,8 @@ static int proc_pid_permission(struct in
 	bool has_perms;
 
 	task = get_proc_task(inode);
+	if (!task)
+		return -ESRCH;
 	has_perms = has_pid_permissions(pid, task, 1);
 	put_task_struct(task);
 
_

Patches currently in -mm which might be from xtfeng@gmail.com are

origin.patch

