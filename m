From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch removed
 from -mm tree
Date: Thu, 07 Sep 2017 11:41:22 -0700
Message-ID: <20170907184122.KlI_TFGQQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57712 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdIGSlX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 7 Sep 2017 14:41:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@kernel.org, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, tj@kernel.org


The patch titled
     Subject: mm/vmalloc.c: halve the number of comparisons performed in pcpu_get_vm_areas()
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmalloc.c: halve the number of comparisons performed in pcpu_get_vm_areas()

In pcpu_get_vm_areas(), it checks each range is not overlapped.  To make
sure it is, only (N^2)/2 comparison is necessary, while current code does
N^2 times.  By starting from the next range, it achieves the goal and the
continue could be removed.

Also,

- the overlap check of two ranges could be done with one clause

- one typo in comment is fixed.

Link: http://lkml.kernel.org/r/20170803063822.48702-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -2482,7 +2482,7 @@ static unsigned long pvm_determine_end(s
  * matching slot.  While scanning, if any of the areas overlaps with
  * existing vmap_area, the base address is pulled down to fit the
  * area.  Scanning is repeated till all the areas fit and then all
- * necessary data structres are inserted and the result is returned.
+ * necessary data structures are inserted and the result is returned.
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
@@ -2510,15 +2510,11 @@ struct vm_struct **pcpu_get_vm_areas(con
 		if (start > offsets[last_area])
 			last_area = area;
 
-		for (area2 = 0; area2 < nr_vms; area2++) {
+		for (area2 = area + 1; area2 < nr_vms; area2++) {
 			unsigned long start2 = offsets[area2];
 			unsigned long end2 = start2 + sizes[area2];
 
-			if (area2 == area)
-				continue;
