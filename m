From: akpm@linux-foundation.org
Subject: [merged] x86-fix-boot-on-uniprocessor-systems.patch removed from
 -mm tree
Date: Mon, 31 Mar 2014 11:21:19 -0700
Message-ID: <5339b21f.HAMA44g1pbHCKatg%akpm__8060.46710717982$1396290098$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320AbaCaSVU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 31 Mar 2014 14:21:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tglx@linutronix.de, stable@vger.kernel.org, mingo@elte.hu, hpa@zytor.com, eranian@google.com, a.p.zijlstra@chello.nl, artem_fetishev@epam.com

Subject: [merged] x86-fix-boot-on-uniprocessor-systems.patch removed from -mm tree
To: artem_fetishev@epam.com,a.p.zijlstra@chello.nl,eranian@google.com,hpa@zytor.com,mingo@elte.hu,stable@vger.kernel.org,tglx@linutronix.de,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 31 Mar 2014 11:21:19 -0700


The patch titled
     Subject: x86: fix boot on uniprocessor systems
has been removed from the -mm tree.  Its filename was
     x86-fix-boot-on-uniprocessor-systems.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Artem Fetishev <artem_fetishev@epam.com>
Subject: x86: fix boot on uniprocessor systems

On x86 uniprocessor systems topology_physical_package_id() returns -1
which causes rapl_cpu_prepare() to leave rapl_pmu variable uninitialized
which leads to GPF in rapl_pmu_init().  See
arch/x86/kernel/cpu/perf_event_intel_rapl.c.

It turns out that physical_package_id and core_id can actually be
retreived for uniprocessor systems too.  Enabling them also fixes rapl_pmu
code.

Signed-off-by: Artem Fetishev <artem_fetishev@epam.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/topology.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/topology.h~x86-fix-boot-on-uniprocessor-systems arch/x86/include/asm/topology.h
--- a/arch/x86/include/asm/topology.h~x86-fix-boot-on-uniprocessor-systems
+++ a/arch/x86/include/asm/topology.h
@@ -119,9 +119,10 @@ static inline void setup_node_to_cpumask
 
 extern const struct cpumask *cpu_coregroup_mask(int cpu);
 
-#ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
+
+#ifdef ENABLE_TOPO_DEFINES
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
 #endif
_

Patches currently in -mm which might be from artem_fetishev@epam.com are


