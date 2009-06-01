From: akpm@linux-foundation.org
Subject: + x86-nmi-add-intel-processor-0x6f4-to-nmi-perfctr1-workaround.patch added to -mm tree
Date: Mon, 01 Jun 2009 15:36:43 -0700
Message-ID: <200906012236.n51MahaX008411@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbZFAWhc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jun 2009 18:37:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: prarit@redhat.com, mingo@elte.hu, suresh.b.siddha@intel.com


The patch titled
     x86: nmi: add Intel processor 0x6f4 to NMI perfctr1 workaround
has been added to the -mm tree.  Its filename is
     x86-nmi-add-intel-processor-0x6f4-to-nmi-perfctr1-workaround.patch

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
Subject: x86: nmi: add Intel processor 0x6f4 to NMI perfctr1 workaround
From: Prarit Bhargava <prarit@redhat.com>

Expand Intel NMI perfctr1 workaround to include a Core2 processor stepping
(cpuid family-6, model-f, stepping-4).  Resolves a situation where the NMI
would not enable on these processors.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perfctr-watchdog.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff -puN arch/x86/kernel/cpu/perfctr-watchdog.c~x86-nmi-add-intel-processor-0x6f4-to-nmi-perfctr1-workaround arch/x86/kernel/cpu/perfctr-watchdog.c
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c~x86-nmi-add-intel-processor-0x6f4-to-nmi-perfctr1-workaround
+++ a/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -716,11 +716,15 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		/*
-		 * Work around Core Duo (Yonah) errata AE49 where perfctr1
-		 * doesn't have a working enable bit.
+		/* Work around where perfctr1 doesn't have a working enable
+		 * bit as described in the following errata:
+		 * AE49 Core Duo and Intel Core Solo 65 nm
+		 * AN49 Intel Pentium Dual-Core
+		 * AF49 Dual-Core Intel Xeon Processor LV
 		 */
-		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
+		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) ||
+		    ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 15 &&
+		     boot_cpu_data.x86_mask == 4))) {
 			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
 			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
 		}
_

Patches currently in -mm which might be from prarit@redhat.com are

x86-nmi-add-intel-processor-0x6f4-to-nmi-perfctr1-workaround.patch

