From: akpm@linux-foundation.org
Subject: + getrusage-fill-ru_maxrss-value-update.patch added to -mm tree
Date: Wed, 17 Jun 2009 13:20:13 -0700
Message-ID: <200906172020.n5HKKDD7001712@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50505 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZFQUUx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 16:20:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpirko@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com


The patch titled
     getrusage-fill-ru_maxrss-value-update
has been added to the -mm tree.  Its filename is
     getrusage-fill-ru_maxrss-value-update.patch

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
Subject: getrusage-fill-ru_maxrss-value-update
From: Jiri Pirko <jpirko@redhat.com>

(resend, repetitive patterns put into an inline function - not using max macro
 because it's was decided not to use it in previous conversation)

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c             |    8 ++------
 include/linux/sched.h |    9 +++++++++
 kernel/exit.c         |    8 ++------
 kernel/sys.c          |    5 +----
 4 files changed, 14 insertions(+), 16 deletions(-)

diff -puN fs/exec.c~getrusage-fill-ru_maxrss-value-update fs/exec.c
--- a/fs/exec.c~getrusage-fill-ru_maxrss-value-update
+++ a/fs/exec.c
@@ -845,12 +845,8 @@ static int de_thread(struct task_struct 
 	sig->notify_count = 0;
 
 no_thread_group:
-	if (current->mm) {
-		unsigned long hiwater_rss = get_mm_hiwater_rss(current->mm);
-
-		if (sig->maxrss < hiwater_rss)
-			sig->maxrss = hiwater_rss;
-	}
+	if (current->mm)
+		setmax_mm_hiwater_rss(&sig->maxrss, current->mm);
 
 	exit_itimers(sig);
 	flush_itimer_signals();
diff -puN include/linux/sched.h~getrusage-fill-ru_maxrss-value-update include/linux/sched.h
--- a/include/linux/sched.h~getrusage-fill-ru_maxrss-value-update
+++ a/include/linux/sched.h
@@ -408,6 +408,15 @@ static inline unsigned long get_mm_hiwat
 	return max(mm->hiwater_rss, get_mm_rss(mm));
 }
 
+static inline void setmax_mm_hiwater_rss(unsigned long *maxrss,
+					 struct mm_struct *mm)
+{
+	unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
+
+	if (*maxrss < hiwater_rss)
+		*maxrss = hiwater_rss;
+}
+
 static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
 {
 	return max(mm->hiwater_vm, mm->total_vm);
diff -puN kernel/exit.c~getrusage-fill-ru_maxrss-value-update kernel/exit.c
--- a/kernel/exit.c~getrusage-fill-ru_maxrss-value-update
+++ a/kernel/exit.c
@@ -945,12 +945,8 @@ NORET_TYPE void do_exit(long code)
 	if (group_dead) {
 		hrtimer_cancel(&tsk->signal->real_timer);
 		exit_itimers(tsk->signal);
-		if (tsk->mm) {
-			unsigned long hiwater_rss = get_mm_hiwater_rss(tsk->mm);
-
-			if (tsk->signal->maxrss < hiwater_rss)
-				tsk->signal->maxrss = hiwater_rss;
-		}
+		if (tsk->mm)
+			setmax_mm_hiwater_rss(&tsk->signal->maxrss, tsk->mm);
 	}
 	acct_collect(code, group_dead);
 	if (group_dead)
diff -puN kernel/sys.c~getrusage-fill-ru_maxrss-value-update kernel/sys.c
--- a/kernel/sys.c~getrusage-fill-ru_maxrss-value-update
+++ a/kernel/sys.c
@@ -1401,10 +1401,7 @@ out:
 	if (who != RUSAGE_CHILDREN) {
 		struct mm_struct *mm = get_task_mm(p);
 		if (mm) {
-			unsigned long hiwater_rss = get_mm_hiwater_rss(mm);
