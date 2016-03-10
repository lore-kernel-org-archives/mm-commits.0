From: akpm@linux-foundation.org
Subject: [merged] arm64-kasan-clear-stale-stack-poison.patch removed from
 -mm tree
Date: Thu, 10 Mar 2016 10:58:07 -0800
Message-ID: <56e1c3bf.pIvY2q6yyHE63ivu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51831 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbcCJS6I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 10 Mar 2016 13:58:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mark.rutland@arm.com, aryabinin@virtuozzo.com, catalin.marinas@arm.com, glider@google.com, lorenzo.pieralisi@arm.com, mingo@kernel.org, will.deacon@arm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arm64: kasan: clear stale stack poison
has been removed from the -mm tree.  Its filename was
     arm64-kasan-clear-stale-stack-poison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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


