From: akpm@linux-foundation.org
Subject: - add-default-cpu-topology-information.patch removed from -mm tree
Date: Fri, 18 Apr 2008 00:32:40 -0700
Message-ID: <200804180732.m3I7WeNh017282@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbYDRHdH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 18 Apr 2008 03:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, heiko.carstens@de.ibm.com, mingo@elte.hu, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Add default CPU topology information
has been removed from the -mm tree.  Its filename was
     add-default-cpu-topology-information.patch

This patch was dropped because it had testing failures

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Add default CPU topology information
From: Ben Hutchings <bhutchings@solarflare.com>

Not all architectures and configurations define CPU topology information. 
This can result in an empty topology directory in sysfs, and requires
in-kernel users to protect all uses with #ifdef - see
<http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.

The documentation of CPU topology specifies what the defaults should be
if only partial information is available from the hardware.  So we can
provide these defaults as a fallback.

This patch:

- Adds default definitions of the 4 topology macros to
  include/asm-generic/topology.h.
- Changes include/asm-*/topology.h to include <asm-generic/topology.h>
  unconditionally.
- Changes drivers/base/topology.c to use the topology macros unconditionally
  and to cope with definitions that aren't lvalues.
- Updates documentation accordingly.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cputopology.txt  |   26 +++++++++-----------------
 drivers/base/topology.c        |   31 ++++++-------------------------
 include/asm-alpha/topology.h   |    6 +++---
 include/asm-frv/topology.h     |    4 +---
 include/asm-generic/topology.h |   15 +++++++++++++++
 include/asm-mips/topology.h    |    4 ++--
 include/asm-powerpc/topology.h |    5 ++---
 include/asm-x86/topology.h     |    8 +++-----
 8 files changed, 41 insertions(+), 58 deletions(-)

diff -puN Documentation/cputopology.txt~add-default-cpu-topology-information Documentation/cputopology.txt
--- a/Documentation/cputopology.txt~add-default-cpu-topology-information
+++ a/Documentation/cputopology.txt
@@ -14,9 +14,8 @@ represent the thread siblings to cpu X i
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
 
-If one architecture wants to support this feature, it just needs to
-implement 4 defines, typically in file include/asm-XXX/topology.h.
-The 4 defines are:
+If one architecture wants to support this feature, it must define
+some of these macros in include/asm-XXX/topology.h:
 #define topology_physical_package_id(cpu)
 #define topology_core_id(cpu)
 #define topology_thread_siblings(cpu)
@@ -25,17 +24,10 @@ The 4 defines are:
 The type of **_id is int.
 The type of siblings is cpumask_t.
 
-To be consistent on all architectures, the 4 attributes should have
-default values if their values are unavailable. Below is the rule.
-1) physical_package_id: If cpu has no physical package id, -1 is the
-default value.
-2) core_id: If cpu doesn't support multi-core, its core id is 0.
-3) thread_siblings: Just include itself, if the cpu doesn't support
-HT/multi-thread.
-4) core_siblings: Just include itself, if the cpu doesn't support
-multi-core and HT/Multi-thread.
-
-So be careful when declaring the 4 defines in include/asm-XXX/topology.h.
-
-If an attribute isn't defined on an architecture, it won't be exported.
-
+To be consistent on all architectures, include/asm-generic/topology.h
+provides default definitions for any of the above macros that are
+not already defined:
+1) physical_package_id: -1
+2) core_id: 0
+3) thread_siblings: just the given CPU
+4) core_siblings: just the given CPU
diff -puN drivers/base/topology.c~add-default-cpu-topology-information drivers/base/topology.c
--- a/drivers/base/topology.c~add-default-cpu-topology-information
+++ a/drivers/base/topology.c
@@ -45,47 +45,28 @@ static ssize_t show_##name(struct sys_de
 {									\
 	ssize_t len = -1;						\
 	unsigned int cpu = dev->id;					\
-	len = cpumask_scnprintf(buf, NR_CPUS+1, topology_##name(cpu));	\
+	cpumask_t siblings = topology_##name(cpu);			\
+	len = cpumask_scnprintf(buf, NR_CPUS+1, siblings);		\
 	return (len + sprintf(buf + len, "\n"));			\
 }
 
-#ifdef	topology_physical_package_id
 define_id_show_func(physical_package_id);
 define_one_ro(physical_package_id);
-#define ref_physical_package_id_attr	&attr_physical_package_id.attr,
-#else
-#define ref_physical_package_id_attr
-#endif
 
-#ifdef topology_core_id
 define_id_show_func(core_id);
 define_one_ro(core_id);
-#define ref_core_id_attr		&attr_core_id.attr,
-#else
-#define ref_core_id_attr
-#endif
 
-#ifdef topology_thread_siblings
 define_siblings_show_func(thread_siblings);
 define_one_ro(thread_siblings);
-#define ref_thread_siblings_attr	&attr_thread_siblings.attr,
-#else
-#define ref_thread_siblings_attr
-#endif
 
-#ifdef topology_core_siblings
 define_siblings_show_func(core_siblings);
 define_one_ro(core_siblings);
-#define ref_core_siblings_attr		&attr_core_siblings.attr,
-#else
-#define ref_core_siblings_attr
-#endif
 
 static struct attribute *default_attrs[] = {
-	ref_physical_package_id_attr
-	ref_core_id_attr
-	ref_thread_siblings_attr
-	ref_core_siblings_attr
+	&attr_physical_package_id.attr,
+	&attr_core_id.attr,
+	&attr_thread_siblings.attr,
+	&attr_core_siblings.attr,
 	NULL
 };
 
diff -puN include/asm-alpha/topology.h~add-default-cpu-topology-information include/asm-alpha/topology.h
--- a/include/asm-alpha/topology.h~add-default-cpu-topology-information
+++ a/include/asm-alpha/topology.h
@@ -41,8 +41,8 @@ static inline cpumask_t node_to_cpumask(
 
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
 
-#else /* CONFIG_NUMA */
-# include <asm-generic/topology.h>
-#endif /* !CONFIG_NUMA */
+#endif /* CONFIG_NUMA */
+
+#include <asm-generic/topology.h>
 
 #endif /* _ASM_ALPHA_TOPOLOGY_H */
diff -puN include/asm-frv/topology.h~add-default-cpu-topology-information include/asm-frv/topology.h
--- a/include/asm-frv/topology.h~add-default-cpu-topology-information
+++ a/include/asm-frv/topology.h
@@ -5,10 +5,8 @@
 
 #error NUMA not supported yet
 
-#else /* !CONFIG_NUMA */
+#endif /* CONFIG_NUMA */
 
 #include <asm-generic/topology.h>
 
-#endif /* CONFIG_NUMA */
-
 #endif /* _ASM_TOPOLOGY_H */
diff -puN include/asm-generic/topology.h~add-default-cpu-topology-information include/asm-generic/topology.h
--- a/include/asm-generic/topology.h~add-default-cpu-topology-information
+++ a/include/asm-generic/topology.h
@@ -27,6 +27,8 @@
 #ifndef _ASM_GENERIC_TOPOLOGY_H
 #define _ASM_GENERIC_TOPOLOGY_H
 
+#include <linux/cpumask.h>
+
 /* Other architectures wishing to use this simple topology API should fill
    in the below functions as appropriate in their own <asm/topology.h> file. */
 #ifndef cpu_to_node
@@ -52,4 +54,17 @@
 				)
 #endif
 
+#ifndef topology_physical_package_id
+#define topology_physical_package_id(cpu)	((void)(cpu), -1)
+#endif
+#ifndef topology_core_id
+#define topology_core_id(cpu)			((void)(cpu), 0)
+#endif
+#ifndef topology_thread_siblings
+#define topology_thread_siblings(cpu)		cpumask_of_cpu(cpu)
+#endif
+#ifndef topology_core_siblings
+#define topology_core_siblings(cpu)		cpumask_of_cpu(cpu)
+#endif
+
 #endif /* _ASM_GENERIC_TOPOLOGY_H */
diff -puN include/asm-mips/topology.h~add-default-cpu-topology-information include/asm-mips/topology.h
--- a/include/asm-mips/topology.h~add-default-cpu-topology-information
+++ a/include/asm-mips/topology.h
@@ -8,10 +8,10 @@
 #ifndef __ASM_TOPOLOGY_H
 #define __ASM_TOPOLOGY_H
 
-#include <topology.h>
-
 #ifdef CONFIG_SMP
 #define smt_capable()   (smp_num_siblings > 1)
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif /* __ASM_TOPOLOGY_H */
diff -puN include/asm-powerpc/topology.h~add-default-cpu-topology-information include/asm-powerpc/topology.h
--- a/include/asm-powerpc/topology.h~add-default-cpu-topology-information
+++ a/include/asm-powerpc/topology.h
@@ -96,9 +96,6 @@ static inline void sysfs_remove_device_f
 {
 }
 
-
-#include <asm-generic/topology.h>
-
 #endif /* CONFIG_NUMA */
 
 #ifdef CONFIG_SMP
@@ -112,5 +109,7 @@ static inline void sysfs_remove_device_f
 #endif
 #endif
 
+#include <asm-generic/topology.h>
+
 #endif /* __KERNEL__ */
 #endif	/* _ASM_POWERPC_TOPOLOGY_H */
diff -puN include/asm-x86/topology.h~add-default-cpu-topology-information include/asm-x86/topology.h
--- a/include/asm-x86/topology.h~add-default-cpu-topology-information
+++ a/include/asm-x86/topology.h
@@ -172,11 +172,7 @@ extern int __node_distance(int, int);
 #define node_distance(a, b) __node_distance(a, b)
 #endif
 
-#else /* CONFIG_NUMA */
-
-#include <asm-generic/topology.h>
