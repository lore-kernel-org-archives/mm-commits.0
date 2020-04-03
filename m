From: akpm@linux-foundation.org
Subject: [merged]
 hugetlb-support-file_region-coalescing-again.patch removed from -mm tree
Date: Fri, 03 Apr 2020 13:40:47 -0700
Message-ID: <20200403204047.Om9veEGAI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDCUkt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Apr 2020 16:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: almasrymina@google.com, gthelen@google.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org, rientjes@google.com, sandipan@linux.ibm.com, shakeelb@google.com, shuah@kernel.org


The patch titled
     Subject: hugetlb: support file_region coalescing again
has been removed from the -mm tree.  Its filename was
     hugetlb-support-file_region-coalescing-again.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mina Almasry <almasrymina@google.com>
Subject: hugetlb: support file_region coalescing again

An earlier patch in this series disabled file_region coalescing in order
to hang the hugetlb_cgroup uncharge info on the file_region entries.

This patch re-adds support for coalescing of file_region entries. 
Essentially everytime we add an entry, we call a recursive function that
tries to coalesce the added region with the regions next to it.  The worst
case call depth for this function is 3: one to coalesce with the region
next to it, one to coalesce to the region prev, and one to reach the base
case.

This is an important performance optimization as private mappings add
their entries page by page, and we could incur big performance costs for
large mappings with lots of file_region entries in their resv_map.

[almasrymina@google.com: fix CONFIG_CGROUP_HUGETLB ifdefs]
  Link: http://lkml.kernel.org/r/20200214204544.231482-1-almasrymina@google.com
[almasrymina@google.com: remove check_coalesce_bug debug code]
  Link: http://lkml.kernel.org/r/20200219233610.13808-1-almasrymina@google.com
Link: http://lkml.kernel.org/r/20200211213128.73302-7-almasrymina@google.com
Signed-off-by: Mina Almasry <almasrymina@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Sandipan Das <sandipan@linux.ibm.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/mm/hugetlb.c~hugetlb-support-file_region-coalescing-again
+++ a/mm/hugetlb.c
@@ -276,6 +276,48 @@ static void record_hugetlb_cgroup_unchar
 #endif
 }
 
+static bool has_same_uncharge_info(struct file_region *rg,
+				   struct file_region *org)
+{
+#ifdef CONFIG_CGROUP_HUGETLB
+	return rg && org &&
+	       rg->reservation_counter == org->reservation_counter &&
+	       rg->css == org->css;
+
+#else
+	return true;
+#endif
+}
+
+static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
+{
+	struct file_region *nrg = NULL, *prg = NULL;
+
+	prg = list_prev_entry(rg, link);
+	if (&prg->link != &resv->regions && prg->to == rg->from &&
+	    has_same_uncharge_info(prg, rg)) {
+		prg->to = rg->to;
+
+		list_del(&rg->link);
+		kfree(rg);
+
+		coalesce_file_region(resv, prg);
+		return;
+	}
+
+	nrg = list_next_entry(rg, link);
+	if (&nrg->link != &resv->regions && nrg->from == rg->to &&
+	    has_same_uncharge_info(nrg, rg)) {
+		nrg->from = rg->from;
+
+		list_del(&rg->link);
+		kfree(rg);
+
+		coalesce_file_region(resv, nrg);
+		return;
+	}
+}
+
 /* Must be called with resv->lock held. Calling this with count_only == true
  * will count the number of pages to be added but will not modify the linked
  * list. If regions_needed != NULL and count_only == true, then regions_needed
@@ -327,6 +369,7 @@ static long add_reservation_in_range(str
 				record_hugetlb_cgroup_uncharge_info(h_cg, h,
 								    resv, nrg);
 				list_add(&nrg->link, rg->link.prev);
+				coalesce_file_region(resv, nrg);
 			} else if (regions_needed)
 				*regions_needed += 1;
 		}
@@ -344,6 +387,7 @@ static long add_reservation_in_range(str
 				resv, last_accounted_offset, t);
 			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
 			list_add(&nrg->link, rg->link.prev);
+			coalesce_file_region(resv, nrg);
 		} else if (regions_needed)
 			*regions_needed += 1;
 	}
_

Patches currently in -mm which might be from almasrymina@google.com are
