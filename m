From: akpm@linux-foundation.org
Subject: +
 proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file.patch added to -mm tree
Date: Thu, 08 Feb 2018 12:28:59 -0800
Message-ID: <5a7cb30b.HhiPnf2CmiZxr5EI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39066 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751786AbeBHU3B (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Feb 2018 15:29:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mguzik@redhat.com, adobriyan@gmail.com, jmarchan@redhat.com, koct9i@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: get rid of task lock/unlock pair to read umask for the "status" file
has been added to the -mm tree.  Its filename is
     proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mateusz Guzik <mguzik@redhat.com>
Subject: proc: get rid of task lock/unlock pair to read umask for the "status" file

get_task_umask locks/unlocks the task on its own.  The only caller does
the same thing immediately after.

Utilize the fact the task has to be locked anyway and just do it once. 
Since there are no other users and the code is short, fold it in.

Link: http://lkml.kernel.org/r/1517995608-23683-1-git-send-email-mguzik@redhat.com
Signed-off-by: Mateusz Guzik <mguzik@redhat.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: Jerome Marchand <jmarchan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/array.c |   23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff -puN fs/proc/array.c~proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file fs/proc/array.c
--- a/fs/proc/array.c~proc-get-rid-of-task-lock-unlock-pair-to-read-umask-for-the-status-file
+++ a/fs/proc/array.c
@@ -141,25 +141,12 @@ static inline const char *get_task_state
 	return task_state_array[task_state_index(tsk)];
 }
 
-static inline int get_task_umask(struct task_struct *tsk)
-{
-	struct fs_struct *fs;
-	int umask = -ENOENT;
-
-	task_lock(tsk);
-	fs = tsk->fs;
-	if (fs)
-		umask = fs->umask;
-	task_unlock(tsk);
-	return umask;
-}
-
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
 	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
-	int g, umask;
+	int g, umask = -1;
 	struct task_struct *tracer;
 	const struct cred *cred;
 	pid_t ppid, tpid = 0, tgid, ngid;
@@ -177,16 +164,16 @@ static inline void task_state(struct seq
 	ngid = task_numa_group_id(p);
 	cred = get_task_cred(p);
 
-	umask = get_task_umask(p);
-	if (umask >= 0)
-		seq_printf(m, "Umask:\t%#04o\n", umask);
