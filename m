From: akpm@linux-foundation.org
Subject: [merged] wait_task_zombie-do-not-use-thread_group_cputime.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:46:47 -0700
Message-ID: <200906182246.n5IMklw0005764@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57722 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759202AbZFRWrb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, a.p.zijlstra@chello.nl, roland@redhat.com, sgruszka@redhat.com, vmayatsk@redhat.com, mm-commits@vger.kernel.org


The patch titled
     wait_task_zombie: do not use thread_group_cputime()
has been removed from the -mm tree.  Its filename was
     wait_task_zombie-do-not-use-thread_group_cputime.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wait_task_zombie: do not use thread_group_cputime()
From: Oleg Nesterov <oleg@redhat.com>

There is no reason for thread_group_cputime() in wait_task_zombie(), there
must be no other threads.

This call was previously needed to collect the per-cpu data which we do
not have any longer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Roland McGrath <roland@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Vitaly Mayatskikh <vmayatsk@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff -puN kernel/exit.c~wait_task_zombie-do-not-use-thread_group_cputime kernel/exit.c
--- a/kernel/exit.c~wait_task_zombie-do-not-use-thread_group_cputime
+++ a/kernel/exit.c
@@ -1191,7 +1191,6 @@ static int wait_task_zombie(struct task_
 	if (likely(!traced)) {
 		struct signal_struct *psig;
 		struct signal_struct *sig;
-		struct task_cputime cputime;
 
 		/*
 		 * The resource counters for the group leader are in its
@@ -1207,23 +1206,20 @@ static int wait_task_zombie(struct task_
 		 * need to protect the access to parent->signal fields,
 		 * as other threads in the parent group can be right
 		 * here reaping other children at the same time.
-		 *
-		 * We use thread_group_cputime() to get times for the thread
-		 * group, which consolidates times for all threads in the
-		 * group including the group leader.
 		 */
-		thread_group_cputime(p, &cputime);
 		spin_lock_irq(&p->real_parent->sighand->siglock);
 		psig = p->real_parent->signal;
 		sig = p->signal;
 		psig->cutime =
 			cputime_add(psig->cutime,
-			cputime_add(cputime.utime,
-				    sig->cutime));
+			cputime_add(p->utime,
+			cputime_add(sig->utime,
+				    sig->cutime)));
 		psig->cstime =
 			cputime_add(psig->cstime,
-			cputime_add(cputime.stime,
-				    sig->cstime));
+			cputime_add(p->stime,
+			cputime_add(sig->stime,
+				    sig->cstime)));
 		psig->cgtime =
 			cputime_add(psig->cgtime,
 			cputime_add(p->gtime,
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
ptrace-wait_task_zombie-do-not-account-traced-sub-threads.patch
linux-next.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
signals-tracehook_notify_jctl-change.patch
utrace-core.patch

