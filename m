From: akpm@linux-foundation.org
Subject: + signals-kill-force_sig_specific.patch added to -mm tree
Date: Fri, 16 Oct 2009 15:20:19 -0700
Message-ID: <200910162220.n9GMKJ8k000437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55319 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751460AbZJPWUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Oct 2009 18:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com, sukadev@us.ibm.com


The patch titled
     signals: kill force_sig_specific()
has been added to the -mm tree.  Its filename is
     signals-kill-force_sig_specific.patch

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
Subject: signals: kill force_sig_specific()
From: Oleg Nesterov <oleg@redhat.com>

Kill force_sig_specific(), this trivial wrapper has no callers.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN include/linux/sched.h~signals-kill-force_sig_specific include/linux/sched.h
--- a/include/linux/sched.h~signals-kill-force_sig_specific
+++ a/include/linux/sched.h
@@ -2074,7 +2074,6 @@ extern int kill_proc_info(int, struct si
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
@@ -1032,12 +1032,6 @@ force_sig_info(int sig, struct siginfo *
 	return ret;
 }
 
-void
-force_sig_specific(int sig, struct task_struct *t)
-{
-	force_sig_info(sig, SEND_SIG_FORCED, t);
-}
