From: akpm@linux-foundation.org
Subject: [merged]
 signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch removed from -mm tree
Date: Mon, 09 Nov 2015 12:13:28 -0800
Message-ID: <5640fe68.FWd7UkJf1OboeITt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbbKIUN3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2015 15:13:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, balbi@ti.com, dwmw2@infradead.org, mpa@pengutronix.de, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: introduce kernel_signal_stop() to fix jffs2_garbage_collect_thread()
has been removed from the -mm tree.  Its filename was
     signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: introduce kernel_signal_stop() to fix jffs2_garbage_collect_thread()

jffs2_garbage_collect_thread() can race with SIGCONT and sleep in
TASK_STOPPED state after it was already sent. Add the new helper,
kernel_signal_stop(), which does this correctly.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Markus Pargmann <mpa@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jffs2/background.c |    3 +--
 include/linux/sched.h |   10 ++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/jffs2/background.c~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread fs/jffs2/background.c
--- a/fs/jffs2/background.c~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread
+++ a/fs/jffs2/background.c
@@ -132,8 +132,7 @@ static int jffs2_garbage_collect_thread(
 			case SIGSTOP:
 				jffs2_dbg(1, "%s(): SIGSTOP received\n",
 					  __func__);
-				set_current_state(TASK_STOPPED);
-				schedule();
+				kernel_signal_stop();
 				break;
 
 			case SIGKILL:
diff -puN include/linux/sched.h~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread include/linux/sched.h
--- a/include/linux/sched.h~signal-introduce-kernel_signal_stop-to-fix-jffs2_garbage_collect_thread
+++ a/include/linux/sched.h
@@ -2475,6 +2475,16 @@ static inline int kernel_dequeue_signal(
 	return ret;
 }
 
+static inline void kernel_signal_stop(void)
+{
+	spin_lock_irq(&current->sighand->siglock);
+	if (current->jobctl & JOBCTL_STOP_DEQUEUED)
+		__set_current_state(TASK_STOPPED);
+	spin_unlock_irq(&current->sighand->siglock);
+
+	schedule();
+}
+
 extern void release_task(struct task_struct * p);
 extern int send_sig_info(int, struct siginfo *, struct task_struct *);
 extern int force_sigsegv(int, struct task_struct *);
_

Patches currently in -mm which might be from oleg@redhat.com are


