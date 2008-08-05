From: akpm@linux-foundation.org
Subject: + rcu-trace-fix-possible-mem-leak.patch added to -mm tree
Date: Tue, 05 Aug 2008 15:32:18 -0700
Message-ID: <200808052232.m75MWIxC026919@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39650 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755074AbYHEWde (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Aug 2008 18:33:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rostedt@goodmis.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com, peterz@infradead.org, tglx@linutronix.de


The patch titled
     rcu: trace fix possible mem-leak
has been added to the -mm tree.  Its filename is
     rcu-trace-fix-possible-mem-leak.patch

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

origin.patch
rcu-just-rename-call_rcu_bh-instead-of-making-it-a-macro.patch
rcu-trace-fix-possible-mem-leak.patch
ftrace-new-continue-entry-separate-out-from-trace_entry.patch
ftrace-printk-formatting-infrastructure.patch
ftrace-printk-formatting-infrastructure-fix.patch
ftrace-disable-function-tracing-bringing-up-new-cpu.patch

