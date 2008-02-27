From: akpm@linux-foundation.org
Subject: - fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch removed from -mm tree
Date: Wed, 27 Feb 2008 14:17:20 -0800
Message-ID: <200802272217.m1RMHKLE000806@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759646AbYB0WRt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Feb 2008 17:17:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiyou.wangcong@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Fix shadowed variables in kernel/posix-cpu-timers.c
has been removed from the -mm tree.  Its filename was
     fix-shadowed-variables-in-kernel-posix-cpu-timersc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

git-hrt.patch
arch-um-kernel-um_archc-some-small-improvements.patch
elf-fix-shadowed-variables-in-fs-binfmt_elfc.patch
