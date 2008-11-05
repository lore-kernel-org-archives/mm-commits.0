From: akpm@linux-foundation.org
Subject: + alpha-use-generic-percpu-support.patch added to -mm tree
Date: Tue, 04 Nov 2008 16:30:24 -0800
Message-ID: <200811050030.mA50UODs022914@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYKEAat (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2008 19:30:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cl@linux-foundation.org, ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net, rusty@rustcorp.com.au, sfr@canb.auug.org.au


The patch titled
     alpha: use generic percpu support
has been added to the -mm tree.  Its filename is
     alpha-use-generic-percpu-support.patch

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
Subject: alpha: use generic percpu support
From: Christoph Lameter <cl@linux-foundation.org>

The percpu support for alpha currently expects a percpu variable to be
passed to SHIFT_PERCPU_PTR.  However, SHIFT_PERCPU_PTR takes a pointer
and not a variable.  This breaks code that uses SHIFT_PERCPU_PTR on a
pointer.

Simply switch alpha to use generic cpu.

The purpose of the special percpu code seems to be optmization.  That
could be done by modifying the per_cpu_var() (and related) macros which
indeed take a variable as a parameter.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Jay Estabrook <jay.estabrook@hp.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
CC: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/percpu.h |   77 ------------------------------
 1 file changed, 1 insertion(+), 76 deletions(-)

diff -puN arch/alpha/include/asm/percpu.h~alpha-use-generic-percpu-support arch/alpha/include/asm/percpu.h
--- a/arch/alpha/include/asm/percpu.h~alpha-use-generic-percpu-support
+++ a/arch/alpha/include/asm/percpu.h
@@ -1,79 +1,4 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
-#include <linux/compiler.h>
-#include <linux/threads.h>
-
-/*
- * Determine the real variable name from the name visible in the
- * kernel sources.
- */
-#define per_cpu_var(var) per_cpu__##var
-
-#ifdef CONFIG_SMP
-
-/*
- * per_cpu_offset() is the offset that has to be added to a
- * percpu variable to get to the instance for a certain processor.
- */
-extern unsigned long __per_cpu_offset[NR_CPUS];
-
-#define per_cpu_offset(x) (__per_cpu_offset[x])
-
-#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
-#ifdef CONFIG_DEBUG_PREEMPT
-#define my_cpu_offset per_cpu_offset(smp_processor_id())
-#else
-#define my_cpu_offset __my_cpu_offset
-#endif
-
-#ifndef MODULE
-#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
-#define PER_CPU_ATTRIBUTES
-#else
-/*
- * To calculate addresses of locally defined variables, GCC uses 32-bit
- * displacement from the GP. Which doesn't work for per cpu variables in
- * modules, as an offset to the kernel per cpu area is way above 4G.
- *
- * This forces allocation of a GOT entry for per cpu variable using
- * ldq instruction with a 'literal' relocation.
- */
-#define SHIFT_PERCPU_PTR(var, offset) ({		\
-	extern int simple_identifier_##var(void);	\
-	unsigned long __ptr, tmp_gp;			\
-	asm (  "br	%1, 1f		  	      \n\
-	1:	ldgp	%1, 0(%1)	    	      \n\
-		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
-		: "=&r"(__ptr), "=&r"(tmp_gp));		\
-	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
-
-#define PER_CPU_ATTRIBUTES	__used
-
-#endif /* MODULE */
-
-/*
- * A percpu variable may point to a discarded regions. The following are
- * established ways to produce a usable pointer from the percpu variable
- * offset.
- */
-#define per_cpu(var, cpu) \
-	(*SHIFT_PERCPU_PTR(var, per_cpu_offset(cpu)))
-#define __get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
-#define __raw_get_cpu_var(var) \
-	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
-
-#else /* ! SMP */
-
-#define per_cpu(var, cpu)		(*((void)(cpu), &per_cpu_var(var)))
-#define __get_cpu_var(var)		per_cpu_var(var)
-#define __raw_get_cpu_var(var)		per_cpu_var(var)
-#define per_cpu_offset(x) 0
-
-#define PER_CPU_ATTRIBUTES
-
-#endif /* SMP */
-
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
