From: akpm@linux-foundation.org
Subject: + topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage.patch added to -mm tree
Date: Mon, 14 Jun 2010 15:48:46 -0700
Message-ID: <201006142248.o5EMmkFU003472@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57538 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757147Ab0FNWtV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jun 2010 18:49:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, lee.schermerhorn@hp.com, tony.luck@intel.com


The patch titled
     topology: alternate fix for ia64 tiger_defconfig build breakage
has been added to the -mm tree.  Its filename is
     topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage.patch

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
Subject: topology: alternate fix for ia64 tiger_defconfig build breakage
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Define stubs for the numa_*_id() generic percpu related functions for
non-NUMA configurations in <asm-generic/topology.h> where the other
non-numa stubs live.

Fixes ia64 !NUMA build breakage -- e.g., tiger_defconfig

Back out now unneeded '#ifndef CONFIG_NUMA' guards from ia64 smpboot.c

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/Kconfig              |    3 +--
 arch/ia64/kernel/smpboot.c     |    4 ----
 include/asm-generic/topology.h |   20 +++++++++++++++++++-
 include/linux/topology.h       |    4 ----
 4 files changed, 20 insertions(+), 11 deletions(-)

diff -puN arch/ia64/Kconfig~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage
+++ a/arch/ia64/Kconfig
@@ -503,8 +503,7 @@ config USE_PERCPU_NUMA_NODE_ID
 	depends on NUMA
 
 config HAVE_MEMORYLESS_NODES
-	def_bool y
-	depends on NUMA
+	def_bool NUMA
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
diff -puN arch/ia64/kernel/smpboot.c~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage
+++ a/arch/ia64/kernel/smpboot.c
@@ -390,13 +390,11 @@ smp_callin (void)
 
 	fix_b0_for_bsp();
 
-#ifdef CONFIG_NUMA
 	/*
 	 * numa_node_id() works after this.
 	 */
 	set_numa_node(cpu_to_node_map[cpuid]);
 	set_numa_mem(local_memory_node(cpu_to_node_map[cpuid]));
-#endif
 
 	ipi_call_lock_irq();
 	spin_lock(&vector_lock);
@@ -640,9 +638,7 @@ void __devinit smp_prepare_boot_cpu(void
 {
 	cpu_set(smp_processor_id(), cpu_online_map);
 	cpu_set(smp_processor_id(), cpu_callin_map);
-#ifdef CONFIG_NUMA
 	set_numa_node(cpu_to_node_map[smp_processor_id()]);
-#endif
 	per_cpu(cpu_state, smp_processor_id()) = CPU_ONLINE;
 	paravirt_post_smp_prepare_boot_cpu();
 }
diff -puN include/asm-generic/topology.h~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage
+++ a/include/asm-generic/topology.h
@@ -5,7 +5,7 @@
  *
  * Copyright (C) 2002, IBM Corp.
  *
- * All rights reserved.          
+ * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -34,9 +34,16 @@
 #ifndef cpu_to_node
 #define cpu_to_node(cpu)	((void)(cpu),0)
 #endif
+#ifndef set_numa_node
+#define set_numa_node(node)
+#endif
+#ifndef set_cpu_numa_node
+#define set_cpu_numa_node(cpu, node)
+#endif
 #ifndef cpu_to_mem
 #define cpu_to_mem(cpu)		((void)(cpu),0)
 #endif
+
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
@@ -55,4 +62,15 @@
 
 #endif	/* CONFIG_NUMA */
 
+#if !defined(CONFIG_NUMA) || !defined(CONFIG_HAVE_MEMORYLESS_NODES)
+
+#ifndef set_numa_mem
+#define set_numa_mem(node)
+#endif
+#ifndef set_cpu_numa_mem
+#define set_cpu_numa_mem(cpu, node)
+#endif
+
+#endif	/* !CONFIG_NUMA || !CONFIG_HAVE_MEMORYLESS_NODES */
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
diff -puN include/linux/topology.h~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage include/linux/topology.h
--- a/include/linux/topology.h~topology-alternate-fix-for-ia64-tiger_defconfig-build-breakage
+++ a/include/linux/topology.h
@@ -291,10 +291,6 @@ static inline void set_cpu_numa_mem(int 
 
 #else	/* !CONFIG_HAVE_MEMORYLESS_NODES */
 
-static inline void set_numa_mem(int node) {}
-
-static inline void set_cpu_numa_mem(int cpu, int node) {}
