From: akpm@linux-foundation.org
Subject: + parisc-fix-smp-build-error.patch added to -mm tree
Date: Wed, 12 Nov 2008 16:27:33 -0800
Message-ID: <200811130027.mAD0RX1G020094@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927AbYKMA2y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Nov 2008 19:28:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cavokz@gmail.com, cavok@dandreoli.com, grundler@parisc-linux.org, kyle@mcmartin.ca, mingo@elte.hu, rusty@rustcorp.com.au


The patch titled
     parisc: fix SMP build error
has been added to the -mm tree.  Its filename is
     parisc-fix-smp-build-error.patch

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
Subject: parisc: fix SMP build error
From: Domenico Andreoli <cavokz@gmail.com>

Remove extern declaration of cpu_present_mask.

Fixes build error due to new cpumask API
2d3854a37e8b767a51aba38ed6d22817b0631e33 ("cpumask: introduce new API,
without changing anything").

Signed-off-by: Domenico Andreoli <cavok@dandreoli.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Grant Grundler <grundler@parisc-linux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/parisc/include/asm/smp.h |    2 --
 1 file changed, 2 deletions(-)

diff -puN arch/parisc/include/asm/smp.h~parisc-fix-smp-build-error arch/parisc/include/asm/smp.h
--- a/arch/parisc/include/asm/smp.h~parisc-fix-smp-build-error
+++ a/arch/parisc/include/asm/smp.h
@@ -44,8 +44,6 @@ extern void arch_send_call_function_ipi(
  
 #define PROC_CHANGE_PENALTY	15		/* Schedule penalty */
 
-extern unsigned long cpu_present_mask;
