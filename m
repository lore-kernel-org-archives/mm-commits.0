Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E56C12CDA5
	for <mm-commits@vger.kernel.org>; Sun, 30 Aug 2026 01:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788051835; cv=none; b=jnYTPAD5OVF5f5aRRCfPw8bBajSuKseeNPWJ496G+b+VvKtnWxC4jctEqY3iLvWSh8OehRlLffODKZPQ8urjqCERl9Vh9Wh8GHO49p9a494qGWBG/6x4PbQQzUYcbux5wvLHMA7XjjOupdpPyU1s6J7rI1itVw6uOxZJVQZTdVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788051835; c=relaxed/simple;
	bh=QhRG8Oam/frodIEaXAAZNshWL69cwaCXR8nPMRQ5Ccg=;
	h=Date:To:From:Subject:Message-Id; b=qzHhOMEDcP5/z0iFE3cneipfU8w/3ma4pq9EILthkbHcadbWEGwKnlWhIvm5/L/niOQaL8WlNGNgz/sQ+XklueRJl9m4iCwVAL4jPkj1dFQyI/qAJGy7Zn3bhc02BQKJThvV9iQ++z/TyB6cCzLoJzbd5siBYfJw98U4WH4SMzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uTuQ1+05; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uTuQ1+05"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74291F000E9;
	Sun, 30 Aug 2026 01:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788051834;
	bh=6kiDBWER3ypGZdO82pvN/ZzQK3I5Rq4fE/HXe6zUUOo=;
	h=Date:To:From:Subject;
	b=uTuQ1+05mL0oxcHdjvKmR1s6kufh5JigM/d9CgQ6rEsrTEjnZ+XWBkd3lLYE7dBQr
	 vjm0fbfaRGjmfBevQzVnvzmWUQbVt7qpHqNimhK3olgIrn33vb/Jeh35apEal7zV0x
	 lkQHdLjIgsCm1ElfP8X4Pvv2uLQn25kSwiNOj7L4=
Date: Sat, 29 Aug 2026 18:03:53 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ptikhomirov@virtuozzo.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch added to mm-nonmm-unstable branch
Message-Id: <20260830010353.E74291F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: proc: report SIGEV_NONE in /proc/pid/timers if target task has died
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Andrei Vagin <avagin@google.com>
Subject: proc: report SIGEV_NONE in /proc/pid/timers if target task has died
Date: Sun, 16 Aug 2026 16:12:15 +0000

When a posix timer is created targeting a specific thread (using
SIGEV_SIGNAL | SIGEV_THREAD_ID), it takes a reference to the target struct
pid in timer->it_pid.  If the target thread subsequently terminates, its
numeric tid is freed and can be recycled for an unrelated task.  However,
the timer holds its reference to the original struct pid.

show_timer() in /proc/[pid]/timers previously called pid_nr_ns() directly
on timer->it_pid without checking whether any task remained attached to
that struct pid.  As a result:

1. It reported the stale tid, which could mistakenly refer to a recycled
   pid.

2. In the kernel, expired signals for dead target threads are dropped by
   posixtimer_send_sigqueue() because posixtimer_get_target() returns
   NULL, so the timer functionally acts as SIGEV_NONE.

3. Checkpoint/restore tools (CRIU) parsing /proc/[pid]/timers would try
   to restore a timer with SIGEV_SIGNAL | SIGEV_THREAD_ID targeting a
   non-existent or unrelated thread.

Check pid_has_task(timer->it_pid, timer->it_pid_type) in show_timer().  If
the target task has died, override notify to SIGEV_NONE and report PID 0
(e.g., 'notify: none/pid.0').

Link: https://lore.kernel.org/20260816161216.984580-1-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@google.com>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c~proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died
+++ a/fs/proc/base.c
@@ -2519,17 +2519,23 @@ static int show_timer(struct seq_file *m
 	struct k_itimer *timer = hlist_entry((struct hlist_node *)v, struct k_itimer, list);
 	struct timers_private *tp = m->private;
 	int notify = timer->it_sigev_notify;
+	pid_t nr = 0;
 
 	guard(spinlock_irq)(&timer->it_lock);
 	if (!posixtimer_valid(timer))
 		return 0;
 
+	if (timer->it_pid && pid_has_task(timer->it_pid, timer->it_pid_type))
+		nr = pid_nr_ns(timer->it_pid, tp->ns);
+	else
+		notify = SIGEV_NONE;
+
 	seq_printf(m, "ID: %d\n", timer->it_id);
 	seq_printf(m, "signal: %d/%px\n", timer->sigq.info.si_signo,
 		   timer->sigq.info.si_value.sival_ptr);
 	seq_printf(m, "notify: %s/%s.%d\n", nstr[notify & ~SIGEV_THREAD_ID],
 		   (notify & SIGEV_THREAD_ID) ? "tid" : "pid",
-		   pid_nr_ns(timer->it_pid, tp->ns));
+		   nr);
 	seq_printf(m, "ClockID: %d\n", timer->it_clock);
 
 	return 0;
_

Patches currently in -mm which might be from avagin@google.com are

proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch

