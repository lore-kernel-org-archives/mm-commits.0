From: akpm@linux-foundation.org
Subject: + alpha-forward-declare-struct-pt_regs-in-processorh.patch added
 to -mm tree
Date: Thu, 16 Apr 2015 10:28:02 -0700
Message-ID: <552ff122.Tw/l0ukRXTHLmO2k%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245AbbDPR2D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 16 Apr 2015 13:28:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, ink@jurassic.park.msu.ru, mattst88@gmail.com, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: forward declare struct pt_regs in processor.h
has been added to the -mm tree.  Its filename is
     alpha-forward-declare-struct-pt_regs-in-processorh.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/alpha-forward-declare-struct-pt_regs-in-processorh.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/alpha-forward-declare-struct-pt_regs-in-processorh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: alpha: forward declare struct pt_regs in processor.h

Removal of exec domains uncovered this new warning.  processor.h re-used
struct pt_regs from personality.h which is now gone.

./arch/alpha/include/asm/processor.h:47:33: warning: 'struct pt_regs' declared inside parameter list [enabled by default]

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/processor.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/alpha/include/asm/processor.h~alpha-forward-declare-struct-pt_regs-in-processorh arch/alpha/include/asm/processor.h
--- a/arch/alpha/include/asm/processor.h~alpha-forward-declare-struct-pt_regs-in-processorh
+++ a/arch/alpha/include/asm/processor.h
@@ -44,6 +44,7 @@ struct task_struct;
 extern unsigned long thread_saved_pc(struct task_struct *);
 
 /* Do necessary setup to start up a newly executed thread.  */
+struct pt_regs;
 extern void start_thread(struct pt_regs *, unsigned long, unsigned long);
 
 /* Free all resources held by a thread. */
_

Patches currently in -mm which might be from richard@nod.at are

origin.patch
alpha-forward-declare-struct-pt_regs-in-processorh.patch
signal-remove-warning-about-using-si_tkill-in-rt_sigqueueinfo.patch
linux-next.patch

