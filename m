From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch added to
 -mm tree
Date: Thu, 03 Aug 2017 16:00:59 -0700
Message-ID: <5983ab2b.I2AP9AgQwEK3C2Iy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35904 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751754AbdHCXBA (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Aug 2017 19:01:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc.c: halve the number of comparisons performed in pcpu_get_vm_areas()
has been added to the -mm tree.  Its filename is
     mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-reduce-half-comparison-during-pcpu_get_vm_areas
+++ a/mm/vmalloc.c
@@ -2479,7 +2479,7 @@ static unsigned long pvm_determine_end(s
  * matching slot.  While scanning, if any of the areas overlaps with
  * existing vmap_area, the base address is pulled down to fit the
  * area.  Scanning is repeated till all the areas fit and then all
- * necessary data structres are inserted and the result is returned.
+ * necessary data structures are inserted and the result is returned.
  */
 struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
 				     const size_t *sizes, int nr_vms,
@@ -2507,15 +2507,11 @@ struct vm_struct **pcpu_get_vm_areas(con
 		if (start > offsets[last_area])
 			last_area = area;
 
-		for (area2 = 0; area2 < nr_vms; area2++) {
+		for (area2 = area + 1; area2 < nr_vms; area2++) {
 			unsigned long start2 = offsets[area2];
 			unsigned long end2 = start2 + sizes[area2];
 
-			if (area2 == area)
-				continue;
