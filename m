From: akpm@linux-foundation.org
Subject: [to-be-updated] signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch removed from -mm tree
Date: Wed, 01 Jul 2009 13:39:02 -0700
Message-ID: <200907012039.n61Kd2QP019460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55254 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750963AbZGAUjz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Jul 2009 16:39:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, mingo@elte.hu, rnalumasu@gmail.com, roland@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: shift security_task_wait() from eligible_child() to wait_consider_task()
has been removed from the -mm tree.  Its filename was
     signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: shift security_task_wait() from eligible_child() to wait_consider_task()
From: Oleg Nesterov <oleg@redhat.com>

Preparation, no functional changes.

eligible_child() has a single caller, wait_consider_task().  We can move
security_task_wait() out from eligible_child(), this allows us to use it
for filtered wake_up().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ratan Nalumasu <rnalumasu@gmail.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN kernel/exit.c~signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task kernel/exit.c
--- a/kernel/exit.c~signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task
+++ a/kernel/exit.c
@@ -1108,8 +1108,6 @@ static struct pid *task_pid_type(struct 
 
 static int eligible_child(struct wait_opts *wo, struct task_struct *p)
 {
-	int err;
-
 	if (wo->wo_type < PIDTYPE_MAX) {
 		if (task_pid_type(p, wo->wo_type) != wo->wo_pid)
 			return 0;
@@ -1124,10 +1122,6 @@ static int eligible_child(struct wait_op
 	    && !(wo->wo_flags & __WALL))
 		return 0;
 
-	err = security_task_wait(p);
-	if (err)
-		return err;
-
 	return 1;
 }
 
@@ -1488,6 +1482,7 @@ static int wait_consider_task(struct wai
 	if (!ret)
 		return ret;
 
+	ret = security_task_wait(p);
 	if (unlikely(ret < 0)) {
 		/*
 		 * If we have not yet seen any eligible child,
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
cred_guard_mutex-do-not-return-eintr-to-user-space.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-shift-security_task_wait-from-eligible_child-to-wait_consider_task.patch
signals-change-__wake_up_parent-to-use-filtered-wakeup.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

