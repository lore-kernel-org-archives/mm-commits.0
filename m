From: akpm@linux-foundation.org
Subject: + remove-unused-proc_change_penalty-constant.patch added to -mm tree
Date: Fri, 20 May 2011 12:16:12 -0700
Message-ID: <201105201916.p4KJGCoh025500@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38735 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752Ab1ETTRQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 May 2011 15:17:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org, ink@jurassic.park.msu.ru, kyle@mcmartin.ca, mattst88@gmail.com, richard@nod.at, rmk@arm.linux.org.uk, rth@twiddle.net, takata@linux-m32r.org


The patch titled
     Remove unused PROC_CHANGE_PENALTY constant
has been added to the -mm tree.  Its filename is
     remove-unused-proc_change_penalty-constant.patch

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
Subject: Remove unused PROC_CHANGE_PENALTY constant
From: Stephen Boyd <sboyd@codeaurora.org>

This constant hasn't been used since before the git era (2.6.12) and thus
can be dropped.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Richard Weinberger <richard@nod.at>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/smp.h  |    2 --
 arch/arm/include/asm/smp.h    |    6 ------
 arch/m32r/include/asm/smp.h   |    2 --
 arch/parisc/include/asm/smp.h |    9 ---------
 arch/um/include/asm/smp.h     |    1 -
 5 files changed, 20 deletions(-)

diff -puN arch/alpha/include/asm/smp.h~remove-unused-proc_change_penalty-constant arch/alpha/include/asm/smp.h
--- a/arch/alpha/include/asm/smp.h~remove-unused-proc_change_penalty-constant
+++ a/arch/alpha/include/asm/smp.h
@@ -39,8 +39,6 @@ struct cpuinfo_alpha {
 
 extern struct cpuinfo_alpha cpu_data[NR_CPUS];
 
-#define PROC_CHANGE_PENALTY     20
-
 #define hard_smp_processor_id()	__hard_smp_processor_id()
 #define raw_smp_processor_id()	(current_thread_info()->cpu)
 
diff -puN arch/arm/include/asm/smp.h~remove-unused-proc_change_penalty-constant arch/arm/include/asm/smp.h
--- a/arch/arm/include/asm/smp.h~remove-unused-proc_change_penalty-constant
+++ a/arch/arm/include/asm/smp.h
@@ -20,12 +20,6 @@
 
 #define raw_smp_processor_id() (current_thread_info()->cpu)
 
-/*
- * at the moment, there's not a big penalty for changing CPUs
- * (the >big< penalty is running SMP in the first place)
- */
-#define PROC_CHANGE_PENALTY		15
-
 struct seq_file;
 
 /*
diff -puN arch/m32r/include/asm/smp.h~remove-unused-proc_change_penalty-constant arch/m32r/include/asm/smp.h
--- a/arch/m32r/include/asm/smp.h~remove-unused-proc_change_penalty-constant
+++ a/arch/m32r/include/asm/smp.h
@@ -94,8 +94,6 @@ extern void arch_send_call_function_ipi_
 
 #define NO_PROC_ID (0xff)	/* No processor magic marker */
 
-#define PROC_CHANGE_PENALTY	(15)	/* Schedule penalty */
-
 /*
  * M32R-mp IPI
  */
diff -puN arch/parisc/include/asm/smp.h~remove-unused-proc_change_penalty-constant arch/parisc/include/asm/smp.h
--- a/arch/parisc/include/asm/smp.h~remove-unused-proc_change_penalty-constant
+++ a/arch/parisc/include/asm/smp.h
@@ -33,15 +33,6 @@ extern void arch_send_call_function_ipi_
 
 #endif /* !ASSEMBLY */
 
-/*
- *	This magic constant controls our willingness to transfer
- *      a process across CPUs. Such a transfer incurs cache and tlb
- *      misses. The current value is inherited from i386. Still needs
- *      to be tuned for parisc.
- */
- 
-#define PROC_CHANGE_PENALTY	15		/* Schedule penalty */
