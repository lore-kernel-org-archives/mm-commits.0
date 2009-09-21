From: akpm@linux-foundation.org
Subject: [folded] getrusage-fill-ru_maxrss-value-update.patch removed from -mm tree
Date: Mon, 21 Sep 2009 14:39:52 -0700
Message-ID: <200909212139.n8LLdqjR007956@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803AbZIUVkG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 Sep 2009 17:40:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jpirko@redhat.com, hugh.dickins@tiscali.co.uk, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     getrusage-fill-ru_maxrss-value-update
has been removed from the -mm tree.  Its filename was
     getrusage-fill-ru_maxrss-value-update.patch

This patch was dropped because it was folded into getrusage-fill-ru_maxrss-value.patch

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
@@ -426,6 +426,15 @@ static inline unsigned long get_mm_hiwat
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
