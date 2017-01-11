From: akpm@linux-foundation.org
Subject: [merged]
 signal-protect-signal_unkillable-from-unintentional-clearing.patch removed
 from -mm tree
Date: Wed, 11 Jan 2017 14:28:15 -0800
Message-ID: <5876b17f.Byqh6n+6TcwamkHv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51544 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933263AbdAKW2i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 11 Jan 2017 17:28:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jamie.iles@oracle.com, mingo@redhat.com, oleg@redhat.com, peterz@infradead.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: protect SIGNAL_UNKILLABLE from unintentional clearing
has been removed from the -mm tree.  Its filename was
     signal-protect-signal_unkillable-from-unintentional-clearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Jamie Iles <jamie.iles@oracle.com>
Subject: signal: protect SIGNAL_UNKILLABLE from unintentional clearing.

Since 00cd5c37af (ptrace: permit ptracing of /sbin/init) we can now trace
init processes.  init is initially protected with SIGNAL_UNKILLABLE which
will prevent fatal signals such as SIGSTOP, but there are a number of
paths during tracing where SIGNAL_UNKILLABLE can be implicitly cleared.

This can result in init becoming stoppable/killable after tracing.  For
example, running:

  while true; do kill -STOP 1; done &
  strace -p 1

and then stopping strace and the kill loop will result in init being left
in state TASK_STOPPED.  Sending SIGCONT to init will resume it, but init
will now respond to future SIGSTOP signals rather than ignoring them.

Make sure that when setting SIGNAL_STOP_CONTINUED/SIGNAL_STOP_STOPPED
that we don't clear SIGNAL_UNKILLABLE.

Link: http://lkml.kernel.org/r/20170104122017.25047-1-jamie.iles@oracle.com
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   10 ++++++++++
 kernel/signal.c       |    4 ++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~signal-protect-signal_unkillable-from-unintentional-clearing include/linux/sched.h
--- a/include/linux/sched.h~signal-protect-signal_unkillable-from-unintentional-clearing
+++ a/include/linux/sched.h
@@ -854,6 +854,16 @@ struct signal_struct {
 
 #define SIGNAL_UNKILLABLE	0x00000040 /* for init: ignore fatal signals */
 
+#define SIGNAL_STOP_MASK (SIGNAL_CLD_MASK | SIGNAL_STOP_STOPPED | \
+			  SIGNAL_STOP_CONTINUED)
+
+static inline void signal_set_stop_flags(struct signal_struct *sig,
+					 unsigned int flags)
+{
+	WARN_ON(sig->flags & (SIGNAL_GROUP_EXIT|SIGNAL_GROUP_COREDUMP));
+	sig->flags = (sig->flags & ~SIGNAL_STOP_MASK) | flags;
+}
+
 /* If true, all threads except ->group_exit_task have pending SIGKILL */
 static inline int signal_group_exit(const struct signal_struct *sig)
 {
diff -puN kernel/signal.c~signal-protect-signal_unkillable-from-unintentional-clearing kernel/signal.c
--- a/kernel/signal.c~signal-protect-signal_unkillable-from-unintentional-clearing
+++ a/kernel/signal.c
@@ -346,7 +346,7 @@ static bool task_participate_group_stop(
 	 * fresh group stop.  Read comment in do_signal_stop() for details.
 	 */
 	if (!sig->group_stop_count && !(sig->flags & SIGNAL_STOP_STOPPED)) {
-		sig->flags = SIGNAL_STOP_STOPPED;
+		signal_set_stop_flags(sig, SIGNAL_STOP_STOPPED);
 		return true;
 	}
 	return false;
@@ -843,7 +843,7 @@ static bool prepare_signal(int sig, stru
 			 * will take ->siglock, notice SIGNAL_CLD_MASK, and
 			 * notify its parent. See get_signal_to_deliver().
 			 */
-			signal->flags = why | SIGNAL_STOP_CONTINUED;
+			signal_set_stop_flags(signal, why | SIGNAL_STOP_CONTINUED);
 			signal->group_stop_count = 0;
 			signal->group_exit_code = 0;
 		}
_

Patches currently in -mm which might be from jamie.iles@oracle.com are


