From: akpm@linux-foundation.org
Subject: + x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:32:40 -0800
Message-ID: <200702212032.l1LKWe2i025021@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43244 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbXBUUjK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:39:10 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eranian@hpl.hp.com, ak@suse.de


The patch titled
     x86_64: make NMI use PERFCTR1 for architectural perfmon (take 2)
has been added to the -mm tree.  Its filename is
     x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: make NMI use PERFCTR1 for architectural perfmon (take 2)
From: Stephane Eranian <eranian@hpl.hp.com>

Make the NMI watchdog use PERFSEL1/PERFCTR1 instead of PERFSEL0/PERFCTR0 on
processors supporting Intel architectural perfmon, such as Intel Core 2. 
Although all PMU events can work on both counters, the Precise Event-Based
Sampling (PEBS) requires that the event be in PERFCTR0 to work correctly
(see section 18.14.4.1 in the IA32 SDM Vol 3b).  This versions has 3 chunks
compared to previous where we had missed on check.

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/nmi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/x86_64/kernel/nmi.c~x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2 arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2
+++ a/arch/x86_64/kernel/nmi.c
@@ -285,7 +285,7 @@ int __init check_nmi_watchdog (void)
 		struct nmi_watchdog_ctlblk *wd = &__get_cpu_var(nmi_watchdog_ctlblk);
 
 		nmi_hz = 1;
-	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0)
+	 	if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1)
 			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 	}
 
@@ -650,8 +650,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!reserve_perfctr_nmi(perfctr_msr))
 		goto fail;
@@ -895,7 +895,7 @@ int __kprobes nmi_watchdog_tick(struct p
 				/* start the cycle over again */
 				wrmsrl(wd->perfctr_msr,
 				       -((u64)cpu_khz * 1000 / nmi_hz));
-	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+	 		} else if (wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/*
 				 * ArchPerfom/Core Duo needs to re-unmask
 				 * the apic vector
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

git-ia64.patch
i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
x86_64-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
