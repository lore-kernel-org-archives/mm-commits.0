From: akpm@linux-foundation.org
Subject: - signals-join-send_sigqueue-with-send_group_sigqueue.patch removed from -mm tree
Date: Thu, 01 May 2008 02:26:51 -0700
Message-ID: <200805010926.m419QpJk030340@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56975 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752689AbYEAJ1k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:27:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: join send_sigqueue() with send_group_sigqueue()
has been removed from the -mm tree.  Its filename was
     signals-join-send_sigqueue-with-send_group_sigqueue.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: join send_sigqueue() with send_group_sigqueue()
From: Oleg Nesterov <oleg@tv-sign.ru>

We export send_sigqueue() and send_group_sigqueue() for the only user,
posix_timer_event().  This is a bit silly, because both are just trivial
helpers on top of do_send_sigqueue() and because the we pass the unused
.si_signo parameter.

Kill them both, rename do_send_sigqueue() to send_sigqueue(), and export it.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    3 +--
 kernel/posix-timers.c |    6 ++----
 kernel/signal.c       |   15 +--------------
 3 files changed, 4 insertions(+), 20 deletions(-)

diff -puN include/linux/sched.h~signals-join-send_sigqueue-with-send_group_sigqueue include/linux/sched.h
--- a/include/linux/sched.h~signals-join-send_sigqueue-with-send_group_sigqueue
+++ a/include/linux/sched.h
@@ -1751,8 +1751,7 @@ extern void zap_other_threads(struct tas
 extern int kill_proc(pid_t, int, int);
 extern struct sigqueue *sigqueue_alloc(void);
 extern void sigqueue_free(struct sigqueue *);
-extern int send_sigqueue(int, struct sigqueue *,  struct task_struct *);
-extern int send_group_sigqueue(int, struct sigqueue *,  struct task_struct *);
+extern int send_sigqueue(struct sigqueue *,  struct task_struct *, int group);
 extern int do_sigaction(int, struct k_sigaction *, struct k_sigaction *);
 extern int do_sigaltstack(const stack_t __user *, stack_t __user *, unsigned long);
 
diff -puN kernel/posix-timers.c~signals-join-send_sigqueue-with-send_group_sigqueue kernel/posix-timers.c
--- a/kernel/posix-timers.c~signals-join-send_sigqueue-with-send_group_sigqueue
+++ a/kernel/posix-timers.c
@@ -310,8 +310,7 @@ int posix_timer_event(struct k_itimer *t
 
 	if (timr->it_sigev_notify & SIGEV_THREAD_ID) {
 		struct task_struct *leader;
-		int ret = send_sigqueue(timr->it_sigev_signo, timr->sigq,
-					timr->it_process);
+		int ret = send_sigqueue(timr->sigq, timr->it_process, 0);
 
 		if (likely(ret >= 0))
 			return ret;
@@ -322,8 +321,7 @@ int posix_timer_event(struct k_itimer *t
 		timr->it_process = leader;
 	}
 
-	return send_group_sigqueue(timr->it_sigev_signo, timr->sigq,
-				   timr->it_process);
+	return send_sigqueue(timr->sigq, timr->it_process, 1);
 }
 EXPORT_SYMBOL_GPL(posix_timer_event);
 
diff -puN kernel/signal.c~signals-join-send_sigqueue-with-send_group_sigqueue kernel/signal.c
--- a/kernel/signal.c~signals-join-send_sigqueue-with-send_group_sigqueue
+++ a/kernel/signal.c
@@ -1240,8 +1240,7 @@ void sigqueue_free(struct sigqueue *q)
 	__sigqueue_free(q);
 }
 
-static int do_send_sigqueue(struct sigqueue *q, struct task_struct *t,
-				int group)
+int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 {
 	int sig = q->info.si_signo;
 	struct sigpending *pending;
@@ -1266,7 +1265,6 @@ static int do_send_sigqueue(struct sigqu
 		 * If an SI_TIMER entry is already queue just increment
 		 * the overrun count.
 		 */
-
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
 		goto out;
@@ -1283,17 +1281,6 @@ ret:
 	return ret;
 }
 
-int send_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
-{
-	return do_send_sigqueue(q, p, 0);
-}
-
-int
-send_group_sigqueue(int sig, struct sigqueue *q, struct task_struct *p)
-{
-	return do_send_sigqueue(q, p, 1);
-}
