From: akpm@linux-foundation.org
Subject: + rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch added to -mm tree
Date: Tue, 05 Aug 2008 15:32:10 -0700
Message-ID: <200808052232.m75MWAtp026908@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41855 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754492AbYHEWdA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 18:33:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srostedt@redhat.org, tglx@linutronix.de


The patch titled
     rcu: just rename call_rcu_bh instead of making it a macro
has been added to the -mm tree.  Its filename is
     rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch

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
Subject: rcu: just rename call_rcu_bh instead of making it a macro
From: Steven Rostedt <rostedt@goodmis.org>

Seems that I found a box that has a config that passes call_rcu_bh as a
function pointer (see net/sctp/sm_make_chunk.c), so declaring the
call_rcu_bh has a macro function isn't good enough.

This patch makes it just another name of call_rcu for rcupreempt.

Signed-off-by: Steven Rostedt <srostedt@redhat.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rcupreempt.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN include/linux/rcupreempt.h~rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro include/linux/rcupreempt.h
--- a/include/linux/rcupreempt.h~rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro
+++ a/include/linux/rcupreempt.h
@@ -57,7 +57,13 @@ static inline void rcu_qsctr_inc(int cpu
 	rdssp->sched_qs++;
 }
 #define rcu_bh_qsctr_inc(cpu)
-#define call_rcu_bh(head, rcu) call_rcu(head, rcu)
+
+/*
+ * Someone might want to pass call_rcu_bh as a function pointer.
+ * So this needs to just be a rename and not a macro function.
+ *  (no parentheses)
+ */
+#define call_rcu_bh	 	call_rcu
 
 /**
  * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
_

Patches currently in -mm which might be from rostedt@goodmis.org are

origin.patch
rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch
rcu-trace-fix-possible-mem-leak.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch

