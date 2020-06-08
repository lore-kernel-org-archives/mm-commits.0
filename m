From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch
 added to -mm tree
Date: Mon, 08 Jun 2020 16:56:34 -0700
Message-ID: <20200608235634.42rAVh-_P%akpm@linux-foundation.org>
References: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbgFHX4g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 8 Jun 2020 19:56:36 -0400
In-Reply-To: <20200607212615.b050e41fac139a1e16fe00bd@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, nao.horiguchi@gmail.com, naoya.horiguchi@nec.com


The patch titled
     Subject: mm/memory-failure: send SIGBUS(BUS_MCEERR_AR) only to current thread
has been added to the -mm tree.  Its filename is
     mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch

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
Subject: mm/memory-failure: send SIGBUS(BUS_MCEERR_AR) only to current thread

Action Required memory error should happen only when a processor is about
to access to a corrupted memory, so it's synchronous and only affects
current process/thread.  Recently commit 872e9a205c84 ("mm,
memory_failure: don't send BUS_MCEERR_AO for action required error") fixed
the issue that Action Required memory could unnecessarily send SIGBUS to
the processes which share the error memory.  But we still have another
issue that we could send SIGBUS to a wrong thread.

This is because collect_procs() and task_early_kill() fails to add the
current process to "to-kill" list.  So this patch is suggesting to fix it.
With this fix, SIGBUS(BUS_MCEERR_AR) is never sent to non-current
process/thread.

Link: http://lkml.kernel.org/r/1591321039-22141-3-git-send-email-naoya.horiguchi@nec.com
Signed-off-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread
+++ a/mm/memory-failure.c
@@ -212,15 +212,13 @@ static int kill_proc(struct to_kill *tk,
 	short addr_lsb = tk->size_shift;
 	int ret = 0;
 
-	if ((t->mm == current->mm) || !(flags & MF_ACTION_REQUIRED))
-		pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
+	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
 			pfn, t->comm, t->pid);
 
 	if (flags & MF_ACTION_REQUIRED) {
-		if (t->mm == current->mm)
-			ret = force_sig_mceerr(BUS_MCEERR_AR,
+		WARN_ON_ONCE(t != current);
+		ret = force_sig_mceerr(BUS_MCEERR_AR,
 					 (void __user *)tk->addr, addr_lsb);
-		/* send no signal to non-current processes */
 	} else {
 		/*
 		 * Don't use force here, it's convenient if the signal
@@ -419,14 +417,25 @@ static struct task_struct *find_early_ki
  * to be signaled when some page under the process is hwpoisoned.
  * Return task_struct of the dedicated thread (main thread unless explicitly
  * specified) if the process is "early kill," and otherwise returns NULL.
+ *
+ * Note that the above is true for Action Optional case, but not for Action
+ * Required case where SIGBUS should sent only to the current thread.
  */
 static struct task_struct *task_early_kill(struct task_struct *tsk,
 					   int force_early)
 {
 	if (!tsk->mm)
 		return NULL;
-	if (force_early)
-		return tsk;
+	if (force_early) {
+		/*
+		 * Comparing ->mm here because current task might represent
+		 * a subthread, while tsk always points to the main thread.
+		 */
+		if (tsk->mm == current->mm)
+			return current;
+		else
+			return NULL;
+	}
 	return find_early_kill_thread(tsk);
 }
 
_

Patches currently in -mm which might be from nao.horiguchi@gmail.com are

mm-memory-failure-prioritize-prctlpr_mce_kill-over-vmmemory_failure_early_kill.patch
mm-memory-failure-send-sigbusbus_mceerr_ar-only-to-current-thread.patch
