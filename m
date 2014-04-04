From: akpm@linux-foundation.org
Subject: [merged] sh-remove-unused-do_fpu_error.patch removed from -mm
 tree
Date: Fri, 04 Apr 2014 12:29:47 -0700
Message-ID: <533f082b.hQG8qSDosNS0Tyrc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42678 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaDDT3r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:29:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.mundt@gmail.com, koorogi@koorogi.info

Subject: [merged] sh-remove-unused-do_fpu_error.patch removed from -mm tree
To: koorogi@koorogi.info,paul.mundt@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:29:47 -0700


The patch titled
     Subject: sh: remove unused do_fpu_error
has been removed from the -mm tree.  Its filename was
     sh-remove-unused-do_fpu_error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bobby Bingham <koorogi@koorogi.info>
Subject: sh: remove unused do_fpu_error

This does not appear to have been used since 74d99a5e26222 ("sh: SH-2A FPU
support") in 2007.

Signed-off-by: Bobby Bingham <koorogi@koorogi.info>
Cc: Paul Mundt <paul.mundt@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/math-emu/math.c |   18 ------------------
 1 file changed, 18 deletions(-)

diff -puN arch/sh/math-emu/math.c~sh-remove-unused-do_fpu_error arch/sh/math-emu/math.c
--- a/arch/sh/math-emu/math.c~sh-remove-unused-do_fpu_error
+++ a/arch/sh/math-emu/math.c
@@ -574,24 +574,6 @@ static int ieee_fpe_handler(struct pt_re
 	return 0;
 }
 
-asmlinkage void do_fpu_error(unsigned long r4, unsigned long r5,
-			     unsigned long r6, unsigned long r7,
-			     struct pt_regs regs)
-{
-	struct task_struct *tsk = current;
-	siginfo_t info;
-
-	if (ieee_fpe_handler (&regs))
-		return;
-
-	regs.pc += 2;
-	info.si_signo = SIGFPE;
-	info.si_errno = 0;
-	info.si_code = FPE_FLTINV;
-	info.si_addr = (void __user *)regs.pc;
-	force_sig_info(SIGFPE, &info, tsk);
-}
