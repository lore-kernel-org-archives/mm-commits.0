From: akpm@linux-foundation.org
Subject: - cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:43:24 -0700
Message-ID: <200804300543.m3U5hOrq029314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758228AbYD3Fn7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:43:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, pj@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Cpuset hardwall flag: add a mem_hardwall flag to cpusets
has been removed from the -mm tree.  Its filename was
     cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Cpuset hardwall flag: add a mem_hardwall flag to cpusets
From: Paul Menage <menage@google.com>

This flag provides the hardwalling properties of mem_exclusive, without
enforcing the exclusivity.  Either mem_hardwall or mem_exclusive is sufficient
to prevent GFP_KERNEL allocations from passing outside the cpuset's assigned
nodes.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Paul Jackson <pj@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |   26 ++++++++++---------
 kernel/cpuset.c           |   48 ++++++++++++++++++++++++------------
 2 files changed, 46 insertions(+), 28 deletions(-)

diff -puN Documentation/cpusets.txt~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets
+++ a/Documentation/cpusets.txt
@@ -171,6 +171,7 @@ files describing that cpuset:
  - memory_migrate flag: if set, move pages to cpusets nodes
  - cpu_exclusive flag: is cpu placement exclusive?
  - mem_exclusive flag: is memory placement exclusive?
+ - mem_hardwall flag:  is memory allocation hardwalled
  - memory_pressure: measure of how much paging pressure in cpuset
 
 In addition, the root cpuset only has the following file:
@@ -222,17 +223,18 @@ If a cpuset is cpu or mem exclusive, no 
 a direct ancestor or descendent, may share any of the same CPUs or
 Memory Nodes.
 
-A cpuset that is mem_exclusive restricts kernel allocations for
-page, buffer and other data commonly shared by the kernel across
-multiple users.  All cpusets, whether mem_exclusive or not, restrict
-allocations of memory for user space.  This enables configuring a
-system so that several independent jobs can share common kernel data,
-such as file system pages, while isolating each jobs user allocation in
-its own cpuset.  To do this, construct a large mem_exclusive cpuset to
-hold all the jobs, and construct child, non-mem_exclusive cpusets for
-each individual job.  Only a small amount of typical kernel memory,
-such as requests from interrupt handlers, is allowed to be taken
-outside even a mem_exclusive cpuset.
+A cpuset that is mem_exclusive *or* mem_hardwall is "hardwalled",
+i.e. it restricts kernel allocations for page, buffer and other data
+commonly shared by the kernel across multiple users.  All cpusets,
+whether hardwalled or not, restrict allocations of memory for user
+space.  This enables configuring a system so that several independent
+jobs can share common kernel data, such as file system pages, while
+isolating each job's user allocation in its own cpuset.  To do this,
+construct a large mem_exclusive cpuset to hold all the jobs, and
+construct child, non-mem_exclusive cpusets for each individual job.
+Only a small amount of typical kernel memory, such as requests from
+interrupt handlers, is allowed to be taken outside even a
+mem_exclusive cpuset.
 
 
 1.5 What is memory_pressure ?
@@ -707,7 +709,7 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-cpus  cpu_exclusive  mems  mem_exclusive  tasks
+cpus  cpu_exclusive  mems  mem_exclusive mem_hardwall  tasks
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
diff -puN kernel/cpuset.c~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets
+++ a/kernel/cpuset.c
@@ -127,6 +127,7 @@ struct cpuset_hotplug_scanner {
 typedef enum {
 	CS_CPU_EXCLUSIVE,
 	CS_MEM_EXCLUSIVE,
+	CS_MEM_HARDWALL,
 	CS_MEMORY_MIGRATE,
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
@@ -144,6 +145,11 @@ static inline int is_mem_exclusive(const
 	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
 }
 
+static inline int is_mem_hardwall(const struct cpuset *cs)
+{
+	return test_bit(CS_MEM_HARDWALL, &cs->flags);
+}
+
 static inline int is_sched_load_balance(const struct cpuset *cs)
 {
 	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
@@ -1042,12 +1048,9 @@ static int update_relax_domain_level(str
 
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
- * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
- *				CS_SCHED_LOAD_BALANCE,
- *				CS_NOTIFY_ON_RELEASE, CS_MEMORY_MIGRATE,
- *				CS_SPREAD_PAGE, CS_SPREAD_SLAB)
- * cs:	the cpuset to update
- * buf:	the buffer where we read the 0 or 1
+ * bit:		the bit to update (see cpuset_flagbits_t)
+ * cs:		the cpuset to update
+ * turning_on: 	whether the flag is being set or cleared
  *
  * Call with cgroup_mutex held.
  */
@@ -1228,6 +1231,7 @@ typedef enum {
 	FILE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
+	FILE_MEM_HARDWALL,
 	FILE_SCHED_LOAD_BALANCE,
 	FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	FILE_MEMORY_PRESSURE_ENABLED,
@@ -1312,6 +1316,9 @@ static int cpuset_write_u64(struct cgrou
 	case FILE_MEM_EXCLUSIVE:
 		retval = update_flag(CS_MEM_EXCLUSIVE, cs, val);
 		break;
+	case FILE_MEM_HARDWALL:
+		retval = update_flag(CS_MEM_HARDWALL, cs, val);
+		break;
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
@@ -1422,6 +1429,8 @@ static u64 cpuset_read_u64(struct cgroup
 		return is_cpu_exclusive(cs);
 	case FILE_MEM_EXCLUSIVE:
 		return is_mem_exclusive(cs);
+	case FILE_MEM_HARDWALL:
+		return is_mem_hardwall(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
 	case FILE_MEMORY_MIGRATE:
@@ -1474,6 +1483,13 @@ static struct cftype files[] = {
 	},
 
 	{
+		.name = "mem_hardwall",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEM_HARDWALL,
+	},
+
+	{
 		.name = "sched_load_balance",
 		.read_u64 = cpuset_read_u64,
 		.write_u64 = cpuset_write_u64,
@@ -1962,14 +1978,14 @@ int cpuset_nodemask_valid_mems_allowed(n
 }
 
 /*
- * nearest_exclusive_ancestor() - Returns the nearest mem_exclusive
- * ancestor to the specified cpuset.  Call holding callback_mutex.
- * If no ancestor is mem_exclusive (an unusual configuration), then
- * returns the root cpuset.
+ * nearest_hardwall_ancestor() - Returns the nearest mem_exclusive or
+ * mem_hardwall ancestor to the specified cpuset.  Call holding
+ * callback_mutex.  If no ancestor is mem_exclusive or mem_hardwall
+ * (an unusual configuration), then returns the root cpuset.
  */
-static const struct cpuset *nearest_exclusive_ancestor(const struct cpuset *cs)
+static const struct cpuset *nearest_hardwall_ancestor(const struct cpuset *cs)
 {
-	while (!is_mem_exclusive(cs) && cs->parent)
+	while (!(is_mem_exclusive(cs) || is_mem_hardwall(cs)) && cs->parent)
 		cs = cs->parent;
 	return cs;
 }
@@ -1983,7 +1999,7 @@ static const struct cpuset *nearest_excl
  * __GFP_THISNODE is set, yes, we can always allocate.  If zone
  * z's node is in our tasks mems_allowed, yes.  If it's not a
  * __GFP_HARDWALL request and this zone's nodes is in the nearest
- * mem_exclusive cpuset ancestor to this tasks cpuset, yes.
+ * hardwalled cpuset ancestor to this tasks cpuset, yes.
  * If the task has been OOM killed and has access to memory reserves
  * as specified by the TIF_MEMDIE flag, yes.
  * Otherwise, no.
@@ -2006,7 +2022,7 @@ static const struct cpuset *nearest_excl
  * and do not allow allocations outside the current tasks cpuset
  * unless the task has been OOM killed as is marked TIF_MEMDIE.
  * GFP_KERNEL allocations are not so marked, so can escape to the
- * nearest enclosing mem_exclusive ancestor cpuset.
+ * nearest enclosing hardwalled ancestor cpuset.
  *
  * Scanning up parent cpusets requires callback_mutex.  The
  * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
@@ -2029,7 +2045,7 @@ static const struct cpuset *nearest_excl
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	TIF_MEMDIE   - any node ok
- *	GFP_KERNEL   - any node in enclosing mem_exclusive cpuset ok
+ *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
  * Rule:
@@ -2066,7 +2082,7 @@ int __cpuset_zone_allowed_softwall(struc
 	mutex_lock(&callback_mutex);
 
 	task_lock(current);
-	cs = nearest_exclusive_ancestor(task_cs(current));
+	cs = nearest_hardwall_ancestor(task_cs(current));
 	task_unlock(current);
 
 	allowed = node_isset(node, cs->mems_allowed);
_

Patches currently in -mm which might be from menage@google.com are

origin.patch
disable-the-memory-controller-by-default-v3.patch
add-a-refcount-check-in-dput.patch

