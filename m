From: akpm@linux-foundation.org
Subject: [merged] signals-inline-__fatal_signal_pending.patch removed from -mm tree
Date: Thu, 24 Sep 2009 12:35:54 -0700
Message-ID: <200909241935.n8OJZsXb001382@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754031AbZIXTgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Sep 2009 15:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: roland@redhat.com, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     signals: inline __fatal_signal_pending
has been removed from the -mm tree.  Its filename was
     signals-inline-__fatal_signal_pending.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: signals: inline __fatal_signal_pending
From: Roland McGrath <roland@redhat.com>

__fatal_signal_pending inlines to one instruction on x86, probably two
instructions on other machines.  It takes two longer x86 instructions just
to call it and test its return value, not to mention the function itself.

On my random x86_64 config, this saved 70 bytes of text (59 of those being
__fatal_signal_pending itself).

Signed-off-by: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |    5 ++++-
 kernel/signal.c       |    6 ------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff -puN include/linux/sched.h~signals-inline-__fatal_signal_pending include/linux/sched.h
--- a/include/linux/sched.h~signals-inline-__fatal_signal_pending
+++ a/include/linux/sched.h
@@ -2334,7 +2334,10 @@ static inline int signal_pending(struct 
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
-extern int __fatal_signal_pending(struct task_struct *p);
+static inline int __fatal_signal_pending(struct task_struct *p)
+{
+	return unlikely(sigismember(&p->pending.signal, SIGKILL));
+}
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
diff -puN kernel/signal.c~signals-inline-__fatal_signal_pending kernel/signal.c
--- a/kernel/signal.c~signals-inline-__fatal_signal_pending
+++ a/kernel/signal.c
@@ -1050,12 +1050,6 @@ void zap_other_threads(struct task_struc
 	}
 }
 
-int __fatal_signal_pending(struct task_struct *tsk)
-{
-	return sigismember(&tsk->pending.signal, SIGKILL);
-}
-EXPORT_SYMBOL(__fatal_signal_pending);
