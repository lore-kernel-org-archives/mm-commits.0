From: akpm@linux-foundation.org
Subject: + proc-fix-null-pointer-deref-in-proc_pid_permission.patch added to -mm tree
Date: Wed, 11 Jan 2012 13:58:58 -0800
Message-ID: <20120111215858.AF9C61E0070@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:38276 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038Ab2AKV7A (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2012 16:59:00 -0500
Received: by ghrr15 with SMTP id r15so141230ghr.1
        for <mm-commits@vger.kernel.org>; Wed, 11 Jan 2012 13:59:00 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xtfeng@gmail.com, dannyfeng@tencent.com, rientjes@google.com, segoon@openwall.com, viro@zeniv.linux.org.uk, wilsons@start.ca


The patch titled
     Subject: proc: fix null pointer deref in proc_pid_permission()
has been added to the -mm tree.  Its filename is
     proc-fix-null-pointer-deref-in-proc_pid_permission.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: David Rientjes <rientjes@google.com>
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
Subject: Subject: proc: fix null pointer deref in proc_pid_permission()

Patches currently in -mm which might be from xtfeng@gmail.com are

proc-fix-null-pointer-deref-in-proc_pid_permission.patch

