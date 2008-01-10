From: akpm@linux-foundation.org
Subject: + fix-x86-32-bit-frame_pointer-chasing-code.patch added to -mm tree
Date: Wed, 09 Jan 2008 22:16:36 -0800
Message-ID: <200801100616.m0A6GG5W008445@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58534 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751297AbYAJGQ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jan 2008 01:16:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@linux.intel.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86: fix 32 bit FRAME_POINTER chasing code
has been added to the -mm tree.  Its filename is
     fix-x86-32-bit-frame_pointer-chasing-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: fix 32 bit FRAME_POINTER chasing code
From: Arjan van de Ven <arjan@linux.intel.com>

The current x86 32 bit FRAME_POINTER chasing code has a nasty bug in that
the EBP tracer doesn't actually update the value of EBP it is tracing, so
that the code doesn't actually switch to the irq stack properly.

The result is a truncated backtrace:

WARNING: at timeroops.c:8 kerneloops_regression_test() (Not tainted)
Pid: 0, comm: swapper Not tainted 2.6.24-0.77.rc4.git4.fc9 #1
 [<c040649a>] show_trace_log_lvl+0x1a/0x2f
 [<c0406d41>] show_trace+0x12/0x14
 [<c0407061>] dump_stack+0x6c/0x72
 [<e0258049>] kerneloops_regression_test+0x44/0x46 [timeroops]
 [<c04371ac>] run_timer_softirq+0x127/0x18f
 [<c0434685>] __do_softirq+0x78/0xff
 [<c0407759>] do_softirq+0x74/0xf7
 =======================

This patch fixes the code to update EBP properly, and to check the EIP
before printing (as the non-framepointer backtracer does) so that
the same test backtrace now looks like this:

WARNING: at timeroops.c:8 kerneloops_regression_test()
Pid: 0, comm: swapper Not tainted 2.6.24-rc7 #4
 [<c0405d17>] show_trace_log_lvl+0x1a/0x2f
 [<c0406681>] show_trace+0x12/0x14
 [<c0406ef2>] dump_stack+0x6a/0x70
 [<e01f6040>] kerneloops_regression_test+0x3b/0x3d [timeroops]
 [<c0426f07>] run_timer_softirq+0x11b/0x17c
 [<c04243ac>] __do_softirq+0x42/0x94
 [<c040704c>] do_softirq+0x50/0xb6
 [<c04242a9>] irq_exit+0x37/0x67
 [<c040714c>] do_IRQ+0x9a/0xaf
 [<c04057da>] common_interrupt+0x2e/0x34
 [<c05807fe>] cpuidle_idle_call+0x52/0x78
 [<c04034f3>] cpu_idle+0x46/0x60
 [<c05fbbd3>] rest_init+0x43/0x45
 [<c070aa3d>] start_kernel+0x279/0x27f
 =======================

This shows that the backtrace goes all the way down to user context now.
This bug was found during the port to 64 bit of the frame pointer backtracer.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/traps_32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/x86/kernel/traps_32.c~fix-x86-32-bit-frame_pointer-chasing-code arch/x86/kernel/traps_32.c
--- a/arch/x86/kernel/traps_32.c~fix-x86-32-bit-frame_pointer-chasing-code
+++ a/arch/x86/kernel/traps_32.c
@@ -125,7 +125,8 @@ static inline unsigned long print_contex
 		unsigned long addr;
 
 		addr = frame->return_address;
-		ops->address(data, addr);
+		if (__kernel_text_address(addr))
+			ops->address(data, addr);
 		/*
 		 * break out of recursive entries (such as
 		 * end_of_stack_stop_unwind_function). Also,
@@ -133,6 +134,7 @@ static inline unsigned long print_contex
 		 * move downwards!
 		 */
 		next = frame->next_frame;
+		ebp = (unsigned long) next;
 		if (next <= frame)
 			break;
 		frame = next;
_

Patches currently in -mm which might be from arjan@linux.intel.com are

git-input.patch
git-sched.patch
fix-x86-32-bit-frame_pointer-chasing-code.patch
drivers-edac-use-round_jiffies_relative.patch
