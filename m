From: akpm@linux-foundation.org
Subject: [merged] signals-introduce-do_send_sig_info-helper.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:45 -0700
Message-ID: <200909241935.n8OJZjkf001094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753559AbZIXTqt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:46:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, a.p.zijlstra@chello.nl, eranian@googlemail.com, mingo@elte.hu, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: introduce do_send_sig_info() helper
has been removed from the -mm tree.  Its filename was
     signals-introduce-do_send_sig_info-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: introduce do_send_sig_info() helper
From: Oleg Nesterov <oleg@redhat.com>

Introduce do_send_sig_info() and convert group_send_sig_info(),
send_sig_info(), do_send_specific() to use this helper.

Hopefully it will have more users soon, it allows to specify
specific/group behaviour via "bool group" argument.

Shaves 80 bytes from .text.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: stephane eranian <eranian@googlemail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |    2 +
 kernel/signal.c        |   56 ++++++++++++++++++---------------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff -puN include/linux/signal.h~signals-introduce-do_send_sig_info-helper include/linux/signal.h
--- a/include/linux/signal.h~signals-introduce-do_send_sig_info-helper
+++ a/include/linux/signal.h
@@ -233,6 +233,8 @@ static inline int valid_signal(unsigned 
 }
 
 extern int next_signal(struct sigpending *pending, sigset_t *mask);
+extern int do_send_sig_info(int sig, struct siginfo *info,
+				struct task_struct *p, bool group);
 extern int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p);
 extern int __group_send_sig_info(int, struct siginfo *, struct task_struct *);
 extern long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig,
diff -puN kernel/signal.c~signals-introduce-do_send_sig_info-helper kernel/signal.c
--- a/kernel/signal.c~signals-introduce-do_send_sig_info-helper
+++ a/kernel/signal.c
@@ -971,6 +971,20 @@ specific_send_sig_info(int sig, struct s
 	return send_signal(sig, info, t, 0);
 }
 
+int do_send_sig_info(int sig, struct siginfo *info, struct task_struct *p,
+			bool group)
+{
+	unsigned long flags;
+	int ret = -ESRCH;
+
+	if (lock_task_sighand(p, &flags)) {
+		ret = send_signal(sig, info, p, group);
+		unlock_task_sighand(p, &flags);
+	}
+
+	return ret;
+}
+
 /*
  * Force a signal that the process can't ignore: if necessary
  * we unblock the signal and change any SIG_IGN to SIG_DFL.
@@ -1068,18 +1082,10 @@ struct sighand_struct *lock_task_sighand
  */
 int group_send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	unsigned long flags;
-	int ret;
-
-	ret = check_kill_permission(sig, info, p);
+	int ret = check_kill_permission(sig, info, p);
 
-	if (!ret && sig) {
-		ret = -ESRCH;
-		if (lock_task_sighand(p, &flags)) {
-			ret = __group_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
-		}
-	}
+	if (!ret && sig)
+		ret = do_send_sig_info(sig, info, p, true);
 
 	return ret;
 }
@@ -1224,15 +1230,9 @@ static int kill_something_info(int sig, 
  * These are for backward compatibility with the rest of the kernel source.
  */
 
-/*
- * The caller must ensure the task can't exit.
- */
 int
 send_sig_info(int sig, struct siginfo *info, struct task_struct *p)
 {
-	int ret;
-	unsigned long flags;
-
 	/*
 	 * Make sure legacy kernel users don't send in bad values
 	 * (normal paths check this in check_kill_permission).
@@ -1240,10 +1240,7 @@ send_sig_info(int sig, struct siginfo *i
 	if (!valid_signal(sig))
 		return -EINVAL;
 
-	spin_lock_irqsave(&p->sighand->siglock, flags);
-	ret = specific_send_sig_info(sig, info, p);
-	spin_unlock_irqrestore(&p->sighand->siglock, flags);
-	return ret;
+	return do_send_sig_info(sig, info, p, false);
 }
 
 #define __si_special(priv) \
@@ -2278,7 +2275,6 @@ static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct siginfo *info)
 {
 	struct task_struct *p;
-	unsigned long flags;
 	int error = -ESRCH;
 
 	rcu_read_lock();
@@ -2288,14 +2284,16 @@ do_send_specific(pid_t tgid, pid_t pid, 
 		/*
 		 * The null signal is a permissions and process existence
 		 * probe.  No signal is actually delivered.
-		 *
-		 * If lock_task_sighand() fails we pretend the task dies
-		 * after receiving the signal. The window is tiny, and the
-		 * signal is private anyway.
 		 */
-		if (!error && sig && lock_task_sighand(p, &flags)) {
-			error = specific_send_sig_info(sig, info, p);
-			unlock_task_sighand(p, &flags);
+		if (!error && sig) {
+			error = do_send_sig_info(sig, info, p, false);
+			/*
+			 * If lock_task_sighand() failed we pretend the task
+			 * dies after receiving the signal. The window is tiny,
+			 * and the signal is private anyway.
+			 */
+			if (unlikely(error == -ESRCH))
+				error = 0;
 		}
 	}
 	rcu_read_unlock();
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
linux-next.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch
utrace-core.patch

