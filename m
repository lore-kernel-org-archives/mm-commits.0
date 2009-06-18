From: akpm@linux-foundation.org
Subject: [merged] ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:24 -0700
Message-ID: <200906182247.n5IMlOcZ006495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46658 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758586AbZFRWsF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:48:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, sukadev@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: do_notify_parent_cldstop: fix the wrong ->nsproxy usage
has been removed from the -mm tree.  Its filename was
     ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: do_notify_parent_cldstop: fix the wrong ->nsproxy usage
From: Oleg Nesterov <oleg@redhat.com>

If the non-traced sub-thread calls do_notify_parent_cldstop(), we send the
notification to group_leader->real_parent and we report group_leader's
pid.

But, if group_leader is traced we use the wrong ->parent->nsproxy->pid_ns,
the tracer and parent can live in different namespaces.  Change the code
to use "parent" instead of tsk->parent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/signal.c~ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage kernel/signal.c
--- a/kernel/signal.c~ptrace-do_notify_parent_cldstop-fix-the-wrong-nsproxy-usage
+++ a/kernel/signal.c
@@ -1499,7 +1499,7 @@ static void do_notify_parent_cldstop(str
 	 * see comment in do_notify_parent() abot the following 3 lines
 	 */
 	rcu_read_lock();
-	info.si_pid = task_pid_nr_ns(tsk, tsk->parent->nsproxy->pid_ns);
+	info.si_pid = task_pid_nr_ns(tsk, parent->nsproxy->pid_ns);
 	info.si_uid = __task_cred(tsk)->uid;
 	rcu_read_unlock();
 
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

