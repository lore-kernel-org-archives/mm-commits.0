From: akpm@linux-foundation.org
Subject: [merged] mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch
 removed from -mm tree
Date: Fri, 31 Jan 2014 11:16:36 -0800
Message-ID: <52ebf694.p3yF34Mc+md4MKAv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50644 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651AbaAaTQg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 Jan 2014 14:16:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rlippert@google.com, peterz@infradead.org, mingo@kernel.org, mgorman@suse.de, rientjes@google.com

Subject: [merged] mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch removed from -mm tree
To: rientjes@google.com,mgorman@suse.de,mingo@kernel.org,peterz@infradead.org,rlippert@google.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 31 Jan 2014 11:16:36 -0800


The patch titled
     Subject: mm/mempolicy.c: fix mempolicy printing in numa_maps
has been removed from the -mm tree.  Its filename was
     mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm/mempolicy.c: fix mempolicy printing in numa_maps

As a result of 5606e3877ad8 ("mm: numa: Migrate on reference policy"),
/proc/<pid>/numa_maps prints the mempolicy for any <pid> as "prefer:N" for
the local node, N, of the process reading the file.

This should only be printed when the mempolicy of <pid> is MPOL_PREFERRED
for node N.

If the process is actually only using the default mempolicy for local node
allocation, make sure "default" is printed as expected.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Robert Lippert <rlippert@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>	[3.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/mempolicy.c~mm-mempolicyc-fix-mempolicy-printing-in-numa_maps mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicyc-fix-mempolicy-printing-in-numa_maps
+++ a/mm/mempolicy.c
@@ -2930,7 +2930,7 @@ void mpol_to_str(char *buffer, int maxle
 	unsigned short mode = MPOL_DEFAULT;
 	unsigned short flags = 0;
 
-	if (pol && pol != &default_policy) {
+	if (pol && pol != &default_policy && !(pol->flags & MPOL_F_MORON)) {
 		mode = pol->mode;
 		flags = pol->flags;
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
mm-slb-fix-misleading-comments.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-remove-bug_on-from-mlock_vma_page.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

