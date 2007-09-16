From: akpm@linux-foundation.org
Subject: + mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch added to -mm tree
Date: Sat, 15 Sep 2007 22:36:38 -0700
Message-ID: <200709160536.l8G5acIB002037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49845 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978AbXIPFgz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 16 Sep 2007 01:36:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, clameter@sgi.com, lee.schermerhorn@hp.com


The patch titled
     Mem Policy: add MPOL_F_MEMS_ALLOWED get_mempolicy() flag
has been added to the -mm tree.  Its filename is
     mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Mem Policy: add MPOL_F_MEMS_ALLOWED get_mempolicy() flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Return-Path: <Lee.Schermerhorn@hp.com>
Received: from localhost (bix [127.0.0.1])
	by localhost.localdomain (8.12.10/8.12.10) with ESMTP id l8EJRjv3016321
	for <akpm@localhost>; Fri, 14 Sep 2007 12:27:45 -0700
Received: from imap1.linux-foundation.org [207.189.120.55]
	by localhost with IMAP (fetchmail-6.2.5)
	for akpm@localhost (single-drop); Fri, 14 Sep 2007 12:27:45 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [207.189.120.13])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8EKPNQv022876
	for <akpm@imap1.linux-foundation.org>; Fri, 14 Sep 2007 13:25:23 -0700
Received: from atlrel6.hp.com (atlrel6.hp.com [156.153.255.205])
	by smtp1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with ESMTP id l8EKPG1Z012652
	for <akpm@linux-foundation.org>; Fri, 14 Sep 2007 13:25:17 -0700
Received: from smtp2.fc.hp.com (smtp.cnd.hp.com [15.11.136.114])
	by atlrel6.hp.com (Postfix) with ESMTP id 5E81D36432;
	Fri, 14 Sep 2007 16:24:30 -0400 (EDT)
Received: from ldl.fc.hp.com (ldl.fc.hp.com [15.11.146.30])
	by smtp2.fc.hp.com (Postfix) with ESMTP id 72BFC223F57;
	Fri, 14 Sep 2007 20:24:19 +0000 (UTC)
Received: from localhost (ldl.fc.hp.com [127.0.0.1])
	by ldl.fc.hp.com (Postfix) with ESMTP id 4C8D139C1A0;
	Fri, 14 Sep 2007 14:24:19 -0600 (MDT)
X-Virus-Scanned: Debian amavisd-new at ldl.fc.hp.com
Received: from ldl.fc.hp.com ([127.0.0.1])
	by localhost (ldl.fc.hp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id q1SGreLzV+os; Fri, 14 Sep 2007 14:24:16 -0600 (MDT)
Received: from [16.116.100.58] (unknown [16.116.100.58])
	(using SSLv3 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by ldl.fc.hp.com (Postfix) with ESMTP id 8340F39C19D;
	Fri, 14 Sep 2007 14:24:15 -0600 (MDT)
Subject: [PATCH] Mem Policy:  add MPOL_F_MEMS_ALLOWED get_mempolicy() flag
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ak@suse.de, mtk-manpages@gmx.net,
        clameter@sgi.com, eric.whitney@hp.com, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20070830185130.22619.93436.sendpatchset@localhost>
References: <20070830185053.22619.96398.sendpatchset@localhost>
	 <20070830185130.22619.93436.sendpatchset@localhost>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 14 Sep 2007 16:24:17 -0400
Message-Id: <1189801457.5315.81.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Received-SPF: none (domain of lee.schermerhorn@hp.com does not designate permitted sender hosts)
X-MIMEDefang-Filter: lf$Revision: 1.185 $
X-Scanned-By: MIMEDefang 2.53 on 207.189.120.13
X-Spam-Checker-Version: SpamAssassin 3.0.2 (2004-11-16) on bix
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=2.0 tests=AWL autolearn=ham 
	version=3.0.2

PATCH  add MPOL_F_MEMS_ALLOWED get_mempolicy() flag

Against:  2.6.23-rc4-mm1

V1 -> V2:
+ extracted from earlier mempolicy series as stand alone patch
+ update numa_memory_policy to indicate that cpuset resources can
  change after task queries allowed nodes.  Suggestion from
  Christoph L.

Allow an application to query the memories allowed by its context.

Updated numa_memory_policy.txt to mention that applications can use this
to obtain allowed memories for constructing valid policies.

TODO:  update out-of-tree libnuma wrapper[s], or maybe add a new 
wrapper--e.g.,  numa_get_mems_allowed() ?

Also, update numa syscall man pages.

Tested with memtoy V>=0.13.

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
V1 was:
Acked-by: Christoph Lameter <clameter@sgi.com>

 Documentation/vm/numa_memory_policy.txt |   33 +++++++++++++++-----------------
 include/linux/mempolicy.h               |    1 
 mm/mempolicy.c                          |   12 ++++++++++-
 3 files changed, 28 insertions(+), 18 deletions(-)

Index: Linux/include/linux/mempolicy.h
===================================================================
--- Linux.orig/include/linux/mempolicy.h	2007-09-14 12:00:38.000000000 -0400
+++ Linux/include/linux/mempolicy.h	2007-09-14 12:03:12.000000000 -0400
@@ -19,6 +19,7 @@
 /* Flags for get_mem_policy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
+#define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
Index: Linux/mm/mempolicy.c
===================================================================
--- Linux.orig/mm/mempolicy.c	2007-09-14 12:00:38.000000000 -0400
+++ Linux/mm/mempolicy.c	2007-09-14 12:03:12.000000000 -0400
@@ -533,8 +533,18 @@ static long do_get_mempolicy(int *policy
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
Index: Linux/Documentation/vm/numa_memory_policy.txt
===================================================================
--- Linux.orig/Documentation/vm/numa_memory_policy.txt	2007-09-12 09:02:50.000000000 -0400
+++ Linux/Documentation/vm/numa_memory_policy.txt	2007-09-14 12:10:30.000000000 -0400
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


Patches currently in -mm which might be from Lee.Schermerhorn@hp.com are

mem-policy-add-mpol_f_mems_allowed-get_mempolicy-flag.patch
memoryless-nodes-generic-management-of-nodemasks-for-various-purposes-fix.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory.patch
memoryless-nodes-introduce-mask-of-nodes-with-memory-fix.patch
update-n_high_memory-node-state-for-memory-hotadd.patch
memoryless-nodes-add-n_cpu-node-state-move-setup-of-n_cpu-node-state-mask.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
add-node-states-sysfs-class-attributes-v5.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix-2.patch
