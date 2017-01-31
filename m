From: akpm@linux-foundation.org
Subject: + exit-fix-the-setns-pr_set_child_subreaper-interaction.patch
 added to -mm tree
Date: Tue, 31 Jan 2017 15:30:32 -0800
Message-ID: <58911e18.IjgZ8cZ1Kmh2YLzz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58010 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdAaXku (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2017 18:40:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, ebiederm@xmission.com, gorcunov@openvz.org, john.stultz@linaro.org, kay.sievers@vrfy.org, khorenko@virtuozzo.com, lennart@poettering.net, mguzik@redhat.com, mhocko@suse.com, mingo@redhat.com, nicolas.pitre@linaro.org, peterz@infradead.org, ptikhomirov@virtuozzo.com, skinsbursky@virtuozzo.com, tglx@linutronix.de, xemul@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: exit: fix the setns() && PR_SET_CHILD_SUBREAPER interaction
has been added to the -mm tree.  Its filename is
     exit-fix-the-setns-pr_set_child_subreaper-interaction.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/exit-fix-the-setns-pr_set_child_subreaper-interaction.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/exit-fix-the-setns-pr_set_child_subreaper-interaction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: exit: fix the setns() && PR_SET_CHILD_SUBREAPER interaction

find_new_reaper() checks same_thread_group(reaper, child_reaper) to
prevent the cross-namespace reparenting but this is not enough if the
exiting parent was injected by setns() + fork().

Suppose we have a process P in the root namespace and some namespace X.  P
does setns() to enter the X namespace, and forks the child C.  C forks a
grandchild G and exits.

The grandchild G should be re-parented to X->child_reaper, but in this
case the ->real_parent chain does not lead to ->child_reaper, so it will
be wrongly reparanted to P's sub-reaper or a global init.

Link: http://lkml.kernel.org/r/20170130181735.GA11285@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Stanislav Kinsburskiy <skinsbursky@virtuozzo.com>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Cc: Konstantin Khorenko <khorenko@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN kernel/exit.c~exit-fix-the-setns-pr_set_child_subreaper-interaction kernel/exit.c
--- a/kernel/exit.c~exit-fix-the-setns-pr_set_child_subreaper-interaction
+++ a/kernel/exit.c
@@ -578,15 +578,18 @@ static struct task_struct *find_new_reap
 		return thread;
 
 	if (father->signal->has_child_subreaper) {
+		unsigned int ns_level = task_pid(father)->level;
 		/*
 		 * Find the first ->is_child_subreaper ancestor in our pid_ns.
-		 * We start from father to ensure we can not look into another
-		 * namespace, this is safe because all its threads are dead.
+		 * We can't check reaper != child_reaper to ensure we do not
+		 * cross the namespaces, the exiting parent could be injected
+		 * by setns() + fork().
+		 * We check pid->level, this is slightly more efficient than
+		 * task_active_pid_ns(reaper) != task_active_pid_ns(father).
 		 */
-		for (reaper = father;
-		     !same_thread_group(reaper, child_reaper);
+		for (reaper = father->real_parent;
+		     task_pid(reaper)->level == ns_level;
 		     reaper = reaper->real_parent) {
-			/* call_usermodehelper() descendants need this check */
 			if (reaper == &init_task)
 				break;
 			if (!reaper->signal->is_child_subreaper)
_

Patches currently in -mm which might be from oleg@redhat.com are

exit-fix-the-setns-pr_set_child_subreaper-interaction.patch

