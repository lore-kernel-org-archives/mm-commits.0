Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EDA235045
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 02:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791338664; cv=none; b=TobTuF0P6zdE+wWMeLVj+ex104rNc9BSXwixeaZks4d4nPWeCK2nrqMNTaNF8HbkW/5GzV8+mww3tjbnoWFzKJdCOEuW2feNXnZpKjYNqQn+ar+fz39wVDg6dtTmPUc9EcawU+1jOGa4ZxT/zZ6kwAeL3X1Qjq+avNd7Qzpnfdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791338664; c=relaxed/simple;
	bh=LxNTs2WMpO0yTAWvgMLhXaFO73Ra0TFsK1u9nus1Tko=;
	h=Date:To:From:Subject:Message-Id; b=jkHplukrO6sqAqHR4+YwOuZq1iBI3Lz15Fy1UkVgomuq1H09TEUGQXYlI4uI3JfbWP9CedNUmu3nYuoixLQ/m+zO+x5jzL9eg0jj6lG7hT3qXL6i/GA7YjlhH6bAeLskQ2rmD0kIB5goOre7EBLu5SqOevoVJzWP757moyac1Ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eqTd41L0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eqTd41L0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7CD1F0089C;
	Wed,  7 Oct 2026 02:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791338662;
	bh=UcziYHsVy36+qnC+fj+kcK974MVZtwf6ht8fLXxgdRY=;
	h=Date:To:From:Subject;
	b=eqTd41L0Vm/apsjJ/cNfcIL5HcJnxTVaXcQEBYX7i7zmYdnWRnA4aDUa5I7yaMvFg
	 ykSuawabtWq4O4axo4tfNbXeBQyPWu6R+PohL2GgdYcXM5KQAbCPQ3J02JjMopUXTg
	 x1whNMETAdIwudZ1AsYQrLXoN2EfahKtKdwuiljc=
Date: Tue, 06 Oct 2026 19:04:22 -0700
To: mm-commits@vger.kernel.org,tglx@linutronix.de,ptikhomirov@virtuozzo.com,avagin@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch removed from -mm tree
Message-Id: <20261007020422.7D7CD1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: proc: report SIGEV_NONE in /proc/pid/timers if target task has died
has been removed from the -mm tree.  Its filename was
     proc-report-sigev_none-in-proc-pid-timers-if-target-task-has-died.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Fixes: 57b8015e07a7 ("posix-timers: Show sigevent info in proc file")
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
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


