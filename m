From: akpm@linux-foundation.org
Subject: + mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch added
 to -mm tree
Date: Tue, 28 Jan 2014 12:08:39 -0800
Message-ID: <52e80e47.nu/vrT5urxiXq32P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46104 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1UIk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 15:08:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, rlippert@google.com, peterz@infradead.org, mingo@kernel.org, mgorman@suse.de, rientjes@google.com

Subject: + mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch added to -mm tree
To: rientjes@google.com,mgorman@suse.de,mingo@kernel.org,peterz@infradead.org,rlippert@google.com,stable@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 12:08:39 -0800


The patch titled
     Subject: mm/mempolicy.c: fix mempolicy printing in numa_maps
has been added to the -mm tree.  Its filename is
     mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
slab-fix-wrong-retval-on-kmem_cache_create_memcg-error-path-2.patch
mm-remove-bug_on-from-mlock_vma_page.patch
mm-mempolicyc-fix-mempolicy-printing-in-numa_maps.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug.patch
numa-mem-hotplug-initialize-numa_kernel_nodes-in-numa_clear_kernel_node_hotplug-fix.patch
numa-mem-hotplug-fix-array-index-overflow-when-synchronizing-nid-to-memblockreserved.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
cpusets-allocate-heap-only-when-required.patch
linux-next.patch

