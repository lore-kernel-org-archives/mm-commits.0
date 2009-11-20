From: akpm@linux-foundation.org
Subject: [merged] speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c.patch removed from -mm tree
Date: Fri, 20 Nov 2009 11:30:27 -0800
Message-ID: <200911201930.nAKJURe7010679@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbZKTTd6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Nov 2009 14:33:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rusty@rustcorp.com.au, dave.mueller@gmx.ch, davej@redhat.com, linux@brodo.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c
has been removed from the -mm tree.  Its filename was
     speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: speedstep-ich: fix error caused by 394122ab144dae4b276d74644a2f11c44a60ac5c
From: Rusty Russell <rusty@rustcorp.com.au>

"[CPUFREQ] cpumask: avoid playing with cpus_allowed in speedstep-ich.c"
changed the code to mistakenly pass the current cpu as the "processor"
argument of speedstep_get_frequency(), whereas it should be the type of
the processor.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14340

Based on a patch by Dave Mueller.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Jones <davej@redhat.com>
Acked-by: Dominik Brodowski <linux@brodo.de>
Reported-by: Dave Mueller <dave.mueller@gmx.ch>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c |   19 ++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c~speedstep-ich-fix-error-caused-by-394122ab144dae4b276d74644a2f11c44a60ac5c
+++ a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -232,28 +232,23 @@ static unsigned int speedstep_detect_chi
 	return 0;
 }
 
-struct get_freq_data {
-	unsigned int speed;
-	unsigned int processor;
-};
-
-static void get_freq_data(void *_data)
+static void get_freq_data(void *_speed)
 {
-	struct get_freq_data *data = _data;
+	unsigned int *speed = _speed;
 
-	data->speed = speedstep_get_frequency(data->processor);
+	*speed = speedstep_get_frequency(speedstep_processor);
 }
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	struct get_freq_data data = { .processor = cpu };
+	unsigned int speed;
 
 	/* You're supposed to ensure CPU is online. */
-	if (smp_call_function_single(cpu, get_freq_data, &data, 1) != 0)
+	if (smp_call_function_single(cpu, get_freq_data, &speed, 1) != 0)
 		BUG();
 
-	dprintk("detected %u kHz as current frequency\n", data.speed);
-	return data.speed;
+	dprintk("detected %u kHz as current frequency\n", speed);
+	return speed;
 }
 
 /**
_

Patches currently in -mm which might be from rusty@rustcorp.com.au are

linux-next.patch
kernel-core-add-smp_call_function_any.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts-by-using-smp_call_function_any.patch
kbuild-clean-up-marker.patch
kbuild-clear-marker-out-of-modpost.patch
percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
generic-ipi-cleanup-for-generic_smp_call_function_interrupt.patch
reiser4.patch

