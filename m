From: akpm@linux-foundation.org
Subject: - rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:09 -0700
Message-ID: <200808261845.m7QIj9CG021379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757705AbYHZSqq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org, srostedt@redhat.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rcu: just rename call_rcu_bh instead of making it a macro
has been removed from the -mm tree.  Its filename was
     rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch

