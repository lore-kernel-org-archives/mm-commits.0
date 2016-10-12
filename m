From: akpm@linux-foundation.org
Subject: + kprobes-avoid-false-kasan-reports-during-stack-copy.patch added to -mm tree
Date: Wed, 12 Oct 2016 15:10:47 -0700
Message-ID: <57feb4e7.rWd9OiQJ8L/Q2JJu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39482 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932694AbcJLWfu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Oct 2016 18:35:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, ananth@linux.vnet.ibm.com, anil.s.keshavamurthy@intel.com, caiqian@redhat.com, davem@davemloft.net, glider@google.com, hpa@zytor.com, mhiramat@kernel.org, mingo@redhat.com, ryabinin.a.a@gmail.com, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: kprobes: avoid false KASAN reports during stack copy
has been added to the -mm tree.  Its filename is
     kprobes-avoid-false-kasan-reports-during-stack-copy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kprobes-avoid-false-kasan-reports-during-stack-copy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kprobes-avoid-false-kasan-reports-during-stack-copy.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kprobes: avoid false KASAN reports during stack copy

Kprobes saves and restores raw stack chunks with memcpy().  With KASAN
these chunks can contain poisoned stack redzones, as the result memcpy()
interceptor produces false stack out-of-bounds reports.

Use __memcpy() instead of memcpy() for stack copying.  __memcpy() is not
instrumented by KASAN and does not lead to the false reports.

Link: http://lkml.kernel.org/r/1476188018-36101-1-git-send-email-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Reported-by: CAI Qian <caiqian@redhat.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ananth N Mavinakayanahalli <ananth@linux.vnet.ibm.com>
Cc: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/kprobes/core.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/x86/kernel/kprobes/core.c~kprobes-avoid-false-kasan-reports-during-stack-copy arch/x86/kernel/kprobes/core.c
--- a/arch/x86/kernel/kprobes/core.c~kprobes-avoid-false-kasan-reports-during-stack-copy
+++ a/arch/x86/kernel/kprobes/core.c
@@ -1057,9 +1057,11 @@ int setjmp_pre_handler(struct kprobe *p,
 	 * tailcall optimization. So, to be absolutely safe
 	 * we also save and restore enough stack bytes to cover
 	 * the argument area.
+	 * Use __memcpy to avoid KASAN stack out-of-bounds reports as we copy
+	 * raw stack chunk with redzones.
 	 */
-	memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
-	       MIN_STACK_SIZE(addr));
+	__memcpy(kcb->jprobes_stack, (kprobe_opcode_t *)addr,
+		 MIN_STACK_SIZE(addr));
 	regs->flags &= ~X86_EFLAGS_IF;
 	trace_hardirqs_off();
 	regs->ip = (unsigned long)(jp->entry);
@@ -1118,7 +1120,8 @@ int longjmp_break_handler(struct kprobe
 		/* It's OK to start function graph tracing again */
 		unpause_graph_tracing();
 		*regs = kcb->jprobe_saved_regs;
-		memcpy(saved_sp, kcb->jprobes_stack, MIN_STACK_SIZE(saved_sp));
+		__memcpy(saved_sp, kcb->jprobes_stack,
+			 MIN_STACK_SIZE(saved_sp));
 		preempt_enable_no_resched();
 		return 1;
 	}
_

Patches currently in -mm which might be from dvyukov@google.com are

kprobes-avoid-false-kasan-reports-during-stack-copy.patch

