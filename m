From: akpm@linux-foundation.org
Subject: + sh-remove-unused-do_fpu_error.patch added to -mm tree
Date: Wed, 19 Feb 2014 13:01:57 -0800
Message-ID: <53051bc5.UDyIAT+mUstDSIrt%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbaBSVB6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 19 Feb 2014 16:01:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, paul.mundt@gmail.com, koorogi@koorogi.info

Subject: + sh-remove-unused-do_fpu_error.patch added to -mm tree
To: koorogi@koorogi.info,paul.mundt@gmail.com
From: akpm@linux-foundation.org
Date: Wed, 19 Feb 2014 13:01:57 -0800


The patch titled
     Subject: sh: remove unused do_fpu_error
has been added to the -mm tree.  Its filename is
     sh-remove-unused-do_fpu_error.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sh-remove-unused-do_fpu_error.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sh-remove-unused-do_fpu_error.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
