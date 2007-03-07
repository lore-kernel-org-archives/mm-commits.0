From: akpm@linux-foundation.org
Subject: - x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch removed from -mm tree
Date: Tue, 06 Mar 2007 20:41:14 -0800
Message-ID: <200703070441.l274fE4D019327@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:47585 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbXCGElk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 23:41:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai.lu@amd.com, ak@suse.de, ebiederm@xmission.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     x86_64 irq: make affinity work for genapic_flat mode
has been removed from the -mm tree.  Its filename was
     x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch

This patch was dropped because it was nacked by the maintainer

------------------------------------------------------
Subject: x86_64 irq: make affinity work for genapic_flat mode
From: "Yinghai Lu" <yinghai.lu@amd.com>

For AMD dual socket system with two IO Hypertransort chain on differenct cpu. 
We still can use apic_flat mode instead of apic_physflat mode, and like to
CPUs on second socket to handle irq for device on its chain.  When apic_flat
mode is used, the domain will be the same (all CPUS).  We need to check the
old affinity in addition to domain, otherwise we can not set affinity from
0x0f to 0x0c, or from 0xff to 0xf0.  Also need to make sure vector is changed
when we set affinity from 0x03 to 0x0c or 0x0f to 0xf0.

[akpm@linux-foundation.org: cleanups]
Signed-off-by: Yinghai Lu <yinghai.lu@amd.com> 
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/io_apic.c |   33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff -puN arch/x86_64/kernel/io_apic.c~x86_64-irq-make-affinity-works-for-genapic_flat-mode arch/x86_64/kernel/io_apic.c
--- a/arch/x86_64/kernel/io_apic.c~x86_64-irq-make-affinity-works-for-genapic_flat-mode
+++ a/arch/x86_64/kernel/io_apic.c
@@ -673,8 +673,28 @@ static int __assign_irq_vector(int irq, 
 	if (old_vector) {
 		cpumask_t tmp;
 		cpus_and(tmp, cfg->domain, mask);
-		if (!cpus_empty(tmp))
-			return 0;
+
+		/* only exact same mask can return directly */
+		for_each_cpu_mask(cpu, mask) {
+			cpumask_t domain;
+
+			domain = vector_allocation_domain(cpu);
+			if (cpus_equal(domain, cfg->domain)) {
+#ifdef CONFIG_SMP
+				/*
+				 * We don't need lock for desc here for
+				 * apic_flat can not be used with
+				 * CONFIG_HOTPLUG_CPU others only have one cpu
+				 * set in domain or affinity
+				 */
+				if (cpus_equal(tmp, irq_desc[irq].affinity))
+					return 0;
+#else
+				return 0;
+#endif
+			}
+
+               }
 	}
 
 	for_each_cpu_mask(cpu, mask) {
@@ -683,7 +703,6 @@ static int __assign_irq_vector(int irq, 
 		int vector, offset;
 
 		domain = vector_allocation_domain(cpu);
-		cpus_and(new_mask, domain, cpu_online_map);
 
 		vector = current_vector;
 		offset = current_offset;
@@ -698,9 +717,17 @@ next:
 			continue;
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
+
+		cpus_and(new_mask, domain, cpu_online_map);
 		for_each_cpu_mask(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
+
+		/* Make sure vector is changed when domain is not changed */
+		if (unlikely(vector == old_vector))
+			if (cpus_equal(domain, cfg->domain))
+				goto next;
+
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
_

Patches currently in -mm which might be from yinghai.lu@amd.com are

x86_64-irq-remove-extra-smp_processor_id-calling.patch
x86_64-irq-make-affinity-works-for-genapic_flat-mode.patch
x86_64-irq-keep-consistent-for-changing-irq0_vector-from-0x20-to-0x30.patch
