From: akpm@linux-foundation.org
Subject: - signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:33 -0700
Message-ID: <200807252259.m6PMxXX3003400@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53923 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752262AbYGYXAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mtk.manpages@googlemail.com, mingo@elte.hu, mtk.manpages@gmail.com, oleg@tv-sign.ru, roland@redhat.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     signals: make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
has been removed from the -mm tree.  Its filename was
     signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: make siginfo_t si_utime + si_sstime report times in USER_HZ, not HZ
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>

In the switch to configurable HZ in 2.6, the treatment of the si_utime and
si_stime fields that are exposed to userland via the siginfo structure
looks to have been botched.  As things stand, these fields report times in
units of HZ, so that userland gets information that varies depending on
the HZ that the kernel was configured with.  This patch changes the
reported values to use USER_HZ units.

Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN kernel/signal.c~signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz kernel/signal.c
--- a/kernel/signal.c~signals-make-siginfo_t-si_utime-si_sstime-report-times-in-user_hz-not-hz
+++ a/kernel/signal.c
@@ -1370,10 +1370,9 @@ void do_notify_parent(struct task_struct
 
 	info.si_uid = tsk->uid;
 
-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(cputime_add(tsk->utime,
+	info.si_utime = cputime_to_clock_t(cputime_add(tsk->utime,
 						       tsk->signal->utime));
-	info.si_stime = cputime_to_jiffies(cputime_add(tsk->stime,
+	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
 						       tsk->signal->stime));
 
 	info.si_status = tsk->exit_code & 0x7f;
@@ -1441,9 +1440,8 @@ static void do_notify_parent_cldstop(str
 
 	info.si_uid = tsk->uid;
 
-	/* FIXME: find out whether or not this is supposed to be c*time. */
-	info.si_utime = cputime_to_jiffies(tsk->utime);
-	info.si_stime = cputime_to_jiffies(tsk->stime);
+	info.si_utime = cputime_to_clock_t(tsk->utime);
+	info.si_stime = cputime_to_clock_t(tsk->stime);
 
  	info.si_code = why;
  	switch (why) {
_

Patches currently in -mm which might be from mtk.manpages@googlemail.com are

origin.patch

