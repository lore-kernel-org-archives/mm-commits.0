From: akpm@linux-foundation.org
Subject: [patch 118/127] nmi_backtrace: do a local dump_stack() instead of a self-NMI
Date: Fri, 07 Oct 2016 17:02:49 -0700
Message-ID: <57f837a9.JTjhLSgxdMFR+JhS%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39664 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932593AbcJHACu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 20:02:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, cmetcalf@mellanox.com, atomlin@redhat.com, daniel.thompson@linaro.org, linux@arm.linux.org.uk, mingo@elte.hu, pmladek@suse.com, rjw@rjwysocki.net, tglx@linutronix.de

From: Chris Metcalf <cmetcalf@mellanox.com>
Subject: nmi_backtrace: do a local dump_stack() instead of a self-NMI

Currently on arm there is code that checks whether it should call
dump_stack() explicitly, to avoid trying to raise an NMI when the current
context is not preemptible by the backtrace IPI.  Similarly, the
forthcoming arch/tile support uses an IPI mechanism that does not support
generating an NMI to self.

Accordingly, move the code that guards this case into the generic
mechanism, and invoke it unconditionally whenever we want a backtrace of
the current cpu.  It seems plausible that in all cases, dump_stack() will
generate better information than generating a stack from the NMI handler. 
The register state will be missing, but that state is likely not
particularly helpful in any case.

Or, if we think it is helpful, we should be capturing and emitting the
current register state in all cases when regs == NULL is passed to
nmi_cpu_backtrace().

Link: http://lkml.kernel.org/r/1472487169-14923-3-git-send-email-cmetcalf@mellanox.com
Signed-off-by: Chris Metcalf <cmetcalf@mellanox.com>
Tested-by: Daniel Thompson <daniel.thompson@linaro.org> [arm]
Reviewed-by: Petr Mladek <pmladek@suse.com>
Acked-by: Aaron Tomlin <atomlin@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/kernel/smp.c |    9 ---------
 lib/nmi_backtrace.c   |    9 +++++++++
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/arm/kernel/smp.c~nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi arch/arm/kernel/smp.c
--- a/arch/arm/kernel/smp.c~nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi
+++ a/arch/arm/kernel/smp.c
@@ -748,15 +748,6 @@ core_initcall(register_cpufreq_notifier)
 
 static void raise_nmi(cpumask_t *mask)
 {
-	/*
-	 * Generate the backtrace directly if we are running in a calling
-	 * context that is not preemptible by the backtrace IPI. Note
-	 * that nmi_cpu_backtrace() automatically removes the current cpu
-	 * from mask.
-	 */
-	if (cpumask_test_cpu(smp_processor_id(), mask) && irqs_disabled())
-		nmi_cpu_backtrace(NULL);
