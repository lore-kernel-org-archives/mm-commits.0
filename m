From: akpm@linux-foundation.org
Subject: [merged] cpuset-various-documentation-fixes-and-updates.patch removed from -mm tree
Date: Mon, 23 Feb 2009 12:06:46 -0800
Message-ID: <200902232006.n1NK6kR3013426@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751719AbZBWUSL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Feb 2009 15:18:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lizf@cn.fujitsu.com, menage@google.com, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     cpuset: various documentation fixes and updates
has been removed from the -mm tree.  Its filename was
     cpuset-various-documentation-fixes-and-updates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpuset: various documentation fixes and updates
From: Li Zefan <lizf@cn.fujitsu.com>

I noticed the old commit 8f5aa26c75b7722e80c0c5c5bb833d41865d7019
("cpusets: update_cpumask documentation fix") is not a complete fix,
resulting in inconsistent paragraphs.  This patch fixes it and does other
fixes and updates:

- s/migrate_all_tasks()/migrate_live_tasks()/
- describe more cpuset control files
- s/cpumask_t/struct cpumask/
- document cpu hotplug and change of 'sched_relax_domain_level' may cause
  domain rebuild
- document various ways to query and modify cpusets
- the equivalent of "mount -t cpuset" is "mount -t cgroup -o cpuset,noprefix"

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cgroups/cpusets.txt |   63 ++++++++++++++++------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff -puN Documentation/cgroups/cpusets.txt~cpuset-various-documentation-fixes-and-updates Documentation/cgroups/cpusets.txt
--- a/Documentation/cgroups/cpusets.txt~cpuset-various-documentation-fixes-and-updates
+++ a/Documentation/cgroups/cpusets.txt
@@ -142,7 +142,7 @@ into the rest of the kernel, none in per
  - in fork and exit, to attach and detach a task from its cpuset.
  - in sched_setaffinity, to mask the requested CPUs by what's
    allowed in that tasks cpuset.
- - in sched.c migrate_all_tasks(), to keep migrating tasks within
+ - in sched.c migrate_live_tasks(), to keep migrating tasks within
    the CPUs allowed by their cpuset, if possible.
  - in the mbind and set_mempolicy system calls, to mask the requested
    Memory Nodes by what's allowed in that tasks cpuset.
@@ -175,6 +175,10 @@ files describing that cpuset:
  - mem_exclusive flag: is memory placement exclusive?
  - mem_hardwall flag:  is memory allocation hardwalled
  - memory_pressure: measure of how much paging pressure in cpuset
+ - memory_spread_page flag: if set, spread page cache evenly on allowed nodes
+ - memory_spread_slab flag: if set, spread slab cache evenly on allowed nodes
+ - sched_load_balance flag: if set, load balance within CPUs on that cpuset
+ - sched_relax_domain_level: the searching range when migrating tasks
 
 In addition, the root cpuset only has the following file:
  - memory_pressure_enabled flag: compute memory_pressure?
@@ -252,7 +256,7 @@ is causing.
 
 This is useful both on tightly managed systems running a wide mix of
 submitted jobs, which may choose to terminate or re-prioritize jobs that
-are trying to use more memory than allowed on the nodes assigned them,
+are trying to use more memory than allowed on the nodes assigned to them,
 and with tightly coupled, long running, massively parallel scientific
 computing jobs that will dramatically fail to meet required performance
 goals if they start to use more memory than allowed to them.
@@ -378,7 +382,7 @@ as cpusets and sched_setaffinity.
 The algorithmic cost of load balancing and its impact on key shared
 kernel data structures such as the task list increases more than
 linearly with the number of CPUs being balanced.  So the scheduler
-has support to  partition the systems CPUs into a number of sched
+has support to partition the systems CPUs into a number of sched
 domains such that it only load balances within each sched domain.
 Each sched domain covers some subset of the CPUs in the system;
 no two sched domains overlap; some CPUs might not be in any sched
@@ -485,17 +489,22 @@ of CPUs allowed to a cpuset having 'sche
 The internal kernel cpuset to scheduler interface passes from the
 cpuset code to the scheduler code a partition of the load balanced
 CPUs in the system. This partition is a set of subsets (represented
-as an array of cpumask_t) of CPUs, pairwise disjoint, that cover all
-the CPUs that must be load balanced.
+as an array of struct cpumask) of CPUs, pairwise disjoint, that cover
+all the CPUs that must be load balanced.
 
-Whenever the 'sched_load_balance' flag changes, or CPUs come or go
-from a cpuset with this flag enabled, or a cpuset with this flag
-enabled is removed, the cpuset code builds a new such partition and
-passes it to the scheduler sched domain setup code, to have the sched
-domains rebuilt as necessary.
+The cpuset code builds a new such partition and passes it to the
+scheduler sched domain setup code, to have the sched domains rebuilt
+as necessary, whenever:
+ - the 'sched_load_balance' flag of a cpuset with non-empty CPUs changes,
+ - or CPUs come or go from a cpuset with this flag enabled,
+ - or 'sched_relax_domain_level' value of a cpuset with non-empty CPUs
+   and with this flag enabled changes,
+ - or a cpuset with non-empty CPUs and with this flag enabled is removed,
+ - or a cpu is offlined/onlined.
 
 This partition exactly defines what sched domains the scheduler should
-setup - one sched domain for each element (cpumask_t) in the partition.
+setup - one sched domain for each element (struct cpumask) in the
+partition.
 
 The scheduler remembers the currently active sched domain partitions.
 When the scheduler routine partition_sched_domains() is invoked from
@@ -559,7 +568,7 @@ domain, the largest value among those is
 requests 0 and others are -1 then 0 is used.
 
 Note that modifying this file will have both good and bad effects,
-and whether it is acceptable or not will be depend on your situation.
+and whether it is acceptable or not depends on your situation.
 Don't modify this file if you are not sure.
 
 If your situation is:
@@ -600,19 +609,15 @@ to allocate a page of memory for that ta
 
 If a cpuset has its 'cpus' modified, then each task in that cpuset
 will have its allowed CPU placement changed immediately.  Similarly,
-if a tasks pid is written to a cpusets 'tasks' file, in either its
-current cpuset or another cpuset, then its allowed CPU placement is
-changed immediately.  If such a task had been bound to some subset
-of its cpuset using the sched_setaffinity() call, the task will be
-allowed to run on any CPU allowed in its new cpuset, negating the
-affect of the prior sched_setaffinity() call.
+if a tasks pid is written to another cpusets 'tasks' file, then its
+allowed CPU placement is changed immediately.  If such a task had been
+bound to some subset of its cpuset using the sched_setaffinity() call,
+the task will be allowed to run on any CPU allowed in its new cpuset,
+negating the effect of the prior sched_setaffinity() call.
 
 In summary, the memory placement of a task whose cpuset is changed is
 updated by the kernel, on the next allocation of a page for that task,
-but the processor placement is not updated, until that tasks pid is
-rewritten to the 'tasks' file of its cpuset.  This is done to avoid
-impacting the scheduler code in the kernel with a check for changes
-in a tasks processor placement.
+and the processor placement is updated immediately.
 
 Normally, once a page is allocated (given a physical page
 of main memory) then that page stays on whatever node it
@@ -681,10 +686,14 @@ and then start a subshell 'sh' in that c
   # The next line should display '/Charlie'
   cat /proc/self/cpuset
 
-In the future, a C library interface to cpusets will likely be
-available.  For now, the only way to query or modify cpusets is
-via the cpuset file system, using the various cd, mkdir, echo, cat,
-rmdir commands from the shell, or their equivalent from C.
+There are ways to query or modify cpusets:
+ - via the cpuset file system directly, using the various cd, mkdir, echo,
+   cat, rmdir commands from the shell, or their equivalent from C.
+ - via the C library libcpuset.
+ - via the C library libcgroup.
+   (http://sourceforge.net/proects/libcg/)
+ - via the python application cset.
+   (http://developer.novell.com/wiki/index.php/Cpuset)
 
 The sched_setaffinity calls can also be done at the shell prompt using
 SGI's runon or Robert Love's taskset.  The mbind and set_mempolicy
@@ -756,7 +765,7 @@ mount -t cpuset X /dev/cpuset
 
 is equivalent to
 
-mount -t cgroup -ocpuset X /dev/cpuset
+mount -t cgroup -ocpuset,noprefix X /dev/cpuset
 echo "/sbin/cpuset_release_agent" > /dev/cpuset/release_agent
 
 2.2 Adding/removing cpus
_

Patches currently in -mm which might be from lizf@cn.fujitsu.com are

linux-next.patch
vfs-add-missing-unlock-in-sget.patch
relax-ns_can_attach-checks-to-allow-attaching-to-grandchild-cgroups.patch
cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
cpuset-fix-possible-races-in-cpu-memory-hotplug.patch

