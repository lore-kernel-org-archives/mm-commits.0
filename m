From: akpm@linux-foundation.org
Subject: + signals-annotate-lock_task_sighand.patch added to -mm tree
Date: Mon, 27 Sep 2010 14:11:59 -0700
Message-ID: <201009272111.o8RLBx0q016885@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39633 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751806Ab0I0VMs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Sep 2010 17:12:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: namhyung@gmail.com, eric.dumazet@gmail.com, mingo@elte.hu, oleg@redhat.com, roland@redhat.com


The patch titled
     signals: annotate lock_task_sighand()
has been added to the -mm tree.  Its filename is
     signals-annotate-lock_task_sighand.patch

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
Subject: signals: annotate lock_task_sighand()
From: Namhyung Kim <namhyung@gmail.com>

lock_task_sighand() grabs sighand->siglock in case of returning non-NULL
but unlock_task_sighand() releases it unconditionally.  This leads sparse
to complain about the lock context imbalance.  Rename and wrap
lock_task_sighand() using __cond_lock() macro to make sparse happy.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    9 ++++++++-
 kernel/signal.c       |    3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~signals-annotate-lock_task_sighand include/linux/sched.h
--- a/include/linux/sched.h~signals-annotate-lock_task_sighand
+++ a/include/linux/sched.h
@@ -2223,9 +2223,16 @@ static inline void task_unlock(struct ta
 	spin_unlock(&p->alloc_lock);
 }
 
-extern struct sighand_struct *lock_task_sighand(struct task_struct *tsk,
+extern struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
 							unsigned long *flags);
 
+#define lock_task_sighand(tsk, flags)					\
+({	struct sighand_struct *__ss;					\
+	__cond_lock(&(tsk)->sighand->siglock,				\
+		    (__ss = __lock_task_sighand(tsk, flags)));		\
+	__ss;								\
+})									\
+
 static inline void unlock_task_sighand(struct task_struct *tsk,
 						unsigned long *flags)
 {
diff -puN kernel/signal.c~signals-annotate-lock_task_sighand kernel/signal.c
--- a/kernel/signal.c~signals-annotate-lock_task_sighand
+++ a/kernel/signal.c
@@ -1105,7 +1105,8 @@ int zap_other_threads(struct task_struct
 	return count;
 }
 
-struct sighand_struct *lock_task_sighand(struct task_struct *tsk, unsigned long *flags)
+struct sighand_struct *__lock_task_sighand(struct task_struct *tsk,
+					   unsigned long *flags)
 {
 	struct sighand_struct *sighand;
 
_

Patches currently in -mm which might be from namhyung@gmail.com are

linux-next.patch
init-mark-__user-address-space-on-string-literals.patch
kernel-userc-add-lock-release-annotation-on-free_user.patch
printk-fixup-declaration-of-kmsg_reasons.patch
printk-add-lock-context-annotation.patch
printk-change-type-of-boot_delay-to-int.patch
printk-declare-printk_ratelimit_state-in-ratelimith.patch
printk-declare-printk_ratelimit_state-in-ratelimith-fix.patch
signals-annotate-lock_task_sighand.patch
exit-add-lock-context-annotation-on-find_new_reaper.patch

