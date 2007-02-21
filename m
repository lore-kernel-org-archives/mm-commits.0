From: akpm@linux-foundation.org
Subject: + i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch added to -mm tree
Date: Wed, 21 Feb 2007 12:31:57 -0800
Message-ID: <200702212031.l1LKVv5m024995@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:43195 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161146AbXBUUiZ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 15:38:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: eranian@hpl.hp.com, ak@suse.de


The patch titled
     i386: make NMI use PERFCTR1 for architectural perfmon
has been added to the -mm tree.  Its filename is
     i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: make NMI use PERFCTR1 for architectural perfmon
From: Stephane Eranian <eranian@hpl.hp.com>

Make the NMI watchdog use PERFSEL1/PERFCTR1 instead of PERFSEL0/PERFCTR0 on
processors supporting Intel architectural perfmon, such as Intel Core 2. 
Although all PMU events can work on both counters, the Precise Event-Based
Sampling (PEBS) requires that the event be in PERFCTR0 to work correctly
(see section 18.14.4.1 in the IA32 SDM Vol 3b).

Signed-off-by: stephane eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/nmi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN arch/i386/kernel/nmi.c~i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2 arch/i386/kernel/nmi.c
--- a/arch/i386/kernel/nmi.c~i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2
+++ a/arch/i386/kernel/nmi.c
@@ -307,7 +307,7 @@ static int __init check_nmi_watchdog(voi
 		nmi_hz = 1;
 
 		if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+		    wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 			nmi_hz = adjust_for_32bit_ctr(nmi_hz);
 		}
 	}
@@ -741,8 +741,8 @@ static int setup_intel_arch_watchdog(voi
 	    (ebx & ARCH_PERFMON_UNHALTED_CORE_CYCLES_PRESENT))
 		goto fail;
 
-	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR0;
-	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL0;
+	perfctr_msr = MSR_ARCH_PERFMON_PERFCTR1;
+	evntsel_msr = MSR_ARCH_PERFMON_EVENTSEL1;
 
 	if (!reserve_perfctr_nmi(perfctr_msr))
 		goto fail;
@@ -1022,7 +1022,7 @@ __kprobes int nmi_watchdog_tick(struct p
 				write_watchdog_counter(wd->perfctr_msr, NULL);
 	 		}
 			else if (wd->perfctr_msr == MSR_P6_PERFCTR0 ||
-				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR0) {
+				 wd->perfctr_msr == MSR_ARCH_PERFMON_PERFCTR1) {
 				/* P6 based Pentium M need to re-unmask
 				 * the apic vector but it doesn't hurt
 				 * other P6 variant.
_

Patches currently in -mm which might be from eranian@hpl.hp.com are

git-ia64.patch
i386-make-nmi-use-perfctr1-for-architectural-perfmon-take-2.patch
