From: akpm@linux-foundation.org
Subject: + arm64-kasan-clear-stale-stack-poison.patch added to -mm tree
Date: Fri, 04 Mar 2016 14:33:42 -0800
Message-ID: <56da0d46.0fMC8XeYYQJTXgKe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851AbcCDWdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 17:33:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, aryabinin@virtuozzo.com, catalin.marinas@arm.com, glider@google.com, lorenzo.pieralisi@arm.com, mingo@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: clear stale stack poison
has been added to the -mm tree.  Its filename is
     arm64-kasan-clear-stale-stack-poison.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arm64-kasan-clear-stale-stack-poison.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arm64-kasan-clear-stale-stack-poison.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mark Rutland <mark.rutland@arm.com>
Subject: arm64: kasan: clear stale stack poison

Functions which the compiler has instrumented for KASAN place poison on
the stack shadow upon entry and remove this poison prior to returning.

In the case of cpuidle, CPUs exit the kernel a number of levels deep in C
code.  Any instrumented functions on this critical path will leave
portions of the stack shadow poisoned.

If CPUs lose context and return to the kernel via a cold path, we restore
a prior context saved in __cpu_suspend_enter are forgotten, and we never
remove the poison they placed in the stack shadow area by functions calls
between this and the actual exit of the kernel.

Thus, (depending on stackframe layout) subsequent calls to instrumented
functions may hit this stale poison, resulting in (spurious) KASAN splats
to the console.

To avoid this, clear any stale poison from the idle thread for a CPU prior
to bringing a CPU online.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reviewed-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/kernel/sleep.S |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN arch/arm64/kernel/sleep.S~arm64-kasan-clear-stale-stack-poison arch/arm64/kernel/sleep.S
--- a/arch/arm64/kernel/sleep.S~arm64-kasan-clear-stale-stack-poison
+++ a/arch/arm64/kernel/sleep.S
@@ -145,6 +145,10 @@ ENTRY(cpu_resume_mmu)
 ENDPROC(cpu_resume_mmu)
 	.popsection
 cpu_resume_after_mmu:
+#ifdef CONFIG_KASAN
+	mov	x0, sp
+	bl	kasan_unpoison_remaining_stack
+#endif
 	mov	x0, #0			// return zero on success
 	ldp	x19, x20, [sp, #16]
 	ldp	x21, x22, [sp, #32]
_

Patches currently in -mm which might be from mark.rutland@arm.com are

kasan-add-functions-to-clear-stack-poison.patch
sched-kasan-remove-stale-kasan-poison-after-hotplug.patch
arm64-kasan-clear-stale-stack-poison.patch

