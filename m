From: akpm@linux-foundation.org
Subject: - cpusets-fix-and-update-documentation.patch removed from -mm tree
Date: Sun, 08 Jun 2008 12:47:02 -0700
Message-ID: <200806081947.m58Jl2dN017390@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53866 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755253AbYFHTrp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 15:47:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, pj@sgi.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     cpusets: fix and update Documentation
has been removed from the -mm tree.  Its filename was
     cpusets-fix-and-update-documentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpusets: fix and update Documentation
From: Miao Xie <miaox@cn.fujitsu.com>

Make the doc consistent with current cpusets implementation.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Acked-by: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/cpusets.txt |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN Documentation/cpusets.txt~cpusets-fix-and-update-documentation Documentation/cpusets.txt
--- a/Documentation/cpusets.txt~cpusets-fix-and-update-documentation
+++ a/Documentation/cpusets.txt
@@ -199,7 +199,7 @@ using the sched_setaffinity, mbind and s
 The following rules apply to each cpuset:
 
  - Its CPUs and Memory Nodes must be a subset of its parents.
- - It can only be marked exclusive if its parent is.
+ - It can't be marked exclusive unless its parent is.
  - If its cpu or memory is exclusive, they may not overlap any sibling.
 
 These rules, and the natural hierarchy of cpusets, enable efficient
@@ -345,7 +345,7 @@ is modified to perform an inline check f
 flag, and if set, a call to a new routine cpuset_mem_spread_node()
 returns the node to prefer for the allocation.
 
-Similarly, setting 'memory_spread_cache' turns on the flag
+Similarly, setting 'memory_spread_slab' turns on the flag
 PF_SPREAD_SLAB, and appropriately marked slab caches will allocate
 pages from the node returned by cpuset_mem_spread_node().
 
@@ -709,7 +709,10 @@ Now you want to do something with this c
 
 In this directory you can find several files:
 # ls
-cpus  cpu_exclusive  mems  mem_exclusive mem_hardwall  tasks
+cpu_exclusive  memory_migrate      mems                      tasks
+cpus           memory_pressure     notify_on_release
+mem_exclusive  memory_spread_page  sched_load_balance
+mem_hardwall   memory_spread_slab  sched_relax_domain_level
 
 Reading them will give you information about the state of this cpuset:
 the CPUs and Memory Nodes it can use, the processes that are using
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

origin.patch
cpusets-restructure-the-function-update_cpumask-and-update_nodemask.patch
cpusets-update-tasks-cpus_allowed-and-mems_allowed-after-cpu-node-offline-online.patch

