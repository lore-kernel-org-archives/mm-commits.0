From: akpm@linux-foundation.org
Subject: + fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch added to -mm tree
Date: Fri, 15 Feb 2008 12:24:17 -0800
Message-ID: <200802152024.m1FKOHhT022160@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53656 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762346AbYBOUYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 15:24:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiyou.wangcong@gmail.com, tglx@linutronix.de


The patch titled
     Fix shadowed variables in kernel/posix-cpu-timers.c
has been added to the -mm tree.  Its filename is
     fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Fix shadowed variables in kernel/posix-cpu-timers.c
From: WANG Cong <xiyou.wangcong@gmail.com>

Fix sparse warnings like this:
kernel/posix-cpu-timers.c:1090:25: warning: symbol 't' shadows an earlier one
kernel/posix-cpu-timers.c:1058:21: originally declared here

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/posix-cpu-timers.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff -puN kernel/posix-cpu-timers.c~fix-shadowed-variables-in-kernel-posix-cpu-timersc kernel/posix-cpu-timers.c
--- a/kernel/posix-cpu-timers.c~fix-shadowed-variables-in-kernel-posix-cpu-timersc
+++ a/kernel/posix-cpu-timers.c
@@ -1087,45 +1087,45 @@ static void check_process_timers(struct 
 	maxfire = 20;
 	prof_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(ptime, t->expires.cpu)) {
-			prof_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(ptime, tl->expires.cpu)) {
+			prof_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	virt_expires = cputime_zero;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || cputime_lt(utime, t->expires.cpu)) {
-			virt_expires = t->expires.cpu;
+		if (!--maxfire || cputime_lt(utime, tl->expires.cpu)) {
+			virt_expires = tl->expires.cpu;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	++timers;
 	maxfire = 20;
 	sched_expires = 0;
 	while (!list_empty(timers)) {
-		struct cpu_timer_list *t = list_first_entry(timers,
+		struct cpu_timer_list *tl = list_first_entry(timers,
 						      struct cpu_timer_list,
 						      entry);
-		if (!--maxfire || sum_sched_runtime < t->expires.sched) {
-			sched_expires = t->expires.sched;
+		if (!--maxfire || sum_sched_runtime < tl->expires.sched) {
+			sched_expires = tl->expires.sched;
 			break;
 		}
-		t->firing = 1;
-		list_move_tail(&t->entry, firing);
+		tl->firing = 1;
+		list_move_tail(&tl->entry, firing);
 	}
 
 	/*
_

Patches currently in -mm which might be from xiyou.wangcong@gmail.com are

uml-fix-initrd-printk.patch
arch-um-kernel-memc-fix-a-shadowed-variable.patch
fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch
