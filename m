From: akpm@linux-foundation.org
Subject: + posix_cpu_timers-consolidate-timer-list-cleanups.patch added to -mm tree
Date: Mon, 18 Mar 2013 14:25:06 -0700
Message-ID: <20130318212506.D86015A4358@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f202.google.com ([209.85.213.202]:56312 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933124Ab3CRVZI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Mar 2013 17:25:08 -0400
Received: by mail-ye0-f202.google.com with SMTP id q5so621020yen.5
        for <mm-commits@vger.kernel.org>; Mon, 18 Mar 2013 14:25:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fweisbec@gmail.com, a.p.zijlstra@chello.nl, mingo@elte.hu, oleg@redhat.com, sgruszka@redhat.com, tglx@linutronix.de


The patch titled
     Subject: posix_cpu_timers: consolidate timer list cleanups
has been added to the -mm tree.  Its filename is
     posix_cpu_timers-consolidate-timer-list-cleanups.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: posix_cpu_timers: consolidate timer list cleanups

Cleaning up the posix cpu timers on task exit shares some common code
among timer list types, most notably the list traversal and expiry time
update.

Unify this in a common helper.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   48 ++++++++++++++----------------------
 1 file changed, 19 insertions(+), 29 deletions(-)

diff -puN kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-timer-list-cleanups kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~posix_cpu_timers-consolidate-timer-list-cleanups
+++ a/kernel/posix-cpu-timers.c
@@ -382,6 +382,21 @@ static int posix_cpu_timer_del(struct k_
 	return ret;
 }
 
+static void cleanup_timers_list(struct list_head *head,
+				unsigned long long curr)
+{
+	struct cpu_timer_list *timer, *next;
+
+	list_for_each_entry_safe(timer, next, head, entry) {
+		list_del_init(&timer->entry);
+		if (timer->expires < curr) {
+			timer->expires = 0;
+		} else {
+			timer->expires -= curr;
+		}
+	}
+}
+
 /*
  * Clean out CPU timers still ticking when a thread exited.  The task
  * pointer is cleared, and the expiry time is replaced with the residual
@@ -392,37 +407,12 @@ static void cleanup_timers(struct list_h
 			   cputime_t utime, cputime_t stime,
 			   unsigned long long sum_exec_runtime)
 {
-	struct cpu_timer_list *timer, *next;
-	cputime_t ptime = utime + stime;
 
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(ptime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(ptime);
-		}
-	}
-
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < cputime_to_expires(utime)) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= cputime_to_expires(utime);
-		}
-	}
+	cputime_t ptime = utime + stime;
 
-	++head;
-	list_for_each_entry_safe(timer, next, head, entry) {
-		list_del_init(&timer->entry);
-		if (timer->expires < sum_exec_runtime) {
-			timer->expires = 0;
-		} else {
-			timer->expires -= sum_exec_runtime;
-		}
-	}
+	cleanup_timers_list(head, cputime_to_expires(ptime));
+	cleanup_timers_list(++head, cputime_to_expires(utime));
+	cleanup_timers_list(++head, sum_exec_runtime);
 }
 
 /*
_

Patches currently in -mm which might be from fweisbec@gmail.com are

linux-next.patch
irq_workh-fix-warning-when-config_irq_work=n.patch
printk-provide-a-wake_up_klogd-off-case.patch
printk-provide-a-wake_up_klogd-off-case-fix.patch
posix_cpu_timer-consolidate-expiry-time-type.patch
posix_cpu_timers-consolidate-timer-list-cleanups.patch
posix_cpu_timers-consolidate-expired-timers-check.patch
selftests-add-basic-posix-timers-selftests.patch
mm-trace-filemap-add-and-del.patch
mm-trace-filemap-add-and-del-v2.patch
printk-tracing-rework-console-tracing.patch

