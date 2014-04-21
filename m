From: akpm@linux-foundation.org
Subject: [merged]
 wait-explain-the-shadowing-and-type-inconsistencies.patch removed from -mm
 tree
Date: Mon, 21 Apr 2014 11:11:03 -0700
Message-ID: <53555f37.xgFc7IcHXQXvFtZ0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35652 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837AbaDUSLD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 14:11:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org, peterz@infradead.org

Subject: [merged] wait-explain-the-shadowing-and-type-inconsistencies.patch removed from -mm tree
To: peterz@infradead.org,akpm@linux-foundation.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 11:11:03 -0700


The patch titled
     Subject: wait: explain the shadowing and type inconsistencies
has been removed from the -mm tree.  Its filename was
     wait-explain-the-shadowing-and-type-inconsistencies.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Peter Zijlstra <peterz@infradead.org>
Subject: wait: explain the shadowing and type inconsistencies

Stick in a comment before someone else tries to fix the sparse warning
this generates.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/n/tip-o2ro6f3vkxklni0bc8f7m68s@git.kernel.org
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/wait.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff -puN include/linux/wait.h~wait-explain-the-shadowing-and-type-inconsistencies include/linux/wait.h
--- a/include/linux/wait.h~wait-explain-the-shadowing-and-type-inconsistencies
+++ a/include/linux/wait.h
@@ -191,11 +191,23 @@ wait_queue_head_t *bit_waitqueue(void *,
 	(!__builtin_constant_p(state) ||				\
 		state == TASK_INTERRUPTIBLE || state == TASK_KILLABLE)	\
 
+/*
+ * The below macro ___wait_event() has an explicit shadow of the __ret
+ * variable when used from the wait_event_*() macros.
+ *
+ * This is so that both can use the ___wait_cond_timeout() construct
+ * to wrap the condition.
+ *
+ * The type inconsistency of the wait_event_*() __ret variable is also
+ * on purpose; we use long where we can return timeout values and int
+ * otherwise.
+ */
+
 #define ___wait_event(wq, condition, state, exclusive, ret, cmd)	\
 ({									\
 	__label__ __out;						\
 	wait_queue_t __wait;						\
-	long __ret = ret;						\
+	long __ret = ret;	/* explicit shadow */			\
 									\
 	INIT_LIST_HEAD(&__wait.task_list);				\
 	if (exclusive)							\
_

Patches currently in -mm which might be from peterz@infradead.org are

x86-require-x86-64-for-automatic-numa-balancing.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels.patch
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix-2.patch
init-mainc-add-initcall_blacklist-kernel-parameter.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
kthreads-kill-clone_kernel-change-kernel_threadkernel_init-to-avoid-clone_sighand.patch
signals-kill-sigfindinword.patch
signals-s-siginitset-sigemptyset-in-do_sigtimedwait.patch
signals-kill-rm_from_queue-change-prepare_signal-to-use-for_each_thread.patch
signals-rename-rm_from_queue_full-to-flush_sigqueue_mask.patch
signals-cleanup-the-usage-of-t-current-in-do_sigaction.patch
signals-mv-disallow_signal-from-schedh-exitc-to-signal.patch
signals-jffs2-fix-the-wrong-usage-of-disallow_signal.patch
signals-kill-the-obsolete-sigdelset-and-recalc_sigpending-in-allow_signal.patch
signals-disallow_signal-should-flush-the-potentially-pending-signal.patch
signals-introduce-kernel_sigaction.patch
signals-change-wait_for_helper-to-use-kernel_sigaction.patch
linux-next.patch

