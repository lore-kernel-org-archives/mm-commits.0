From: akpm@linux-foundation.org
Subject: [merged] nodemask-make-nodemask_alloc-more-general.patch removed from -mm tree
Date: Tue, 15 Dec 2009 13:50:45 -0800
Message-ID: <200912152150.nBFLojV2014979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761191AbZLOVwU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 16:52:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, agl@us.ibm.com, andi@firstfloor.org, apw@canonical.com, cl@linux-foundation.org, eric.whitney@hp.com, kamezawa.hiroyu@jp.fujitsu.com, lee.schermerhorn@hp.com, mel


The patch titled
     nodemask: make NODEMASK_ALLOC more general
has been removed from the -mm tree.  Its filename was
     nodemask-make-nodemask_alloc-more-general.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nodemask: make NODEMASK_ALLOC more general
From: David Rientjes <rientjes@google.com>

This is a series of patches to provide control over the location of the
allocation and freeing of persistent huge pages on a NUMA platform. 
Please consider for merging into mmotm.

This series uses two mechanisms to constrain the nodes from which
persistent huge pages are allocated: 1) the task NUMA mempolicy of the
task modifying a new sysctl "nr_hugepages_mempolicy", based on a
suggestion by Mel Gorman; and 2) a subset of the hugepages hstate sysfs
attributes have been added [in V4] to each node system device under:

	/sys/devices/node/node[0-9]*/hugepages

The per node attibutes allow direct assignment of a huge page count on a
specific node, regardless of the task's mempolicy or cpuset constraints.  


This patch:

NODEMASK_ALLOC(x, m) assumes x is a type of struct, which is unnecessary. 
It's perfectly reasonable to use this macro to allocate a nodemask_t,
which is anonymous, either dynamically or on the stack depending on
NODES_SHIFT.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Eric Whitney <eric.whitney@hp.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff -puN include/linux/nodemask.h~nodemask-make-nodemask_alloc-more-general include/linux/nodemask.h
--- a/include/linux/nodemask.h~nodemask-make-nodemask_alloc-more-general
+++ a/include/linux/nodemask.h
@@ -481,14 +481,14 @@ static inline int num_node_state(enum no
 
 /*
  * For nodemask scrach area.(See CPUMASK_ALLOC() in cpumask.h)
+ * NODEMASK_ALLOC(x, m) allocates an object of type 'x' with the name 'm'.
  */
-
 #if NODES_SHIFT > 8 /* nodemask_t > 64 bytes */
-#define NODEMASK_ALLOC(x, m) struct x *m = kmalloc(sizeof(*m), GFP_KERNEL)
-#define NODEMASK_FREE(m) kfree(m)
+#define NODEMASK_ALLOC(x, m)		x *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define NODEMASK_FREE(m)		kfree(m)
 #else
-#define NODEMASK_ALLOC(x, m) struct x _m, *m = &_m
-#define NODEMASK_FREE(m)
+#define NODEMASK_ALLOC(x, m)		x _m, *m = &_m
+#define NODEMASK_FREE(m)		do {} while (0)
 #endif
 
 /* A example struture for using NODEMASK_ALLOC, used in mempolicy. */
@@ -497,8 +497,9 @@ struct nodemask_scratch {
 	nodemask_t	mask2;
 };
 
-#define NODEMASK_SCRATCH(x) NODEMASK_ALLOC(nodemask_scratch, x)
-#define NODEMASK_SCRATCH_FREE(x)  NODEMASK_FREE(x)
+#define NODEMASK_SCRATCH(x)	\
+		NODEMASK_ALLOC(struct nodemask_scratch, x)
+#define NODEMASK_SCRATCH_FREE(x)	NODEMASK_FREE(x)
 
 
 #endif /* __LINUX_NODEMASK_H */
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
acpi-remove-nid_inval.patch
oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
do_wait-optimization-do-not-place-sub-threads-on-task_struct-children-list.patch

