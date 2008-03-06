From: akpm@linux-foundation.org
Subject: + cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:18:31 -0800
Message-ID: <200803060018.m260IW4H029839@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909AbYCFASk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:18:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, pj@sgi.com


The patch titled
     Cpuset hardwall flag: add a mem_hardwall flag to cpusets
has been added to the -mm tree.  Its filename is
     cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch

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
@@ -169,6 +169,7 @@ files describing that cpuset:
  - memory_migrate flag: if set, move pages to cpusets nodes
  - cpu_exclusive flag: is cpu placement exclusive?
  - mem_exclusive flag: is memory placement exclusive?
+ - mem_hardwall flag:  is memory allocation hardwalled
  - memory_pressure: measure of how much paging pressure in cpuset
 
 In addition, the root cpuset only has the following file:
@@ -220,17 +221,18 @@ If a cpuset is cpu or mem exclusive, no 
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
@@ -639,7 +641,7 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-cpus  cpu_exclusive  mems  mem_exclusive  tasks
+cpus  cpu_exclusive  mems  mem_exclusive mem_hardwall  tasks
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
diff -puN kernel/cpuset.c~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets
+++ a/kernel/cpuset.c
@@ -124,6 +124,7 @@ struct cpuset_hotplug_scanner {
 typedef enum {
 	CS_CPU_EXCLUSIVE,
 	CS_MEM_EXCLUSIVE,
+	CS_MEM_HARDWALL,
 	CS_MEMORY_MIGRATE,
 	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
@@ -141,6 +142,11 @@ static inline int is_mem_exclusive(const
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
@@ -1002,12 +1008,9 @@ int current_cpuset_is_being_rebound(void
 
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
@@ -1188,6 +1191,7 @@ typedef enum {
 	FILE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
+	FILE_MEM_HARDWALL,
 	FILE_SCHED_LOAD_BALANCE,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
@@ -1268,6 +1272,9 @@ static int cpuset_write_u64(struct cgrou
 	case FILE_MEM_EXCLUSIVE:
 		retval = update_flag(CS_MEM_EXCLUSIVE, cs, val);
 		break;
+	case FILE_MEM_HARDWALL:
+		retval = update_flag(CS_MEM_HARDWALL, cs, val);
+		break;
 	case FILE_SCHED_LOAD_BALANCE:
 		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, val);
 		break;
@@ -1375,6 +1382,8 @@ static u64 cpuset_read_u64(struct cgroup
 		return is_cpu_exclusive(cs);
 	case FILE_MEM_EXCLUSIVE:
 		return is_mem_exclusive(cs);
+	case FILE_MEM_HARDWALL:
+		return is_mem_hardwall(cs);
 	case FILE_SCHED_LOAD_BALANCE:
 		return is_sched_load_balance(cs);
 	case FILE_MEMORY_MIGRATE:
@@ -1427,6 +1436,13 @@ static struct cftype files[] = {
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
@@ -1913,14 +1929,14 @@ int cpuset_nodemask_valid_mems_allowed(n
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
@@ -1934,7 +1950,7 @@ static const struct cpuset *nearest_excl
  * __GFP_THISNODE is set, yes, we can always allocate.  If zone
  * z's node is in our tasks mems_allowed, yes.  If it's not a
  * __GFP_HARDWALL request and this zone's nodes is in the nearest
- * mem_exclusive cpuset ancestor to this tasks cpuset, yes.
+ * hardwalled cpuset ancestor to this tasks cpuset, yes.
  * If the task has been OOM killed and has access to memory reserves
  * as specified by the TIF_MEMDIE flag, yes.
  * Otherwise, no.
@@ -1957,7 +1973,7 @@ static const struct cpuset *nearest_excl
  * and do not allow allocations outside the current tasks cpuset
  * unless the task has been OOM killed as is marked TIF_MEMDIE.
  * GFP_KERNEL allocations are not so marked, so can escape to the
- * nearest enclosing mem_exclusive ancestor cpuset.
+ * nearest enclosing hardwalled ancestor cpuset.
  *
  * Scanning up parent cpusets requires callback_mutex.  The
  * __alloc_pages() routine only calls here with __GFP_HARDWALL bit
@@ -1980,7 +1996,7 @@ static const struct cpuset *nearest_excl
  *	in_interrupt - any node ok (current task context irrelevant)
  *	GFP_ATOMIC   - any node ok
  *	TIF_MEMDIE   - any node ok
- *	GFP_KERNEL   - any node in enclosing mem_exclusive cpuset ok
+ *	GFP_KERNEL   - any node in enclosing hardwalled cpuset ok
  *	GFP_USER     - only nodes in current tasks mems allowed ok.
  *
  * Rule:
@@ -2017,7 +2033,7 @@ int __cpuset_zone_allowed_softwall(struc
 	mutex_lock(&callback_mutex);
 
 	task_lock(current);
-	cs = nearest_exclusive_ancestor(task_cs(current));
+	cs = nearest_hardwall_ancestor(task_cs(current));
 	task_unlock(current);
 
 	allowed = node_isset(node, cs->mems_allowed);
_

Patches currently in -mm which might be from menage@google.com are

make-cgroup_enable_task_cg_lists-static.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
cgroup-api-files-rename-read-write_uint-methods-to-read_write_u64.patch
cgroup-api-files-add-res_counter_read_u64.patch
cgroup-api-files-use-read_u64-in-memory-controller.patch
cgroup-api-files-strip-all-trailing-whitespace-in-cgroup_write_u64.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api.patch
cgroup-api-files-update-cpusets-to-use-cgroup-structured-file-api-fix.patch
cgroup-api-files-add-cgroup-map-data-type.patch
cgroup-api-files-use-cgroup-map-for-memcontrol-stats-file.patch
cgroup-api-files-drop-mem_cgroup_force_empty.patch
cgroup-api-files-move-releasable-to-cgroup_debug-subsystem.patch
cgroup-api-files-make-cgroup_debug-default-to-off.patch
cpuset-hardwall-flag-switch-cpusets-to-use-the-bulk-cgroup_add_files-api.patch
cpuset-hardwall-flag-add-a-mem_hardwall-flag-to-cpusets.patch
add-a-refcount-check-in-dput.patch

