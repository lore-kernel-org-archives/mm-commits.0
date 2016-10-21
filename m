From: akpm@linux-foundation.org
Subject: + signals-avoid-unnecessary-taking-of-sighand-siglock.patch added to -mm tree
Date: Fri, 21 Oct 2016 14:24:48 -0700
Message-ID: <580a87a0.Vtw1zjldAqDdRrXc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933451AbcJUVYt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Oct 2016 17:24:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Waiman.Long@hpe.com, doug.hatch@hpe.com, mingo@kernel.org, oleg@redhat.com, scott.norton@hpe.com, stsp@list.ru, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: signals: avoid unnecessary taking of sighand->siglock
has been added to the -mm tree.  Its filename is
     signals-avoid-unnecessary-taking-of-sighand-siglock.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signals-avoid-unnecessary-taking-of-sighand-siglock.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signals-avoid-unnecessary-taking-of-sighand-siglock.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <Waiman.Long@hpe.com>
Subject: signals: avoid unnecessary taking of sighand->siglock

When running certain database workload on a high-end system with many
CPUs, it was found that spinlock contention in the sigprocmask syscalls
became a significant portion of the overall CPU cycles as shown below.

  9.30%  9.30%  905387  dataserver  /proc/kcore 0x7fff8163f4d2
  [k] _raw_spin_lock_irq
            |
            ---_raw_spin_lock_irq
               |
               |--99.34%-- __set_current_blocked
               |          sigprocmask
               |          sys_rt_sigprocmask
               |          system_call_fastpath
               |          |
               |          |--50.63%-- __swapcontext
               |          |          |
               |          |          |--99.91%-- upsleepgeneric
               |          |
               |          |--49.36%-- __setcontext
               |          |          ktskRun

Looking further into the swapcontext function in glibc, it was found that
the function always call sigprocmask() without checking if there are
changes in the signal mask.

A check was added to the __set_current_blocked() function to avoid taking
the sighand->siglock spinlock if there is no change in the signal mask. 
This will prevent unneeded spinlock contention when many threads are
trying to call sigprocmask().

With this patch applied, the spinlock contention in sigprocmask() was
gone.

Link: http://lkml.kernel.org/r/1474979209-11867-1-git-send-email-Waiman.Long@hpe.com
Signed-off-by: Waiman Long <Waiman.Long@hpe.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Stas Sergeev <stsp@list.ru>
Cc: Scott J Norton <scott.norton@hpe.com>
Cc: Douglas Hatch <doug.hatch@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |   17 +++++++++++++++++
 kernel/signal.c        |    7 +++++++
 2 files changed, 24 insertions(+)

diff -puN include/linux/signal.h~signals-avoid-unnecessary-taking-of-sighand-siglock include/linux/signal.h
--- a/include/linux/signal.h~signals-avoid-unnecessary-taking-of-sighand-siglock
+++ a/include/linux/signal.h
@@ -97,6 +97,23 @@ static inline int sigisemptyset(sigset_t
 	}
 }
 
+static inline int sigequalsets(const sigset_t *set1, const sigset_t *set2)
+{
+	switch (_NSIG_WORDS) {
+	case 4:
+		return	(set1->sig[3] == set2->sig[3]) &&
+			(set1->sig[2] == set2->sig[2]) &&
+			(set1->sig[1] == set2->sig[1]) &&
+			(set1->sig[0] == set2->sig[0]);
+	case 2:
+		return	(set1->sig[1] == set2->sig[1]) &&
+			(set1->sig[0] == set2->sig[0]);
+	case 1:
+		return	set1->sig[0] == set2->sig[0];
+	}
+	return 0;
+}
+
 #define sigmask(sig)	(1UL << ((sig) - 1))
 
 #ifndef __HAVE_ARCH_SIG_SETOPS
diff -puN kernel/signal.c~signals-avoid-unnecessary-taking-of-sighand-siglock kernel/signal.c
--- a/kernel/signal.c~signals-avoid-unnecessary-taking-of-sighand-siglock
+++ a/kernel/signal.c
@@ -2485,6 +2485,13 @@ void __set_current_blocked(const sigset_
 {
 	struct task_struct *tsk = current;
 
+	/*
+	 * In case the signal mask hasn't changed, there is nothing we need
+	 * to do. The current->blocked shouldn't be modified by other task.
+	 */
+	if (sigequalsets(&tsk->blocked, newset))
+		return;
+
 	spin_lock_irq(&tsk->sighand->siglock);
 	__set_task_blocked(tsk, newset);
 	spin_unlock_irq(&tsk->sighand->siglock);
_

Patches currently in -mm which might be from Waiman.Long@hpe.com are

signals-avoid-unnecessary-taking-of-sighand-siglock.patch

