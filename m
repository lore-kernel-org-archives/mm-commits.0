From: akpm@linux-foundation.org
Subject: [obsolete] mm-hugetlb-improve-page-fault-scalability-update.patch removed from -mm tree
Date: Mon, 03 Feb 2014 16:36:31 -0800
Message-ID: <52f0360f.LiQ4nHfRS9H0+at0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbaBDAgc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Feb 2014 19:36:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, iamjoonsoo.kim@lge.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, davidlohr@hp.com

Subject: [obsolete] mm-hugetlb-improve-page-fault-scalability-update.patch removed from -mm tree
To: davidlohr@hp.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,iamjoonsoo.kim@lge.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 03 Feb 2014 16:36:31 -0800


The patch titled
     Subject: mm, hugetlb: improve page-fault scalability
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-improve-page-fault-scalability-update.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Davidlohr Bueso <davidlohr@hp.com>
Subject: mm, hugetlb: improve page-fault scalability

The kernel can currently only handle a single hugetlb page fault at a
time.  This is due to a single mutex that serializes the entire path. 
This lock protects from spurious OOM errors under conditions of low of low
availability of free hugepages.  This problem is specific to hugepages,
because it is normal to want to use every single hugepage in the system -
with normal pages we simply assume there will always be a few spare pages
which can be used temporarily until the race is resolved.

Address this problem by using a table of mutexes, allowing a better chance
of parallelization, where each hugepage is individually serialized.  The
hash key is selected depending on the mapping type.  For shared ones it
consists of the address space and file offset being faulted; while for
private ones the mm and virtual address are used.  The size of the table
is selected based on a compromise of collisions and memory footprint of a
series of database workloads.

Large database workloads that make heavy use of hugepages can be
particularly exposed to this issue, causing start-up times to be painfully
slow.  This patch reduces the startup time of a 10 Gb Oracle DB (with
~5000 faults) from 37.5 secs to 25.7 secs.  Larger workloads will
naturally benefit even more.

NOTE: The only downside to this patch, detected by Joonsoo Kim, is that a
small race is possible in private mappings: A child process (with its own
mm, after cow) can instantiate a page that is already being handled by the
parent in a cow fault.  When low on pages, can trigger spurious OOMs.  I
have not been able to think of a efficient way of handling this...  but do
we really care about such a tiny window?  We already maintain another
theoretical race with normal pages.  If not, one possible way to is to
maintain the single hash for private mappings -- any workloads that
*really* suffer from this scaling problem should already use shared
mappings.

Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-update mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-improve-page-fault-scalability-update
+++ a/mm/hugetlb.c
@@ -55,9 +55,9 @@ static unsigned long __initdata default_
 DEFINE_SPINLOCK(hugetlb_lock);
 
 /*
- * Serializes faults on the same logical page.  This is used to
- * prevent spurious OOMs when the hugepage pool is fully utilized.
- */
++ * Serializes faults on the same logical page.  This is used to
++ * prevent spurious OOMs when the hugepage pool is fully utilized.
++ */
 static int num_fault_mutexes;
 static struct mutex *htlb_fault_mutex_table ____cacheline_aligned_in_smp;
 
@@ -2003,7 +2003,8 @@ static int __init hugetlb_init(void)
 #endif
 	htlb_fault_mutex_table =
 		kmalloc(sizeof(struct mutex) * num_fault_mutexes, GFP_KERNEL);
-	BUG_ON(!htlb_fault_mutex_table);
+	if (!htlb_fault_mutex_table)
+		return -ENOMEM;
 
 	for (i = 0; i < num_fault_mutexes; i++)
 		mutex_init(&htlb_fault_mutex_table[i]);
_

Patches currently in -mm which might be from davidlohr@hp.com are

mm-hugetlb-unify-region-structure-handling.patch
mm-hugetlb-improve-cleanup-resv_map-parameters.patch
mm-hugetlb-fix-race-in-region-tracking.patch
mm-hugetlb-remove-resv_map_put.patch
mm-hugetlb-use-vma_resv_map-map-types.patch
mm-hugetlb-improve-page-fault-scalability.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
linux-next.patch

