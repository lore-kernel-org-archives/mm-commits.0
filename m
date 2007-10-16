From: akpm@linux-foundation.org
Subject: - mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:48 -0700
Message-ID: <200710162031.l9GKVm73014533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760124AbXJPVwg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:52:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com, mm-commits@vger.kernel.org


The patch titled
     Mem Policy: add MPOL_F_MEMS_ALLOWED get_mempolicy() flag
has been removed from the -mm tree.  Its filename was
     mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Mem Policy: add MPOL_F_MEMS_ALLOWED get_mempolicy() flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>

Allow an application to query the memories allowed by its context.

Updated numa_memory_policy.txt to mention that applications can use this to
obtain allowed memories for constructing valid policies.

TODO:  update out-of-tree libnuma wrapper[s], or maybe add a new
wrapper--e.g.,  numa_get_mems_allowed() ?

Also, update numa syscall man pages.

Tested with memtoy V>=0.13.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/numa_memory_policy.txt |   33 ++++++++++------------
 include/linux/mempolicy.h               |    1 
 mm/mempolicy.c                          |   12 +++++++-
 3 files changed, 28 insertions(+), 18 deletions(-)

diff -puN Documentation/vm/numa_memory_policy.txt~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag Documentation/vm/numa_memory_policy.txt
--- a/Documentation/vm/numa_memory_policy.txt~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag
+++ a/Documentation/vm/numa_memory_policy.txt
@@ -302,31 +302,30 @@ MEMORY POLICIES AND CPUSETS
 
 Memory policies work within cpusets as described above.  For memory policies
 that require a node or set of nodes, the nodes are restricted to the set of
-nodes whose memories are allowed by the cpuset constraints.  If the
-intersection of the set of nodes specified for the policy and the set of nodes
-allowed by the cpuset is the empty set, the policy is considered invalid and
-cannot be installed.
+nodes whose memories are allowed by the cpuset constraints.  If the nodemask
+specified for the policy contains nodes that are not allowed by the cpuset, or
+the intersection of the set of nodes specified for the policy and the set of
+nodes with memory is the empty set, the policy is considered invalid
+and cannot be installed.
 
 The interaction of memory policies and cpusets can be problematic for a
 couple of reasons:
 
-1) the memory policy APIs take physical node id's as arguments.  However, the
-   memory policy APIs do not provide a way to determine what nodes are valid
-   in the context where the application is running.  An application MAY consult
-   the cpuset file system [directly or via an out of tree, and not generally
-   available, libcpuset API] to obtain this information, but then the
-   application must be aware that it is running in a cpuset and use what are
-   intended primarily as administrative APIs.
-
-   However, as long as the policy specifies at least one node that is valid
-   in the controlling cpuset, the policy can be used.
+1) the memory policy APIs take physical node id's as arguments.  As mentioned
+   above, it is illegal to specify nodes that are not allowed in the cpuset.
+   The application must query the allowed nodes using the get_mempolicy()
+   API with the MPOL_F_MEMS_ALLOWED flag to determine the allowed nodes and
+   restrict itself to those nodes.  However, the resources available to a
+   cpuset can be changed by the system administrator, or a workload manager
+   application, at any time.  So, a task may still get errors attempting to
+   specify policy nodes, and must query the allowed memories again.
 
 2) when tasks in two cpusets share access to a memory region, such as shared
    memory segments created by shmget() of mmap() with the MAP_ANONYMOUS and
    MAP_SHARED flags, and any of the tasks install shared policy on the region,
    only nodes whose memories are allowed in both cpusets may be used in the
-   policies.  Again, obtaining this information requires "stepping outside"
-   the memory policy APIs, as well as knowing in what cpusets other task might
-   be attaching to the shared region, to use the cpuset information.
+   policies.  Obtaining this information requires "stepping outside" the
+   memory policy APIs to use the cpuset information and requires that one
+   know in what cpusets other task might be attaching to the shared region.
    Furthermore, if the cpusets' allowed memory sets are disjoint, "local"
    allocation is the only valid policy.
diff -puN include/linux/mempolicy.h~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag
+++ a/include/linux/mempolicy.h
@@ -19,6 +19,7 @@
 /* Flags for get_mem_policy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
+#define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
diff -puN mm/mempolicy.c~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag mm/mempolicy.c
--- a/mm/mempolicy.c~mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag
+++ a/mm/mempolicy.c
@@ -526,8 +526,18 @@ long do_get_mempolicy(int *policy, nodem
 	struct mempolicy *pol = current->mempolicy;
 
 	cpuset_update_task_memory_state();
-	if (flags & ~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR))
+	if (flags &
+		~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR|MPOL_F_MEMS_ALLOWED))
 		return -EINVAL;
+
+	if (flags & MPOL_F_MEMS_ALLOWED) {
+		if (flags & (MPOL_F_NODE|MPOL_F_ADDR))
+			return -EINVAL;
+		*policy = 0;	/* just so it's initialized */
+		*nmask  = cpuset_current_mems_allowed;
+		return 0;
+	}
+
 	if (flags & MPOL_F_ADDR) {
 		down_read(&mm->mmap_sem);
 		vma = find_vma_intersection(mm, addr, addr+1);
_

Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

origin.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
