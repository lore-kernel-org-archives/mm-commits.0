From: akpm@linux-foundation.org
Subject: + i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch added to -mm tree
Date: Fri, 06 Apr 2007 23:24:58 -0700
Message-ID: <200704070624.l376OwD4029027@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965369AbXDGGZK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 7 Apr 2007 02:25:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anil.s.keshavamurthy@intel.com, ak@suse.de, ego@in.ibm.com


The patch titled
     i386: avoid checking for cpu gone when CONFIG_HOTPLUG_CPU not defined
has been added to the -mm tree.  Its filename is
     i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -366,10 +366,12 @@ static void flush_tlb_others(cpumask_t c
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

i386-avoid-checking-for-cpu-gone-when-config_hotplug_cpu-not-defined.patch
kprobes-print-details-of-kretprobe-on-assertion-failure.patch
kprobes-use-hlist_for_each_entry.patch
kprobes-codingstyle-cleanups.patch
kprobes-kretprobes-simplifcations.patch
