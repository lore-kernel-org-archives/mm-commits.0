From: akpm@linux-foundation.org
Subject: + kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch added to -mm tree
Date: Mon, 04 Jan 2010 13:16:54 -0800
Message-ID: <201001042116.o04LGsOI018390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752215Ab0ADVSC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jan 2010 16:18:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andi@firstfloor.org, ak@linux.intel.com, mingo@elte.hu, oleg@redhat.com, stable@kernel.org


The patch titled
     kernel/signal.c: fix kernel information leak with print-fatal-signals=1
has been added to the -mm tree.  Its filename is
     kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernel/signal.c: fix kernel information leak with print-fatal-signals=1
From: Andi Kleen <andi@firstfloor.org>

When print-fatal-signals is enabled it's possible to dump any memory
reachable by the kernel to the log by simply jumping to that address from
user space.

Or crash the system if there's some hardware with read side effects.

The fatal signals handler will dump 16 bytes at the execution address,
which is fully controlled by ring 3.

In addition when something jumps to a unmapped address there will be up to
16 additional useless page faults, which might be potentially slow (and at
least is not very efficient)

Fortunately this option is off by default and only there on i386.

But fix it by checking for kernel addresses and also stopping when there's
a page fault.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/signal.c~kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1 kernel/signal.c
--- a/kernel/signal.c~kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1
+++ a/kernel/signal.c
@@ -979,7 +979,8 @@ static void print_fatal_signal(struct pt
 		for (i = 0; i < 16; i++) {
 			unsigned char insn;
 
-			__get_user(insn, (unsigned char *)(regs->ip + i));
+			if (get_user(insn, (unsigned char *)(regs->ip + i)))
+				break;
 			printk("%02x ", insn);
 		}
 	}
_

Patches currently in -mm which might be from andi@firstfloor.org are

origin.patch
kernel-signalc-fix-kernel-information-leak-with-print-fatal-signals=1.patch
hardware-latency-detector-remove-default-m.patch
kbuild-move-fno-dwarf2-cfi-asm-to-powerpc-only.patch
mm-introduce-dump_page-and-print-symbolic-flag-names.patch
tracehooks-kill-some-pt_ptraced-checks.patch
tracehooks-check-pt_ptraced-before-reporting-the-single-step.patch
ptrace_signal-check-pt_ptraced-before-reporting-a-signal.patch
export-__ptrace_detach-and-do_notify_parent_cldstop.patch
reorder-the-code-in-kernel-ptracec.patch
implement-utrace-ptrace.patch
utrace-core.patch

