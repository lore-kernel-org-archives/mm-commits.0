From: akpm@linux-foundation.org
Subject: - i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:18 -0700
Message-ID: <200704281055.l3SAtISx020167@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54750 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965756AbXD1Kzd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anil.s.keshavamurthy@intel.com, ak@suse.de, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     i386: avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
has been removed from the -mm tree.  Its filename was
     i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>

Avoid checking for cpu gone in mm hot path when CONFIG_HOTPLUG_CPU is not
defined.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/smp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/smp.c~i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined arch/i386/kernel/smp.c
--- a/arch/i386/kernel/smp.c~i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined
+++ a/arch/i386/kernel/smp.c
@@ -367,10 +367,12 @@ void native_flush_tlb_others(const cpuma
 	BUG_ON(cpu_isset(smp_processor_id(), cpumask));
 	BUG_ON(!mm);
 
+#ifdef CONFIG_HOTPLUG_CPU
 	/* If a CPU which we ran on has gone down, OK. */
 	cpus_and(cpumask, cpumask, cpu_online_map);
-	if (cpus_empty(cpumask))
+	if (unlikely(cpus_empty(cpumask)))
 		return;
+#endif
 
 	/*
 	 * i'm not happy about this global shared spinlock in the
_

Patches currently in -mm which might be from anil.s.keshavamurthy@intel.com are

kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
