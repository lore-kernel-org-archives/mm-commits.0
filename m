From: akpm@linux-foundation.org
Subject: - cpuset-sched_load_balance-flag.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:52:12 -0700
Message-ID: <200710192252.l9JMqCag024251@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38389 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966780AbXJSXGA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:06:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pj@sgi.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     cpuset sched_load_balance flag
has been removed from the -mm tree.  Its filename was
     cpuset-sched_load_balance-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cpuset sched_load_balance flag
From: Paul Jackson <pj@sgi.com>

Add a new per-cpuset flag called 'sched_load_balance'.

When enabled in a cpuset (the default value) it tells the kernel scheduler
that the scheduler should provide the normal load balancing on the CPUs in
that cpuset, sometimes moving tasks from one CPU to a second CPU if the
second CPU is less loaded and if that task is allowed to run there.

When disabled (write "0" to the file) then it tells the kernel scheduler
that load balancing is not required for the CPUs in that cpuset.

Now even if this flag is disabled for some cpuset, the kernel may still
have to load balance some or all the CPUs in that cpuset, if some
overlapping cpuset has its sched_load_balance flag enabled.

If there are some CPUs that are not in any cpuset whose sched_load_balance
flag is enabled, the kernel scheduler will not load balance tasks to those
CPUs.

Moreover the kernel will partition the 'sched domains' (non-overlapping
sets of CPUs over which load balancing is attempted) into the finest
granularity partition that it can find, while still keeping any two CPUs
that are in the same shed_load_balance enabled cpuset in the same element
of the partition.

This serves two purposes:
 1) It provides a mechanism for real time isolation of some CPUs, and
 2) it can be used to improve performance on systems with many CPUs
    by supporting configurations in which load balancing is not done
    across all CPUs at once, but rather only done in several smaller
    disjoint sets of CPUs.

This mechanism replaces the earlier overloading of the per-cpuset
flag 'cpu_exclusive', which overloading was removed in an earlier
patch: cpuset-remove-sched-domain-hooks-from-cpusets

See further the Documentation and comments in the code itself.

[akpm@linux-foundation.org: don't be weird]
Signed-off-by: Paul Jackson <pj@sgi.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |  141 ++++++++++++++++++
 include/linux/sched.h     |    2 
 kernel/cpuset.c           |  275 +++++++++++++++++++++++++++++++++++-
 kernel/sched.c            |   95 ++++++++++--
 4 files changed, 492 insertions(+), 21 deletions(-)

diff -puN Documentation/cpusets.txt~cpuset-sched_load_balance-flag Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpuset-sched_load_balance-flag
+++ a/Documentation/cpusets.txt
@@ -19,7 +19,8 @@ CONTENTS:
   1.4 What are exclusive cpusets ?
   1.5 What is memory_pressure ?
   1.6 What is memory spread ?
-  1.7 How do I use cpusets ?
+  1.7 What is sched_load_balance ?
+  1.8 How do I use cpusets ?
 2. Usage Examples and Syntax
   2.1 Basic Usage
   2.2 Adding/removing cpus
@@ -359,8 +360,144 @@ policy, especially for jobs that might h
 data set, the memory allocation across the nodes in the jobs cpuset
 can become very uneven.
 
+1.7 What is sched_load_balance ?
+--------------------------------
+
+The kernel scheduler (kernel/sched.c) automatically load balances
+tasks.  If one CPU is underutilized, kernel code running on that
+CPU will look for tasks on other more overloaded CPUs and move those
+tasks to itself, within the constraints of such placement mechanisms
+as cpusets and sched_setaffinity.
+
+The algorithmic cost of load balancing and its impact on key shared
+kernel data structures such as the task list increases more than
+linearly with the number of CPUs being balanced.  So the scheduler
+has support to  partition the systems CPUs into a number of sched
+domains such that it only load balances within each sched domain.
+Each sched domain covers some subset of the CPUs in the system;
+no two sched domains overlap; some CPUs might not be in any sched
+domain and hence won't be load balanced.
+
+Put simply, it costs less to balance between two smaller sched domains
+than one big one, but doing so means that overloads in one of the
+two domains won't be load balanced to the other one.
+
+By default, there is one sched domain covering all CPUs, except those
+marked isolated using the kernel boot time "isolcpus=" argument.
+
+This default load balancing across all CPUs is not well suited for
+the following two situations:
+ 1) On large systems, load balancing across many CPUs is expensive.
+    If the system is managed using cpusets to place independent jobs
+    on separate sets of CPUs, full load balancing is unnecessary.
+ 2) Systems supporting realtime on some CPUs need to minimize
+    system overhead on those CPUs, including avoiding task load
+    balancing if that is not needed.
+
+When the per-cpuset flag "sched_load_balance" is enabled (the default
+setting), it requests that all the CPUs in that cpusets allowed 'cpus'
+be contained in a single sched domain, ensuring that load balancing
+can move a task (not otherwised pinned, as by sched_setaffinity)
+from any CPU in that cpuset to any other.
+
+When the per-cpuset flag "sched_load_balance" is disabled, then the
+scheduler will avoid load balancing across the CPUs in that cpuset,
+--except-- in so far as is necessary because some overlapping cpuset
+has "sched_load_balance" enabled.
+
+So, for example, if the top cpuset has the flag "sched_load_balance"
+enabled, then the scheduler will have one sched domain covering all
+CPUs, and the setting of the "sched_load_balance" flag in any other
+cpusets won't matter, as we're already fully load balancing.
+
+Therefore in the above two situations, the top cpuset flag
+"sched_load_balance" should be disabled, and only some of the smaller,
+child cpusets have this flag enabled.
+
+When doing this, you don't usually want to leave any unpinned tasks in
+the top cpuset that might use non-trivial amounts of CPU, as such tasks
+may be artificially constrained to some subset of CPUs, depending on
+the particulars of this flag setting in descendent cpusets.  Even if
+such a task could use spare CPU cycles in some other CPUs, the kernel
+scheduler might not consider the possibility of load balancing that
+task to that underused CPU.
+
+Of course, tasks pinned to a particular CPU can be left in a cpuset
+that disables "sched_load_balance" as those tasks aren't going anywhere
+else anyway.
+
+There is an impedance mismatch here, between cpusets and sched domains.
+Cpusets are hierarchical and nest.  Sched domains are flat; they don't
+overlap and each CPU is in at most one sched domain.
+
+It is necessary for sched domains to be flat because load balancing
+across partially overlapping sets of CPUs would risk unstable dynamics
+that would be beyond our understanding.  So if each of two partially
+overlapping cpusets enables the flag 'sched_load_balance', then we
+form a single sched domain that is a superset of both.  We won't move
+a task to a CPU outside it cpuset, but the scheduler load balancing
+code might waste some compute cycles considering that possibility.
+
+This mismatch is why there is not a simple one-to-one relation
+between which cpusets have the flag "sched_load_balance" enabled,
+and the sched domain configuration.  If a cpuset enables the flag, it
+will get balancing across all its CPUs, but if it disables the flag,
+it will only be assured of no load balancing if no other overlapping
+cpuset enables the flag.
+
+If two cpusets have partially overlapping 'cpus' allowed, and only
+one of them has this flag enabled, then the other may find its
+tasks only partially load balanced, just on the overlapping CPUs.
+This is just the general case of the top_cpuset example given a few
+paragraphs above.  In the general case, as in the top cpuset case,
+don't leave tasks that might use non-trivial amounts of CPU in
+such partially load balanced cpusets, as they may be artificially
+constrained to some subset of the CPUs allowed to them, for lack of
+load balancing to the other CPUs.
+
+1.7.1 sched_load_balance implementation details.
+------------------------------------------------
+
+The per-cpuset flag 'sched_load_balance' defaults to enabled (contrary
+to most cpuset flags.)  When enabled for a cpuset, the kernel will
+ensure that it can load balance across all the CPUs in that cpuset
+(makes sure that all the CPUs in the cpus_allowed of that cpuset are
+in the same sched domain.)
+
+If two overlapping cpusets both have 'sched_load_balance' enabled,
+then they will be (must be) both in the same sched domain.
+
+If, as is the default, the top cpuset has 'sched_load_balance' enabled,
+then by the above that means there is a single sched domain covering
+the whole system, regardless of any other cpuset settings.
+
+The kernel commits to user space that it will avoid load balancing
+where it can.  It will pick as fine a granularity partition of sched
+domains as it can while still providing load balancing for any set
+of CPUs allowed to a cpuset having 'sched_load_balance' enabled.
+
+The internal kernel cpuset to scheduler interface passes from the
+cpuset code to the scheduler code a partition of the load balanced
+CPUs in the system. This partition is a set of subsets (represented
+as an array of cpumask_t) of CPUs, pairwise disjoint, that cover all
+the CPUs that must be load balanced.
+
+Whenever the 'sched_load_balance' flag changes, or CPUs come or go
+from a cpuset with this flag enabled, or a cpuset with this flag
+enabled is removed, the cpuset code builds a new such partition and
+passes it to the scheduler sched domain setup code, to have the sched
+domains rebuilt as necessary.
+
+This partition exactly defines what sched domains the scheduler should
+setup - one sched domain for each element (cpumask_t) in the partition.
+
+The scheduler remembers the currently active sched domain partitions.
+When the scheduler routine partition_sched_domains() is invoked from
+the cpuset code to update these sched domains, it compares the new
+partition requested with the current, and updates its sched domains,
+removing the old and adding the new, for each change.
 
-1.7 How do I use cpusets ?
+1.8 How do I use cpusets ?
 --------------------------
 
 In order to minimize the impact of cpusets on critical kernel
diff -puN include/linux/sched.h~cpuset-sched_load_balance-flag include/linux/sched.h
--- a/include/linux/sched.h~cpuset-sched_load_balance-flag
+++ a/include/linux/sched.h
@@ -737,6 +737,8 @@ struct sched_domain {
 #endif
 };
 
+extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new);
+
 #endif	/* CONFIG_SMP */
 
 /*
diff -puN kernel/cpuset.c~cpuset-sched_load_balance-flag kernel/cpuset.c
--- a/kernel/cpuset.c~cpuset-sched_load_balance-flag
+++ a/kernel/cpuset.c
@@ -4,7 +4,7 @@
  *  Processor and Memory placement constraints for sets of tasks.
  *
  *  Copyright (C) 2003 BULL SA.
- *  Copyright (C) 2004-2006 Silicon Graphics, Inc.
+ *  Copyright (C) 2004-2007 Silicon Graphics, Inc.
  *  Copyright (C) 2006 Google, Inc
  *
  *  Portions derived from Patrick Mochel's sysfs code.
@@ -54,6 +54,7 @@
 #include <asm/uaccess.h>
 #include <asm/atomic.h>
 #include <linux/mutex.h>
+#include <linux/kfifo.h>
 
 /*
  * Tracks how many cpusets are currently defined in system.
@@ -91,6 +92,9 @@ struct cpuset {
 	int mems_generation;
 
 	struct fmeter fmeter;		/* memory_pressure filter */
+
+	/* partition number for rebuild_sched_domains() */
+	int pn;
 };
 
 /* Retrieve the cpuset for a cgroup */
@@ -113,6 +117,7 @@ typedef enum {
 	CS_CPU_EXCLUSIVE,
 	CS_MEM_EXCLUSIVE,
 	CS_MEMORY_MIGRATE,
+	CS_SCHED_LOAD_BALANCE,
 	CS_SPREAD_PAGE,
 	CS_SPREAD_SLAB,
 } cpuset_flagbits_t;
@@ -128,6 +133,11 @@ static inline int is_mem_exclusive(const
 	return test_bit(CS_MEM_EXCLUSIVE, &cs->flags);
 }
 
+static inline int is_sched_load_balance(const struct cpuset *cs)
+{
+	return test_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
+}
+
 static inline int is_memory_migrate(const struct cpuset *cs)
 {
 	return test_bit(CS_MEMORY_MIGRATE, &cs->flags);
@@ -482,6 +492,208 @@ static int validate_change(const struct 
 }
 
 /*
+ * Helper routine for rebuild_sched_domains().
+ * Do cpusets a, b have overlapping cpus_allowed masks?
+ */
+
+static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
+{
+	return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
+}
+
+/*
+ * rebuild_sched_domains()
+ *
+ * If the flag 'sched_load_balance' of any cpuset with non-empty
+ * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
+ * which has that flag enabled, or if any cpuset with a non-empty
+ * 'cpus' is removed, then call this routine to rebuild the
+ * scheduler's dynamic sched domains.
+ *
+ * This routine builds a partial partition of the systems CPUs
+ * (the set of non-overlappping cpumask_t's in the array 'part'
+ * below), and passes that partial partition to the kernel/sched.c
+ * partition_sched_domains() routine, which will rebuild the
+ * schedulers load balancing domains (sched domains) as specified
+ * by that partial partition.  A 'partial partition' is a set of
+ * non-overlapping subsets whose union is a subset of that set.
+ *
+ * See "What is sched_load_balance" in Documentation/cpusets.txt
+ * for a background explanation of this.
+ *
+ * Does not return errors, on the theory that the callers of this
+ * routine would rather not worry about failures to rebuild sched
+ * domains when operating in the severe memory shortage situations
+ * that could cause allocation failures below.
+ *
+ * Call with cgroup_mutex held.  May take callback_mutex during
+ * call due to the kfifo_alloc() and kmalloc() calls.  May nest
+ * a call to the lock_cpu_hotplug()/unlock_cpu_hotplug() pair.
+ * Must not be called holding callback_mutex, because we must not
+ * call lock_cpu_hotplug() while holding callback_mutex.  Elsewhere
+ * the kernel nests callback_mutex inside lock_cpu_hotplug() calls.
+ * So the reverse nesting would risk an ABBA deadlock.
+ *
+ * The three key local variables below are:
+ *    q  - a kfifo queue of cpuset pointers, used to implement a
+ *	   top-down scan of all cpusets.  This scan loads a pointer
+ *	   to each cpuset marked is_sched_load_balance into the
+ *	   array 'csa'.  For our purposes, rebuilding the schedulers
+ *	   sched domains, we can ignore !is_sched_load_balance cpusets.
+ *  csa  - (for CpuSet Array) Array of pointers to all the cpusets
+ *	   that need to be load balanced, for convenient iterative
+ *	   access by the subsequent code that finds the best partition,
+ *	   i.e the set of domains (subsets) of CPUs such that the
+ *	   cpus_allowed of every cpuset marked is_sched_load_balance
+ *	   is a subset of one of these domains, while there are as
+ *	   many such domains as possible, each as small as possible.
+ * doms  - Conversion of 'csa' to an array of cpumasks, for passing to
+ *	   the kernel/sched.c routine partition_sched_domains() in a
+ *	   convenient format, that can be easily compared to the prior
+ *	   value to determine what partition elements (sched domains)
+ *	   were changed (added or removed.)
+ *
+ * Finding the best partition (set of domains):
+ *	The triple nested loops below over i, j, k scan over the
+ *	load balanced cpusets (using the array of cpuset pointers in
+ *	csa[]) looking for pairs of cpusets that have overlapping
+ *	cpus_allowed, but which don't have the same 'pn' partition
+ *	number and gives them in the same partition number.  It keeps
+ *	looping on the 'restart' label until it can no longer find
+ *	any such pairs.
+ *
+ *	The union of the cpus_allowed masks from the set of
+ *	all cpusets having the same 'pn' value then form the one
+ *	element of the partition (one sched domain) to be passed to
+ *	partition_sched_domains().
+ */
+
+static void rebuild_sched_domains(void)
+{
+	struct kfifo *q;	/* queue of cpusets to be scanned */
+	struct cpuset *cp;	/* scans q */
+	struct cpuset **csa;	/* array of all cpuset ptrs */
+	int csn;		/* how many cpuset ptrs in csa so far */
+	int i, j, k;		/* indices for partition finding loops */
+	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
+	int ndoms;		/* number of sched domains in result */
+	int nslot;		/* next empty doms[] cpumask_t slot */
+
+	q = NULL;
+	csa = NULL;
+	doms = NULL;
+
+	/* Special case for the 99% of systems with one, full, sched domain */
+	if (is_sched_load_balance(&top_cpuset)) {
+		ndoms = 1;
+		doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+		if (!doms)
+			goto rebuild;
+		*doms = top_cpuset.cpus_allowed;
+		goto rebuild;
+	}
+
+	q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
+	if (IS_ERR(q))
+		goto done;
+	csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
+	if (!csa)
+		goto done;
+	csn = 0;
+
+	cp = &top_cpuset;
+	__kfifo_put(q, (void *)&cp, sizeof(cp));
+	while (__kfifo_get(q, (void *)&cp, sizeof(cp))) {
+		struct cgroup *cont;
+		struct cpuset *child;   /* scans child cpusets of cp */
+		if (is_sched_load_balance(cp))
+			csa[csn++] = cp;
+		list_for_each_entry(cont, &cp->css.cgroup->children, sibling) {
+			child = cgroup_cs(cont);
+			__kfifo_put(q, (void *)&child, sizeof(cp));
+		}
+  	}
+
+	for (i = 0; i < csn; i++)
+		csa[i]->pn = i;
+	ndoms = csn;
+
+restart:
+	/* Find the best partition (set of sched domains) */
+	for (i = 0; i < csn; i++) {
+		struct cpuset *a = csa[i];
+		int apn = a->pn;
+
+		for (j = 0; j < csn; j++) {
+			struct cpuset *b = csa[j];
+			int bpn = b->pn;
+
+			if (apn != bpn && cpusets_overlap(a, b)) {
+				for (k = 0; k < csn; k++) {
+					struct cpuset *c = csa[k];
+
+					if (c->pn == bpn)
+						c->pn = apn;
+				}
+				ndoms--;	/* one less element */
+				goto restart;
+			}
+		}
+	}
+
+	/* Convert <csn, csa> to <ndoms, doms> */
+	doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
+	if (!doms)
+		goto rebuild;
+
+	for (nslot = 0, i = 0; i < csn; i++) {
+		struct cpuset *a = csa[i];
+		int apn = a->pn;
+
+		if (apn >= 0) {
+			cpumask_t *dp = doms + nslot;
+
+			if (nslot == ndoms) {
+				static int warnings = 10;
+				if (warnings) {
+					printk(KERN_WARNING
+					 "rebuild_sched_domains confused:"
+					  " nslot %d, ndoms %d, csn %d, i %d,"
+					  " apn %d\n",
+					  nslot, ndoms, csn, i, apn);
+					warnings--;
+				}
+				continue;
+			}
+
+			cpus_clear(*dp);
+			for (j = i; j < csn; j++) {
+				struct cpuset *b = csa[j];
+
+				if (apn == b->pn) {
+					cpus_or(*dp, *dp, b->cpus_allowed);
+					b->pn = -1;
+				}
+			}
+			nslot++;
+		}
+	}
+	BUG_ON(nslot != ndoms);
+
+rebuild:
+	/* Have scheduler rebuild sched domains */
+	lock_cpu_hotplug();
+	partition_sched_domains(ndoms, doms);
+	unlock_cpu_hotplug();
+
+done:
+	if (q && !IS_ERR(q))
+		kfifo_free(q);
+	kfree(csa);
+	/* Don't kfree(doms) -- partition_sched_domains() does that. */
+}
+
+/*
  * Call with manage_mutex held.  May take callback_mutex during call.
  */
 
@@ -489,6 +701,7 @@ static int update_cpumask(struct cpuset 
 {
 	struct cpuset trialcs;
 	int retval;
+	int cpus_changed, is_load_balanced;
 
 	/* top_cpuset.cpus_allowed tracks cpu_online_map; it's read-only */
 	if (cs == &top_cpuset)
@@ -516,9 +729,17 @@ static int update_cpumask(struct cpuset 
 	retval = validate_change(cs, &trialcs);
 	if (retval < 0)
 		return retval;
+
+	cpus_changed = !cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed);
+	is_load_balanced = is_sched_load_balance(&trialcs);
+
 	mutex_lock(&callback_mutex);
 	cs->cpus_allowed = trialcs.cpus_allowed;
 	mutex_unlock(&callback_mutex);
+
+	if (cpus_changed && is_load_balanced)
+		rebuild_sched_domains();
+
 	return 0;
 }
 
@@ -752,6 +973,7 @@ static int update_memory_pressure_enable
 /*
  * update_flag - read a 0 or a 1 in a file and update associated flag
  * bit:	the bit to update (CS_CPU_EXCLUSIVE, CS_MEM_EXCLUSIVE,
+ *				CS_SCHED_LOAD_BALANCE,
  *				CS_NOTIFY_ON_RELEASE, CS_MEMORY_MIGRATE,
  *				CS_SPREAD_PAGE, CS_SPREAD_SLAB)
  * cs:	the cpuset to update
@@ -765,6 +987,7 @@ static int update_flag(cpuset_flagbits_t
 	int turning_on;
 	struct cpuset trialcs;
 	int err;
+	int cpus_nonempty, balance_flag_changed;
 
 	turning_on = (simple_strtoul(buf, NULL, 10) != 0);
 
@@ -777,10 +1000,18 @@ static int update_flag(cpuset_flagbits_t
 	err = validate_change(cs, &trialcs);
 	if (err < 0)
 		return err;
+
+	cpus_nonempty = !cpus_empty(trialcs.cpus_allowed);
+	balance_flag_changed = (is_sched_load_balance(cs) !=
+		 			is_sched_load_balance(&trialcs));
+
 	mutex_lock(&callback_mutex);
 	cs->flags = trialcs.flags;
 	mutex_unlock(&callback_mutex);
 
+	if (cpus_nonempty && balance_flag_changed)
+		rebuild_sched_domains();
+
 	return 0;
 }
 
@@ -928,6 +1159,7 @@ typedef enum {
 	FILE_MEMLIST,
 	FILE_CPU_EXCLUSIVE,
 	FILE_MEM_EXCLUSIVE,
+	FILE_SCHED_LOAD_BALANCE,
 	FILE_MEMORY_PRESSURE_ENABLED,
 	FILE_MEMORY_PRESSURE,
 	FILE_SPREAD_PAGE,
@@ -946,7 +1178,7 @@ static ssize_t cpuset_common_file_write(
 	int retval = 0;
 
 	/* Crude upper limit on largest legitimate cpulist user might write. */
-	if (nbytes > 100 + 6 * max(NR_CPUS, MAX_NUMNODES))
+	if (nbytes > 100U + 6 * max(NR_CPUS, MAX_NUMNODES))
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
@@ -979,6 +1211,9 @@ static ssize_t cpuset_common_file_write(
 	case FILE_MEM_EXCLUSIVE:
 		retval = update_flag(CS_MEM_EXCLUSIVE, cs, buffer);
 		break;
+	case FILE_SCHED_LOAD_BALANCE:
+		retval = update_flag(CS_SCHED_LOAD_BALANCE, cs, buffer);
+		break;
 	case FILE_MEMORY_MIGRATE:
 		retval = update_flag(CS_MEMORY_MIGRATE, cs, buffer);
 		break;
@@ -1074,6 +1309,9 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_MEM_EXCLUSIVE:
 		*s++ = is_mem_exclusive(cs) ? '1' : '0';
 		break;
+	case FILE_SCHED_LOAD_BALANCE:
+		*s++ = is_sched_load_balance(cs) ? '1' : '0';
+		break;
 	case FILE_MEMORY_MIGRATE:
 		*s++ = is_memory_migrate(cs) ? '1' : '0';
 		break;
@@ -1137,6 +1375,13 @@ static struct cftype cft_mem_exclusive =
 	.private = FILE_MEM_EXCLUSIVE,
 };
 
+static struct cftype cft_sched_load_balance = {
+	.name = "sched_load_balance",
+	.read = cpuset_common_file_read,
+	.write = cpuset_common_file_write,
+	.private = FILE_SCHED_LOAD_BALANCE,
+};
+
 static struct cftype cft_memory_migrate = {
 	.name = "memory_migrate",
 	.read = cpuset_common_file_read,
@@ -1186,6 +1431,8 @@ static int cpuset_populate(struct cgroup
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_memory_migrate)) < 0)
 		return err;
+	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
+		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
 		return err;
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
@@ -1267,6 +1514,7 @@ static struct cgroup_subsys_state *cpuse
 		set_bit(CS_SPREAD_PAGE, &cs->flags);
 	if (is_spread_slab(parent))
 		set_bit(CS_SPREAD_SLAB, &cs->flags);
+	set_bit(CS_SCHED_LOAD_BALANCE, &cs->flags);
 	cs->cpus_allowed = CPU_MASK_NONE;
 	cs->mems_allowed = NODE_MASK_NONE;
 	cs->mems_generation = cpuset_mems_generation++;
@@ -1277,11 +1525,27 @@ static struct cgroup_subsys_state *cpuse
 	return &cs->css ;
 }
 
+/*
+ * Locking note on the strange update_flag() call below:
+ *
+ * If the cpuset being removed has its flag 'sched_load_balance'
+ * enabled, then simulate turning sched_load_balance off, which
+ * will call rebuild_sched_domains().  The lock_cpu_hotplug()
+ * call in rebuild_sched_domains() must not be made while holding
+ * callback_mutex.  Elsewhere the kernel nests callback_mutex inside
+ * lock_cpu_hotplug() calls.  So the reverse nesting would risk an
+ * ABBA deadlock.
+ */
+
 static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct cpuset *cs = cgroup_cs(cont);
 
 	cpuset_update_task_memory_state();
+
+	if (is_sched_load_balance(cs))
+		update_flag(CS_SCHED_LOAD_BALANCE, cs, "0");
+
 	number_of_cpusets--;
 	kfree(cs);
 }
@@ -1326,6 +1590,7 @@ int __init cpuset_init(void)
 
 	fmeter_init(&top_cpuset.fmeter);
 	top_cpuset.mems_generation = cpuset_mems_generation++;
+	set_bit(CS_SCHED_LOAD_BALANCE, &top_cpuset.flags);
 
 	err = register_filesystem(&cpuset_fs_type);
 	if (err < 0)
@@ -1412,8 +1677,8 @@ static void common_cpu_mem_hotplug_unplu
  * cpu_online_map on each CPU hotplug (cpuhp) event.
  */
 
-static int cpuset_handle_cpuhp(struct notifier_block *nb,
-				unsigned long phase, void *cpu)
+static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
+				unsigned long phase, void *unused_cpu)
 {
 	if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
 		return NOTIFY_DONE;
@@ -1803,7 +2068,7 @@ void __cpuset_memory_pressure_bump(void)
  *    the_top_cpuset_hack in cpuset_exit(), which sets an exiting tasks
  *    cpuset to top_cpuset.
  */
-static int proc_cpuset_show(struct seq_file *m, void *v)
+static int proc_cpuset_show(struct seq_file *m, void *unused_v)
 {
 	struct pid *pid;
 	struct task_struct *tsk;
diff -puN kernel/sched.c~cpuset-sched_load_balance-flag kernel/sched.c
--- a/kernel/sched.c~cpuset-sched_load_balance-flag
+++ a/kernel/sched.c
@@ -6376,26 +6376,31 @@ error:
 	return -ENOMEM;
 #endif
 }
+
+static cpumask_t *doms_cur;	/* current sched domains */
+static int ndoms_cur;		/* number of sched domains in 'doms_cur' */
+
+/*
+ * Special case: If a kmalloc of a doms_cur partition (array of
+ * cpumask_t) fails, then fallback to a single sched domain,
+ * as determined by the single cpumask_t fallback_doms.
+ */
+static cpumask_t fallback_doms;
+
 /*
  * Set up scheduler domains and groups.  Callers must hold the hotplug lock.
+ * For now this just excludes isolated cpus, but could be used to
+ * exclude other special cases in the future.
  */
 static int arch_init_sched_domains(const cpumask_t *cpu_map)
 {
-	cpumask_t cpu_default_map;
-	int err;
-
-	/*
-	 * Setup mask for cpus without special case scheduling requirements.
-	 * For now this just excludes isolated cpus, but could be used to
-	 * exclude other special cases in the future.
-	 */
-	cpus_andnot(cpu_default_map, *cpu_map, cpu_isolated_map);
-
-	err = build_sched_domains(&cpu_default_map);
-
+	ndoms_cur = 1;
+	doms_cur = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
+	if (!doms_cur)
+		doms_cur = &fallback_doms;
+	cpus_andnot(*doms_cur, *cpu_map, cpu_isolated_map);
 	register_sched_domain_sysctl();
-
-	return err;
+	return build_sched_domains(doms_cur);
 }
 
 static void arch_destroy_sched_domains(const cpumask_t *cpu_map)
@@ -6419,6 +6424,68 @@ static void detach_destroy_domains(const
 	arch_destroy_sched_domains(cpu_map);
 }
 
+/*
+ * Partition sched domains as specified by the 'ndoms_new'
+ * cpumasks in the array doms_new[] of cpumasks.  This compares
+ * doms_new[] to the current sched domain partitioning, doms_cur[].
+ * It destroys each deleted domain and builds each new domain.
+ *
+ * 'doms_new' is an array of cpumask_t's of length 'ndoms_new'.
+ * The masks don't intersect (don't overlap.)  We should setup one
+ * sched domain for each mask.  CPUs not in any of the cpumasks will
+ * not be load balanced.  If the same cpumask appears both in the
+ * current 'doms_cur' domains and in the new 'doms_new', we can leave
+ * it as it is.
+ *
+ * The passed in 'doms_new' should be kmalloc'd.  This routine takes
+ * ownership of it and will kfree it when done with it.  If the caller
+ * failed the kmalloc call, then it can pass in doms_new == NULL,
+ * and partition_sched_domains() will fallback to the single partition
+ * 'fallback_doms'.
+ *
+ * Call with hotplug lock held
+ */
+void partition_sched_domains(int ndoms_new, cpumask_t *doms_new)
+{
+	int i, j;
+
+	if (doms_new == NULL) {
+		ndoms_new = 1;
+		doms_new = &fallback_doms;
+		cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
+	}
+
+	/* Destroy deleted domains */
+	for (i = 0; i < ndoms_cur; i++) {
+		for (j = 0; j < ndoms_new; j++) {
+			if (cpus_equal(doms_cur[i], doms_new[j]))
+				goto match1;
+		}
+		/* no match - a current sched domain not in new doms_new[] */
+		detach_destroy_domains(doms_cur + i);
+match1:
+		;
+	}
+
+	/* Build new domains */
+	for (i = 0; i < ndoms_new; i++) {
+		for (j = 0; j < ndoms_cur; j++) {
+			if (cpus_equal(doms_new[i], doms_cur[j]))
+				goto match2;
+		}
+		/* no match - add a new doms_new */
+		build_sched_domains(doms_new + i);
+match2:
+		;
+	}
+
+	/* Remember the new sched domains */
+	if (doms_cur != &fallback_doms)
+		kfree(doms_cur);
+	doms_cur = doms_new;
+	ndoms_cur = ndoms_new;
+}
+
 #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
 static int arch_reinit_sched_domains(void)
 {
_

Patches currently in -mm which might be from pj@sgi.com are

origin.patch
git-scsi-misc.patch
