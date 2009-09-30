From: akpm@linux-foundation.org
Subject: + itimers-fix-racy-writes-to-cpu_itimer-fields.patch added to -mm tree
Date: Wed, 30 Sep 2009 13:23:32 -0700
Message-ID: <200909302023.n8UKNXqn011094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629AbZI3UYn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Sep 2009 16:24:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sgruszka@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, tglx@linutronix.de


The patch titled
     itimers: fix racy writes to cpu_itimer fields
has been added to the -mm tree.  Its filename is
     itimers-fix-racy-writes-to-cpu_itimer-fields.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: itimers: fix racy writes to cpu_itimer fields
From: Stanislaw Gruszka <sgruszka@redhat.com>

incr_error and error fields of struct cpu_itimer are used when calculating
next timer tick in check_cpu_itimers() and should not be modified without
tsk->sighand->siglock taken.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/itimer.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN kernel/itimer.c~itimers-fix-racy-writes-to-cpu_itimer-fields kernel/itimer.c
--- a/kernel/itimer.c~itimers-fix-racy-writes-to-cpu_itimer-fields
+++ a/kernel/itimer.c
@@ -146,6 +146,7 @@ static void set_cpu_itimer(struct task_s
 {
 	cputime_t cval, nval, cinterval, ninterval;
 	s64 ns_ninterval, ns_nval;
+	u32 error, incr_error;
 	struct cpu_itimer *it = &tsk->signal->it[clock_id];
 
 	nval = timeval_to_cputime(&value->it_value);
@@ -153,8 +154,8 @@ static void set_cpu_itimer(struct task_s
 	ninterval = timeval_to_cputime(&value->it_interval);
 	ns_ninterval = timeval_to_ns(&value->it_interval);
 
-	it->incr_error = cputime_sub_ns(ninterval, ns_ninterval);
-	it->error = cputime_sub_ns(nval, ns_nval);
+	error = cputime_sub_ns(nval, ns_nval);
+	incr_error = cputime_sub_ns(ninterval, ns_ninterval);
 
 	spin_lock_irq(&tsk->sighand->siglock);
 
@@ -168,6 +169,8 @@ static void set_cpu_itimer(struct task_s
 	}
 	it->expires = nval;
 	it->incr = ninterval;
+	it->error = error;
+	it->incr_error = incr_error;
 	trace_itimer_state(clock_id == CPUCLOCK_VIRT ?
 			   ITIMER_VIRTUAL : ITIMER_PROF, value, nval);
 
_

Patches currently in -mm which might be from sgruszka@redhat.com are

itimers-fix-racy-writes-to-cpu_itimer-fields.patch
posix-cpu-timers-initialize-new_itimer-itcpufiring.patch

