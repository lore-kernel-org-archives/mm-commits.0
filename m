From: akpm@linux-foundation.org
Subject: + nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi.patch added to -mm tree
Date: Mon, 29 Aug 2016 16:35:13 -0700
Message-ID: <57c4c6b1.bMq382rLogdSZjwH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40270 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755676AbcH2XfP (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 29 Aug 2016 19:35:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cmetcalf@mellanox.com, atomlin@redhat.com, daniel.thompson@linaro.org, linux@arm.linux.org.uk, mingo@elte.hu, pmladek@suse.com, rjw@rjwysocki.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: nmi_backtrace: do a local dump_stack() instead of a self-NMI
has been added to the -mm tree.  Its filename is
     nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
Cc: Rafael J. Wysocki" <rjw@rjwysocki.net>
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
-
 	smp_cross_call(mask, IPI_CPU_BACKTRACE);
 }
 
diff -puN lib/nmi_backtrace.c~nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi lib/nmi_backtrace.c
--- a/lib/nmi_backtrace.c~nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi
+++ a/lib/nmi_backtrace.c
@@ -49,6 +49,15 @@ void nmi_trigger_cpumask_backtrace(const
 	if (exclude_self)
 		cpumask_clear_cpu(this_cpu, to_cpumask(backtrace_mask));
 
+	/*
+	 * Don't try to send an NMI to this cpu; it may work on some
+	 * architectures, but on others it may not, and we'll get
+	 * information at least as useful just by doing a dump_stack() here.
+	 * Note that nmi_cpu_backtrace(NULL) will clear the cpu bit.
+	 */
+	if (cpumask_test_cpu(this_cpu, to_cpumask(backtrace_mask)))
+		nmi_cpu_backtrace(NULL);
+
 	if (!cpumask_empty(to_cpumask(backtrace_mask))) {
 		pr_info("Sending NMI from CPU %d to CPUs %*pbl:\n",
 			this_cpu, nr_cpumask_bits, to_cpumask(backtrace_mask));
_

Patches currently in -mm which might be from cmetcalf@mellanox.com are

nmi_backtrace-add-more-trigger__cpu_backtrace-methods.patch
nmi_backtrace-do-a-local-dump_stack-instead-of-a-self-nmi.patch
arch-tile-adopt-the-new-nmi_backtrace-framework.patch
nmi_backtrace-generate-one-line-reports-for-idle-cpus.patch

