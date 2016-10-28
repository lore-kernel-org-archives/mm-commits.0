From: akpm@linux-foundation.org
Subject: [patch 03/20] h8300: fix syscall restarting
Date: Thu, 27 Oct 2016 17:46:24 -0700
Message-ID: <58129fe0.8VRp9QZcJf2kjJJD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57782 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936219AbcJ1AqZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 27 Oct 2016 20:46:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mark.rutland@arm.com, luto@amacapital.net, stable@vger.kernel.org, ysato@users.sourceforge.jp

From: Mark Rutland <mark.rutland@arm.com>
Subject: h8300: fix syscall restarting

Back in f56141e3e2d9aabf ("all arches, signal: move restart_block to
struct task_struct"), all architectures and core code were changed to use
task_struct::restart_block.  However, when h8300 support was subsequently
restored in v4.2, it was not updated to account for this, and maintains
thread_info::restart_block, which is not kept in sync.

This patch drops the redundant restart_block from thread_info, and moves
h8300 to the common one in task_struct, ensuring that syscall restarting
always works as expected.

Fixes: f56141e3e2d9aabf ("all arches, signal: move restart_block to struct task_struct")
Link: http://lkml.kernel.org/r/1476714934-11635-1-git-send-email-mark.rutland@arm.com
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: uclinux-h8-devel@lists.sourceforge.jp
Cc: <stable@vger.kernel.org>	[4.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/thread_info.h |    4 ----
 arch/h8300/kernel/signal.c           |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/h8300/include/asm/thread_info.h~h8300-fix-syscall-restarting arch/h8300/include/asm/thread_info.h
--- a/arch/h8300/include/asm/thread_info.h~h8300-fix-syscall-restarting
+++ a/arch/h8300/include/asm/thread_info.h
@@ -31,7 +31,6 @@ struct thread_info {
 	int		   cpu;			/* cpu we're on */
 	int		   preempt_count;	/* 0 => preemptable, <0 => BUG */
 	mm_segment_t		addr_limit;
-	struct restart_block restart_block;
 };
 
 /*
@@ -44,9 +43,6 @@ struct thread_info {
 	.cpu =		0,			\
 	.preempt_count = INIT_PREEMPT_COUNT,	\
 	.addr_limit	= KERNEL_DS,		\
-	.restart_block	= {			\
-		.fn = do_no_restart_syscall,	\
-	},					\
 }
 
 #define init_thread_info	(init_thread_union.thread_info)
diff -puN arch/h8300/kernel/signal.c~h8300-fix-syscall-restarting arch/h8300/kernel/signal.c
--- a/arch/h8300/kernel/signal.c~h8300-fix-syscall-restarting
+++ a/arch/h8300/kernel/signal.c
@@ -79,7 +79,7 @@ restore_sigcontext(struct sigcontext *us
 	unsigned int er0;
 
 	/* Always make any pending restarted system calls return -EINTR */
-	current_thread_info()->restart_block.fn = do_no_restart_syscall;
+	current->restart_block.fn = do_no_restart_syscall;
 
 	/* restore passed registers */
 #define COPY(r)  do { err |= get_user(regs->r, &usc->sc_##r); } while (0)
_
