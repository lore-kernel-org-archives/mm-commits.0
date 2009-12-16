From: akpm@linux-foundation.org
Subject: [merged] signals-kill-force_sig_specific.patch removed from -mm tree
Date: Wed, 16 Dec 2009 12:38:24 -0800
Message-ID: <200912162038.nBGKcO2i013424@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964940AbZLPUig (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 16 Dec 2009 15:38:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     signals: kill force_sig_specific()
has been removed from the -mm tree.  Its filename was
     signals-kill-force_sig_specific.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: kill force_sig_specific()
From: Oleg Nesterov <oleg@redhat.com>

Kill force_sig_specific(), this trivial wrapper has no callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    1 -
 kernel/signal.c       |    6 ------
 2 files changed, 7 deletions(-)

diff -puN include/linux/sched.h~signals-kill-force_sig_specific include/linux/sched.h
--- a/include/linux/sched.h~signals-kill-force_sig_specific
+++ a/include/linux/sched.h
@@ -2083,7 +2083,6 @@ extern int kill_proc_info(int, struct si
 extern int do_notify_parent(struct task_struct *, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
-extern void force_sig_specific(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
 extern void zap_other_threads(struct task_struct *p);
 extern struct sigqueue *sigqueue_alloc(void);
diff -puN kernel/signal.c~signals-kill-force_sig_specific kernel/signal.c
--- a/kernel/signal.c~signals-kill-force_sig_specific
+++ a/kernel/signal.c
@@ -1062,12 +1062,6 @@ force_sig_info(int sig, struct siginfo *
 	return ret;
 }
 
-void
-force_sig_specific(int sig, struct task_struct *t)
-{
-	force_sig_info(sig, SEND_SIG_FORCED, t);
-}
