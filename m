From: akpm@linux-foundation.org
Subject: + oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch added to -mm tree
Date: Mon, 22 Nov 2010 16:10:35 -0800
Message-ID: <201011230010.oAN0AZXN017068@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932369Ab0KWALW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Nov 2010 19:11:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: msb@chromium.org, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com, rientjes@google.com, yinghan@google.com


The patch titled
     oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj down
has been added to the -mm tree.  Its filename is
     oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch

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
Subject: oom: allow a non-CAP_SYS_RESOURCE proces to oom_score_adj down
From: Mandeep Singh Baines <msb@chromium.org>

We'd like to be able to oom_score_adj a process up/down as it
enters/leaves the foreground.  Currently, it is not possible to oom_adj
down without CAP_SYS_RESOURCE.  This patch allows a task to decrease its
oom_score_adj back to the value that a CAP_SYS_RESOURCE thread set it to
or its inherited value at fork.  Assuming the thread that has forked it
has oom_score_adj of 0, each process could decrease it back from 0 upon
activation unless a CAP_SYS_RESOURCE thread elevated it to something
higher.

Alternative considered:

* a setuid binary
* a daemon with CAP_SYS_RESOURCE

Since you don't wan't all processes to be able to reduce their oom_adj, a
setuid or daemon implementation would be complex.  The alternatives also
have much higher overhead.

This patch updated from original patch based on feedback from David
Rientjes.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Acked-by: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++++
 fs/proc/base.c                     |    4 +++-
 include/linux/sched.h              |    2 ++
 kernel/fork.c                      |    1 +
 4 files changed, 10 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/proc.txt~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down
+++ a/Documentation/filesystems/proc.txt
@@ -1323,6 +1323,10 @@ scaled linearly with /proc/<pid>/oom_sco
 Writing to /proc/<pid>/oom_score_adj or /proc/<pid>/oom_adj will change the
 other with its scaled value.
 
+The value of /proc/<pid>/oom_score_adj may be reduced no lower than the last
+value set by a CAP_SYS_RESOURCE process. To reduce the value any lower
+requires CAP_SYS_RESOURCE.
+
 NOTICE: /proc/<pid>/oom_adj is deprecated and will be removed, please see
 Documentation/feature-removal-schedule.txt.
 
diff -puN fs/proc/base.c~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down fs/proc/base.c
--- a/fs/proc/base.c~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down
+++ a/fs/proc/base.c
@@ -1164,7 +1164,7 @@ static ssize_t oom_score_adj_write(struc
 		goto err_task_lock;
 	}
 
-	if (oom_score_adj < task->signal->oom_score_adj &&
+	if (oom_score_adj < task->signal->oom_score_adj_min &&
 			!capable(CAP_SYS_RESOURCE)) {
 		err = -EACCES;
 		goto err_sighand;
@@ -1177,6 +1177,8 @@ static ssize_t oom_score_adj_write(struc
 			atomic_dec(&task->mm->oom_disable_count);
 	}
 	task->signal->oom_score_adj = oom_score_adj;
+	if (has_capability_noaudit(current, CAP_SYS_RESOURCE))
+		task->signal->oom_score_adj_min = oom_score_adj;
 	/*
 	 * Scale /proc/pid/oom_adj appropriately ensuring that OOM_DISABLE is
 	 * always attainable.
diff -puN include/linux/sched.h~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down include/linux/sched.h
--- a/include/linux/sched.h~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down
+++ a/include/linux/sched.h
@@ -626,6 +626,8 @@ struct signal_struct {
 
 	int oom_adj;		/* OOM kill score adjustment (bit shift) */
 	int oom_score_adj;	/* OOM kill score adjustment */
+	int oom_score_adj_min;	/* OOM kill score adjustment minimum value.
+				 * Only settable by CAP_SYS_RESOURCE. */
 
 	struct mutex cred_guard_mutex;	/* guard against foreign influences on
 					 * credential calculations
diff -puN kernel/fork.c~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down kernel/fork.c
--- a/kernel/fork.c~oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down
+++ a/kernel/fork.c
@@ -907,6 +907,7 @@ static int copy_signal(unsigned long clo
 
 	sig->oom_adj = current->signal->oom_adj;
 	sig->oom_score_adj = current->signal->oom_score_adj;
+	sig->oom_score_adj_min = current->signal->oom_score_adj_min;
 
 	mutex_init(&sig->cred_guard_mutex);
 
_

Patches currently in -mm which might be from msb@chromium.org are

oom-allow-a-non-cap_sys_resource-proces-to-oom_score_adj-down.patch

