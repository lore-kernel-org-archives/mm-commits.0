From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 =?US-ASCII?Q?mm-memory-failure-prioritize-prctlpr=5Fmce=5Fkill-over-vmmem?=
 =?US-ASCII?Q?ory=5Ffailure=5Fearly=5Fkill.patch?= added to -mm tree
Date: Mon, 08 Jun 2020 16:56:32 -0700
Message-ID: <20200608235632.EeH0i3sod%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732743AbgFHX4d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 19:56:33 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nao.horiguchi@gmail.com, naoya.horiguchi@nec.com


The patch titled
     Subject: mm/memory-failure: prioritize prctl(PR_MCE_KILL) over vm.memory_failure_early_kill
has been added to the -mm tree.  Its filename is
     mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: mm/memory-failure: prioritize prctl(PR_MCE_KILL) over vm.memory_failure_early_kill

Patch series "hwpoison: fixes signaling on memory error"

This is a small patchset to solve issues in memory error handler to
send SIGBUS to proper process/thread as expected in configuration.
Please see descriptions in individual patches for more details.


This patch (of 2):

Early-kill policy is controlled from two types of settings, one is
per-process setting prctl(PR_MCE_KILL) and the other is system-wide
setting vm.memory_failure_early_kill.  Users expect per-process setting to
override system-wide setting as many other settings do, but early-kill
setting doesn't work as such.  For example, if a system configures
vm.memory_failure_early_kill to 1 (enabled), a process receives SIGBUS
even if it's configured to explicitly disable PF_MCE_KILL by prctl(). 
That's not desirable for applications with their own policies.

This patch is suggesting to change the priority of these two types of
settings, by checking sysctl_memory_failure_early_kill only when a given
process has the default kill policy.

Note that this patch is solving a thread choice issue too.  Originally,
collect_procs() always chooses the main thread when
vm.memory_failure_early_kill is 1, even if the process has a dedicated
thread for memory error handling.  SIGBUS should be sent to the dedicated
thread if early-kill is enabled via vm.memory_failure_early_kill as we are
doing for PR_MCE_KILL_EARLY processes.

Link: http://lkml.kernel.org/r/1591321039-22141-1-git-send-email-naoya.horiguchi@nec.com
Link: http://lkml.kernel.org/r/1591321039-22141-2-git-send-email-naoya.horiguchi@nec.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill
+++ a/mm/memory-failure.c
@@ -402,9 +402,15 @@ static struct task_struct *find_early_ki
 {
 	struct task_struct *t;
 
-	for_each_thread(tsk, t)
-		if ((t->flags & PF_MCE_PROCESS) && (t->flags & PF_MCE_EARLY))
-			return t;
+	for_each_thread(tsk, t) {
+		if (t->flags & PF_MCE_PROCESS) {
+			if (t->flags & PF_MCE_EARLY)
+				return t;
+		} else {
+			if (sysctl_memory_failure_early_kill)
+				return t;
+		}
+	}
 	return NULL;
 }
 
@@ -417,17 +423,11 @@ static struct task_struct *find_early_ki
 static struct task_struct *task_early_kill(struct task_struct *tsk,
 					   int force_early)
 {
-	struct task_struct *t;
 	if (!tsk->mm)
 		return NULL;
 	if (force_early)
 		return tsk;
-	t = find_early_kill_thread(tsk);
-	if (t)
-		return t;
-	if (sysctl_memory_failure_early_kill)
-		return tsk;
-	return NULL;
+	return find_early_kill_thread(tsk);
 }
 
 /*
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill.patch
mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch
