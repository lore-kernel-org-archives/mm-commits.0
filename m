From: akpm@linux-foundation.org
Subject: - rcu-trace-fix-possible-mem-leak.patch removed from -mm tree
Date: Tue, 26 Aug 2008 11:45:18 -0700
Message-ID: <200808261845.m7QIjIgU021391@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757798AbYHZSqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 26 Aug 2008 14:46:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rostedt@goodmis.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     rcu: trace fix possible mem-leak
has been removed from the -mm tree.  Its filename was
     rcu-trace-fix-possible-mem-leak.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rcu: trace fix possible mem-leak
From: Steven Rostedt <rostedt@goodmis.org>

In the initialization of the RCU trace module, if
rcupreempt_debugfs_init() fails, we never free the the trace buffer.

This patch frees the trace buffer in case the debugfs fails.

Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupreempt_trace.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/rcupreempt_trace.c~rcu-trace-fix-possible-mem-leak kernel/rcupreempt_trace.c
--- a/kernel/rcupreempt_trace.c~rcu-trace-fix-possible-mem-leak
+++ a/kernel/rcupreempt_trace.c
@@ -308,11 +308,16 @@ out:
 
 static int __init rcupreempt_trace_init(void)
 {
+	int ret;
+
 	mutex_init(&rcupreempt_trace_mutex);
 	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
 	if (!rcupreempt_trace_buf)
 		return 1;
-	return rcupreempt_debugfs_init();
+	ret = rcupreempt_debugfs_init();
+	if (ret)
+		kfree(rcupreempt_trace_buf);
+	return ret;
 }
 
 static void __exit rcupreempt_trace_cleanup(void)
_

Patches currently in -mm which might be from rostedt@goodmis.org are

linux-next.patch
kbuild-ftrace-dont-assume-that-scripts-recordmcountpl-is-executable.patch

