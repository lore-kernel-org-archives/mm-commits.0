From: akpm@linux-foundation.org
Subject: + proc-relax-proc-tid-timerslack_ns-capability-requirements.patch added to -mm tree
Date: Fri, 22 Jul 2016 13:13:38 -0700
Message-ID: <57927e72.TlrgwFK7tyUCvPRD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54903 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbcGVUNk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Jul 2016 16:13:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: john.stultz@linaro.org, arjan@linux.intel.com, ccross@android.com, dimitrysh@google.com, enh@google.com, kandoiruchi@google.com, keescook@chromium.org, kernel-team@android.com, nnk@google.com, orenl@cellrox.com, romlem@android.com, serge@hallyn.com, tglx@linutronix.de, tkjos@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: proc: relax /proc/<tid>/timerslack_ns capability requirements
has been added to the -mm tree.  Its filename is
     proc-relax-proc-tid-timerslack_ns-capability-requirements.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/proc-relax-proc-tid-timerslack_ns-capability-requirements.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/proc-relax-proc-tid-timerslack_ns-capability-requirements.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: John Stultz <john.stultz@linaro.org>
Subject: proc: relax /proc/<tid>/timerslack_ns capability requirements

When an interface to allow a task to change another tasks timerslack was
first proposed, it was suggested that something greater then CAP_SYS_NICE
would be needed, as a task could be delayed further then what normally
could be done with nice adjustments.

So CAP_SYS_PTRACE was adopted instead for what became the
/proc/<tid>/timerslack_ns interface.  However, for Android (where this
feature originates), giving the system_server CAP_SYS_PTRACE would allow
it to observe and modify all tasks memory.  This is considered too high a
privilege level for only needing to change the timerslack.

After some discussion, it was realized that a CAP_SYS_NICE process can set
a task as SCHED_FIFO, so they could fork some spinning processes and set
them all SCHED_FIFO 99, in effect delaying all other tasks for an infinite
amount of time.

So as a CAP_SYS_NICE task can already cause trouble for other tasks, using
it as a required capability for accessing and modifying
/proc/<tid>/timerslack_ns seems sufficient.

Thus, this patch loosens the capability requirements to CAP_SYS_NICE and
removes CAP_SYS_PTRACE, simplifying some of the code flow as well.

This is technically an ABI change, but as the feature just landed in 4.6,
I suspect no one is yet using it.

Link: http://lkml.kernel.org/r/1469132667-17377-1-git-send-email-john.stultz@linaro.org
Signed-off-by: John Stultz <john.stultz@linaro.org>
Reviewed-by: Nick Kralevich <nnk@google.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Oren Laadan <orenl@cellrox.com>
Cc: Ruchi Kandoi <kandoiruchi@google.com>
Cc: Rom Lemarchand <romlem@android.com>
Cc: Todd Kjos <tkjos@google.com>
Cc: Colin Cross <ccross@android.com>
Cc: Nick Kralevich <nnk@google.com>
Cc: Dmitry Shmidt <dimitrysh@google.com>
Cc: Elliott Hughes <enh@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff -puN fs/proc/base.c~proc-relax-proc-tid-timerslack_ns-capability-requirements fs/proc/base.c
--- a/fs/proc/base.c~proc-relax-proc-tid-timerslack_ns-capability-requirements
+++ a/fs/proc/base.c
@@ -2285,16 +2285,19 @@ static ssize_t timerslack_ns_write(struc
 	if (!p)
 		return -ESRCH;
 
-	if (ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)) {
-		task_lock(p);
-		if (slack_ns == 0)
-			p->timer_slack_ns = p->default_timer_slack_ns;
-		else
-			p->timer_slack_ns = slack_ns;
-		task_unlock(p);
-	} else
+	if (!capable(CAP_SYS_NICE)) {
 		count = -EPERM;
+		goto out;
+	}
 
+	task_lock(p);
+	if (slack_ns == 0)
+		p->timer_slack_ns = p->default_timer_slack_ns;
+	else
+		p->timer_slack_ns = slack_ns;
+	task_unlock(p);
+
+out:
 	put_task_struct(p);
 
 	return count;
@@ -2304,19 +2307,22 @@ static int timerslack_ns_show(struct seq
 {
 	struct inode *inode = m->private;
 	struct task_struct *p;
-	int err =  0;
+	int err = 0;
 
 	p = get_proc_task(inode);
 	if (!p)
 		return -ESRCH;
 
-	if (ptrace_may_access(p, PTRACE_MODE_ATTACH_FSCREDS)) {
-		task_lock(p);
-		seq_printf(m, "%llu\n", p->timer_slack_ns);
-		task_unlock(p);
-	} else
+	if (!capable(CAP_SYS_NICE)) {
 		err = -EPERM;
+		goto out;
+	}
+
+	task_lock(p);
+	seq_printf(m, "%llu\n", p->timer_slack_ns);
+	task_unlock(p);
 
+out:
 	put_task_struct(p);
 
 	return err;
_

Patches currently in -mm which might be from john.stultz@linaro.org are

proc-relax-proc-tid-timerslack_ns-capability-requirements.patch
proc-add-lsm-hook-checks-to-proc-tid-timerslack_ns.patch

