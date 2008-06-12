From: akpm@linux-foundation.org
Subject: - cputopology-always-define-cpu-topology-information.patch removed from -mm tree
Date: Thu, 12 Jun 2008 13:38:26 -0700
Message-ID: <200806122038.m5CKcQhY005533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53840 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbYFLUkD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 Jun 2008 16:40:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhutchings@solarflare.com, clameter@sgi.com, hawkes@sgi.com, mingo@elte.hu, nickpiggin@yahoo.com.au, sekharan@us.ibm.com, suresh.b.siddha@intel.com, travis@sgi.com, vegard.nossum@gmail


The patch titled
     cpu topology: always define CPU topology information
has been removed from the -mm tree.  Its filename was
     cputopology-always-define-cpu-topology-information.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu topology: always define CPU topology information
From: Ben Hutchings <bhutchings@solarflare.com>

Not all architectures and configurations define CPU topology information.
This can result in an empty topology directory in sysfs, and requires
in-kernel users to protect all uses with #ifdef - see
<http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.

The documentation of CPU topology specifies what the defaults should be if
only partial information is available from the hardware.  So we can
provide these defaults as a fallback.

This patch:

- Adds default definitions of the 4 topology macros to <linux/topology.h>
- Changes drivers/base/topology.c to use the topology macros unconditionally
  and to cope with definitions that aren't lvalues
- Updates documentation accordingly

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Mike Travis <travis@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: John Hawkes <hawkes@sgi.com>
Cc: Zhang, Yanmin <yanmin.zhang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cputopology.txt |   26 +++++++--------------
 drivers/base/topology.c       |   38 ++++++++------------------------
 include/linux/topology.h      |   13 ++++++++++
 3 files changed, 32 insertions(+), 45 deletions(-)

diff -puN Documentation/cputopology.txt~cputopology-always-define-cpu-topology-information Documentation/cputopology.txt
--- a/Documentation/cputopology.txt~cputopology-always-define-cpu-topology-information
+++ a/Documentation/cputopology.txt
@@ -14,9 +14,8 @@ represent the thread siblings to cpu X i
 To implement it in an architecture-neutral way, a new source file,
 drivers/base/topology.c, is to export the 4 attributes.
 
-If one architecture wants to support this feature, it just needs to
-implement 4 defines, typically in file include/asm-XXX/topology.h.
-The 4 defines are:
+For an architecture to support this feature, it must define some of
+these macros in include/asm-XXX/topology.h:
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
+To be consistent on all architectures, include/linux/topology.h
+provides default definitions for any of the above macros that are
+not defined by include/asm-XXX/topology.h:
+1) physical_package_id: -1
+2) core_id: 0
+3) thread_siblings: just the given CPU
+4) core_siblings: just the given CPU
diff -puN drivers/base/topology.c~cputopology-always-define-cpu-topology-information drivers/base/topology.c
--- a/drivers/base/topology.c~cputopology-always-define-cpu-topology-information
+++ a/drivers/base/topology.c
@@ -62,14 +62,16 @@ static ssize_t show_cpumap(int type, cpu
 static ssize_t show_##name(struct sys_device *dev, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
+	cpumask_t siblings = topology_##name(cpu);			\
+	return show_cpumap(0, &siblings, buf);				\
 }
 
 #define define_siblings_show_list(name)					\
 static ssize_t show_##name##_list(struct sys_device *dev, char *buf) \
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+	cpumask_t siblings = topology_##name(cpu);			\
+	return show_cpumap(1, &siblings, buf);				\
 }
 
 #else
@@ -93,47 +95,27 @@ static ssize_t show_##name##_list(struct
 #define define_siblings_show_func(name)		\
 	define_siblings_show_map(name); define_siblings_show_list(name)
 
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
 define_one_ro(thread_siblings_list);
-#define ref_thread_siblings_attr	\
-		&attr_thread_siblings.attr, &attr_thread_siblings_list.attr,
-#else
-#define ref_thread_siblings_attr
-#endif
 
-#ifdef topology_core_siblings
 define_siblings_show_func(core_siblings);
 define_one_ro(core_siblings);
 define_one_ro(core_siblings_list);
-#define ref_core_siblings_attr		\
-		&attr_core_siblings.attr, &attr_core_siblings_list.attr,
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
+	&attr_thread_siblings_list.attr,
+	&attr_core_siblings.attr,
+	&attr_core_siblings_list.attr,
 	NULL
 };
 
diff -puN include/linux/topology.h~cputopology-always-define-cpu-topology-information include/linux/topology.h
--- a/include/linux/topology.h~cputopology-always-define-cpu-topology-information
+++ a/include/linux/topology.h
@@ -179,4 +179,17 @@ void arch_update_cpu_topology(void);
 #endif
 #endif /* CONFIG_NUMA */
 
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
 #endif /* _LINUX_TOPOLOGY_H */
_

Patches currently in -mm which might be from bhutchings@solarflare.com are

origin.patch
linux-next.patch
cputopology-always-define-cpu-topology-information-cleanup.patch

