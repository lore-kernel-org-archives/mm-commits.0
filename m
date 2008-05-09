From: akpm@linux-foundation.org
Subject: + mm-define-default-cpu_to_node.patch added to -mm tree
Date: Thu, 08 May 2008 21:07:18 -0700
Message-ID: <200805090407.m4947Il9021289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45331 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbYEIEIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 00:08:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: travis@sgi.com, anton@samba.org, bunk@kernel.org, davem@davemloft.net, hpa@zytor.com, ink@jurassic.park.msu.ru, lethal@linux-sh.org, paulus@samba.org, rth@twiddle.net, tglx@linutronix.de, wli@holomorphy.com


The patch titled
     mm: define default cpu_to_node()
has been added to the -mm tree.  Its filename is
     mm-define-default-cpu_to_node.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: define default cpu_to_node()
From: Mike Travis <travis@sgi.com>

Some architectures have CONFIG_NUMA=y but do not define a default cpu_to_node
macro.  This provides the default in asm-generic/topology.h but it relies on
the fact that cpu_to_node is a defined macro (and not an inline function).

Which means that those architecutures that define cpu_to_node as a function
are changed to:

    #define cpu_to_node(cpu)  _cpu_to_node(cpu)
    < ... declare the _cpu_to_node(int cpu) function. ... >

Based on:
    //git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: William L. Irwin <wli@holomorphy.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-alpha/topology.h   |    3 ++-
 include/asm-generic/topology.h |   11 ++++++++---
 include/asm-powerpc/topology.h |    3 ++-
 include/asm-sparc64/topology.h |    3 ++-
 include/asm-x86/topology.h     |    6 ++++--
 5 files changed, 18 insertions(+), 8 deletions(-)

diff -puN include/asm-alpha/topology.h~mm-define-default-cpu_to_node include/asm-alpha/topology.h
--- a/include/asm-alpha/topology.h~mm-define-default-cpu_to_node
+++ a/include/asm-alpha/topology.h
@@ -6,7 +6,8 @@
 #include <asm/machvec.h>
 
 #ifdef CONFIG_NUMA
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	int node;
 	
diff -puN include/asm-generic/topology.h~mm-define-default-cpu_to_node include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~mm-define-default-cpu_to_node
+++ a/include/asm-generic/topology.h
@@ -27,13 +27,18 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+/*
+ * cpu_to_node is referenced but not defined in some arch's that
+ * have CONFIG_NUMA=y
+ */
+#ifndef cpu_to_node
+#define cpu_to_node(cpu)	((void)(cpu),0)
+#endif
+
 #ifndef	CONFIG_NUMA
 
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
-#ifndef cpu_to_node
-#define cpu_to_node(cpu)	((void)(cpu),0)
-#endif
 #ifndef parent_node
 #define parent_node(node)	((void)(node),0)
 #endif
diff -puN include/asm-powerpc/topology.h~mm-define-default-cpu_to_node include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~mm-define-default-cpu_to_node
+++ a/include/asm-powerpc/topology.h
@@ -10,7 +10,8 @@ struct device_node;
 
 #include <asm/mmzone.h>
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return numa_cpu_lookup_table[cpu];
 }
diff -puN include/asm-sparc64/topology.h~mm-define-default-cpu_to_node include/asm-sparc64/topology.h
--- a/include/asm-sparc64/topology.h~mm-define-default-cpu_to_node
+++ a/include/asm-sparc64/topology.h
@@ -5,7 +5,8 @@
 
 #include <asm/mmzone.h>
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return numa_cpu_lookup_table[cpu];
 }
diff -puN include/asm-x86/topology.h~mm-define-default-cpu_to_node include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~mm-define-default-cpu_to_node
+++ a/include/asm-x86/topology.h
@@ -53,7 +53,8 @@ extern cpumask_t node_to_cpumask_map[];
 /* Returns the number of the node containing CPU 'cpu' */
 #ifdef CONFIG_X86_32
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 	return cpu_to_node_map[cpu];
 }
@@ -76,7 +77,8 @@ static inline int early_cpu_to_node(int 
 #define	early_cpu_to_node(cpu)	cpu_to_node(cpu)
 #endif
 
-static inline int cpu_to_node(int cpu)
+#define cpu_to_node(cpu) _cpu_to_node(cpu)
+static inline int _cpu_to_node(int cpu)
 {
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 	if (x86_cpu_to_node_map_early_ptr) {
_

Patches currently in -mm which might be from travis@sgi.com are

cpumask-remove-bitmap_scnprintf_len-and-cpumask_scnprintf_len.patch
mm-define-default-cpu_to_node.patch
acpi-change-processors-from-array-to-per_cpu-variable.patch
cpufreq-change-cpu-freq-arrays-to-per_cpu-variables.patch
show_schedstat-fix-memleak.patch

